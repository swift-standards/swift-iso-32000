// ISO 32000-2:2020, 9.8 Font descriptors
//
// Sections:
//   9.8.1  General
//   9.8.2  Font descriptor flags
//   9.8.3  Font metrics

public import ISO_32000_Shared
public import ISO_32000_8_Graphics
import ISO_32000_Annex_D

extension ISO_32000.`9` {
    /// ISO 32000-2:2020, 9.8 Font descriptors
    public enum `8` {}
}

// MARK: - 9.8.3 Font Design Units

extension ISO_32000.`9`.`8` {
    /// Font design space namespace
    ///
    /// Per ISO 32000-2:2020, Section 9.8.3, font metrics are specified in
    /// font design units. For Type 1 fonts (including the Standard 14),
    /// the em square is 1000 units.
    public enum FontDesign {}
}

extension ISO_32000 {
    public typealias FontDesign = ISO_32000.`9`.`8`.FontDesign
}

extension ISO_32000.`9`.`8`.FontDesign {
    /// Font design unit (1/1000 em for Type 1 fonts)
    ///
    /// Per ISO 32000-2:2020, Section 9.8.3:
    /// > Glyph coordinate systems are defined so that the em square has a
    /// > standard 1000-unit width for Type 1 fonts.
    ///
    /// This type provides type-safety for measurements in font design space,
    /// which is used for font metrics like ascender, descender, x-height, etc.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let ascender: FontDesign.Unit = 683   // Times Roman ascender
    /// let descender: FontDesign.Unit = -217 // Times Roman descender
    /// let lineHeight = ascender - descender // 900 units
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 9.8.3 — Font metrics
    public struct Unit: Sendable, Codable {
        /// The measurement value in font design units (1/1000 em for Type 1)
        public var value: Int

        /// Create a font design unit measurement
        ///
        /// - Parameter value: The measurement in font design units
        @inlinable
        public init(_ value: Int) {
            self.value = value
        }

        /// Convert to user space units at a specific font size
        ///
        /// - Parameter fontSize: The font size in user space units
        /// - Returns: The measurement in user space units
        @inlinable
        public func atSize(_ fontSize: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
            ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit(Double(value) * fontSize.value / 1000.0)
        }
    }
}

// MARK: - AdditiveArithmetic

extension ISO_32000.`9`.`8`.FontDesign.Unit: AdditiveArithmetic {
    /// Zero
    public static var zero: Self { Self(0) }

    /// Add two measurements
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs.value + rhs.value)
    }

    /// Subtract two measurements
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs.value - rhs.value)
    }
}

// MARK: - Comparable

extension ISO_32000.`9`.`8`.FontDesign.Unit: Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - Hashable

extension ISO_32000.`9`.`8`.FontDesign.Unit: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension ISO_32000.`9`.`8`.FontDesign.Unit: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Int) {
        self.value = value
    }
}

// MARK: - Negation

extension ISO_32000.`9`.`8`.FontDesign.Unit {
    /// Negate
    @inlinable
    public static prefix func - (value: Self) -> Self {
        Self(-value.value)
    }
}

// MARK: - Font Metrics

extension ISO_32000.`9`.`8` {
    /// Font metrics for text measurement
    ///
    /// Per ISO 32000-2 Section 9.8, font descriptors contain metrics
    /// that describe the font's characteristics.
    ///
    /// Metrics are in font design units (1000 units per em for Type 1 fonts).
    /// Use the `atSize(_:)` method on `FontDesign.Unit` to convert to user space.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 9.8.3 — Font metrics
    /// ISO 32000-2:2020, Table 121 — Entries common to all font descriptors
    public struct Metrics: Sendable {
        /// Glyph width table (in font design units)
        private let widths: [UInt32: FontDesign.Unit]

        /// Default width for missing glyphs (in font design units)
        private let defaultWidth: FontDesign.Unit

        /// Ascent: maximum height above the baseline reached by glyphs
        ///
        /// Per ISO 32000-2 Table 121:
        /// > (Required, except for Type 3 fonts) The maximum height above the
        /// > baseline reached by glyphs in this font.
        public let ascender: FontDesign.Unit

