// ISO 32000-2:2020, 9.6 Simple fonts
//
// Sections:
//   9.6.1  General
//   9.6.2  Standard Type 1 fonts (Standard 14)
//   9.6.3  Type 1 fonts
//   9.6.4  Multiple master fonts
//   9.6.5  TrueType fonts
//   9.6.6  Type 3 fonts

public import ISO_32000_7_Syntax
public import ISO_32000_8_Graphics
public import ISO_32000_Shared

extension ISO_32000.`9` {
    /// ISO 32000-2:2020, 9.6 Simple fonts
    public enum `6` {}
}

// MARK: - Font Type

extension ISO_32000.`9`.`6` {
    /// PDF Font
    ///
    /// Represents a font that can be used in PDF documents.
    /// Currently supports the Standard 14 fonts which are guaranteed to be
    /// available in every PDF reader.
    ///
    /// Per ISO 32000-2 Section 9.6.2.2 (Table 111):
    /// > PDF shall provide support for the fourteen standard Type 1 fonts
    /// > listed in Table 111. These fonts, or their font metrics and suitable
    /// > substitution fonts, shall be available to the PDF processor.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let font = Font.helvetica
    /// let boldFont = Font.Helvetica.bold
    /// let italicFont = Font.Times.italic
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 9.6.2.2 — Standard Type 1 fonts (standard 14 fonts)
    public struct Font: Sendable {
        /// The PDF base font name (e.g., "Helvetica", "Times-Roman")
        public let baseFontName: ISO_32000.`7`.`3`.COS.Name

        /// Resource name for this font in the page resources (e.g., "F1")
        public let resourceName: ISO_32000.`7`.`3`.COS.Name

        /// Font metrics for text measurement
        public let metrics: ISO_32000.`9`.`8`.Metrics

        /// Whether this is a fixed-width (monospaced) font
        public let isMonospaced: Bool

        /// Font weight
        public let weight: Weight

        /// Font style
        public let style: Style

        /// Font family
        public let family: Family

        /// Create a font with explicit properties
        public init(
            baseFontName: ISO_32000.`7`.`3`.COS.Name,
            resourceName: ISO_32000.`7`.`3`.COS.Name,
            metrics: ISO_32000.`9`.`8`.Metrics,
            isMonospaced: Bool,
            weight: Weight,
            style: Style,
            family: Family
        ) {
            self.baseFontName = baseFontName
            self.resourceName = resourceName
            self.metrics = metrics
            self.isMonospaced = isMonospaced
            self.weight = weight
            self.style = style
            self.family = family
        }
    }
}

// MARK: - Hashable & Equatable

extension ISO_32000.`9`.`6`.Font: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.baseFontName == rhs.baseFontName
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(baseFontName)
    }
}

// MARK: - Font Properties

extension ISO_32000.`9`.`6`.Font {
    /// Font weight
    public enum Weight: Sendable, Hashable {
        case regular
        case bold
    }

    /// Font style
    public enum Style: Sendable, Hashable {
        case normal
        case italic
        case oblique
    }

    /// Font family
    public enum Family: String, Sendable, Hashable {
        case helvetica = "Helvetica"
        case times = "Times"
        case courier = "Courier"
        case symbol = "Symbol"
        case zapfDingbats = "ZapfDingbats"
    }
}

// MARK: - Font Family Namespaces

extension ISO_32000.`9`.`6`.Font {
    /// Helvetica font family (sans-serif)
    public struct Helvetica: Sendable {
        private init() {}

        /// Helvetica Regular
        public static let regular = ISO_32000.`9`.`6`.Font(
            baseFontName: .helvetica,
            resourceName: .f1,
            metrics: .helvetica,
            isMonospaced: false,
            weight: .regular,
            style: .normal,
            family: .helvetica
        )

        /// Helvetica Bold
        public static let bold = ISO_32000.`9`.`6`.Font(
            baseFontName: .helveticaBold,
            resourceName: .f2,
            metrics: .helveticaBold,
            isMonospaced: false,
            weight: .bold,
            style: .normal,
            family: .helvetica
        )

        /// Helvetica Oblique
        public static let oblique = ISO_32000.`9`.`6`.Font(
            baseFontName: .helveticaOblique,
            resourceName: .f3,
            metrics: .helvetica,
            isMonospaced: false,
            weight: .regular,
            style: .oblique,
            family: .helvetica
        )

        /// Helvetica Bold Oblique
        public static let boldOblique = ISO_32000.`9`.`6`.Font(
            baseFontName: .helveticaBoldOblique,
            resourceName: .f4,
            metrics: .helveticaBold,
            isMonospaced: false,
            weight: .bold,
            style: .oblique,
            family: .helvetica
        )
    }

    /// Times font family (serif)
    public struct Times: Sendable {
        private init() {}

        /// Times Roman (regular)
        public static let regular = ISO_32000.`9`.`6`.Font(
            baseFontName: .timesRoman,
            resourceName: .f5,
            metrics: .timesRoman,
            isMonospaced: false,
            weight: .regular,
            style: .normal,
            family: .times
        )

        /// Times Bold
        public static let bold = ISO_32000.`9`.`6`.Font(
            baseFontName: .timesBold,
            resourceName: .f6,
            metrics: .timesBold,
            isMonospaced: false,
            weight: .bold,
            style: .normal,
            family: .times
        )

        /// Times Italic
        public static let italic = ISO_32000.`9`.`6`.Font(
            baseFontName: .timesItalic,
            resourceName: .f7,
            metrics: .timesRoman,
            isMonospaced: false,
            weight: .regular,
            style: .italic,
            family: .times
        )

        /// Times Bold Italic
        public static let boldItalic = ISO_32000.`9`.`6`.Font(
            baseFontName: .timesBoldItalic,
            resourceName: .f8,
            metrics: .timesBold,
            isMonospaced: false,
            weight: .bold,
            style: .italic,
            family: .times
        )
    }

    /// Courier font family (monospaced)
    public struct Courier: Sendable {
        private init() {}

        /// Courier Regular
        public static let regular = ISO_32000.`9`.`6`.Font(
            baseFontName: .courier,
            resourceName: .f9,
            metrics: .courier,
            isMonospaced: true,
            weight: .regular,
            style: .normal,
            family: .courier
        )

