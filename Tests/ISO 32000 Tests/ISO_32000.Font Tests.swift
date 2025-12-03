// ISO_32000.Font Tests.swift

import Testing
@testable import ISO_32000

@Suite
struct `ISO_32000.Font Tests` {

    // MARK: - Standard 14 Fonts

    @Test
    func `Standard 14 fonts collection has 14 fonts`() {
        #expect(ISO_32000.Font.standard14.count == 14)
    }

    @Test
    func `All Standard 14 fonts have unique base font names`() {
        let names = ISO_32000.Font.standard14.map { $0.baseFontName }
        let uniqueNames = Set(names)
        #expect(uniqueNames.count == 14)
    }

    @Test
    func `All Standard 14 fonts have unique resource names`() {
        let resources = ISO_32000.Font.standard14.map { $0.resourceName }
        let uniqueResources = Set(resources)
        #expect(uniqueResources.count == 14)
    }

    // MARK: - Helvetica Family

    @Test
    func `Helvetica regular font`() {
        let font = ISO_32000.Font.Helvetica.regular
        #expect(font.baseFontName.rawValue == "Helvetica")
        #expect(font.resourceName.rawValue == "F1")
        #expect(font.family == .helvetica)
        #expect(!font.isMonospaced)
    }

    @Test
    func `Helvetica bold font`() {
        let font = ISO_32000.Font.Helvetica.bold
        #expect(font.baseFontName.rawValue == "Helvetica-Bold")
        #expect(font.resourceName.rawValue == "F2")
        #expect(font.family == .helvetica)
        #expect(!font.isMonospaced)
    }

    @Test
    func `Helvetica oblique font`() {
        let font = ISO_32000.Font.Helvetica.oblique
        #expect(font.baseFontName.rawValue == "Helvetica-Oblique")
        #expect(font.resourceName.rawValue == "F3")
        #expect(font.family == .helvetica)
        #expect(!font.isMonospaced)
    }

    @Test
    func `Helvetica bold oblique font`() {
        let font = ISO_32000.Font.Helvetica.boldOblique
        #expect(font.baseFontName.rawValue == "Helvetica-BoldOblique")
        #expect(font.resourceName.rawValue == "F4")
        #expect(font.family == .helvetica)
        #expect(!font.isMonospaced)
    }

    // MARK: - Times Family

    @Test
    func `Times regular font`() {
        let font = ISO_32000.Font.Times.regular
        #expect(font.baseFontName.rawValue == "Times-Roman")
        #expect(font.resourceName.rawValue == "F5")
        #expect(font.family == .times)
        #expect(!font.isMonospaced)
    }

    @Test
    func `Times bold font`() {
        let font = ISO_32000.Font.Times.bold
        #expect(font.baseFontName.rawValue == "Times-Bold")
        #expect(font.resourceName.rawValue == "F6")
        #expect(font.family == .times)
        #expect(!font.isMonospaced)
    }

    @Test
    func `Times italic font`() {
        let font = ISO_32000.Font.Times.italic
        #expect(font.baseFontName.rawValue == "Times-Italic")
        #expect(font.resourceName.rawValue == "F7")
        #expect(font.family == .times)
        #expect(!font.isMonospaced)
    }

    @Test
    func `Times bold italic font`() {
        let font = ISO_32000.Font.Times.boldItalic
        #expect(font.baseFontName.rawValue == "Times-BoldItalic")
        #expect(font.resourceName.rawValue == "F8")
        #expect(font.family == .times)
        #expect(!font.isMonospaced)
    }

    // MARK: - Courier Family

    @Test
    func `Courier regular font`() {
        let font = ISO_32000.Font.Courier.regular
        #expect(font.baseFontName.rawValue == "Courier")
        #expect(font.resourceName.rawValue == "F9")
        #expect(font.family == .courier)
        #expect(font.isMonospaced)
    }

    @Test
    func `Courier bold font`() {
        let font = ISO_32000.Font.Courier.bold
        #expect(font.baseFontName.rawValue == "Courier-Bold")
        #expect(font.resourceName.rawValue == "F10")
        #expect(font.family == .courier)
        #expect(font.isMonospaced)
    }

    @Test
    func `Courier oblique font`() {
        let font = ISO_32000.Font.Courier.oblique
        #expect(font.baseFontName.rawValue == "Courier-Oblique")
        #expect(font.resourceName.rawValue == "F11")
        #expect(font.family == .courier)
        #expect(font.isMonospaced)
    }

    @Test
    func `Courier bold oblique font`() {
        let font = ISO_32000.Font.Courier.boldOblique
        #expect(font.baseFontName.rawValue == "Courier-BoldOblique")
        #expect(font.resourceName.rawValue == "F12")
        #expect(font.family == .courier)
        #expect(font.isMonospaced)
    }

    // MARK: - Special Fonts

    @Test
    func `Symbol font`() {
        let font = ISO_32000.Font.Symbol.regular
        #expect(font.baseFontName.rawValue == "Symbol")
        #expect(font.resourceName.rawValue == "F13")
        #expect(font.family == .symbol)
        #expect(!font.isMonospaced)
    }

    @Test
    func `ZapfDingbats font`() {
        let font = ISO_32000.Font.ZapfDingbats.regular
        #expect(font.baseFontName.rawValue == "ZapfDingbats")
        #expect(font.resourceName.rawValue == "F14")
        #expect(font.family == .zapfDingbats)
        #expect(!font.isMonospaced)
    }

    // MARK: - Convenience Accessors

    @Test
    func `Helvetica accessor returns Helvetica regular`() {
        let font = ISO_32000.Font.helvetica
        #expect(font == ISO_32000.Font.Helvetica.regular)
    }

    @Test
    func `Times accessor returns Times regular`() {
        let font = ISO_32000.Font.times
        #expect(font == ISO_32000.Font.Times.regular)
    }

    @Test
    func `Courier accessor returns Courier regular`() {
        let font = ISO_32000.Font.courier
        #expect(font == ISO_32000.Font.Courier.regular)
    }

    // MARK: - Equality

    @Test
    func `Fonts are equal when same base font`() {
        let a = ISO_32000.Font.helvetica
        let b = ISO_32000.Font.helvetica
        #expect(a == b)
    }

    @Test
    func `Fonts differ when different base fonts`() {
        let a = ISO_32000.Font.helvetica
        let b = ISO_32000.Font.times
        #expect(a != b)
    }

    // MARK: - Font Variants

    @Test
    func `Bold variant of Helvetica`() {
        let font = ISO_32000.Font.helvetica
        let bold = font.bold
        #expect(bold.weight == .bold)
        #expect(bold.family == .helvetica)
    }

    @Test
    func `Italic variant of Helvetica`() {
        let font = ISO_32000.Font.helvetica
        let italic = font.italic
        #expect(italic.style == .oblique)
        #expect(italic.family == .helvetica)
    }

    @Test
    func `Italic variant of Times`() {
        let font = ISO_32000.Font.times
        let italic = font.italic
        #expect(italic.style == .italic)
        #expect(italic.family == .times)
    }

    // MARK: - Text Measurement

    @Test
    func `String width calculation`() {
        let font = ISO_32000.Font.helvetica
        let width = font.stringWidth("Hello", atSize: 12)
        #expect(width > 0)
    }
}