        /// Descent: maximum depth below the baseline reached by glyphs
        ///
        /// Per ISO 32000-2 Table 121:
        /// > (Required, except for Type 3 fonts) The maximum depth below the
        /// > baseline reached by glyphs in this font. The value shall be a
        /// > negative number.
        public let descender: FontDesign.Unit

        /// Cap height: vertical coordinate of the top of flat capital letters
        ///
        /// Per ISO 32000-2 Table 121:
        /// > (Required for fonts that have Latin characters, except for Type 3
        /// > fonts) The y coordinate of the top of flat capital letters,
        /// > measured from the baseline.
        public let capHeight: FontDesign.Unit

        /// x-height: vertical coordinate of the top of flat nonascending lowercase letters
        ///
        /// Per ISO 32000-2 Table 121:
        /// > (Optional) The font's x height: the vertical coordinate of the top
        /// > of flat nonascending lowercase letters (like the letter x),
        /// > measured from the baseline.
        public let xHeight: FontDesign.Unit

        /// Leading: desired spacing between baselines of consecutive lines of text
        ///
        /// Per ISO 32000-2 Table 121:
        /// > (Optional) The spacing between baselines of consecutive lines of text.
        /// > Default value: 0.
        ///
        /// The normal line height (CSS `line-height: normal`) is computed as:
        /// `ascender - descender + leading`
        public let leading: FontDesign.Unit

        /// Create metrics with a width table and vertical metrics
        public init(
            widths: [UInt32: Int],
            defaultWidth: Int,
            ascender: Int,
            descender: Int,
            capHeight: Int,
            xHeight: Int,
            leading: Int = 0
        ) {
            self.widths = widths.mapValues { FontDesign.Unit($0) }
            self.defaultWidth = FontDesign.Unit(defaultWidth)
            self.ascender = FontDesign.Unit(ascender)
            self.descender = FontDesign.Unit(descender)
            self.capHeight = FontDesign.Unit(capHeight)
            self.xHeight = FontDesign.Unit(xHeight)
            self.leading = FontDesign.Unit(leading)
        }

        /// Get width of a single character in font design units
        public func glyphWidth(for scalar: UnicodeScalar) -> FontDesign.Unit {
            widths[scalar.value] ?? defaultWidth
        }

        /// Calculate width of a String in font design units
        public func width(of text: String) -> FontDesign.Unit {
            var total: FontDesign.Unit = 0
            for scalar in text.unicodeScalars {
                total = total + glyphWidth(for: scalar)
            }
            return total
        }

        /// Calculate width of a String at a specific font size
        public func width(of text: String, atSize size: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
            width(of: text).atSize(size)
        }

        /// WinAnsi encoding operations on this font metrics
        public var winAnsi: WinAnsi { WinAnsi(metrics: self) }

        /// WinAnsi encoding namespace for font metrics
        public struct WinAnsi: Sendable {
            let metrics: Metrics

            /// Calculate width of WinAnsi-encoded bytes in font design units
            public func width<Bytes: Collection>(of bytes: Bytes) -> FontDesign.Unit where Bytes.Element == UInt8 {
                var total: FontDesign.Unit = 0
                for byte in bytes {
                    if let scalar = ISO_32000.WinAnsiEncoding.decode(byte) {
                        total = total + metrics.glyphWidth(for: scalar)
                    }
                }
                return total
            }

            /// Calculate width of WinAnsi-encoded bytes at a specific font size
            public func width<Bytes: Collection>(of bytes: Bytes, atSize size: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit where Bytes.Element == UInt8 {
                width(of: bytes).atSize(size)
            }
        }

        /// Line height in font design units (ascender - descender)
        ///
        /// This is the minimum line height without any leading/line gap.
        public var lineHeight: FontDesign.Unit {
            ascender - descender
        }

        /// Normal line height in font design units (ascender - descender + leading)
        ///
        /// This corresponds to CSS `line-height: normal` and includes the font's
        /// recommended leading (from the Leading entry in the font descriptor).
        public var normalLineHeight: FontDesign.Unit {
            ascender - descender + leading
        }

        /// Line height at a specific font size
        public func lineHeight(atSize size: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
            lineHeight.atSize(size)
        }

        /// Normal line height at a specific font size (includes leading)
        public func normalLineHeight(atSize size: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
            normalLineHeight.atSize(size)
        }