        /// Courier Bold
        public static let bold = ISO_32000.`9`.`6`.Font(
            baseFontName: .courierBold,
            resourceName: .f10,
            metrics: .courier,
            isMonospaced: true,
            weight: .bold,
            style: .normal,
            family: .courier
        )

        /// Courier Oblique
        public static let oblique = ISO_32000.`9`.`6`.Font(
            baseFontName: .courierOblique,
            resourceName: .f11,
            metrics: .courier,
            isMonospaced: true,
            weight: .regular,
            style: .oblique,
            family: .courier
        )

        /// Courier Bold Oblique
        public static let boldOblique = ISO_32000.`9`.`6`.Font(
            baseFontName: .courierBoldOblique,
            resourceName: .f12,
            metrics: .courier,
            isMonospaced: true,
            weight: .bold,
            style: .oblique,
            family: .courier
        )
    }

    /// Symbol font (special symbols)
    public struct Symbol: Sendable {
        private init() {}

        /// Symbol font
        public static let regular = ISO_32000.`9`.`6`.Font(
            baseFontName: .symbol,
            resourceName: .f13,
            metrics: .symbol,
            isMonospaced: false,
            weight: .regular,
            style: .normal,
            family: .symbol
        )
    }

    /// ZapfDingbats font (decorative symbols)
    public struct ZapfDingbats: Sendable {
        private init() {}

        /// ZapfDingbats font
        public static let regular = ISO_32000.`9`.`6`.Font(
            baseFontName: .zapfDingbats,
            resourceName: .f14,
            metrics: .zapfDingbats,
            isMonospaced: false,
            weight: .regular,
            style: .normal,
            family: .zapfDingbats
        )
    }

    // MARK: - Font Accessors

    /// Helvetica font (regular weight, normal style)
    public static var helvetica: Self { Helvetica.regular }

    /// Times font (regular weight, normal style)
    public static var times: Self { Times.regular }

    /// Courier font (regular weight, normal style)
    public static var courier: Self { Courier.regular }

    /// Symbol font
    public static var symbol: Self { Symbol.regular }

    /// ZapfDingbats font
    public static var zapfDingbats: Self { ZapfDingbats.regular }
}

// MARK: - Standard 14 Collection (Table 111)

extension ISO_32000.`9`.`6`.Font {
    /// The Standard 14 fonts guaranteed to be available in every PDF reader.
    ///
    /// Per ISO 32000-2 Section 9.6.2.2, Table 111, these fonts are pre-defined
    /// and require no embedding.
    public static let standard14: [ISO_32000.`9`.`6`.Font] = [
        Helvetica.regular,
        Helvetica.bold,
        Helvetica.oblique,
        Helvetica.boldOblique,
        Times.regular,
        Times.bold,
        Times.italic,
        Times.boldItalic,
        Courier.regular,
        Courier.bold,
        Courier.oblique,
        Courier.boldOblique,
        Symbol.regular,
        ZapfDingbats.regular,
    ]
}

// MARK: - Text Measurement

extension ISO_32000.`9`.`6`.Font {
    /// Calculate width of a String at a specific font size (returns UserSpace)
    public func width(
        of text: String,
        atSize fontSize: ISO_32000.UserSpace.Size<1>
    ) -> ISO_32000.UserSpace.Width {
        metrics.width(of: text, atSize: fontSize)
    }

    /// WinAnsi encoding operations on this font
    public var winAnsi: WinAnsi { WinAnsi(font: self) }

    /// WinAnsi encoding namespace for font
    public struct WinAnsi: Sendable {
        let font: ISO_32000.`9`.`6`.Font

        /// Calculate width of WinAnsi-encoded bytes at a specific font size (returns UserSpace)
        public func width<Bytes: Collection>(
            of bytes: Bytes,
            atSize fontSize: ISO_32000.UserSpace.Size<1>
        ) -> ISO_32000.UserSpace.Width where Bytes.Element == UInt8 {
            font.metrics.winAnsi.width(of: bytes, atSize: fontSize)
        }
    }
}

// MARK: - Font Selection Helpers

extension ISO_32000.`9`.`6`.Font {
    /// Find a Standard 14 font matching the given criteria
    public static func find(
        family: Family,
        weight: Weight = .regular,
        style: Style = .normal
    ) -> ISO_32000.`9`.`6`.Font? {
        standard14.first { font in
            font.family == family && font.weight == weight && font.style == style
        }
    }

    /// Get the bold variant of this font
    public var bold: ISO_32000.`9`.`6`.Font {
        if weight == .bold { return self }
        return Self.find(family: family, weight: .bold, style: style) ?? self
    }

    /// Get the italic/oblique variant of this font
    public var italic: ISO_32000.`9`.`6`.Font {
        if style == .italic || style == .oblique { return self }
        let targetStyle: Style = (family == .times) ? .italic : .oblique
        return Self.find(family: family, weight: weight, style: targetStyle) ?? self
    }

    /// Get the regular (non-bold, non-italic) variant of this font
    public var regular: ISO_32000.`9`.`6`.Font {
        Self.find(family: family, weight: .regular, style: .normal) ?? self
    }
}

