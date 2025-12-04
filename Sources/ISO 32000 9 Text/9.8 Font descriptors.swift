// ISO 32000-2:2020, 9.8 Font descriptors
//
// Sections:
//   9.8.1  General
//   9.8.2  Font descriptor flags
//   9.8.3  Font metrics

public import ISO_32000_Shared
public import ISO_32000_8_Graphics

extension ISO_32000.`9` {
    /// ISO 32000-2:2020, 9.8 Font descriptors
    public enum `8` {}
}

// MARK: - Font Metrics

extension ISO_32000.`9`.`8` {
    /// Font metrics for text measurement
    ///
    /// Per ISO 32000-2 Section 9.8, font descriptors contain metrics
    /// that describe the font's characteristics.
    ///
    /// Metrics are in font design units (1000 units per em for Type 1 fonts).
    /// To get actual size: `value * fontSize / 1000`
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 9.8.3 — Font metrics
    public struct Metrics: Sendable {
        /// Glyph width table
        private let widths: [UInt32: Int]

        /// Default width for missing glyphs
        private let defaultWidth: Int

        /// Ascender: height above baseline for tallest glyphs (e.g., 'b', 'd', 'h')
        public let ascender: Int

        /// Descender: depth below baseline (negative value, e.g., 'g', 'p', 'y')
        public let descender: Int

        /// Cap height: height of capital letters
        public let capHeight: Int

        /// x-height: height of lowercase 'x'
        public let xHeight: Int

        /// Create metrics with a width table and vertical metrics
        public init(
            widths: [UInt32: Int],
            defaultWidth: Int,
            ascender: Int,
            descender: Int,
            capHeight: Int,
            xHeight: Int
        ) {
            self.widths = widths
            self.defaultWidth = defaultWidth
            self.ascender = ascender
            self.descender = descender
            self.capHeight = capHeight
            self.xHeight = xHeight
        }

        /// Get width of a single character in font design units
        public func glyphWidth(for scalar: UnicodeScalar) -> Int {
            widths[scalar.value] ?? defaultWidth
        }

        /// Calculate string width in font design units
        public func stringWidth(_ text: String) -> Int {
            var total = 0
            for scalar in text.unicodeScalars {
                total += glyphWidth(for: scalar)
            }
            return total
        }

        /// Calculate string width at a specific font size
        public func stringWidth(_ text: String, atSize size: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
            ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit(Double(stringWidth(text)) * size.value / 1000.0)
        }

        /// Line height in font design units (ascender - descender)
        public var lineHeight: Int {
            ascender - descender
        }

        /// Line height at a specific font size
        public func lineHeight(atSize size: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
            ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit(Double(lineHeight) * size.value / 1000.0)
        }

        /// Ascender at a specific font size
        public func ascender(atSize size: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
            ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit(Double(ascender) * size.value / 1000.0)
        }

        /// Descender at a specific font size (negative value)
        public func descender(atSize size: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
            ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit(Double(descender) * size.value / 1000.0)
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
