// ISO_32000.Font Tests.swift

import Testing
@testable import ISO_32000

@Suite
struct `ISO_32000.Font Tests` {

    // MARK: - Standard 14 Fonts (Parameterized)

    @Test(arguments: ISO_32000.Font.Standard14.allCases)
    func `All Standard 14 fonts exist`(font: ISO_32000.Font.Standard14) {
        let pdfFont = ISO_32000.Font(font)
        #expect(pdfFont.baseFontName.rawValue == font.rawValue)
    }

    @Test(arguments: ISO_32000.Font.Standard14.allCases)
    func `Resource names are unique`(font: ISO_32000.Font.Standard14) {
        let pdfFont = ISO_32000.Font(font)
        #expect(pdfFont.resourceName.rawValue.hasPrefix("F"))
    }

    // MARK: - Font Families

    @Test(arguments: [
        (ISO_32000.Font.Standard14.helvetica, "Helvetica"),
        (.helveticaBold, "Helvetica-Bold"),
        (.helveticaOblique, "Helvetica-Oblique"),
        (.helveticaBoldOblique, "Helvetica-BoldOblique")
    ])
    func `Helvetica family base fonts`(font: ISO_32000.Font.Standard14, expectedName: String) {
        #expect(font.baseFontName.rawValue == expectedName)
    }

    @Test(arguments: [
        (ISO_32000.Font.Standard14.timesRoman, "Times-Roman"),
        (.timesBold, "Times-Bold"),
        (.timesItalic, "Times-Italic"),
        (.timesBoldItalic, "Times-BoldItalic")
    ])
    func `Times family base fonts`(font: ISO_32000.Font.Standard14, expectedName: String) {
        #expect(font.baseFontName.rawValue == expectedName)
    }

    @Test(arguments: [
        (ISO_32000.Font.Standard14.courier, "Courier"),
        (.courierBold, "Courier-Bold"),
        (.courierOblique, "Courier-Oblique"),
        (.courierBoldOblique, "Courier-BoldOblique")
    ])
    func `Courier family base fonts`(font: ISO_32000.Font.Standard14, expectedName: String) {
        #expect(font.baseFontName.rawValue == expectedName)
    }

    @Test(arguments: [
        (ISO_32000.Font.Standard14.symbol, "Symbol"),
        (.zapfDingbats, "ZapfDingbats")
    ])
    func `Special fonts`(font: ISO_32000.Font.Standard14, expectedName: String) {
        #expect(font.baseFontName.rawValue == expectedName)
    }

    // MARK: - Monospaced Detection

    @Test(arguments: [
        ISO_32000.Font.Standard14.courier,
        .courierBold,
        .courierOblique,
        .courierBoldOblique
    ])
    func `Courier fonts are monospaced`(font: ISO_32000.Font.Standard14) {
        #expect(font.isMonospaced)
    }

    @Test(arguments: [
        ISO_32000.Font.Standard14.helvetica,
        .helveticaBold,
        .timesRoman,
        .symbol,
        .zapfDingbats
    ])
    func `Non-Courier fonts are not monospaced`(font: ISO_32000.Font.Standard14) {
        #expect(!font.isMonospaced)
    }

    // MARK: - Resource Name Mapping

    @Test(arguments: [
        (ISO_32000.Font.Standard14.helvetica, "F1"),
        (.helveticaBold, "F2"),
        (.helveticaOblique, "F3"),
        (.helveticaBoldOblique, "F4"),
        (.timesRoman, "F5"),
        (.timesBold, "F6"),
        (.timesItalic, "F7"),
        (.timesBoldItalic, "F8"),
        (.courier, "F9"),
        (.courierBold, "F10"),
        (.courierOblique, "F11"),
        (.courierBoldOblique, "F12"),
        (.symbol, "F13"),
        (.zapfDingbats, "F14")
    ])
    func `Resource names map correctly`(font: ISO_32000.Font.Standard14, expectedResource: String) {
        let pdfFont = ISO_32000.Font(font)
        #expect(pdfFont.resourceName.rawValue == expectedResource)
    }

    // MARK: - Equality

    @Test
    func `Fonts are equal when same Standard14`() {
        let a = ISO_32000.Font(.helvetica)
        let b = ISO_32000.Font(.helvetica)
        #expect(a == b)
    }

    @Test
    func `Fonts differ when different Standard14`() {
        let a = ISO_32000.Font(.helvetica)
        let b = ISO_32000.Font(.timesRoman)
        #expect(a != b)
    }
}