        /// Ascender at a specific font size
        public func ascender(atSize size: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
            ascender.atSize(size)
        }

        /// Descender at a specific font size (negative value)
        public func descender(atSize size: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
            descender.atSize(size)
        }

        /// x-height at a specific font size
        public func xHeight(atSize size: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
            xHeight.atSize(size)
        }

        /// Cap height at a specific font size
        public func capHeight(atSize size: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
            capHeight.atSize(size)
        }
    }
}

// MARK: - Pre-defined Metrics (Standard 14 Fonts)

extension ISO_32000.`9`.`8`.Metrics {
    /// Helvetica metrics (from Adobe AFM)
    public static let helvetica = Self(
        widths: [
            // Space and punctuation
            32: 278, 33: 278, 34: 355, 35: 556, 36: 556, 37: 889, 38: 667, 39: 191,
            40: 333, 41: 333, 42: 389, 43: 584, 44: 278, 45: 333, 46: 278, 47: 278,
            // Digits
            48: 556, 49: 556, 50: 556, 51: 556, 52: 556, 53: 556, 54: 556, 55: 556,
            56: 556, 57: 556,
            // Punctuation
            58: 278, 59: 278, 60: 584, 61: 584, 62: 584, 63: 556,
            // Uppercase
            64: 1015, 65: 667, 66: 667, 67: 722, 68: 722, 69: 667, 70: 611, 71: 778,
            72: 722, 73: 278, 74: 500, 75: 667, 76: 556, 77: 833, 78: 722, 79: 778,
            80: 667, 81: 778, 82: 722, 83: 667, 84: 611, 85: 722, 86: 667, 87: 944,
            88: 667, 89: 667, 90: 611,
            // Brackets
            91: 278, 92: 278, 93: 278, 94: 469, 95: 556, 96: 333,
            // Lowercase
            97: 556, 98: 556, 99: 500, 100: 556, 101: 556, 102: 278, 103: 556,
            104: 556, 105: 222, 106: 222, 107: 500, 108: 222, 109: 833, 110: 556,
            111: 556, 112: 556, 113: 556, 114: 333, 115: 500, 116: 278, 117: 556,
            118: 500, 119: 722, 120: 500, 121: 500, 122: 500,
            // Braces
            123: 334, 124: 260, 125: 334, 126: 584,
        ],
        defaultWidth: 556,
        ascender: 718,
        descender: -207,
        capHeight: 718,
        xHeight: 523
    )

    /// Helvetica Bold metrics (from Adobe AFM)
    public static let helveticaBold = Self(
        widths: [
            32: 278, 33: 333, 34: 474, 35: 556, 36: 556, 37: 889, 38: 722, 39: 238,
            40: 333, 41: 333, 42: 389, 43: 584, 44: 278, 45: 333, 46: 278, 47: 278,
            48: 556, 49: 556, 50: 556, 51: 556, 52: 556, 53: 556, 54: 556, 55: 556,
            56: 556, 57: 556,
            58: 333, 59: 333, 60: 584, 61: 584, 62: 584, 63: 611,
            64: 975, 65: 722, 66: 722, 67: 722, 68: 722, 69: 667, 70: 611, 71: 778,
            72: 722, 73: 278, 74: 556, 75: 722, 76: 611, 77: 833, 78: 722, 79: 778,
            80: 667, 81: 778, 82: 722, 83: 667, 84: 611, 85: 722, 86: 667, 87: 944,
            88: 667, 89: 667, 90: 611,
            91: 333, 92: 278, 93: 333, 94: 584, 95: 556, 96: 333,
            97: 556, 98: 611, 99: 556, 100: 611, 101: 556, 102: 333, 103: 611,
            104: 611, 105: 278, 106: 278, 107: 556, 108: 278, 109: 889, 110: 611,
            111: 611, 112: 611, 113: 611, 114: 389, 115: 556, 116: 333, 117: 611,
            118: 556, 119: 778, 120: 556, 121: 556, 122: 500,
            123: 389, 124: 280, 125: 389, 126: 584,
        ],
        defaultWidth: 611,
        ascender: 718,
        descender: -207,
        capHeight: 718,
        xHeight: 532
    )