// 9.6 Simple fonts
// 9.6.1 General
// There are several types of simple fonts, all of which have these properties:
// • Glyphs in the font shall be selected by single-byte character codes obtained from a string that is
// shown by the text-showing operators (see 9.4.3,
// "Text-showing operators"). Logically, these
// codes index into a table of 256 glyphs; the mapping from codes to glyphs is called the font’s
// encoding. Under some circumstances, the encoding may be altered by means described in 9.6.5,
// "Character encoding"
// .
// • Each glyph shall have a single set of metrics, including a horizontal displacement or width, as
// described in 9.2.4, "Glyph positioning and metrics"; that is, simple fonts support only horizontal
// writing mode.
// • Except for Type 0 fonts, Type 3 fonts in non-tagged PDF documents, and certain standard Type
// 1 fonts, every font dictionary shall contain a subsidiary dictionary, the font descriptor,
// containing font-wide metrics and other attributes of the font; see 9.8, "Font descriptors"
// .
// Among those attributes is an optional, but strongly recommended, font file stream containing
// the font program.
// 9.6.2 Type 1 fonts
// 9.6.2.1 General
// A Type 1 font program is a stylised PostScript language program that describes glyph shapes. It uses a
// compact encoding for the glyph descriptions, and it includes hint information that enables high-quality
// rendering even at small sizes and low resolutions.
// NOTE 1 Details on this format are provided in a separate specification, Adobe Type 1 Font Format. An
// alternative, more compact but functionally equivalent representation of a Type 1 font program is
// documented in Adobe Technical Note #5176, The Compact Font Format Specification.
// NOTE 2 Although a Type 1 font program uses PostScript language syntax, using it does not require a full
// PostScript language compatible interpreter; a specialised Type 1 font interpreter suffices.
// A Type 1 font dictionary may contain the entries listed in "Table 109 — Entries in a Type 1 font
// dictionary"
// .
// Table 109 — Entries in a Type 1 font dictionary
// Key Type Value
// Type name (Required) The type of PDF object that this dictionary describes; shall be Font for
// a font dictionary.
// Subtype name (Required) The type of font; shall be Type1 for a Type 1 font.
// Name name (Required in PDF 1.0; optional in PDF 1.1 through 1.7, deprecated in PDF 2.0) The
// name by which this font is referenced in the Font subdictionary of the current
// resource dictionary.
// © ISO 2020 – All rights reserved 313
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// Key Type Value
// BaseFont name (Required) The PostScript language name of the font. For Type 1 fonts, this is
// always the value of the FontName entry in the font program; for more
// information, see Section 5.2 of the PostScript Language Reference, Third Edition.
// The PostScript language name of the font may be used to find the font program in
// the PDF processor or its environment. It is also the name that is used when
// printing to a PostScript language compatible output device.
// FirstChar integer (Required; optional in PDF 1.0-1.7 for the standard 14 fonts) The first character
// code defined in the font’s Widths array.
// LastChar integer (Required; optional in PDF 1.0-1.7 for the standard 14 fonts) The last character
// code defined in the font’s Widths array.
// Widths array (Required; optional in PDF 1.0-1.7 for the standard 14 fonts; indirect reference
// preferred) An array of (LastChar - FirstChar + 1) numbers, each element being
// the glyph width for the character code that equals FirstChar plus the array index.
// For character codes outside the range FirstChar to LastChar, the value of
// MissingWidth from the FontDescriptor entry for this font shall be used. The
// glyph widths shall be measured in units in which 1000 units correspond to 1 unit
// in text space. These widths shall be consistent with the actual widths given in the
// font program. For more information on glyph widths and other glyph metrics, see
// 9.2.4, "Glyph positioning and metrics"
// .
// FontDescriptor dictionary (Required; optional in PDF 1.0-1.7 for the standard 14 fonts; shall be an indirect
// reference) A font descriptor describing the font’s metrics other than its glyph
// widths (see 9.8, "Font descriptors").
// For the standard 14 fonts, the entries FirstChar, LastChar, Widths, and
// FontDescriptor shall either all be present or all be absent. Ordinarily, these
// dictionary keys may be absent; specifying them enables a standard font to be
// overridden; see 9.6.2.2, "Standard Type 1 fonts (standard 14 fonts) (PDF 1.0-
// 1.7)"
// .
// Encoding name or
// dictionary
// (Optional) A specification of the font’s character encoding if different from its
// built-in encoding. The value of Encoding shall be either the name of a predefined
// encoding (MacRomanEncoding, MacExpertEncoding, or WinAnsiEncoding, as
// described in Annex D, "Character sets and encodings") or an encoding dictionary
// that shall specify differences from the font’s built-in encoding or from a specified
// predefined encoding (see 9.6.5, "Character encoding").
// ToUnicode stream (Optional; PDF 1.2) A stream containing a CMap file that maps character codes to
// Unicode values (see 9.10.3, "ToUnicode CMaps").
// PDF versions 1.0 to 1.7 did not require Type 1 font dictionaries to include FirstChar, LastChar,
// Widths and FontDescriptor entries as described in 9.6.2.2, "Standard Type 1 fonts (standard 14 fonts)
// (PDF 1.0-1.7)". For compatibility reasons PDF processors shall provide glyph widths and font
// descriptor data for those standard fonts for use in processing PDF files when the entries are absent.
// EXAMPLE This example shows the font dictionary for the Adobe Garamond® Semibold font. The font has an encoding
// dictionary (object 25), however neither the encoding dictionary nor the font descriptor (object 7) is shown.
// 14 0 obj
// <</Type /Font
//  Subtype /Type1
//  BaseFont /AGaramond-Semibold
// 314 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
//  FirstChar 0
//  LastChar 255
//  Widths 21 0 R
//  FontDescriptor 7 0 R
//  Encoding 25 0 R
// >>
// endobj
// 21 0 obj
// [ 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255
// 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255
// 255 280 438 510 510 868 834 248 320 320 420 510 255 320 255 347
// 510 510 510 510 510 510 510 510 510 510 255 255 510 510 510 330
// 781 627 627 694 784 580 533 743 812 354 354 684 560 921 780 792
// 588 792 656 504 682 744 650 968 648 590 638 320 329 320 510 500
// 380 420 510 400 513 409 301 464 522 268 259 484 258 798 533 492
// 516 503 349 346 321 520 434 684 439 448 390 320 255 320 510 255
// 627 627 694 580 780 792 744 420 420 420 420 420 420 402 409 409
// 409 409 268 268 268 268 533 492 492 492 492 492 520 520 520 520
// 486 400 510 510 506 398 520 555 800 800 1044 360 380 549 846 792
// 713 510 549 549 510 522 494 713 823 549 274 354 387 768 615 496
// 330 280 510 549 510 549 612 421 421 1000 255 627 627 792 1016 730
// 500 1000 438 438 248 248 510 494 448 590 100 510 256 256 539 539
// 486 255 248 438 1174 627 580 627 580 580 354 354 354 354 792 792
// 790 792 744 744 744 268 380 380 380 380 380 380 380 380 380 380
// ]
// endobj
// 9.6.2.2 Standard Type 1 fonts (standard 14 fonts) (PDF 1.0-1.7)
// The PostScript language names of 14 Type 1 fonts, known as the standard 14 fonts, are as follows:
// Times-Roman, Helvetica, Courier, Symbol, Times-Bold, Helvetica-Bold, Courier-Bold, ZapfDingbats,
// Times-Italic, Helvetica-Oblique, Courier-Oblique, Times-BoldItalic, Helvetica-BoldOblique, Courier-
// BoldOblique.
// In PDF 1.0 to PDF 1.7, the FirstChar, LastChar, Widths and FontDescriptor (see “Table 109 —
// Entries in a Type 1 font dictionary") were optional in Type 1 font dictionaries for the standard 14 fonts.
// PDF processors supporting PDF 1.0 to PDF 1.7 files shall have these fonts, or their font metrics and
// suitable substitution fonts, available.
// These fonts, or their font metrics and suitable substitution fonts, shall be available to the PDF
// processor.
// 9.6.2.3 Multiple master fonts
// The multiple master font format is an extension of the Type 1 font format as specified in Adobe
// Technical Note #5015, Type 1 Font Format Supplement, that allows the generation of a wide variety of
// typeface styles from a single font program. This is accomplished through the presence of various
// design dimensions in the font.
// EXAMPLE 1 Examples of design dimensions are weight (light to extra-bold) and width (condensed to expanded).
// Coordinates along these design dimensions (such as the degree of boldness) are specified by numbers.
// A particular choice of numbers selects an instance of the multiple master font. PDFs can contain
// multiple master instances.
// The font dictionary for a multiple master font instance contains the same entries as a Type 1 font
// © ISO 2020 – All rights reserved 315
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// dictionary (see "Table 109 — Entries in a Type 1 font dictionary"), with these differences:
// • The value of Subtype shall be MMType1.
// • If the PostScript language name of the instance contains SPACEs (20h), the SPACEs shall be
// replaced by LOW LINEs (underscores) (5Fh) in the value of BaseFont. For instance, as illustrated
// in this example, the name "MinionMM 366 465 11 " (which ends with a SPACE character)
// becomes /MinionMM_366_465_11_.
// EXAMPLE 2
// 7 0 obj
// <</Type /Font
//  Subtype /MMType1
//  BaseFont /MinionMM_366_465_11_
//  FirstChar 32
//  LastChar 255
//  Widths 19 0 R
//  FontDescriptor 6 0 R
//  Encoding 5 0 R
// >>
// endobj
// 19 0 obj
// [187 235 317 430 427 717 607 168 326 326 421 619 219 317 219 282 427
// … Omitted data …
// 569 0 569 607 607 607 239 400 400 400 400 253 400 400 400 400 400
// ]
// endobj
// This example illustrates a convention for including the numeric values of the design coordinates as
// part of the instance’s BaseFont name.
// NOTE This convention is commonly used for accessing multiple master font instances from an external
// source in the PDF processor’s environment; it is documented in Adobe Technical Note #5088,
// Font Naming Issues. However, this convention is not prescribed as part of this specification.
// If the font program for a multiple master font instance is embedded in the PDF file, it shall be an
// ordinary Type 1 font program, not a multiple master font program. This font program is called a
// snapshot of the multiple master font instance that incorporates the chosen values of the design
// coordinates.
// 9.6.3 TrueType fonts
// PDF TrueType fonts are those with a Subtype value of TrueType in the font dictionary. PDF fonts of
// this type shall support both the TrueType font format (see Apple Computer, Inc., TrueType Reference
// Manual) as well as the OpenType font format (as defined by ISO/IEC 14496-22).
// A TrueType font dictionary may contain the same entries as a Type 1 font dictionary (see "Table 109 —
// Entries in a Type 1 font dictionary"), with these differences:
// • The value of Subtype shall be TrueType.
// • The value of Encoding is subject to limitations that are described in 9.6.5.4, "Encodings for
// TrueType fonts"
// .
// • The value of BaseFont is derived differently.
// The PostScript language name for the value of BaseFont should be determined in one of two ways:
// 316 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// • If the TrueType or OpenType font program's "name" table contains a PostScript language name, it
// should be used.
// • In the absence of a PostScript language name in the "name" table, a PostScript language name
// should be derived from the name by which the font is known in the host operating system.
// NOTE 1 The OpenType font format (also known as Open Font Format, or ISO/IEC 14496-22) was
// developed jointly by Microsoft and Adobe. It extends the TrueType font format, developed by
// Apple, to include more metadata about the glyphs and text layout as well as supporting both the
// TrueType glyph technology and the CFF glyph technology (see Adobe Technical Note #5176, The
// Compact Font Format Specification). OpenType is available on most modern operating systems.
// NOTE 2 A TrueType or an OpenType font program can be embedded directly in a PDF file as a stream
// object.
// NOTE 3 The Type 42 font format that is defined for the PostScript language does not apply to PDF.
// NOTE 4 For CJK (Chinese, Japanese, and Korean) fonts, the host font system’s font name is often encoded
// in the host operating system’s script. For instance, a Japanese font can have a name that is
// written in Japanese using some (unidentified) Japanese encoding. Thus, TrueType font names
// can contain multiple-byte character codes, each of which requires multiple characters to
// represent in a PDF name object (using the # notation to quote special characters as needed).
// 9.6.4 Type 3 fonts
// Type 3 fonts differ from the other fonts supported by PDF. Font dictionaries for other fonts simply
// contain information about the font and refer to a separate font program for the actual glyph
// descriptions; a Type 3 font dictionary contains the glyph descriptions. In Type 3 fonts, glyphs shall be
// defined by streams of PDF graphics operators. These streams shall be associated with glyph names. A
// separate encoding entry shall map character codes to the appropriate glyph names for the glyphs.
// NOTE 1 Type 3 fonts are more flexible than Type 1 fonts because the glyph descriptions can contain
// arbitrary PDF graphics operators. However, Type 3 fonts have no hinting mechanism for
// improving output at small sizes or low resolutions.
// A Type 3 font dictionary may contain the entries listed in "Table 110 — Entries in a Type 3 font
// dictionary"
// .
// Table 110 — Entries in a Type 3 font dictionary
// Key Type Value
// Type name (Required) The type of PDF object that this dictionary describes; shall be Font
// for a font dictionary.
// Subtype name (Required) The type of font; shall be Type3 for a Type 3 font.
// Name name (Required in PDF 1.0; optional otherwise) See "Table 109 — Entries in a Type 1
// font dictionary"
// .
// © ISO 2020 – All rights reserved 317
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// Key Type FontBBox rectangle FontMatrix array CharProcs dictionary Encoding dictionary FirstChar integer LastChar integer Widths array FontDescriptor dictionary Resources dictionary ToUnicode stream 318 Value
// (Required) A rectangle (see 7.9.5, "Rectangles") expressed in the glyph
// coordinate system, specifying the font bounding box. This is the smallest
// rectangle enclosing all marks that would result if all of the glyphs of the font
// were placed with their origins coincident and their descriptions executed.
// If all four elements of the rectangle are zero, a PDF processor shall make no
// assumptions about glyph sizes based on the font bounding box. If any element
// is non-zero, the font bounding box shall be accurate. If any glyph’s marks fall
// outside this bounding box, behaviour is implementation dependent and may
// not match the creator’s expectations.
// (Required) An array of six numbers specifying the font matrix, mapping glyph
// space to text space (see 9.2.4, "Glyph positioning and metrics").
// NOTE A common practice is to define glyphs in terms of a 1000-unit glyph
// coordinate system, in which case the font matrix is [0.001 0 0 0.001 0 0].
// (Required) A dictionary in which each key shall be a glyph name and the value
// associated with that key shall be a content stream that constructs and paints
// the glyph for that character. The stream shall include as its first operator
// either d0 or d1, followed by operators describing one or more graphics
// objects. See below for more details about Type 3 glyph descriptions.
// (Required) An encoding dictionary whose Differences array shall specify the
// complete character encoding for this font (see 9.6.5, "Character encoding").
// (Required) The first character code defined in the font’s Widths array.
// (Required) The last character code defined in the font’s Widths array.
// (Required; should be an indirect reference) An array of (LastChar - FirstChar +
// 1) numbers, each element being the glyph width for the character code that
// equals FirstChar plus the array index. For character codes outside the range
// FirstChar to LastChar, the width shall be 0. These widths shall be interpreted
// in glyph space as specified by FontMatrix (unlike the widths of a Type 1 font,
// which are in thousandths of a unit of text space).
// If FontMatrix specifies a rotation, only the horizontal component of the
// transformed width shall be used. That is, the resulting displacement shall be
// horizontal in text space, as is the case for all simple fonts.
// (Required in Tagged PDF documents; shall be an indirect reference) A font
// descriptor describing the font’s default metrics other than its glyph widths
// (see 9.8, "Font descriptors").
// NOTE (2020) The conditions for when the FontDescriptor key is required were
// corrected in this document to match ISO 32000-1:2008.
// (Optional but should be used; PDF 1.2) A list of the named resources, such as
// fonts and images, required by the glyph descriptions in this font (see 7.8.3,
// "Resource dictionaries"). If any glyph descriptions refer to named resources
// but this dictionary is absent, the names shall be looked up in the resource
// dictionary of the page on which the font is used.
// (Optional; PDF 1.2) A stream containing a CMap file that maps character codes
// to Unicode values (see 9.10.3, "ToUnicode CMaps").
// © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// For each character code shown by a text-showing operator that uses a Type 3 font, the PDF processor
// shall:
// a) Look up the character code in the font’s Encoding entry, as described in 9.6.5, "Character encoding" to
// obtain a glyph name.
// b) Look up the glyph name in the font’s CharProcs dictionary to obtain a stream object containing a glyph
// description. If the name is not present as a key in CharProcs, no glyph shall be painted.
// c) Invoke the glyph description. The graphics state shall be saved before this invocation and shall be
// restored afterward; therefore, any changes the glyph description makes to the graphics state do not
// persist after it finishes.
// d) If any glyph descriptions refer to named resources they shall be looked up in the Resources entry of the
// Type 3 font dictionary. If any glyph descriptions refer to named resources but this dictionary is absent,
// the names shall be looked up in the resource dictionary of the page on which the font is used.
// When the glyph description begins execution, the current transformation matrix (CTM) shall be the
// concatenation of the font matrix (FontMatrix in the current font dictionary) and the text space that
// was in effect at the time the text-showing operator was invoked (see 9.4.4, "Text space details"). This
// means that shapes described in the glyph coordinate system are transformed into the user coordinate
// system and appear in the appropriate size and orientation on the page. The glyph description shall
// describe the glyph in terms of absolute coordinates in the glyph coordinate system, placing the glyph
// origin at (0, 0) in this space. It shall make no assumptions about the initial text position.
// Aside from the CTM, the graphics state shall be inherited from the graphics state at the point of
// invocation of the text-showing operator that caused the glyph description to be invoked. To ensure
// predictable results, the glyph description shall initialise any graphics state parameters on which it
// depends. In particular, if it invokes any operator from "Table 59 — Path-painting operators" which
// performs stroking, it shall explicitly set the line width, line join, line cap, and dash pattern to
// appropriate values. The TK flag (see 9.3.8, "Text knockout") of the graphics state controls the
// behaviour of glyphs obtained from any font type, including Type 3.
// NOTE 2 Normally, it is unnecessary and undesirable to initialise the current colour parameters because
// the text-showing operators are designed to paint glyphs with the current colours.
// The glyph description shall execute one of the operators described in "Table 111 — Type 3 font
// operators" to pass width and bounding box information to the font machinery. This shall precede the
// execution of any path construction or path-painting operators describing the glyph.
// NOTE 3 Type 3 fonts in PDF are very similar to those in the PostScript language. Some of the information
// provided in Type 3 font dictionaries and glyph descriptions, although seemingly redundant or
// unnecessary, is nevertheless required for correct results when a PDF processor prints to a
// PostScript language compatible output device. This applies particularly to the operands of the d0
// and d1 operators, which are the equivalent of PostScript's setcharwidth and setcachedevice.
// For further explanation, see clause 5.7 of the PostScript Language Reference, Third Edition.
// © ISO 2020 – All rights reserved 319
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// Table 111 — Type 3 font operators
// Operands Operator Description
// wx wy d0 Set width information for the glyph and declare that the glyph description
// specifies both its shape and its colour.
// NOTE 1 This operator name ends in the digit 0.
// wx denotes the horizontal displacement in the glyph coordinate system; it shall
// be consistent with the corresponding width in the font’s Widths array. wy shall
// be 0 (see 9.2.4, "Glyph positioning and metrics").
// This operator shall only be permitted as the first operator in a content stream
// appearing in a Type 3 font’s CharProcs dictionary. It is typically used only if the
// glyph description executes operators to set the colour or other colour-related
// parameters explicitly.
// NOTE 2 An image does set the colour space and colour explicitly; an image mask does
// not and requires explicit operators to do so for it.
// wx wy llx lly urx ury d1 Set width and bounding box information for the glyph and declare that the glyph
// description specifies only shape, not colour.
// NOTE 3 This operator name ends in the digit 1.
// wx denotes the horizontal displacement in the glyph coordinate system; it shall
// be consistent with the corresponding width in the font’s Widths array. wy shall
// be 0 (see 9.2.4, "Glyph positioning and metrics").
// llx and lly denote the coordinates of the lower-left corner, and urx and ury denote
// the upper-right corner, of the glyph bounding box. The glyph bounding box is
// the smallest rectangle, oriented with the axes of the glyph coordinate system,
// that completely encloses all marks placed on the page as a result of executing the
// glyph’s description. The declared bounding box shall be correct — in other
// words, sufficiently large to enclose the entire glyph. If any marks fall outside this
// bounding box, the result is implementation-dependent.
// A glyph description that begins with the d1 operator should not execute any
// operators that set the colour (or other colour-related parameters including
// transparency) in the graphics state; any use of such operators shall be ignored
// and the glyph stream continues to be processed without error (see 8.6.8, "Colour
// operators"). The glyph description is executed solely to determine the glyph’s
// shape. Its colour shall be determined by the graphics state in effect each time
// this glyph is painted by a text-showing operator. For the same reason, the glyph
// description shall not include an image; however, an image mask is acceptable,
// since it merely defines a region of the page to be painted with the current colour.
// This operator shall be used only in a content stream appearing in a Type 3 font’s
// CharProcs dictionary.
// EXAMPLE This example shows the definition of a Type 3 font with only two glyphs — a filled square and a filled triangle,
// selected by the character codes a and b. "Figure 62 — Output from the example” shows the result of showing
// 320 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// the string ( ababab ) using this font.
// Figure 62 — Output from the example
// %Snippet of page content stream that places several Type 3 font strings onto the page
// …
// 0.2 0.8 0.0 rg
// 0.1 0.4 0.0 RG
// BT
//  FT3 15 Tf
// 300 400 Td
// (ab) Tj
// 0.8 0.2 0.0 rg
// 0.4 0.1 0.0 RG
// (ab) Tj
// 0.8 0.8 0.2 rg
// 0.4 0.4 0.1 RG
// (ab) Tj
// ET
// …
// %Type 3 font definition encoding two glyphs, 'a' and 'b'.
// 4 0 obj
// <<
//  Type /Font
//  Subtype /Type3
//  FontBBox [-36 -36 786 786]
//  FontMatrix [0.001 0 0 0.001 0 0]
//  CharProcs 10 0 R
//  Encoding 9 0 R
//  FirstChar 97
//  LastChar 104
//  Widths [1000 1000]
// >>
// endobj
// 9 0 obj
// <<
//  Type /Encoding
//  Differences [97 /square /triangle]
// >>
// endobj
// 10 0 obj
// <<
//  square 11 0 R
//  triangle 12 0 R
// >>
// endobj
// %Type 3 "square" glyph description
// © ISO 2020 – All rights reserved 321
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// 11 0 obj
// <</Length …>>
// stream
// 1000 0 -36 -36 786 786 d1 %uncoloured glyph - defines only shape
// 72 w
// 0 0 750 750 re
// B
// endstream
// endobj
// %Type 3 "triangle" glyph description
// 12 0 obj
// <</Length …>>
// stream
// 1000 0 d0 %coloured glyph - defines colour and shape
// 72 w
// 0.2 0.6 0.8 rg
// 0.1 0.3 0.4 RG
// 0 0 m
// 375 750 l
// 750 0 l
// b
// endstream
// endobj
// 9.6.5 Character encoding
// 9.6.5.1 General
// A font’s encoding is the association between character codes (obtained from text strings that are
// shown) and glyph descriptions. This subclause describes the character encoding scheme used with
// simple PDF fonts. Composite fonts (Type 0) use a different character mapping algorithm, as discussed
// in 9.7, "Composite fonts"
// .
// Except for Type 3 fonts, every font program shall have a built-in encoding. Under certain
// circumstances, a PDF font dictionary may change the encoding used with the font program to match
// the requirements of the PDF writer generating the text being shown.
// This flexibility in character encoding is valuable for two reasons:
// • It permits showing text that is encoded according to any of the various existing conventions. For
// example, the Microsoft WindowsTM and Apple Mac OS operating systems use different standard
// encodings for Latin text, and many PDF writers use their own special-purpose encodings.
// • It permits PDF writers to specify how characters selected from a large character set are to be
// encoded.
// Some character sets consist of more than 256 characters, including ligatures, accented characters, and
// other symbols required for high-quality typography or non-Latin writing systems. Different encodings
// may select different subsets of the same character set.
// One commonly used font encoding for Latin-text font programs is often referred to as
// StandardEncoding. The name StandardEncoding shall have no special meaning in PDF, but this
// encoding does play a role as a default encoding (as shown in "Table 112 — Entries in an encoding
// dictionary"). The regular encodings used for Latin-text fonts on Mac OS and Microsoft WindowsTM
// systems shall be named MacRomanEncoding and WinAnsiEncoding, respectively. An encoding named
// MacExpertEncoding may be used with "expert" fonts that contain additional characters useful for
// 322 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// sophisticated typography. Complete details of these encodings and of the characters present in typical
// fonts are provided in Annex D,
// "Character sets and encodings"
// .
// In PDF, a font is classified as either nonsymbolic or symbolic according to whether all of its characters
// are members of the standard Latin character set; see D.2, "Latin character set and encodings". This
// shall be indicated by flags in the font descriptor; see 9.8.2, "Font descriptor flags". Symbolic fonts
// contain other character sets, to which the encodings mentioned previously ordinarily do not apply.
// Such font programs have built-in encodings that are usually unique to each font. The standard 14 fonts
// include two symbolic fonts, Symbol and ZapfDingbats, whose encodings and character sets are
// documented in Annex D,
// "Character sets and encodings"
// .
// A font program’s built-in encoding may be overridden by including an Encoding entry in the PDF font
// dictionary. The possible encoding modifications depend on the font type. The value of the Encoding
// entry shall be either a named encoding (the name of one of the predefined encodings
// MacRomanEncoding, MacExpertEncoding, or WinAnsiEncoding) or an encoding dictionary. An encoding
// dictionary contains the entries listed in "Table 112 — Entries in an encoding dictionary"
// .
// Table 112 — Entries in an encoding dictionary
// Key Type Value
// Type name (Optional) The type of PDF object that this dictionary describes; if
// present, shall be Encoding for an encoding dictionary.
// BaseEncoding name (Optional) The base encoding — that is, the encoding from which the
// Differences entry (if present) describes differences — shall be the
// name of one of the predefined encodings MacRomanEncoding,
// MacExpertEncoding, or WinAnsiEncoding (see Annex D, "Character
// sets and encodings").
// If this entry is absent, the Differences entry shall describe differences
// from a default base encoding. For a font program that is embedded in
// the PDF file, the default base encoding shall be the font program’s
// built-in encoding, as described in 9.6.5, "Character encoding" and
// further elaborated in the subclauses on specific font types. Otherwise,
// for a nonsymbolic font, it shall be StandardEncoding, and for a
// symbolic font, it shall be the font’s built-in encoding.
// Differences array (Optional; should not be used with TrueType fonts) An array describing
// the differences from the encoding specified by BaseEncoding or, if
// BaseEncoding is absent from a default base encoding. The
// Differences array is described in subsequent subclauses.
// The value of the Differences entry shall be an array of character codes and character names organised
// as follows:
// © ISO 2020 – All rights reserved 323
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// code1 name1,1 name1,2 …
// code2 name2,1 name2,2 …
// …
// coden namen,1 namen,2 …
// Each code shall be the first index in a sequence of character codes to be changed. The first character
// name after the code becomes the name corresponding to that code. Subsequent names replace
// consecutive code indices until the next code appears in the array or the array ends. These sequences
// may be specified in any order but shall not overlap.
// EXAMPLE In the encoding dictionary in this example, the name quotesingle ( ' ) is associated with character code 39,
// Adieresis (Ä) with code 128, Aring (Å) with 129, and trademark (™) with 170.
// 25 0 obj
// <</Type /Encoding
//  Differences
// [39 /quotesingle
// 96 /grave
// 128 /Adieresis /Aring /Ccedilla /Eacute /Ntilde /Odieresis /Udieresis
//  aacute /agrave /acircumflex /adieresis /atilde /aring /ccedilla
//  eacute /egrave /ecircumflex /edieresis /iacute /igrave /icircumflex
//  idieresis /ntilde /oacute /ograve /ocircumflex /odieresis /otilde
//  uacute /ugrave /ucircumflex /udieresis /dagger /degree /cent
//  sterling /section /bullet /paragraph /germandbls /registered
//  copyright /trademark /acute /dieresis
// 174 /AE /Oslash
// 177 /plusminus
// 180 /yen /mu
// 187 /ordfeminine /ordmasculine
// 190 /ae /oslash /questiondown /exclamdown /logicalnot
// 196 /florin
// 199 /guillemotleft /guillemotright /ellipsis
// 203 /Agrave /Atilde /Otilde /OE /oe /endash /emdash /quotedblleft
//  quotedblright /quoteleft /quoteright /divide
// 216 /ydieresis /Ydieresis /fraction /currency /guilsinglleft /guilsinglright
//  fi /fl /daggerdbl /periodcentered /quotesinglbase /quotedblbase
//  perthousand /Acircumflex /Ecircumflex /Aacute /Edieresis /Egrave
//  Iacute /Icircumflex /Idieresis /Igrave /Oacute /Ocircumflex
// 241 /Ograve /Uacute /Ucircumflex /Ugrave /dotlessi /circumflex /tilde
//  macron /breve /dotaccent /ring /cedilla /hungarumlaut /ogonek /caron
// ]
// >>
// endobj
// 9.6.5.2 Encodings for Type 1 fonts
// A Type 1 font program’s glyph descriptions are keyed by glyph names, not by character codes. Glyph
// names are ordinary PDF name objects. Descriptions of Latin alphabetic characters are normally
// associated with names consisting of single letters, such as A or a. Other characters are associated with
// names composed of words, such as three, ampersand, or parenleft. A Type 1 font’s built-in encoding
// shall be defined by an “encoding” array that is part of the font program, not to be confused with the
// Encoding entry in the PDF font dictionary.
// 324 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// An Encoding entry in the PDF font dictionary, if present, shall override a Type 1 font’s mapping from
// character codes to character names. The Differences array maps codes to the names of glyph
// descriptions that exist in the font program, regardless of whether those glyphs are referenced by the
// font’s built-in encoding or by the encoding specified in the BaseEncoding entry.
// All Type 1 font programs shall contain an actual glyph named .notdef. The effect produced by showing
// the .notdef glyph is at the discretion of the font designer. If an encoding maps to a character name that
// does not exist in the Type 1 font program, the .notdef glyph shall be substituted.
// NOTE If a font has no .notdef glyph definition, the results are implementation dependent.
// 9.6.5.3 Encodings for Type 3 fonts
// A Type 3 font, like a Type 1 font, contains glyph descriptions that are keyed by glyph names; in this
// case, they appear as explicit keys in the font’s CharProcs dictionary. A Type 3 font’s mapping from
// character codes to glyph names shall be entirely defined by its Encoding entry, which is required for
// Type 3 fonts.
// NOTE Type 3 fonts do not support the concept of a default glyph name.
// 9.6.5.4 Encodings for TrueType fonts
// A TrueType or OpenType font program’s built-in encoding maps directly from character codes to glyph
// descriptions by means of an internal data structure called a "cmap" (not to be confused with the CMap
// described in 9.7.5, "CMaps"). This subclause describes how the PDF font dictionary’s Encoding entry
// shall be used in conjunction with a "cmap" to map from a character code in a string to a glyph
// description in a TrueType/OpenType font program.
// A "cmap" table may contain one or more subtables that represent multiple encodings intended for use
// on different platforms (such as Mac OS and Microsoft WindowsTM). Each subtable shall be identified by
// the two numbers, such as (3, 1), that represent a combination of a platform ID and a platform-specific
// encoding ID, respectively.
// Glyph names are not required in TrueType/OpenType fonts, although some font programs have an
// optional "post" table listing glyph names for the glyphs. If the PDF processor needs to select glyph
// descriptions by name, it translates from glyph names to codes in one of the encodings given in the font
// program’s "cmap" table. When there is no character code in the "cmap" that corresponds to a glyph
// name, the "post" table shall be used to select a glyph description directly from the glyph name.
// Because some aspects of TrueType/OpenType glyph selection are dependent on the PDF processor or
// the operating system, PDF files that use TrueType/OpenType fonts should follow certain guidelines to
// ensure predictable behaviour across all PDF processors:
// • The font program should be embedded.
// • A nonsymbolic font should specify MacRomanEncoding or WinAnsiEncoding as the value of its
// Encoding entry, with no Differences array. See also D.2 "Latin character set and encodings"
// notes 5 and 6 for situations when a Differences array is required.
// • A font that is used to display glyphs that do not use MacRomanEncoding or WinAnsiEncoding
// should not specify an Encoding entry. The font descriptor’s Symbolic flag (see "Table 121 — Font
// flags") should be set, and its font program’s "cmap" table should contain a (1, 0) subtable. It may
// also contain a (3, 0) subtable; if present, this subtable should map from character codes in the
// © ISO 2020 – All rights reserved 325
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// range 0xF000 to 0xF0FF by prepending the single-byte codes in the (1, 0) subtable with 0xF0 and
// mapping to the corresponding glyph descriptions.
// NOTE 1 Some popular TrueType/OpenType font programs contain incorrect encoding information.
// Implementations of TrueType/OpenType font interpreters have evolved heuristics for dealing
// with such problems; those heuristics are not described here. For maximum portability, only well-
// formed TrueType/OpenType font programs can be used in PDF files. Therefore, a
// TrueType/OpenType font program to be used in a PDF file could need modification to conform
// to these guidelines.
// NOTE 2 Not all glyphs of a TrueType/OpenType font are always accessible with simple PDF font
// resources. A Type 0 PDF font resource can be used to access those glyphs.
// The following paragraphs describe the treatment of TrueType font encodings beginning with PDF 1.3.
// If the font has a named Encoding entry of either MacRomanEncoding or WinAnsiEncoding, or if the font
// descriptor’s Nonsymbolic flag (see "Table 121 — Font flags") is set, the PDF processor shall create a
// table that maps from character codes to glyph names:
// • If the Encoding entry is one of the names MacRomanEncoding or WinAnsiEncoding, the table shall
// be initialised with the mappings described in Annex D,
// "Character sets and encodings"
// .
// • If the Encoding entry is a dictionary, the table shall be initialised with the entries from the
// dictionary’s BaseEncoding entry (see "Table 112 — Entries in an encoding dictionary"). Any
// entries in the Differences array shall be used to update the table. Finally, any undefined entries in
// the table shall be filled using StandardEncoding.
// If a (3, 1) "cmap" subtable (Microsoft Unicode) is present:
// • A character code shall be first mapped to a glyph name using the table described above.
// • The glyph name shall then be mapped to a Unicode value by consulting the Adobe Glyph List and
// Adobe Glyph List for New Fonts.
// • Finally, the Unicode value shall be mapped to a glyph description according to the (3, 1) subtable.
// If no (3, 1) subtable is present but a (1, 0) subtable (Macintosh Roman) is present:
// • A character code shall be first mapped to a glyph name using the table described above.
// • The glyph name shall then be mapped back to a character code according to the standard Roman
// encoding used on Mac OS.
// • Finally, the code shall be mapped to a glyph description according to the (1, 0) subtable.
// In any of these cases, if the glyph name cannot be mapped as specified, the glyph name shall be looked
// up in the font program’s "post" table (if one is present) and the associated glyph description shall be
// used.
// The standard Roman encoding that is used on Mac OS is the same as the MacRomanEncoding described
// in Annex D,
// "Character sets and encodings" with the addition of 15 entries and the replacement of the
// currency glyph with the Euro glyph, as shown in "Table 113 — Additional entries in Mac OS Roman
// encoding not in MacRomanEncoding"
// .
// 326 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// Table 113 — Additional entries in Mac OS Roman encoding not in MacRomanEncoding
// Name Code (Octal) Code (Decimal)
// notequal 255 173
// infinity 260 176
// lessequal 262 178
// greaterequal 263 179
// partialdiff 266 182
// summation 267 183
// product 270 184
// pi 271 185
// integral 272 186
// Omega 275 189
// radical 303 195
// approxequal 305 197
// Delta 306 198
// lozenge 327 215
// Euro 333 219
// apple 360 240
// When the font has no Encoding entry, or the font descriptor’s Symbolic flag is set (in which case the
// Encoding entry is ignored), this shall occur:
// • If the font contains a (3, 0) subtable, the range of character codes shall be one of these: 0x0000 -
// 0x00FF, 0xF000 - 0xF0FF, 0xF100 - 0xF1FF, or 0xF200 - 0xF2FF. Depending on the range of
// codes, each byte from the string shall be prepended with the high byte of the range, to form a two-
// byte character, which shall be used to select the associated glyph description from the subtable.
// • Otherwise, if the font contains a (1, 0) subtable, single bytes from the string shall be used to look
// up the associated glyph descriptions from the subtable.
// If a character cannot be mapped in any of the ways described previously, a PDF processor may supply a
// mapping of its choosing.
