// ISO_32000_Tests.swift

import Testing
@testable import ISO_32000
@testable import ISO_32000_Flate

@Suite("ISO 32000 - PDF Object Model")
struct ISO32000Tests {

    // MARK: - COS Name Tests

    @Test("Name creation")
    func nameCreation() throws {
        let name = try ISO_32000.COS.Name("Type")
        #expect(name.rawValue == "Type")
    }

    @Test("Name validation rejects empty")
    func nameRejectsEmpty() {
        #expect(throws: ISO_32000.COS.Name.Error.empty) {
            _ = try ISO_32000.COS.Name("")
        }
    }

    @Test("Name validation rejects whitespace")
    func nameRejectsWhitespace() {
        #expect(throws: ISO_32000.COS.Name.Error.containsWhitespace) {
            _ = try ISO_32000.COS.Name("Hello World")
        }
    }

    @Test("Well-known names exist")
    func wellKnownNames() {
        #expect(ISO_32000.COS.Name.type.rawValue == "Type")
        #expect(ISO_32000.COS.Name.catalog.rawValue == "Catalog")
        #expect(ISO_32000.COS.Name.page.rawValue == "Page")
        #expect(ISO_32000.COS.Name.helvetica.rawValue == "Helvetica")
    }

    // MARK: - COS String Tests

    @Test("String literal serialization")
    func stringLiteralSerialization() {
        let str = ISO_32000.COS.StringValue("Hello")
        let bytes = str.asLiteral()
        #expect(bytes == Array("(Hello)".utf8))
    }

    @Test("String hexadecimal serialization")
    func stringHexSerialization() {
        let str = ISO_32000.COS.StringValue("Hi")
        let bytes = str.asHexadecimal()
        #expect(bytes == Array("<4869>".utf8))
    }

    // MARK: - COS Dictionary Tests

    @Test("Dictionary creation and access")
    func dictionaryCreation() throws {
        var dict = ISO_32000.COS.Dictionary()
        dict[.type] = .name(.catalog)
        #expect(dict[.type] == .name(.catalog))
    }

    // MARK: - Rectangle Tests

    @Test("A4 paper size")
    func a4Size() {
        let a4 = ISO_32000.Rectangle.a4
        #expect(a4.width > 595 && a4.width < 596)
        #expect(a4.height > 841 && a4.height < 842)
    }

    @Test("Letter paper size")
    func letterSize() {
        let letter = ISO_32000.Rectangle.letter
        #expect(letter.width == 612)
        #expect(letter.height == 792)
    }

    // MARK: - Font Tests

    @Test("Standard 14 fonts")
    func standard14Fonts() {
        let helvetica = ISO_32000.Font(.helvetica)
        #expect(helvetica.baseFontName == .helvetica)
        #expect(helvetica.resourceName.rawValue == "F1")
    }

    @Test("Font metrics")
    func fontMetrics() {
        let metrics = ISO_32000.Font.Standard14.helvetica.metrics

        // Space should be around 278 units
        let spaceWidth = metrics.glyphWidth(for: " ")
        #expect(spaceWidth == 278)

        // Measure "Hello"
        let helloWidth = metrics.stringWidth("Hello")
        #expect(helloWidth > 0)
    }

    // MARK: - Content Stream Tests

    @Test("Content stream builder")
    func contentStreamBuilder() {
        let content = ISO_32000.ContentStream { builder in
            builder.beginText()
            builder.setFont(ISO_32000.Font(.helvetica), size: 12)
            builder.moveText(x: 72, y: 720)
            builder.showText("Hello")
            builder.endText()
        }

        // Should contain BT, Tf, Td, Tj, ET operators
        let str = String(decoding: content.data, as: UTF8.self)
        #expect(str.contains("BT"))
        #expect(str.contains("Tf"))
        #expect(str.contains("ET"))
    }

    // MARK: - Writer Tests

    @Test("Write simple document")
    func writeSimpleDocument() {
        let document = ISO_32000.Document(
            page: ISO_32000.Page(
                mediaBox: .letter,
                content: ISO_32000.ContentStream { builder in
                    builder.beginText()
                    builder.setFont(ISO_32000.Font(.helvetica), size: 12)
                    builder.moveText(x: 72, y: 720)
                    builder.showText("Hello, World!")
                    builder.endText()
                },
                resources: ISO_32000.Resources(fonts: [
                    ISO_32000.Font(.helvetica).resourceName: ISO_32000.Font(.helvetica)
                ])
            )
        )

        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)

        // Check PDF structure
        let str = String(decoding: pdf, as: UTF8.self)
        #expect(str.hasPrefix("%PDF-1.7"))
        #expect(str.contains("/Type /Catalog"))
        #expect(str.contains("/Type /Pages"))
        #expect(str.contains("/Type /Page"))
        #expect(str.contains("%%EOF"))
    }

    @Test("Write document with compression")
    func writeDocumentWithCompression() {
        // Create content stream large enough that compression is beneficial
        // (ZLIB adds 6 bytes overhead, so we need content > ~100 bytes)
        let document = ISO_32000.Document(
            page: ISO_32000.Page(
                mediaBox: .a4,
                content: ISO_32000.ContentStream { builder in
                    builder.beginText()
                    builder.setFont(ISO_32000.Font(.timesRoman), size: 12)
                    builder.moveText(x: 72, y: 700)
                    builder.showText("This is a longer document that will benefit from compression.")
                    builder.moveText(x: 0, y: -20)
                    builder.showText("Adding multiple lines of text to ensure the content stream")
                    builder.moveText(x: 0, y: -20)
                    builder.showText("is large enough that ZLIB compression actually reduces size.")
                    builder.moveText(x: 0, y: -20)
                    builder.showText("The ZLIB format adds 6 bytes of overhead (header + checksum),")
                    builder.moveText(x: 0, y: -20)
                    builder.showText("so very small streams may not benefit from compression at all.")
                    builder.endText()
                },
                resources: ISO_32000.Resources(fonts: [
                    ISO_32000.Font(.timesRoman).resourceName: ISO_32000.Font(.timesRoman)
                ])
            )
        )

        var writer = ISO_32000.Writer.flate()
        let pdf = writer.write(document)

        // Should contain FlateDecode filter
        let str = String(decoding: pdf, as: UTF8.self)
        #expect(str.contains("/Filter /FlateDecode"))
    }

    @Test("Write document with metadata")
    func writeDocumentWithMetadata() {
        let document = ISO_32000.Document(
            page: ISO_32000.Page.empty(size: .letter),
            info: ISO_32000.Info(
                title: "Test Document",
                author: "Swift PDF",
                creator: "swift-iso-32000"
            )
        )

        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)

        let str = String(decoding: pdf, as: UTF8.self)
        #expect(str.contains("/Title"))
        #expect(str.contains("/Author"))
        #expect(str.contains("/Creator"))
    }

    // MARK: - Version Tests

    @Test("PDF version header")
    func versionHeader() {
        #expect(ISO_32000.Version.v1_7.header == "%PDF-1.7")
        #expect(ISO_32000.Version.v2_0.header == "%PDF-2.0")
    }
}
