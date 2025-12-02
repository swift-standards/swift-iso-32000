// ISO_32000.COS.StringValue Tests.swift

import Testing
@testable import ISO_32000

@Suite
struct `ISO_32000.COS.StringValue Tests` {

    // MARK: - Construction

    @Test
    func `Creates string from value`() {
        let str = ISO_32000.COS.StringValue("Hello")
        #expect(str.value == "Hello")
    }

    @Test
    func `Creates string via string literal`() {
        let str: ISO_32000.COS.StringValue = "World"
        #expect(str.value == "World")
    }

    // MARK: - Literal Serialization

    @Test
    func `Serializes simple string as literal`() {
        let str = ISO_32000.COS.StringValue("Hello")
        let bytes = str.asLiteral()
        #expect(bytes == Array("(Hello)".utf8))
    }

    @Test
    func `Escapes parentheses in literal`() {
        let str = ISO_32000.COS.StringValue("(test)")
        let bytes = str.asLiteral()
        let result = String(decoding: bytes, as: UTF8.self)
        #expect(result.contains("\\("))
        #expect(result.contains("\\)"))
    }

    @Test
    func `Escapes backslash in literal`() {
        let str = ISO_32000.COS.StringValue("path\\file")
        let bytes = str.asLiteral()
        let result = String(decoding: bytes, as: UTF8.self)
        #expect(result.contains("\\\\"))
    }

    @Test
    func `Escapes newline in literal`() {
        let str = ISO_32000.COS.StringValue("line1\nline2")
        let bytes = str.asLiteral()
        let result = String(decoding: bytes, as: UTF8.self)
        #expect(result.contains("\\n"))
    }

    @Test
    func `Escapes carriage return in literal`() {
        let str = ISO_32000.COS.StringValue("line1\rline2")
        let bytes = str.asLiteral()
        let result = String(decoding: bytes, as: UTF8.self)
        #expect(result.contains("\\r"))
    }

    @Test
    func `Escapes tab in literal`() {
        let str = ISO_32000.COS.StringValue("col1\tcol2")
        let bytes = str.asLiteral()
        let result = String(decoding: bytes, as: UTF8.self)
        #expect(result.contains("\\t"))
    }

    // MARK: - Hexadecimal Serialization

    @Test
    func `Serializes simple string as hex`() {
        let str = ISO_32000.COS.StringValue("Hi")
        let bytes = str.asHexadecimal()
        #expect(bytes == Array("<4869>".utf8))
    }

    @Test
    func `Serializes empty string as hex`() {
        let str = ISO_32000.COS.StringValue("")
        let bytes = str.asHexadecimal()
        #expect(bytes == Array("<>".utf8))
    }

    @Test
    func `Hex uses uppercase letters`() {
        let str = ISO_32000.COS.StringValue("\u{FF}")  // Non-ASCII triggers UTF-16BE
        let bytes = str.asHexadecimal()
        let result = String(decoding: bytes, as: UTF8.self)
        #expect(result.contains("FEFF"))  // BOM
    }

    // MARK: - Unicode Support

    @Test
    func `Literal includes BOM for Unicode`() {
        // Use explicit Unicode character that's definitely > 0x7F
        let str = ISO_32000.COS.StringValue("\u{00E9}")  // é
        let bytes = str.asLiteral()
        #expect(bytes[0] == UInt8(ascii: "("))
        #expect(bytes.contains(0xFE))
        #expect(bytes.contains(0xFF))
    }

    @Test
    func `Hex includes BOM for Unicode`() {
        let str = ISO_32000.COS.StringValue("日本語")
        let bytes = str.asHexadecimal()
        let result = String(decoding: bytes, as: UTF8.self)
        #expect(result.hasPrefix("<FEFF"))  // UTF-16BE BOM
    }

    // MARK: - Preferred Format

    @Test
    func `Prefers literal for simple strings`() {
        let str = ISO_32000.COS.StringValue("Hello World")
        #expect(str.preferredFormat == .literal)
    }

    @Test
    func `Prefers hex when many escapes needed`() {
        let str = ISO_32000.COS.StringValue("((()")
        #expect(str.preferredFormat == .hexadecimal)
    }

    // MARK: - Description

    @Test
    func `Description shows parenthesized form`() {
        let str = ISO_32000.COS.StringValue("Test")
        #expect(str.description == "(Test)")
    }

    // MARK: - Equality

    @Test
    func `Strings are equal when values match`() {
        let a = ISO_32000.COS.StringValue("Test")
        let b = ISO_32000.COS.StringValue("Test")
        #expect(a == b)
    }

    @Test
    func `Strings are case-sensitive`() {
        let lower = ISO_32000.COS.StringValue("test")
        let upper = ISO_32000.COS.StringValue("TEST")
        #expect(lower != upper)
    }
}
