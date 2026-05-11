// ISO_32000.COS.StringValue.NonASCII Tests.swift
//
// Wave-1 regression-guard tests for ISO 32000-2 §7.9.2.2 compliance.
// `StringValue.serialize(_:into:)` and `asLiteral()` MUST emit PDFDocEncoding
// for fully-encodable scalars, UTF-16BE with `0xFE 0xFF` BOM otherwise, and
// MUST handle surrogate pairs for scalars beyond U+FFFF.
//
// Reference: ISO 32000-2:2020 §7.9.2.2 (Text string type) + Annex D
// (PDFDocEncoding table — note that 0xA0 is EURO, NOT NBSP; NBSP is NOT in
// PDFDocEncoding and forces the UTF-16BE fallback).

import Binary_Primitives
import Testing

@testable import ISO_32000
import ISO_32000_7_Syntax

@Suite
struct `ISO_32000.COS.StringValue NonASCII Tests` {

    // MARK: - serialize(_:into:): PDFDocEncoding path

    @Test
    func `ASCII-only payload serializes as raw PDFDocEncoding bytes`() {
        let str = ISO_32000.`7`.`3`.COS.StringValue("Hello")
        var bytes: [UInt8] = []
        ISO_32000.`7`.`3`.COS.StringValue.serialize(str, into: &bytes)
        // ASCII subset of PDFDocEncoding == ASCII == "(Hello)"
        #expect(bytes == Array("(Hello)".utf8))
    }

    @Test
    func `Bullet U_2022 takes PDFDocEncoding single-byte path at 0x80`() {
        // PDFDocEncoding maps U+2022 BULLET to 0x80 (per Annex D).
        let str = ISO_32000.`7`.`3`.COS.StringValue("\u{2022}")
        var bytes: [UInt8] = []
        ISO_32000.`7`.`3`.COS.StringValue.serialize(str, into: &bytes)
        #expect(bytes == [0x28, 0x80, 0x29])  // ( bullet )
    }

    @Test
    func `Euro U_20AC takes PDFDocEncoding single-byte path at 0xA0`() {
        // PDFDocEncoding maps U+20AC EURO to 0xA0 (NOT WinAnsi 0x80; NOT UTF-16BE).
        let str = ISO_32000.`7`.`3`.COS.StringValue("\u{20AC}")
        var bytes: [UInt8] = []
        ISO_32000.`7`.`3`.COS.StringValue.serialize(str, into: &bytes)
        #expect(bytes == [0x28, 0xA0, 0x29])
    }

    @Test
    func `Dutch dieresis Cli_e_ntnummer takes PDFDocEncoding path`() {
        // U+00EB is in PDFDocEncoding at 0xEB; payload is fully encodable.
        let str = ISO_32000.`7`.`3`.COS.StringValue("Cli\u{00EB}ntnummer")
        var bytes: [UInt8] = []
        ISO_32000.`7`.`3`.COS.StringValue.serialize(str, into: &bytes)
        // ( C l i ë n t n u m m e r )
        #expect(bytes == [
            0x28,                            // (
            0x43, 0x6C, 0x69, 0xEB,          // Clië
            0x6E, 0x74, 0x6E, 0x75,          // ntnu
            0x6D, 0x6D, 0x65, 0x72,          // mmer
            0x29                             // )
        ])
    }

    // MARK: - serialize(_:into:): UTF-16BE fallback

    @Test
    func `NBSP U_00A0 is NOT in PDFDocEncoding and forces UTF-16BE`() {
        // PDFDocEncoding's 0xA0 slot holds EURO; NBSP has no PDFDocEncoding
        // representation. A single NBSP forces the entire string into UTF-16BE.
        let str = ISO_32000.`7`.`3`.COS.StringValue("\u{00A0}")
        var bytes: [UInt8] = []
        ISO_32000.`7`.`3`.COS.StringValue.serialize(str, into: &bytes)
        // ( 0xFE 0xFF 0x00 0xA0 )
        #expect(bytes == [0x28, 0xFE, 0xFF, 0x00, 0xA0, 0x29])
    }

    @Test
    func `Euro plus NBSP plus digits emits UTF-16BE with BOM`() {
        // The on-disk reproducer pattern: "€\u{00A0}150,12" — NBSP forces
        // UTF-16BE even though Euro alone would use single-byte PDFDocEncoding.
        let str = ISO_32000.`7`.`3`.COS.StringValue("\u{20AC}\u{00A0}150,12")
        var bytes: [UInt8] = []
        ISO_32000.`7`.`3`.COS.StringValue.serialize(str, into: &bytes)
        #expect(bytes == [
            0x28, 0xFE, 0xFF,                // ( BOM
            0x20, 0xAC,                      // €
            0x00, 0xA0,                      // NBSP
            0x00, 0x31,                      // 1
            0x00, 0x35,                      // 5
            0x00, 0x30,                      // 0
            0x00, 0x2C,                      // ,
            0x00, 0x31,                      // 1
            0x00, 0x32,                      // 2
            0x29                             // )
        ])
    }

    @Test
    func `Surrogate pair scalar U_1F600 emits two UTF-16BE code units`() {
        // U+1F600 GRINNING FACE — beyond BMP. UTF-16 surrogate pair:
        // High 0xD83D, Low 0xDE00. Not in PDFDocEncoding → UTF-16BE.
        let str = ISO_32000.`7`.`3`.COS.StringValue("\u{1F600}")
        var bytes: [UInt8] = []
        ISO_32000.`7`.`3`.COS.StringValue.serialize(str, into: &bytes)
        #expect(bytes == [
            0x28, 0xFE, 0xFF,                // ( BOM
            0xD8, 0x3D,                      // high surrogate
            0xDE, 0x00,                      // low surrogate
            0x29                             // )
        ])
    }

    // MARK: - Escape table preserved across both paths

    @Test
    func `Parens and backslash escape inside PDFDocEncoding literal`() {
        let str = ISO_32000.`7`.`3`.COS.StringValue("abc(def)ghi")
        var bytes: [UInt8] = []
        ISO_32000.`7`.`3`.COS.StringValue.serialize(str, into: &bytes)
        let decoded = String(decoding: bytes, as: UTF8.self)
        #expect(decoded == "(abc\\(def\\)ghi)")
    }

    // MARK: - asLiteral() parallel paths after surrogate-pair fix

    @Test
    func `asLiteral matches serialize on PDFDocEncoding-only payload`() {
        let str = ISO_32000.COS.StringValue("Hello")
        var via = [UInt8]()
        ISO_32000.`7`.`3`.COS.StringValue.serialize(str, into: &via)
        #expect(via == str.asLiteral())
    }

    @Test
    func `asLiteral matches serialize on UTF-16BE payload`() {
        let str = ISO_32000.COS.StringValue("\u{20AC}\u{00A0}150,12")
        var via = [UInt8]()
        ISO_32000.`7`.`3`.COS.StringValue.serialize(str, into: &via)
        #expect(via == str.asLiteral())
    }

    @Test
    func `asLiteral matches serialize on surrogate-pair payload`() {
        let str = ISO_32000.COS.StringValue("\u{1F600}")
        var via = [UInt8]()
        ISO_32000.`7`.`3`.COS.StringValue.serialize(str, into: &via)
        #expect(via == str.asLiteral())
    }
}
