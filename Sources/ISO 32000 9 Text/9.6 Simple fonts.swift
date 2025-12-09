// ISO 32000-2:2020, 9.6 Simple fonts
//
// Sections:
//   9.6.1  General
//   9.6.2  Standard Type 1 fonts (Standard 14)
//   9.6.3  Type 1 fonts
//   9.6.4  Multiple master fonts
//   9.6.5  TrueType fonts
//   9.6.6  Type 3 fonts

public import ISO_32000_Shared
public import ISO_32000_7_Syntax
public import ISO_32000_8_Graphics

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
            resourceName: try! ISO_32000.`7`.`3`.COS.Name("F1"),
            metrics: .helvetica,
            isMonospaced: false,
            weight: .regular,
            style: .normal,
            family: .helvetica
        )

        /// Helvetica Bold
        public static let bold = ISO_32000.`9`.`6`.Font(
            baseFontName: .helveticaBold,
            resourceName: try! ISO_32000.`7`.`3`.COS.Name( "F2"),
            metrics: .helveticaBold,
            isMonospaced: false,
            weight: .bold,
            style: .normal,
            family: .helvetica
        )

        /// Helvetica Oblique
        public static let oblique = ISO_32000.`9`.`6`.Font(
            baseFontName: .helveticaOblique,
            resourceName: try! ISO_32000.`7`.`3`.COS.Name( "F3"),
            metrics: .helvetica,
            isMonospaced: false,
            weight: .regular,
            style: .oblique,
            family: .helvetica
        )

        /// Helvetica Bold Oblique
        public static let boldOblique = ISO_32000.`9`.`6`.Font(
            baseFontName: .helveticaBoldOblique,
            resourceName: try! ISO_32000.`7`.`3`.COS.Name( "F4"),
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
            resourceName: try! ISO_32000.`7`.`3`.COS.Name( "F5"),
            metrics: .timesRoman,
            isMonospaced: false,
            weight: .regular,
            style: .normal,
            family: .times
        )

        /// Times Bold
        public static let bold = ISO_32000.`9`.`6`.Font(
            baseFontName: .timesBold,
            resourceName: try! ISO_32000.`7`.`3`.COS.Name( "F6"),
            metrics: .timesBold,
            isMonospaced: false,
            weight: .bold,
            style: .normal,
            family: .times
        )

        /// Times Italic
        public static let italic = ISO_32000.`9`.`6`.Font(
            baseFontName: .timesItalic,
            resourceName: try! ISO_32000.`7`.`3`.COS.Name( "F7"),
            metrics: .timesRoman,
            isMonospaced: false,
            weight: .regular,
            style: .italic,
            family: .times
        )

        /// Times Bold Italic
        public static let boldItalic = ISO_32000.`9`.`6`.Font(
            baseFontName: .timesBoldItalic,
            resourceName: try! ISO_32000.`7`.`3`.COS.Name( "F8"),
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
            resourceName: try! ISO_32000.`7`.`3`.COS.Name( "F9"),
            metrics: .courier,
            isMonospaced: true,
            weight: .regular,
            style: .normal,
            family: .courier
        )

        /// Courier Bold
        public static let bold = ISO_32000.`9`.`6`.Font(
            baseFontName: .courierBold,
            resourceName: try! ISO_32000.`7`.`3`.COS.Name( "F10"),
            metrics: .courier,
            isMonospaced: true,
            weight: .bold,
            style: .normal,
            family: .courier
        )

        /// Courier Oblique
        public static let oblique = ISO_32000.`9`.`6`.Font(
            baseFontName: .courierOblique,
            resourceName: try! ISO_32000.`7`.`3`.COS.Name( "F11"),
            metrics: .courier,
            isMonospaced: true,
            weight: .regular,
            style: .oblique,
            family: .courier
        )

        /// Courier Bold Oblique
        public static let boldOblique = ISO_32000.`9`.`6`.Font(
            baseFontName: .courierBoldOblique,
            resourceName: try! ISO_32000.`7`.`3`.COS.Name( "F12"),
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
            resourceName: try! ISO_32000.`7`.`3`.COS.Name( "F13"),
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
            resourceName: try! ISO_32000.`7`.`3`.COS.Name( "F14"),
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
    /// Calculate width of a String at a specific font size
    public func width(of text: String, atSize size: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
        metrics.width(of: text, atSize: size)
    }

    /// WinAnsi encoding operations on this font
    public var winAnsi: WinAnsi { WinAnsi(font: self) }

    /// WinAnsi encoding namespace for font
    public struct WinAnsi: Sendable {
        let font: ISO_32000.`9`.`6`.Font

        /// Calculate width of WinAnsi-encoded bytes at a specific font size
        public func width<Bytes: Collection>(of bytes: Bytes, atSize size: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit where Bytes.Element == UInt8 {
            font.metrics.winAnsi.width(of: bytes, atSize: size)
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
            font.family == family &&
            font.weight == weight &&
            font.style == style
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
