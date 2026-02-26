// ISO_32000.COS.serialize Tests.swift

import Testing

@testable import ISO_32000

@Suite
struct `ISO_32000.COS.serialize Tests` {

    // MARK: - Null

    @Test
    func `Serializes null`() {
        var buffer: [UInt8] = []
        ISO_32000.COS.serialize(.null, into: &buffer)
        #expect(String(decoding: buffer, as: UTF8.self) == "null")
    }

    // MARK: - Boolean

    @Test
    func `Serializes true`() {
        var buffer: [UInt8] = []
        ISO_32000.COS.serialize(.boolean(true), into: &buffer)
        #expect(String(decoding: buffer, as: UTF8.self) == "true")
    }

    @Test
    func `Serializes false`() {
        var buffer: [UInt8] = []
        ISO_32000.COS.serialize(.boolean(false), into: &buffer)
        #expect(String(decoding: buffer, as: UTF8.self) == "false")
    }

    // MARK: - Integer

    @Test
    func `Serializes positive integer`() {
        var buffer: [UInt8] = []
        ISO_32000.COS.serialize(.integer(42), into: &buffer)
        #expect(String(decoding: buffer, as: UTF8.self) == "42")
    }

    @Test
    func `Serializes negative integer`() {
        var buffer: [UInt8] = []
        ISO_32000.COS.serialize(.integer(-100), into: &buffer)
        #expect(String(decoding: buffer, as: UTF8.self) == "-100")
    }

    @Test
    func `Serializes zero`() {
        var buffer: [UInt8] = []
        ISO_32000.COS.serialize(.integer(0), into: &buffer)
        #expect(String(decoding: buffer, as: UTF8.self) == "0")
    }

    // MARK: - Real

    @Test
    func `Serializes real with decimals`() {
        var buffer: [UInt8] = []
        ISO_32000.COS.serialize(.real(3.14), into: &buffer)
        let result = String(decoding: buffer, as: UTF8.self)
        #expect(result.hasPrefix("3.14"))
    }

    @Test
    func `Serializes integer-valued real without decimals`() {
        var buffer: [UInt8] = []
        ISO_32000.COS.serialize(.real(42.0), into: &buffer)
        #expect(String(decoding: buffer, as: UTF8.self) == "42")
    }

    @Test
    func `Serializes negative real`() {
        var buffer: [UInt8] = []
        ISO_32000.COS.serialize(.real(-2.5), into: &buffer)
        #expect(String(decoding: buffer, as: UTF8.self) == "-2.5")
    }

    // MARK: - Name

    @Test
    func `Serializes simple name`() {
        var buffer: [UInt8] = []
        ISO_32000.COS.serialize(.name(.type), into: &buffer)
        #expect(String(decoding: buffer, as: UTF8.self) == "/Type")
    }

    @Test
    func `Serializes name with hyphen`() {
        var buffer: [UInt8] = []
        ISO_32000.COS.serialize(.name(.helveticaBold), into: &buffer)
        #expect(String(decoding: buffer, as: UTF8.self) == "/Helvetica-Bold")
    }

    @Test
    func `Escapes special characters in name`() throws {
        var buffer: [UInt8] = []
        let name = try ISO_32000.COS.Name("Test#Value")
        ISO_32000.COS.serialize(.name(name), into: &buffer)
        let result = String(decoding: buffer, as: UTF8.self)
        #expect(result.contains("#23"))  // # is escaped as #23
    }

    // MARK: - String

    @Test
    func `Serializes string as literal`() {
        var buffer: [UInt8] = []
        ISO_32000.COS.serialize(.string("Hello"), into: &buffer)
        #expect(String(decoding: buffer, as: UTF8.self) == "(Hello)")
    }

    // MARK: - Array

    @Test
    func `Serializes empty array`() {
        var buffer: [UInt8] = []
        ISO_32000.COS.serialize(.array([]), into: &buffer)
        #expect(String(decoding: buffer, as: UTF8.self) == "[]")
    }

    @Test
    func `Serializes integer array`() {
        var buffer: [UInt8] = []
        ISO_32000.COS.serialize(.array([.integer(1), .integer(2), .integer(3)]), into: &buffer)
        #expect(String(decoding: buffer, as: UTF8.self) == "[1 2 3]")
    }

    @Test
    func `Serializes mixed array`() {
        var buffer: [UInt8] = []
        ISO_32000.COS.serialize(.array([.integer(1), .name(.type), .boolean(true)]), into: &buffer)
        let result = String(decoding: buffer, as: UTF8.self)
        #expect(result.hasPrefix("["))
        #expect(result.hasSuffix("]"))
        #expect(result.contains("1"))
        #expect(result.contains("/Type"))
        #expect(result.contains("true"))
    }

    // MARK: - Dictionary

    @Test
    func `Serializes empty dictionary`() {
        var buffer: [UInt8] = []
        ISO_32000.COS.serialize(.dictionary(ISO_32000.COS.Dictionary()), into: &buffer)
        #expect(String(decoding: buffer, as: UTF8.self) == "<<>>")
    }

    @Test
    func `Serializes dictionary with entries`() {
        var buffer: [UInt8] = []
        let dict: ISO_32000.COS.Dictionary = [
            .type: .name(.catalog)
        ]
        ISO_32000.COS.serialize(.dictionary(dict), into: &buffer)
        let result = String(decoding: buffer, as: UTF8.self)
        #expect(result.hasPrefix("<<"))
        #expect(result.hasSuffix(">>"))
        #expect(result.contains("/Type"))
        #expect(result.contains("/Catalog"))
    }

    @Test
    func `Dictionary entries are sorted by key`() {
        var buffer: [UInt8] = []
        let dict: ISO_32000.COS.Dictionary = [
            .type: .name(.page),
            .author: .string("Test"),
            .count: .integer(1),
        ]
        ISO_32000.COS.serialize(.dictionary(dict), into: &buffer)
        let result = String(decoding: buffer, as: UTF8.self)

        let authorPos = result.range(of: "/Author")!.lowerBound
        let countPos = result.range(of: "/Count")!.lowerBound
        let typePos = result.range(of: "/Type")!.lowerBound

        #expect(authorPos < countPos)
        #expect(countPos < typePos)
    }

    // MARK: - Reference

    @Test
    func `Serializes indirect reference`() {
        var buffer: [UInt8] = []
        let ref = ISO_32000.COS.IndirectReference(objectNumber: 5, generation: 0)
        ISO_32000.COS.serialize(.reference(ref), into: &buffer)
        #expect(String(decoding: buffer, as: UTF8.self) == "5 0 R")
    }

    @Test
    func `Serializes reference with generation`() {
        var buffer: [UInt8] = []
        let ref = ISO_32000.COS.IndirectReference(objectNumber: 10, generation: 2)
        ISO_32000.COS.serialize(.reference(ref), into: &buffer)
        #expect(String(decoding: buffer, as: UTF8.self) == "10 2 R")
    }

    // MARK: - Stream

    @Test
    func `Serializes stream with length`() {
        var buffer: [UInt8] = []
        let stream = ISO_32000.COS.Stream(
            dictionary: [:],
            data: Array("Hello".utf8)
        )
        ISO_32000.COS.serialize(.stream(stream), into: &buffer)
        let result = String(decoding: buffer, as: UTF8.self)

        #expect(result.contains("/Length 5"))
        #expect(result.contains("stream"))
        #expect(result.contains("Hello"))
        #expect(result.contains("endstream"))
    }
}