    /// Times Roman metrics (from Adobe AFM)
    public static let timesRoman = Self(
        widths: [
            32: 250, 33: 333, 34: 408, 35: 500, 36: 500, 37: 833, 38: 778, 39: 180,
            40: 333, 41: 333, 42: 500, 43: 564, 44: 250, 45: 333, 46: 250, 47: 278,
            48: 500, 49: 500, 50: 500, 51: 500, 52: 500, 53: 500, 54: 500, 55: 500,
            56: 500, 57: 500,
            58: 278, 59: 278, 60: 564, 61: 564, 62: 564, 63: 444,
            64: 921, 65: 722, 66: 667, 67: 667, 68: 722, 69: 611, 70: 556, 71: 722,
            72: 722, 73: 333, 74: 389, 75: 722, 76: 611, 77: 889, 78: 722, 79: 722,
            80: 556, 81: 722, 82: 667, 83: 556, 84: 611, 85: 722, 86: 722, 87: 944,
            88: 722, 89: 722, 90: 611,
            91: 333, 92: 278, 93: 333, 94: 469, 95: 500, 96: 333,
            97: 444, 98: 500, 99: 444, 100: 500, 101: 444, 102: 333, 103: 500,
            104: 500, 105: 278, 106: 278, 107: 500, 108: 278, 109: 778, 110: 500,
            111: 500, 112: 500, 113: 500, 114: 333, 115: 389, 116: 278, 117: 500,
            118: 500, 119: 722, 120: 500, 121: 500, 122: 444,
            123: 480, 124: 200, 125: 480, 126: 541,
        ],
        defaultWidth: 500,
        ascender: 683,
        descender: -217,
        capHeight: 662,
        xHeight: 450
    )

    /// Times Bold metrics (from Adobe AFM)
    public static let timesBold = Self(
        widths: [
            32: 250, 33: 333, 34: 555, 35: 500, 36: 500, 37: 1000, 38: 833, 39: 278,
            40: 333, 41: 333, 42: 500, 43: 570, 44: 250, 45: 333, 46: 250, 47: 278,
            48: 500, 49: 500, 50: 500, 51: 500, 52: 500, 53: 500, 54: 500, 55: 500,
            56: 500, 57: 500,
            58: 333, 59: 333, 60: 570, 61: 570, 62: 570, 63: 500,
            64: 930, 65: 722, 66: 667, 67: 722, 68: 722, 69: 667, 70: 611, 71: 778,
            72: 778, 73: 389, 74: 500, 75: 778, 76: 667, 77: 944, 78: 722, 79: 778,
            80: 611, 81: 778, 82: 722, 83: 556, 84: 667, 85: 722, 86: 722, 87: 1000,
            88: 722, 89: 722, 90: 667,
            91: 333, 92: 278, 93: 333, 94: 581, 95: 500, 96: 333,
            97: 500, 98: 556, 99: 444, 100: 556, 101: 444, 102: 333, 103: 500,
            104: 556, 105: 278, 106: 333, 107: 556, 108: 278, 109: 833, 110: 556,
            111: 500, 112: 556, 113: 556, 114: 444, 115: 389, 116: 333, 117: 556,
            118: 500, 119: 722, 120: 500, 121: 500, 122: 444,
            123: 394, 124: 220, 125: 394, 126: 520,
        ],
        defaultWidth: 556,
        ascender: 683,
        descender: -217,
        capHeight: 676,
        xHeight: 461
    )

    /// Courier metrics (monospaced - all glyphs are 600 units wide, from Adobe AFM)
    public static let courier = Self(
        widths: [:],
        defaultWidth: 600,
        ascender: 629,
        descender: -157,
        capHeight: 562,
        xHeight: 426
    )

    /// Symbol metrics (from Adobe AFM)
    public static let symbol = Self(
        widths: [:],
        defaultWidth: 500,
        ascender: 0,
        descender: 0,
        capHeight: 0,
        xHeight: 0
    )

    /// ZapfDingbats metrics (from Adobe AFM)
    public static let zapfDingbats = Self(
        widths: [:],
        defaultWidth: 500,
        ascender: 820,
        descender: -143,
        capHeight: 0,
        xHeight: 0
    )
}
