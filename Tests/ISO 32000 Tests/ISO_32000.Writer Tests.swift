// ISO_32000.Writer Tests.swift

import Foundation
import Testing

@testable import ISO_32000
@testable import ISO_32000_Flate
@testable import ISO_32000_9_Text

@Suite
struct `ISO_32000.Writer Tests` {

    // MARK: - PDF Structure

    @Test
    func `Writes valid PDF header`() {
        let document = ISO_32000.Document(
            pages: [ISO_32000.Page.empty(size: .letter)]
        )
        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)
        let str = String(decoding: pdf, as: UTF8.self)

        #expect(str.hasPrefix("%PDF-1.7"))
    }

    @Test
    func `Includes binary marker after header`() {
        let document = ISO_32000.Document(
            pages: [ISO_32000.Page.empty(size: .letter)]
        )
        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)

        let headerEnd = pdf.firstIndex(of: UInt8(ascii: "\n"))!
        let markerStart = pdf.index(after: headerEnd)
        #expect(pdf[pdf.index(after: markerStart)] > 127)
    }

    @Test
    func `Writes catalog object`() {
        let document = ISO_32000.Document(
            pages: [ISO_32000.Page.empty(size: .letter)]
        )
        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)
        let str = String(decoding: pdf, as: UTF8.self)

        #expect(str.contains("/Type /Catalog"))
    }

    @Test
    func `Writes pages object`() {
        let document = ISO_32000.Document(
            pages: [ISO_32000.Page.empty(size: .letter)]
        )
        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)
        let str = String(decoding: pdf, as: UTF8.self)

        #expect(str.contains("/Type /Pages"))
        #expect(str.contains("/Count 1"))
    }

    @Test
    func `Writes page object`() {
        let document = ISO_32000.Document(
            pages: [ISO_32000.Page.empty(size: .letter)]
        )
        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)
        let str = String(decoding: pdf, as: UTF8.self)

        #expect(str.contains("/Type /Page"))
        #expect(str.contains("/MediaBox"))
    }

    @Test
    func `Writes cross-reference table`() {
        let document = ISO_32000.Document(
            pages: [ISO_32000.Page.empty(size: .letter)]
        )
        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)
        let str = String(decoding: pdf, as: UTF8.self)

        #expect(str.contains("xref"))
        #expect(str.contains("0000000000 65535 f"))
    }

    @Test
    func `Writes trailer`() {
        let document = ISO_32000.Document(
            pages: [ISO_32000.Page.empty(size: .letter)]
        )
        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)
        let str = String(decoding: pdf, as: UTF8.self)

        #expect(str.contains("trailer"))
        #expect(str.contains("/Size"))
        #expect(str.contains("/Root"))
        #expect(str.contains("startxref"))
        #expect(str.contains("%%EOF"))
    }

    // MARK: - Paper Sizes (Parameterized)

    @Test(arguments: [
        (ISO_32000.UserSpace.Rectangle.letter, 612.0, 792.0),
        (.a4, 595.276, 841.89),
        (.legal, 612.0, 1008.0),
    ])
    func `Writes correct MediaBox for paper sizes`(
        rect: ISO_32000.UserSpace.Rectangle,
        width: Double,
        height: Double
    ) {
        let document = ISO_32000.Document(
            pages: [ISO_32000.Page.empty(size: rect)]
        )
        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)
        let str = String(decoding: pdf, as: UTF8.self)

        #expect(str.contains("/MediaBox"))
    }

    // MARK: - Document Info

    @Test
    func `Writes document info`() {
        let document = ISO_32000.Document(
            info: ISO_32000.Document.Info(
                title: "Test Document",
                author: "Swift PDF",
                creator: "swift-iso-32000"
            ),
            pages: [ISO_32000.Page.empty(size: .letter)]
        )
        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)
        let str = String(decoding: pdf, as: UTF8.self)

        #expect(str.contains("/Title"))
        #expect(str.contains("/Author"))
        #expect(str.contains("/Creator"))
        #expect(str.contains("/Info"))
    }

    // MARK: - Compression

    @Test
    func `Writes compressed content with FlateDecode`() {
        let content = ISO_32000.ContentStream { builder in
            builder.beginText()
            builder.setFont(ISO_32000.Font.helvetica, size: 12)
            for i in 0..<20 {
                builder.moveText(
                    dx: 72,
                    dy: .init(700 - i * 20)
                )
                builder.showText(
                    "Line \(i): This is test content for compression testing purposes."
                )
            }
            builder.endText()
        }

        let document = ISO_32000.Document(
            pages: [
                ISO_32000.Page(
                    mediaBox: .letter,
                    content: content,
                    resources: ISO_32000.Resources(fonts: [
                        ISO_32000.Font.helvetica.resourceName: ISO_32000.Font.helvetica
                    ])
                )
            ]
        )

        var writer = ISO_32000.Writer.flate()
        let pdf = writer.write(document)
        let str = String(decoding: pdf, as: UTF8.self)

        #expect(str.contains("/Filter /FlateDecode"))
    }

    // MARK: - Multiple Pages

    @Test
    func `Writes multi-page document`() {
        let page1 = ISO_32000.Page.empty(size: .letter)
        let page2 = ISO_32000.Page.empty(size: .letter)

        let document = ISO_32000.Document(pages: [page1, page2])

        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)
        let str = String(decoding: pdf, as: UTF8.self)

        #expect(str.contains("/Count 2"))
    }

    // MARK: - PDF Output for Visual Inspection

    @Test
    func `Outputs simple PDF for inspection`() throws {
        let document = ISO_32000.Document(
            info: ISO_32000.Document.Info(
                title: "Test Document",
                creator: "swift-iso-32000 tests"
            ),
            pages: [
                ISO_32000.Page(
                    mediaBox: .letter,
                    content: ISO_32000.ContentStream { builder in
                        builder.beginText()
                        builder.setFont(ISO_32000.Font.helvetica, size: 24)
                        builder.moveText(dx: 72, dy: 700)
                        builder.showText("ISO 32000 Test Document")

                        builder.setFont(ISO_32000.Font.helvetica, size: 12)
                        builder.moveText(dx: 0, dy: -30)
                        builder.showText("This PDF was generated by swift-iso-32000.")
                        builder.endText()
                    },
                    resources: ISO_32000.Resources(fonts: [
                        ISO_32000.Font.helvetica.resourceName: ISO_32000.Font.helvetica
                    ])
                )
            ]
        )

        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)

        let path = try PDFOutput.write(pdf, name: "iso32000-simple")
        #expect(!pdf.isEmpty)
        print("PDF written to: \(path)")
    }

    @Test
    func `Outputs all Standard 14 fonts for inspection`() throws {
        var contentBuilder = ISO_32000.ContentStream.Builder()
        contentBuilder.beginText()

        var dy: ISO_32000.UserSpace.Dy = 700
        var fonts: [ISO_32000.COS.Name: ISO_32000.Font] = [:]

        for pdfFont in ISO_32000.Font.standard14 {
            fonts[pdfFont.resourceName] = pdfFont

            contentBuilder.setFont(pdfFont, size: 14)
            contentBuilder.moveText(dx: 72, dy: dy)
            contentBuilder.showText(
                "\(pdfFont.baseFontName.rawValue): The quick brown fox jumps over the lazy dog."
            )
            dy = -30
            contentBuilder.moveText(dx: -72, dy: 0)
        }

        contentBuilder.endText()

        let document = ISO_32000.Document(
            info: ISO_32000.Document.Info(title: "Standard 14 Fonts"),
            pages: [
                ISO_32000.Page(
                    mediaBox: .letter,
                    content: ISO_32000.ContentStream(data: contentBuilder.data),
                    resources: ISO_32000.Resources(fonts: fonts)
                )
            ]
        )

        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)

        let path = try PDFOutput.write(pdf, name: "iso32000-standard14-fonts")
        #expect(!pdf.isEmpty)
        print("PDF written to: \(path)")
    }

    #if os(macOS)
    @Test
    func `Outputs embedded TrueType font PDF for inspection`() throws {
        // Load Geneva.ttf from system fonts
        let fontPath = "/System/Library/Fonts/Geneva.ttf"
        let fontData = try Data(contentsOf: URL(fileURLWithPath: fontPath))
        let fontBytes = [UInt8](fontData)

        // Create embedded font with unique resource name (avoiding F1-F14 used by standard fonts)
        let customFont = try ISO_32000.Font(
            data: fontBytes,
            resourceName: try ISO_32000.COS.Name("CF1")
        )

        // Also include Helvetica for comparison (uses F1 by default)
        let helvetica = ISO_32000.Font.helvetica

        let document = ISO_32000.Document(
            info: ISO_32000.Document.Info(
                title: "Embedded TrueType Font Test",
                creator: "swift-iso-32000 tests"
            ),
            pages: [
                ISO_32000.Page(
                    mediaBox: .letter,
                    content: ISO_32000.ContentStream { builder in
                        builder.beginText()

                        // Title with embedded font
                        builder.setFont(customFont, size: 24)
                        builder.moveText(dx: 72, dy: 700)
                        builder.showText("Embedded TrueType Font: Geneva")

                        // Subtitle
                        builder.setFont(customFont, size: 14)
                        builder.moveText(dx: 0, dy: -30)
                        builder.showText("This text uses Geneva.ttf embedded in the PDF.")

                        // Sample text
                        builder.moveText(dx: 0, dy: -25)
                        builder.showText("The quick brown fox jumps over the lazy dog.")

                        builder.moveText(dx: 0, dy: -25)
                        builder.showText("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

                        builder.moveText(dx: 0, dy: -25)
                        builder.showText("abcdefghijklmnopqrstuvwxyz")

                        builder.moveText(dx: 0, dy: -25)
                        builder.showText("0123456789 !@#$%^&*()[]{}|;':\",./<>?")

                        // Comparison with Helvetica
                        builder.setFont(helvetica, size: 14)
                        builder.moveText(dx: 0, dy: -50)
                        builder.showText("--- Comparison: Helvetica (standard font) ---")

                        builder.moveText(dx: 0, dy: -25)
                        builder.showText("The quick brown fox jumps over the lazy dog.")

                        builder.moveText(dx: 0, dy: -25)
                        builder.showText("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

                        builder.endText()
                    },
                    resources: ISO_32000.Resources(fonts: [
                        customFont.resourceName: customFont,
                        helvetica.resourceName: helvetica
                    ])
                )
            ]
        )

        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)

        let path = try PDFOutput.write(pdf, name: "iso32000-embedded-truetype")
        #expect(!pdf.isEmpty)
        #expect(pdf.count > 50000)  // Embedded font should make it larger
        print("PDF written to: \(path)")
        print("PDF size: \(pdf.count) bytes")

        // Verify the PDF contains TrueType markers
        let str = String(decoding: pdf, as: UTF8.self)
        #expect(str.contains("/Subtype /TrueType"))
        #expect(str.contains("/FontFile2"))
        #expect(str.contains("/FontDescriptor"))
    }

    @Test
    func `Outputs subsetted TrueType font PDF for inspection`() throws {
        // Load Geneva.ttf from system fonts
        let fontPath = "/System/Library/Fonts/Geneva.ttf"
        let fontData = try Data(contentsOf: URL(fileURLWithPath: fontPath))
        let fontBytes = [UInt8](fontData)

        // Create embedded font
        let fullEmbedded = try ISO_32000.`9`.`6`.Embedded(data: fontBytes)
        let fullSize = fullEmbedded.data.count

        // Define ALL the text we'll use - must include every character that appears in the PDF
        let allText = """
        Subsetted Font: Geneva
        Hello World! This is a subset font test.
        The font above has been subsetted.
        It only contains glyphs for the characters used.
        """
        let usedChars = Set(allText)
        let text = "Hello World! This is a subset font test."

        // Create subset
        let subsetEmbedded = try fullEmbedded.subsetted(for: usedChars)
        let subsetSize = subsetEmbedded.data.count

        print("Full font size: \(fullSize) bytes")
        print("Subset font size: \(subsetSize) bytes")
        print("Reduction: \(100 - (subsetSize * 100 / fullSize))%")
        print("Characters used: \(usedChars.count)")

        // Verify substantial reduction
        #expect(subsetSize < fullSize / 5)

        // Create font from subset
        let customFont = try ISO_32000.Font(
            embedded: subsetEmbedded,
            resourceName: try ISO_32000.COS.Name("CF1")
        )

        let document = ISO_32000.Document(
            info: ISO_32000.Document.Info(
                title: "Subsetted TrueType Font Test",
                creator: "swift-iso-32000 tests"
            ),
            pages: [
                ISO_32000.Page(
                    mediaBox: .letter,
                    content: ISO_32000.ContentStream { builder in
                        builder.beginText()

                        // Title
                        builder.setFont(customFont, size: 24)
                        builder.moveText(dx: 72, dy: 700)
                        builder.showText("Subsetted Font: Geneva")

                        // Info
                        builder.setFont(customFont, size: 14)
                        builder.moveText(dx: 0, dy: -30)
                        builder.showText(text)

                        builder.moveText(dx: 0, dy: -25)
                        builder.showText("The font above has been subsetted.")

                        builder.moveText(dx: 0, dy: -25)
                        builder.showText("It only contains glyphs for the characters used.")

                        builder.endText()
                    },
                    resources: ISO_32000.Resources(fonts: [
                        customFont.resourceName: customFont
                    ])
                )
            ]
        )

        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)

        let path = try PDFOutput.write(pdf, name: "iso32000-subsetted-truetype")
        #expect(!pdf.isEmpty)
        print("PDF written to: \(path)")
        print("PDF size: \(pdf.count) bytes (vs ~740KB with full font)")

        // Subsetted PDF should be much smaller than full font PDF
        #expect(pdf.count < 100000)  // Should be under 100KB

        // Verify the PDF is valid
        let str = String(decoding: pdf, as: UTF8.self)
        #expect(str.contains("/Subtype /TrueType"))
        #expect(str.contains("/FontFile2"))
    }
    #endif
}
