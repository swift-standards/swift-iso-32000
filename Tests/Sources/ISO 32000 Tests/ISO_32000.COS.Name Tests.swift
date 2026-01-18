// ISO_32000.COS.Name Tests.swift

import Testing

@testable import ISO_32000

@Suite
struct `ISO_32000.COS.Name Tests` {

    // MARK: - Construction

    @Test
    func `Creates valid name`() throws {
        let name = try ISO_32000.COS.Name("Type")
        #expect(name.rawValue == "Type")
    }

    @Test
    func `Creates name with hyphen`() throws {
        let name = try ISO_32000.COS.Name("Helvetica-Bold")
        #expect(name.rawValue == "Helvetica-Bold")
    }

    @Test
    func `Creates name with numbers`() throws {
        let name = try ISO_32000.COS.Name("F1")
        #expect(name.rawValue == "F1")
    }

    @Test
    func `Creates name at maximum length`() throws {
        let maxName = String(repeating: "A", count: 127)
        let name = try ISO_32000.COS.Name(maxName)
        #expect(name.rawValue.utf8.count == 127)
    }

    // MARK: - Validation Errors

    @Test
    func `Rejects empty name`() {
        #expect(throws: ISO_32000.COS.Name.Error.empty) {
            _ = try ISO_32000.COS.Name("")
        }
    }

    @Test
    func `Rejects name exceeding max length`() {
        let tooLong = String(repeating: "A", count: 128)
        #expect(throws: ISO_32000.COS.Name.Error.tooLong(128)) {
            _ = try ISO_32000.COS.Name(tooLong)
        }
    }

    @Test
    func `Rejects name with space`() {
        #expect(throws: ISO_32000.COS.Name.Error.containsWhitespace) {
            _ = try ISO_32000.COS.Name("Hello World")
        }
    }

    @Test
    func `Rejects name with tab`() {
        #expect(throws: ISO_32000.COS.Name.Error.containsWhitespace) {
            _ = try ISO_32000.COS.Name("Hello\tWorld")
        }
    }

    @Test
    func `Rejects name with newline`() {
        #expect(throws: ISO_32000.COS.Name.Error.containsWhitespace) {
            _ = try ISO_32000.COS.Name("Hello\nWorld")
        }
    }

    @Test
    func `Rejects name with null byte`() {
        #expect(throws: ISO_32000.COS.Name.Error.containsNullByte) {
            _ = try ISO_32000.COS.Name("Hello\0World")
        }
    }

    // MARK: - Well-Known Names

    @Test
    func `Document structure names`() {
        #expect(ISO_32000.COS.Name.type.rawValue == "Type")
        #expect(ISO_32000.COS.Name.catalog.rawValue == "Catalog")
        #expect(ISO_32000.COS.Name.pages.rawValue == "Pages")
        #expect(ISO_32000.COS.Name.page.rawValue == "Page")
    }

    @Test
    func `Page attribute names`() {
        #expect(ISO_32000.COS.Name.mediaBox.rawValue == "MediaBox")
        #expect(ISO_32000.COS.Name.contents.rawValue == "Contents")
        #expect(ISO_32000.COS.Name.resources.rawValue == "Resources")
    }

    @Test
    func `Standard 14 font names`() {
        #expect(ISO_32000.COS.Name.helvetica.rawValue == "Helvetica")
        #expect(ISO_32000.COS.Name.helveticaBold.rawValue == "Helvetica-Bold")
        #expect(ISO_32000.COS.Name.timesRoman.rawValue == "Times-Roman")
        #expect(ISO_32000.COS.Name.courier.rawValue == "Courier")
    }

    @Test
    func `Stream attribute names`() {
        #expect(ISO_32000.COS.Name.length.rawValue == "Length")
        #expect(ISO_32000.COS.Name.filter.rawValue == "Filter")
        #expect(ISO_32000.COS.Name.flateDecode.rawValue == "FlateDecode")
    }

    // MARK: - Equality

    @Test
    func `Names are equal when raw values match`() throws {
        let a = try ISO_32000.COS.Name("Test")
        let b = try ISO_32000.COS.Name("Test")
        #expect(a == b)
    }

    @Test
    func `Names are case-sensitive`() throws {
        let lower = try ISO_32000.COS.Name("test")
        let upper = try ISO_32000.COS.Name("TEST")
        #expect(lower != upper)
    }

    // MARK: - Description

    @Test
    func `Description includes leading slash`() throws {
        let name = try ISO_32000.COS.Name("Type")
        #expect(name.description == "/Type")
    }

    // MARK: - Error Descriptions

    @Test
    func `Error descriptions are informative`() {
        #expect(ISO_32000.COS.Name.Error.empty.description == "Name cannot be empty")
        #expect(
            ISO_32000.COS.Name.Error.containsNullByte.description
                == "Name cannot contain null bytes"
        )
        #expect(
            ISO_32000.COS.Name.Error.containsWhitespace.description
                == "Name cannot contain whitespace"
        )
        #expect(ISO_32000.COS.Name.Error.tooLong(200).description.contains("200 bytes"))
    }
}
