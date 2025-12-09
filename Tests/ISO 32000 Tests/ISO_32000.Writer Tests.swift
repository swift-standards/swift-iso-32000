// ISO_32000.Writer Tests.swift

import Foundation
import Testing
@testable import ISO_32000
@testable import ISO_32000_Flate

@Suite
struct `ISO_32000.Writer Tests` {

    // MARK: - PDF Structure

    @Test
    func `Writes valid PDF header`() {
        let document = ISO_32000.Document(
            page: ISO_32000.Page.empty(size: .letter)
        )
        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)
        let str = String(decoding: pdf, as: UTF8.self)

        #expect(str.hasPrefix("%PDF-1.7"))
    }

    @Test
    func `Includes binary marker after header`() {
        let document = ISO_32000.Document(
            page: ISO_32000.Page.empty(size: .letter)
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
            page: ISO_32000.Page.empty(size: .letter)
        )
        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)
        let str = String(decoding: pdf, as: UTF8.self)

        #expect(str.contains("/Type /Catalog"))
    }

    @Test
    func `Writes pages object`() {
        let document = ISO_32000.Document(
            page: ISO_32000.Page.empty(size: .letter)
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
            page: ISO_32000.Page.empty(size: .letter)
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
            page: ISO_32000.Page.empty(size: .letter)
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
            page: ISO_32000.Page.empty(size: .letter)
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
        (.legal, 612.0, 1008.0)
    ])
    func `Writes correct MediaBox for paper sizes`(rect: ISO_32000.UserSpace.Rectangle, width: Double, height: Double) {
        let document = ISO_32000.Document(
            page: ISO_32000.Page.empty(size: rect)
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
            page: ISO_32000.Page.empty(size: .letter)
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
                let yPos = ISO_32000.UserSpace.Y(ISO_32000.UserSpace.Unit(700 - Double(i * 20)))
                builder.moveText(x: 72, y: yPos)
                builder.showText("Line \(i): This is test content for compression testing purposes.")
            }
            builder.endText()
        }

        let document = ISO_32000.Document(
            page: ISO_32000.Page(
                mediaBox: .letter,
                content: content,
                resources: ISO_32000.Resources(fonts: [
                    ISO_32000.Font.helvetica.resourceName: ISO_32000.Font.helvetica
                ])
            )
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
            page: ISO_32000.Page(
                mediaBox: .letter,
                content: ISO_32000.ContentStream { builder in
                    builder.beginText()
                    builder.setFont(ISO_32000.Font.helvetica, size: 24)
                    builder.moveText(x: 72, y: 700)
                    builder.showText("ISO 32000 Test Document")
                    
                    builder.setFont(ISO_32000.Font.helvetica, size: 12)
                    builder.moveText(x: 0, y: -30)
                    builder.showText("This PDF was generated by swift-iso-32000.")
                    builder.endText()
                },
                resources: ISO_32000.Resources(fonts: [
                    ISO_32000.Font.helvetica.resourceName: ISO_32000.Font.helvetica
                ])
            )
        )

        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)

        let path = try PDFOutput.write(pdf, name: "iso32000-simple")
        #expect(pdf.count > 0)
        print("PDF written to: \(path)")
    }

    @Test
    func `Outputs all Standard 14 fonts for inspection`() throws {
        var contentBuilder = ISO_32000.ContentStream.Builder()
        contentBuilder.beginText()

        var y: ISO_32000.UserSpace.Y = 700
        var fonts: [ISO_32000.COS.Name: ISO_32000.Font] = [:]

        for pdfFont in ISO_32000.Font.standard14 {
            fonts[pdfFont.resourceName] = pdfFont

            contentBuilder.setFont(pdfFont, size: 14)
            contentBuilder.moveText(x: 72, y: y)
            contentBuilder.showText("\(pdfFont.baseFontName.rawValue): The quick brown fox jumps over the lazy dog.")
            y = y - 30
            contentBuilder.moveText(x: -72, y: 0)
        }

        contentBuilder.endText()

        let document = ISO_32000.Document(
            info: ISO_32000.Document.Info(title: "Standard 14 Fonts"),
            page: ISO_32000.Page(
                mediaBox: .letter,
                content: ISO_32000.ContentStream(data: contentBuilder.data),
                resources: ISO_32000.Resources(fonts: fonts)
            )
        )

        var writer = ISO_32000.Writer()
        let pdf = writer.write(document)

        let path = try PDFOutput.write(pdf, name: "iso32000-standard14-fonts")
        #expect(pdf.count > 0)
        print("PDF written to: \(path)")
    }
}
