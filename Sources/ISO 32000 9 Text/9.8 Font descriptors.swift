// ISO 32000-2:2020, 9.8 Font descriptors
//
// Sections:
//   9.8.1  General
//   9.8.2  Font descriptor flags
//   9.8.3  Font metrics

import ISO_32000_8_Graphics
import ISO_32000_Annex_D
public import ISO_32000_Shared

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

// MARK: - FontDesign Documentation
//
// ISO_32000.FontDesign is defined as Geometry<Int, ISO_32000.`9`.`8`.FontDesign>
// which provides the following types via the Geometry library:
//
// - Width:  horizontal displacement in font design units
// - Height: vertical displacement in font design units
// - X:      horizontal coordinate in font design units
// - Y:      vertical coordinate in font design units
// - Size<N>: N-dimensional size in font design units
//
// Font design units are integer-valued (1/1000 em for Type 1, 1/2048 for TrueType)

// MARK: - FontDesign Tagged Arithmetic

extension Tagged: AdditiveArithmetic
where Tag == ISO_32000.`9`.`8`.FontDesign, RawValue: AdditiveArithmetic {
    /// The zero value in font design units.
    @inlinable
    public static var zero: Self { Self(RawValue.zero) }

    /// Adds two font design unit values.
    ///
    /// Valid for accumulating glyph widths (e.g., total string width).
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs._rawValue + rhs._rawValue)
    }

    /// Subtracts one font design unit value from another.
    ///
    /// Valid for computing differences (e.g., `ascender - descender` for line height).
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs._rawValue - rhs._rawValue)
    }
}

// MARK: - FontDesign to UserSpace Conversion

extension ISO_32000.FontDesign.Width {
    /// Convert font design width to user space at the given font size.
    ///
    /// Per ISO 32000-2:2020, Section 9.2.4:
    /// `userSpaceValue = fontDesignUnits × (fontSize / unitsPerEm)`
    ///
    /// - Parameters:
    ///   - fontSize: The font size in user space units (points at 1/72 inch)
    ///   - unitsPerEm: Units per em (1000 for Type 1, 2048 for TrueType). Default: 1000
    /// - Returns: Width in user space units
    ///
    /// ## Example
    ///
    /// ```swift
    /// let glyphWidth: ISO_32000.FontDesign.Width = 556  // Helvetica 'a'
    /// let fontSize: ISO_32000.UserSpace.Size<1> = .init(12)
    /// let actualWidth = glyphWidth.scaled(by: fontSize)  // 6.672 points
    /// ```
    @inlinable
    public func scaled(
        by fontSize: ISO_32000.UserSpace.Size<1>,
        unitsPerEm: Int = 1000
    ) -> ISO_32000.UserSpace.Width {
        let scale = fontSize.length._rawValue / Double(unitsPerEm)
        return ISO_32000.UserSpace.Width(Double(self._rawValue) * scale)
    }
}

extension ISO_32000.FontDesign.Height {
    /// Convert font design height to user space at the given font size.
    ///
    /// Per ISO 32000-2:2020, Section 9.2.4:
    /// `userSpaceValue = fontDesignUnits × (fontSize / unitsPerEm)`
    ///
    /// - Parameters:
    ///   - fontSize: The font size in user space units (points at 1/72 inch)
    ///   - unitsPerEm: Units per em (1000 for Type 1, 2048 for TrueType). Default: 1000
    /// - Returns: Height in user space units
    @inlinable
    public func scaled(
        by fontSize: ISO_32000.UserSpace.Size<1>,
        unitsPerEm: Int = 1000
    ) -> ISO_32000.UserSpace.Height {
        let scale = fontSize.length._rawValue / Double(unitsPerEm)
        return ISO_32000.UserSpace.Height(Double(self._rawValue) * scale)
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
    /// Use the `atSize(_:)` method on `FontDesign.Unit2` to convert to user space.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 9.8.3 — Font metrics
    /// ISO 32000-2:2020, Table 121 — Entries common to all font descriptors
    public struct Metrics: Sendable {
        /// Glyph width table (in font design units)
        private let widths: [UInt32: ISO_32000.FontDesign.Width]

        /// Default width for missing glyphs (in font design units)
        private let defaultWidth: ISO_32000.FontDesign.Width

        /// Pre-computed WinAnsi byte-to-width lookup table (256 entries)
        ///
        /// This enables O(1) width lookups for WinAnsi-encoded bytes without
        /// needing to decode to Unicode first. Computed once at initialization.
        private let winAnsiByteWidths: [ISO_32000.FontDesign.Width]

        /// Ascent: maximum height above the baseline reached by glyphs
        ///
        /// Per ISO 32000-2 Table 121:
        /// > (Required, except for Type 3 fonts) The maximum height above the
        /// > baseline reached by glyphs in this font.
        public let ascender: ISO_32000.FontDesign.Height

        /// Descent: maximum depth below the baseline reached by glyphs
        ///
        /// Per ISO 32000-2 Table 121:
        /// > (Required, except for Type 3 fonts) The maximum depth below the
        /// > baseline reached by glyphs in this font. The value shall be a
        /// > negative number.
        public let descender: ISO_32000.FontDesign.Height

        /// Cap height: vertical coordinate of the top of flat capital letters
        ///
        /// Per ISO 32000-2 Table 121:
        /// > (Required for fonts that have Latin characters, except for Type 3
        /// > fonts) The y coordinate of the top of flat capital letters,
        /// > measured from the baseline.
        public let capHeight: ISO_32000.FontDesign.Height

        /// x-height: vertical coordinate of the top of flat nonascending lowercase letters
        ///
        /// Per ISO 32000-2 Table 121:
        /// > (Optional) The font's x height: the vertical coordinate of the top
        /// > of flat nonascending lowercase letters (like the letter x),
        /// > measured from the baseline.
        public let xHeight: ISO_32000.FontDesign.Height

        /// Leading: desired spacing between baselines of consecutive lines of text
        ///
        /// Per ISO 32000-2 Table 121:
        /// > (Optional) The spacing between baselines of consecutive lines of text.
        /// > Default value: 0.
        ///
        /// The normal line height (CSS `line-height: normal`) is computed as:
        /// `ascender - descender + leading`
        public let leading: ISO_32000.FontDesign.Height

        /// Units per em square
        ///
        /// - Type 1 fonts: 1000 units per em
        /// - TrueType fonts: typically 2048 units per em (but variable)
        public let unitsPerEm: Int

        /// Get the width for a Unicode code point.
        ///
        /// Returns the glyph width in font design units, or the default width
        /// if the code point is not in the width table.
        ///
        /// - Parameter codePoint: Unicode code point (e.g., 65 for 'A')
        /// - Returns: Width in font design units
        public func width(forCodePoint codePoint: UInt32) -> Int {
            (widths[codePoint] ?? defaultWidth)._rawValue
        }

        /// The default width for missing glyphs (in font design units).
        ///
        /// Used for characters not in the width table.
        public var missingWidth: Int { defaultWidth._rawValue }

        /// Create metrics with a width table and vertical metrics
        public init(
            widths: [UInt32: Int],
            defaultWidth: Int,
            ascender: Int,
            descender: Int,
            capHeight: Int,
            xHeight: Int,
            leading: Int = 0,
            unitsPerEm: Int = 1000
        ) {
            let typedWidths = widths.mapValues { ISO_32000.FontDesign.Width($0) }
            let typedDefaultWidth = ISO_32000.FontDesign.Width(defaultWidth)

            self.widths = typedWidths
            self.defaultWidth = typedDefaultWidth
            self.ascender = ISO_32000.FontDesign.Height(ascender)
            self.descender = ISO_32000.FontDesign.Height(descender)
            self.capHeight = ISO_32000.FontDesign.Height(capHeight)
            self.xHeight = ISO_32000.FontDesign.Height(xHeight)
            self.leading = ISO_32000.FontDesign.Height(leading)
            self.unitsPerEm = unitsPerEm

            // Pre-compute WinAnsi byte-to-width lookup table
            // This eliminates the decode step in the hot path
            var byteWidths = [ISO_32000.FontDesign.Width](repeating: typedDefaultWidth, count: 256)
            for byte in UInt8.min...UInt8.max {
                if let scalar = ISO_32000.WinAnsiEncoding.decode(byte) {
                    byteWidths[Int(byte)] = typedWidths[scalar.value] ?? typedDefaultWidth
                }
            }
            self.winAnsiByteWidths = byteWidths
        }
    }
}

extension ISO_32000.`9`.`8`.Metrics {

    // MARK: - Primitive: Byte Width (canonical)

    /// Get width of a single WinAnsi byte in font design units
    ///
    /// This is the canonical primitive - all other width calculations are composed from this.
    /// Uses pre-computed lookup table for O(1) access.
    public func width(of byte: UInt8) -> ISO_32000.FontDesign.Width {
        winAnsiByteWidths[Int(byte)]
    }

    /// Calculate width of WinAnsi-encoded bytes in font design units
    ///
    /// Uses pre-computed byte-to-width lookup table for O(1) per-byte access.
    public func width<Bytes: Collection>(of bytes: Bytes) -> ISO_32000.FontDesign.Width
    where Bytes.Element == UInt8 {
        var total = 0
        for byte in bytes {
            total += winAnsiByteWidths[Int(byte)]._rawValue
        }
        return ISO_32000.FontDesign.Width(total)
    }

    /// Calculate width of WinAnsi-encoded bytes at a specific font size (returns UserSpace)
    public func width<Bytes: Collection>(
        of bytes: Bytes,
        atSize fontSize: ISO_32000.UserSpace.Size<1>
    ) -> ISO_32000.UserSpace.Width where Bytes.Element == UInt8 {
        width(of: bytes).scaled(by: fontSize, unitsPerEm: unitsPerEm)
    }

    // MARK: - Composed: Scalar Width (via byte encoding)

    /// Get width of a single Unicode scalar in font design units
    ///
    /// Composed from byte primitive: encodes scalar to WinAnsi byte, then looks up width.
    /// Returns default width if scalar cannot be encoded in WinAnsi.
    public func glyphWidth(for scalar: UnicodeScalar) -> ISO_32000.FontDesign.Width {
        if let byte = ISO_32000.WinAnsiEncoding.encode(scalar) {
            return width(of: byte)
        }
        return defaultWidth
    }

    // MARK: - Composed: String Width (via byte encoding)

    /// Calculate width of a String in font design units
    ///
    /// Composed from byte primitive: encodes each scalar to WinAnsi, then sums widths.
    public func width(of text: String) -> ISO_32000.FontDesign.Width {
        var total = 0
        for scalar in text.unicodeScalars {
            if let byte = ISO_32000.WinAnsiEncoding.encode(scalar) {
                total += winAnsiByteWidths[Int(byte)]._rawValue
            } else {
                total += defaultWidth._rawValue
            }
        }
        return ISO_32000.FontDesign.Width(total)
    }

    /// Calculate width of a String at a specific font size (returns UserSpace)
    public func width(
        of text: String,
        atSize fontSize: ISO_32000.UserSpace.Size<1>
    ) -> ISO_32000.UserSpace.Width {
        width(of: text).scaled(by: fontSize, unitsPerEm: unitsPerEm)
    }

    // MARK: - WinAnsi Namespace (convenience)

    /// WinAnsi encoding operations on this font metrics
    ///
    /// Provides namespaced access to byte-based width calculations.
    /// The underlying implementation uses the same byte primitives.
    public var winAnsi: WinAnsi { WinAnsi(metrics: self) }

    /// WinAnsi encoding namespace for font metrics
    public struct WinAnsi: Sendable {
        let metrics: ISO_32000.`9`.`8`.Metrics

        /// Get width of a single WinAnsi byte in font design units
        public func width(of byte: UInt8) -> ISO_32000.FontDesign.Width {
            metrics.width(of: byte)
        }

        /// Calculate width of WinAnsi-encoded bytes in font design units
        public func width<Bytes: Collection>(of bytes: Bytes) -> ISO_32000.FontDesign.Width
        where Bytes.Element == UInt8 {
            metrics.width(of: bytes)
        }

        /// Calculate width of WinAnsi-encoded bytes at a specific font size (returns UserSpace)
        public func width<Bytes: Collection>(
            of bytes: Bytes,
            atSize fontSize: ISO_32000.UserSpace.Size<1>
        ) -> ISO_32000.UserSpace.Width where Bytes.Element == UInt8 {
            metrics.width(of: bytes, atSize: fontSize)
        }
    }

    /// Line height in font design units (ascender - descender)
    ///
    /// This is the minimum line height without any leading/line gap.
    public var lineHeight: ISO_32000.FontDesign.Height {
        ascender - descender
    }

    /// Normal line height in font design units (ascender - descender + leading)
    ///
    /// This corresponds to CSS `line-height: normal` and includes the font's
    /// recommended leading (from the Leading entry in the font descriptor).
    public var normalLineHeight: ISO_32000.FontDesign.Height {
        ascender - descender + leading
    }

    /// Line height at a specific font size (returns UserSpace)
    public func lineHeight(
        atSize fontSize: ISO_32000.UserSpace.Size<1>
    ) -> ISO_32000.UserSpace.Height {
        lineHeight.scaled(by: fontSize, unitsPerEm: unitsPerEm)
    }

    /// Normal line height at a specific font size (includes leading, returns UserSpace)
    public func normalLineHeight(
        atSize fontSize: ISO_32000.UserSpace.Size<1>
    ) -> ISO_32000.UserSpace.Height {
        normalLineHeight.scaled(by: fontSize, unitsPerEm: unitsPerEm)
    }

    /// Ascender at a specific font size (returns UserSpace)
    public func ascender(
        atSize fontSize: ISO_32000.UserSpace.Size<1>
    ) -> ISO_32000.UserSpace.Height {
        ascender.scaled(by: fontSize, unitsPerEm: unitsPerEm)
    }

    /// Descender at a specific font size (negative value, returns UserSpace)
    public func descender(
        atSize fontSize: ISO_32000.UserSpace.Size<1>
    ) -> ISO_32000.UserSpace.Height {
        descender.scaled(by: fontSize, unitsPerEm: unitsPerEm)
    }

    /// x-height at a specific font size (returns UserSpace)
    public func xHeight(
        atSize fontSize: ISO_32000.UserSpace.Size<1>
    ) -> ISO_32000.UserSpace.Height {
        xHeight.scaled(by: fontSize, unitsPerEm: unitsPerEm)
    }

    /// Cap height at a specific font size (returns UserSpace)
    public func capHeight(
        atSize fontSize: ISO_32000.UserSpace.Size<1>
    ) -> ISO_32000.UserSpace.Height {
        capHeight.scaled(by: fontSize, unitsPerEm: unitsPerEm)
    }

    // MARK: - Line Height Multipliers

    /// Line height metrics as multipliers (relative to font size).
    ///
    /// This provides CSS-compatible line height multipliers:
    /// - `line.height.value` is `(ascender - descender) / unitsPerEm` (the base 1.0 factor)
    /// - `line.normal.value` is `(ascender - descender + leading) / unitsPerEm`
    public var line: Line { Line(metrics: self) }

    /// Line height multipliers namespace.
    public struct Line: Sendable {
        let metrics: ISO_32000.`9`.`8`.Metrics

        /// Base line height as a multiplier (ascender - descender) / unitsPerEm.
        ///
        /// This is the ratio of the typographic line height to the em square.
        public var height: Multiplier {
            let h = metrics.ascender._rawValue - metrics.descender._rawValue
            return Multiplier(Double(h) / Double(metrics.unitsPerEm))
        }

        /// Normal line height as a multiplier (ascender - descender + leading) / unitsPerEm.
        ///
        /// This corresponds to CSS `line-height: normal` and includes the font's
        /// recommended leading (from the Leading entry in the font descriptor).
        public var normal: Multiplier {
            let h =
                metrics.ascender._rawValue - metrics.descender._rawValue + metrics.leading._rawValue
            return Multiplier(Double(h) / Double(metrics.unitsPerEm))
        }

        /// A multiplier value (dimensionless ratio).
        public struct Multiplier: Sendable {
            public let value: Double

            public init(_ value: Double) {
                self.value = value
            }
        }
    }

    // MARK: - Glyph Accessors

    /// Bullet glyph metrics (U+2022, •).
    ///
    /// Provides access to the bullet character metrics for list marker sizing.
    /// The bullet width is the designed size of the disc marker.
    ///
    /// ## Usage
    /// ```swift
    /// let width = metrics.bullet.width              // In font design units
    /// let width = metrics.bullet.width(atSize: 12)  // In user space units
    /// ```
    public var bullet: Glyph {
        Glyph(scalar: "\u{2022}", metrics: self)
    }

    /// Accessor for individual glyph metrics.
    public struct Glyph: Sendable {
        let scalar: UnicodeScalar
        let metrics: ISO_32000.`9`.`8`.Metrics

        /// Glyph width in font design units (1/1000 em)
        public var width: ISO_32000.FontDesign.Width {
            metrics.glyphWidth(for: scalar)
        }

        /// Glyph width at a specific font size (returns UserSpace)
        public func width(
            atSize fontSize: ISO_32000.UserSpace.Size<1>
        ) -> ISO_32000.UserSpace.Width {
            width.scaled(by: fontSize, unitsPerEm: metrics.unitsPerEm)
        }
    }
}

// MARK: - Pre-defined Metrics (Standard 14 Fonts)

extension ISO_32000.`9`.`8`.Metrics {
    /// Helvetica metrics (from Adobe AFM)
    ///
    /// Source: https://github.com/Hopding/standard-fonts/blob/master/font_metrics/Helvetica.afm
    public static let helvetica = Self(
        widths: [
            // Space and punctuation (32-47)
            32: 278, 33: 278, 34: 355, 35: 556, 36: 556, 37: 889, 38: 667, 39: 191,
            40: 333, 41: 333, 42: 389, 43: 584, 44: 278, 45: 333, 46: 278, 47: 278,
            // Digits (48-57)
            48: 556, 49: 556, 50: 556, 51: 556, 52: 556, 53: 556, 54: 556, 55: 556,
            56: 556, 57: 556,
            // Punctuation (58-64)
            58: 278, 59: 278, 60: 584, 61: 584, 62: 584, 63: 556, 64: 1015,
            // Uppercase (65-90)
            65: 667, 66: 667, 67: 722, 68: 722, 69: 667, 70: 611, 71: 778,
            72: 722, 73: 278, 74: 500, 75: 667, 76: 556, 77: 833, 78: 722, 79: 778,
            80: 667, 81: 778, 82: 722, 83: 667, 84: 611, 85: 722, 86: 667, 87: 944,
            88: 667, 89: 667, 90: 611,
            // Brackets (91-96)
            91: 278, 92: 278, 93: 278, 94: 469, 95: 556, 96: 333,
            // Lowercase (97-122)
            97: 556, 98: 556, 99: 500, 100: 556, 101: 556, 102: 278, 103: 556,
            104: 556, 105: 222, 106: 222, 107: 500, 108: 222, 109: 833, 110: 556,
            111: 556, 112: 556, 113: 556, 114: 333, 115: 500, 116: 278, 117: 556,
            118: 500, 119: 722, 120: 500, 121: 500, 122: 500,
            // Braces (123-126)
            123: 334, 124: 260, 125: 334, 126: 584,

            // Extended characters (WinAnsi encoding 128-255, keyed by Unicode scalar)
            // Currency and symbols
            0x20AC: 556,  // Euro sign (WinAnsi 0x80)
            0x201A: 222,  // quotesinglbase (WinAnsi 0x82)
            0x0192: 556,  // florin (WinAnsi 0x83)
            0x201E: 333,  // quotedblbase (WinAnsi 0x84)
            0x2026: 1000,  // ellipsis (WinAnsi 0x85)
            0x2020: 556,  // dagger (WinAnsi 0x86)
            0x2021: 556,  // daggerdbl (WinAnsi 0x87)
            0x02C6: 333,  // circumflex (WinAnsi 0x88)
            0x2030: 1000,  // perthousand (WinAnsi 0x89)
            0x0160: 667,  // Scaron (WinAnsi 0x8A)
            0x2039: 333,  // guilsinglleft (WinAnsi 0x8B)
            0x0152: 1000,  // OE (WinAnsi 0x8C)
            0x017D: 611,  // Zcaron (WinAnsi 0x8E)

            // Quotes and punctuation
            0x2018: 222,  // quoteleft (WinAnsi 0x91)
            0x2019: 222,  // quoteright (WinAnsi 0x92)
            0x201C: 333,  // quotedblleft (WinAnsi 0x93)
            0x201D: 333,  // quotedblright (WinAnsi 0x94)
            0x2022: 350,  // bullet (WinAnsi 0x95) *** KEY FOR LIST MARKERS ***
            0x2013: 556,  // endash (WinAnsi 0x96)
            0x2014: 1000,  // emdash (WinAnsi 0x97)
            0x02DC: 333,  // tilde (WinAnsi 0x98)
            0x2122: 1000,  // trademark (WinAnsi 0x99)
            0x0161: 500,  // scaron (WinAnsi 0x9A)
            0x203A: 333,  // guilsinglright (WinAnsi 0x9B)
            0x0153: 944,  // oe (WinAnsi 0x9C)
            0x017E: 500,  // zcaron (WinAnsi 0x9E)
            0x0178: 667,  // Ydieresis (WinAnsi 0x9F)

            // Latin-1 Supplement (160-255)
            0x00A0: 278,  // nbspace
            0x00A1: 333,  // exclamdown
            0x00A2: 556,  // cent
            0x00A3: 556,  // sterling
            0x00A4: 556,  // currency
            0x00A5: 556,  // yen
            0x00A6: 260,  // brokenbar
            0x00A7: 556,  // section
            0x00A8: 333,  // dieresis
            0x00A9: 737,  // copyright
            0x00AA: 370,  // ordfeminine
            0x00AB: 556,  // guillemotleft
            0x00AC: 584,  // logicalnot
            0x00AD: 333,  // softhyphen
            0x00AE: 737,  // registered
            0x00AF: 333,  // macron
            0x00B0: 400,  // degree
            0x00B1: 584,  // plusminus
            0x00B2: 333,  // twosuperior
            0x00B3: 333,  // threesuperior
            0x00B4: 333,  // acute
            0x00B5: 556,  // mu
            0x00B6: 537,  // paragraph
            0x00B7: 278,  // periodcentered
            0x00B8: 333,  // cedilla
            0x00B9: 333,  // onesuperior
            0x00BA: 365,  // ordmasculine
            0x00BB: 556,  // guillemotright
            0x00BC: 834,  // onequarter
            0x00BD: 834,  // onehalf
            0x00BE: 834,  // threequarters
            0x00BF: 611,  // questiondown

            // Uppercase accented (192-223)
            0x00C0: 667, 0x00C1: 667, 0x00C2: 667, 0x00C3: 667, 0x00C4: 667, 0x00C5: 667,  // À-Å
            0x00C6: 1000,  // Æ
            0x00C7: 722,  // Ç
            0x00C8: 667, 0x00C9: 667, 0x00CA: 667, 0x00CB: 667,  // È-Ë
            0x00CC: 278, 0x00CD: 278, 0x00CE: 278, 0x00CF: 278,  // Ì-Ï
            0x00D0: 722,  // Ð
            0x00D1: 722,  // Ñ
            0x00D2: 778, 0x00D3: 778, 0x00D4: 778, 0x00D5: 778, 0x00D6: 778,  // Ò-Ö
            0x00D7: 584,  // multiply
            0x00D8: 778,  // Ø
            0x00D9: 722, 0x00DA: 722, 0x00DB: 722, 0x00DC: 722,  // Ù-Ü
            0x00DD: 667,  // Ý
            0x00DE: 667,  // Þ
            0x00DF: 611,  // germandbls (ß)

            // Lowercase accented (224-255)
            0x00E0: 556, 0x00E1: 556, 0x00E2: 556, 0x00E3: 556, 0x00E4: 556, 0x00E5: 556,  // à-å
            0x00E6: 889,  // æ
            0x00E7: 500,  // ç
            0x00E8: 556, 0x00E9: 556, 0x00EA: 556, 0x00EB: 556,  // è-ë
            0x00EC: 278, 0x00ED: 278, 0x00EE: 278, 0x00EF: 278,  // ì-ï
            0x00F0: 556,  // ð
            0x00F1: 556,  // ñ
            0x00F2: 556, 0x00F3: 556, 0x00F4: 556, 0x00F5: 556, 0x00F6: 556,  // ò-ö
            0x00F7: 584,  // divide
            0x00F8: 611,  // ø
            0x00F9: 556, 0x00FA: 556, 0x00FB: 556, 0x00FC: 556,  // ù-ü
            0x00FD: 500,  // ý
            0x00FE: 556,  // þ
            0x00FF: 500,  // ÿ
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

// 9.9 Embedded font programs
// 9.9.1 General
// This clause describes how a font program can be embedded in a PDF file as data contained in a PDF
// stream object.
// For text in text rendering mode 3, font programs may be embedded. For text in other text rendering
// modes, font programs should be embedded.
// NOTE 1 Such a stream object is also called a font file by analogy with font programs that are available
// from sources external to PDF processors.
// Font programs are subject to copyright, and the copyright owner may impose conditions under which
// a font program may be used. These permissions are recorded either in the font program or as part of a
// separate license. One of the conditions may be that the font program cannot be embedded, in which
// case it should not be incorporated into a PDF file. A font program may allow embedding for the sole
// purpose of viewing and printing the document but not for creating new or modified text that uses the
// font (in either the same document or other documents). The latter operation would require the user
// performing the operation to have a licensed copy of the font program, not a copy extracted from the
// PDF file. In the absence of explicit information to the contrary, embedded font programs shall be used
// only to view and print the document and not for any other purposes.
// "Table 124 — Embedded font organisation for various font types" summarises the ways in which font
// programs shall be embedded in a PDF file, depending on the representation of the font program. The
// key shall be the name used in the font descriptor to refer to the font file stream; the subtype shall be
// the value of the Subtype key, if present, in the font file stream dictionary.
// © ISO 2020 – All rights reserved 351
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// Table 124 — Embedded font organisation for various font types
// Key Subtype Description
// FontFile — Type 1 font program, in the original (noncompact) format described in
// Adobe Type 1 Font Format. This entry may appear in the font descriptor
// for a Type1 or MMType1 font dictionary.
// The font program provided as the value of this key shall conform to the
// Adobe Type 1 Font Format and/or Adobe Technical Note #5015, Type 1
// Font Format Supplement.
// FontFile2 — (PDF 1.1) TrueType font program, as described in the TrueType Reference
// Manual. This entry may appear in the font descriptor for a TrueType font
// dictionary or (PDF 1.3) for a CIDFontType2 CIDFont dictionary.
// The font program provided as the value of this key shall conform to the
// TrueType Reference Manual. The font program shall include these tables:
// "glyf"
// "head"
// "hhea"
// "hmtx"
// ,
// ,
// ,
// ,
// "loca", and "maxp". The "cvt " (notice the
// trailing SPACE), "fpgm", and "prep" tables shall also be included if they
// are required by the font instructions.
// FontFile3 Type1C (PDF 1.2) Type 1–equivalent font program represented in the Compact
// Font Format (CFF), as described in Adobe Technical Note #5176, The
// Compact Font Format Specification. This entry may appear in the font
// descriptor for a Type1 or MMType1 font dictionary.
// The font program provided as the value of this key shall conform to
// Adobe Technical Note #5176.
// FontFile3 CIDFontType0C (PDF 1.3) Type 0 CIDFont program represented in the Compact Font
// Format (CFF), as described in Adobe Technical Note #5176, The Compact
// Font Format Specification. This entry may appear in the font descriptor
// for a CIDFontType0 CIDFont dictionary.
// The font program provided as the value of this key shall conform to
// Adobe Technical Note #5176.
// 352 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// Key Subtype Description
// FontFile3 OpenType (PDF 1.6) OpenType font program, as described in ISO/IEC 14496-22.
// OpenType is an extension of TrueType that allows inclusion of font
// programs that use the Compact Font Format (CFF).
// • A TrueType font dictionary or a CIDFontType2 CIDFont dictionary, if the
// embedded font program contains a "glyf" table. In addition to the "glyf"
// table, the font program shall include these tables: "head"
// "hhea"
// "hmtx"
// ,
// ,
// ,
// "loca", and "maxp". The "cvt " (notice the trailing SPACE), "fpgm", and
// "prep" tables shall also be included if they are required by the font
// instructions.
// • A CIDFontType0 CIDFont dictionary, if the embedded font program
// contains a "CFF " table (notice the trailing SPACE) with a Top DICT that
// uses CIDFont operators (this is equivalent to subtype CIDFontType0C). In
// addition to the "CFF " table, the font program shall include the "cmap"
// table.
// • A Type1 font dictionary or CIDFontType0 CIDFont dictionary, if the
// embedded font program contains a "CFF " table without CIDFont operators.
// In addition to the "CFF " table, the font program shall include the "cmap"
// table.
// A FontFile3 entry with an OpenType subtype may appear in the font
// descriptor for these types of font dictionaries.
// ISO/IEC 14496-22 describes a set of required tables; however, not all
// tables are required in the font file, as described for each type of font
// dictionary that can include this entry.
// The font program provided as the value of this key shall conform to
// ISO/IEC 14496-22:2019.
// NOTE The absence of some optional tables (such as those used for advanced
// line layout) can prevent editing of text containing the font.
// The stream dictionary for a font file shall contain the normal entries for a stream, such as Length and
// Filter (listed in "Table 5 — Entries common to all stream dictionaries"), plus the additional entries
// listed in "Table 125 — Additional entries in an embedded font stream dictionary"
// .
// Table 125 — Additional entries in an embedded font stream dictionary
// Key Type Value
// Length1 integer (Required for Type 1 and TrueType font programs) The length in bytes of the
// clear-text portion of the Type 1 font program, or the entire TrueType font
// program, after it has been decoded using the filters specified by the stream’s
// Filter entry, if any.
// Length2 integer (Required for Type 1 font programs) The length in bytes of the encrypted
// portion of the Type 1 font program after it has been decoded using the filters
// specified by the stream’s Filter entry.
// Length3 integer (Required for Type 1 font programs) The length in bytes of the fixed-content
// portion of the Type 1 font program after it has been decoded using the filters
// specified by the stream’s Filter entry. If Length3 is 0, it indicates that the
// 512 zeros and cleartomark have not been included in the FontFile font
// program and shall be added by the PDF processor.
// © ISO 2020 – All rights reserved 353
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// Key Type Value
// Subtype name (Required if referenced from FontFile3; PDF 1.2) A name specifying the
// format of the embedded font program. The name shall be Type1C for Type 1
// compact fonts, CIDFontType0C for Type 0 compact CIDFonts, or OpenType
// for OpenType fonts.
// NOTE 2 A standard Type 1 font program, as described in the Adobe Type 1 Font Format specification,
// consists of three parts: a clear-text portion (written using PostScript syntax), an encrypted
// portion, and a fixed-content portion. The fixed-content portion contains 512 ASCII zeros
// followed by a cleartomark operator, and perhaps followed by additional data. Although the
// encrypted portion of a standard Type 1 font can be in binary or ASCII hexadecimal format, PDF
// supports only the binary format. However, the entire font program can be encoded using any
// filters.
// EXAMPLE This code shows the structure of an embedded standard Type 1 font.
// 12 0 obj
// <</Filter /ASCII85Decode
//  Length 41116
//  Length1 2526
//  Length2 32393
//  Length3 570
// >>
// stream
// ,p>`rDKJj'E+LaU0eP.@+AH9dBOu$hFD55nC
// … Omitted data…
// JJQ&Nt')<=^p&mGf(%:%h1%9c//K(/*o=.C>UXkbVGTrr~>
// endstream
// endobj
// As noted in "Table 124 — Embedded font organisation for various font types", a Type 1–equivalent
// font program or a Type 0 CIDFont program may be represented in the Compact Font Format (CFF). The
// Length1, Length2, and Length3 entries are not needed in that case and shall not be present. Although
// CFF enables multiple font or CIDFont programs to be bundled together in a single file, an embedded
// CFF font file in PDF shall consist of exactly one font or CIDFont (as appropriate for the associated font
// dictionary).
// According to the Adobe Type 1 Font Format specification, a Type 1 font program may contain a
// PaintType entry specifying whether the glyphs’ outlines are to be filled or stroked. For fonts
// embedded in a PDF file, this entry shall be ignored; the decision whether to fill or stroke glyph outlines
// is entirely determined by the PDF text rendering mode parameter (see 9.3.6, "Text rendering mode").
// This shall also apply to Type 1 compact fonts and Type 0 compact CIDFonts.
// A TrueType font program may be used as part of either a font or a CIDFont. Although the basic font file
// format is the same in both cases, there are different requirements for what information shall be
// present in the font program. These TrueType tables shall always be present if present in the original
// TrueType font program: "head"
// "hhea"
// "loca"
// ,
// ,
// ,
// "maxp"
// "cvt "
// ,
// ,
// "prep"
// ,
// "glyf"
// ,
// "hmtx", and "fpgm". If used
// with a simple font dictionary, the font program shall additionally contain a "cmap" table defining one
// or more encodings, as discussed in 9.6.5.4, "Encodings for TrueType fonts". If used with a CIDFont
// dictionary, the "cmap" table is not needed and shall not be present, since the mapping from character
// codes to glyph descriptions is provided separately.
// 354 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// The "vhea" and "vmtx" tables that specify vertical metrics shall never be used by a PDF processor. The
// only way to specify vertical metrics in PDF shall be by means of the DW2 and W2 entries in a CIDFont
// dictionary.
// NOTE 3 Beginning with PDF 1.6, font programs can be embedded using the OpenType format, which is an
// extension of the TrueType format that allows inclusion of font programs using the Compact Font
// Format (CFF). It also allows inclusion of data to describe glyph substitutions, kerning, and
// baseline adjustments. In addition to rendering glyphs, PDF processors can use the data in
// OpenType fonts to do advanced line layout, automatically substitute ligatures, provide selections
// of alternative glyphs to users, and handle complex writing scripts.
// The process of finding glyph descriptions in OpenType fonts by a PDF processor shall be the following:
// • For Type 1 fonts using "CFF " tables, the process shall be as described in 9.6.5.2, "Encodings for
// Type 1 fonts"
// .
// • For TrueType fonts using "glyf" tables, the process shall be as described in 9.6.5.4, "Encodings for
// TrueType fonts". Since this process sometimes produces ambiguous results, PDF writers, instead
// of using a simple font, should use a Type 0 font with an Identity-H encoding and use the glyph
// indices as character codes, as described following "Table 116 — Predefined CJK CMap names"
// .
// • For CIDFontType0 fonts using "CFF " tables, the process shall be as described in the discussion of
// embedded Type 0 CIDFonts in 9.7.4.2, "Glyph selection in CIDFonts"
// .
// • For CIDFontType2 fonts using "glyf" tables, the process shall be as described in the discussion of
// embedded Type 2 CIDFonts in 9.7.4.2, "Glyph selection in CIDFonts"
// .
// 9.9.2 Font subsets
// PDF documents may include subsets of PDF fonts whose Subtype is Type1, TrueType or OpenType. The
// font and font descriptor that describe a font subset are slightly different from those of ordinary fonts.
// These differences allow a PDF processor to recognise font subsets and to merge documents containing
// different subsets of the same font. (For more information on font descriptors, see 9.8, "Font
// descriptors".)
// For a font subset, the PostScript name of the font, that is, the value of the font’s BaseFont entry and the
// font descriptor’s FontName entry, shall begin with a tag followed by a plus sign (+) followed by the
// PostScript name of the font from which the subset was created. The tag shall consist of exactly six
// uppercase letters; the choice of letters is arbitrary, but different subsets of the same font in the same
// PDF file shall have different tags. The glyph name .notdef shall be defined in the font subset.
// NOTE It is recommended that PDF processors treat multiple subset fonts as completely independent
// entities, even if they appear to have been created from the same original font.
// EXAMPLE EOODIA+Poetica is the name of a subset of Poetica®, a Type 1 font.
// 9.10 Extraction of text content
// 9.10.1 General
// The preceding subclauses describe all the facilities for showing text and causing glyphs to be painted
// on the page. In addition to rendering text, PDF processors often need to determine the information
// content of text — that is, its meaning according to some standard character identification as opposed
// to its rendered appearance. This need arises during operations such as searching, indexing, and
// © ISO 2020 – All rights reserved 355
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// exporting of text to other file formats.
// Unicode defines a system for numbering all of the common characters used in a large number of
// languages. It is a suitable scheme for representing the information content of text, but not its
// appearance, since Unicode values identify characters, not glyphs. For information about Unicode, see
// the Unicode Standard by the Unicode Consortium.
// When extracting character content, a PDF processor can easily convert text to Unicode values if a font’s
// characters are identified according to a standard character set that is known to the PDF processor. This
// character identification can occur if either the font uses a standard named encoding or the characters
// in the font are identified by standard character names or CIDs in a well-known collection. 9.10.2,
// "Mapping character codes to Unicode values", describes in detail the overall algorithm for mapping
// character codes to Unicode values.
// If a font is not defined in one of these ways, the glyphs can still be shown, but the characters cannot be
// converted to Unicode values without additional information using the following methods:
// • This information can be provided as an optional ToUnicode entry in the font dictionary (PDF 1.2;
// see 9.10.3, "ToUnicode CMaps"), whose value shall be a stream object containing a special kind of
// CMap file that maps character codes to Unicode values.
// • An ActualText entry for a structure element or marked-content sequence (see 14.9.4,
// "Replacement text") may be used to specify the text content directly.
// 9.10.2 Mapping character codes to Unicode values
// A PDF processor can use these methods, in the priority given, to map a character code to a Unicode
// value. Tagged PDF documents, in particular, shall provide at least one of these methods (see 14.8.2.6,
// "Unicode mapping in tagged PDF"):
// • If the font dictionary contains a ToUnicode CMap (see 9.10.3, "ToUnicode CMaps"), use that CMap
// to convert the character code to Unicode.
// • If the font is a simple font and the glyph selection algorithm (see 9.6.5, "Character encoding") uses
// a glyph name, that name can be looked up in the Adobe Glyph List and Adobe Glyph List for New
// Fonts to obtain the corresponding Unicode value.
// • If the font is a composite font that uses one of the predefined CMaps listed in "Table 116 —
// Predefined CJK CMap names" (except Identity–H and Identity–V) or whose descendant CIDFont
// uses the Adobe-GB1, Adobe-CNS1, Adobe-Japan1, Adobe-Korea1 (deprecated in PDF 2.0 (2020)) or
// Adobe-KR (added in PDF 2.0 (2020)) character collection:
// a. Map the character code to a character identifier (CID) according to the font’s CMap.
// b. Obtain the registry and ordering of the character collection used by the font’s CMap (for
// example, Adobe and Japan1) from its CIDSystemInfo dictionary.
// c. Construct a second CMap name by concatenating the registry and ordering obtained in step (b)
// in the format registry–ordering–UCS2 (for example, Adobe–Japan1–UCS2).
// d. Obtain the CMap with the name constructed in step (c) (available from a variety of online
// sources, e.g. https://github.com/adobe-type-tools/mapping-resources-pdf).
// e. Map the CID obtained in step (a) according to the CMap obtained in step (d), producing a
// Unicode value.
// Type 0 fonts whose descendant CIDFonts use the Adobe-GB1, Adobe-CNS1, Adobe-Japan1, Adobe-
// 356 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// Korea1 (deprecated in PDF 2.0 (2020)) or Adobe-KR (added in PDF 2.0 (2020)) character collection (as
// specified in the CIDSystemInfo dictionary) shall have a supplement number corresponding to the
// version of PDF supported by the PDF processor.
// If these methods fail to produce a Unicode value, there is no way to determine what the character code
// represents in which case a PDF processor may choose a character code of their choosing.
// 9.10.3 ToUnicode CMaps
// The CMap defined in the ToUnicode entry of the font dictionary shall follow the syntax for CMaps
// introduced in 9.7.5, "CMaps" and fully documented in Adobe Technical Note #5014, Adobe CMap and
// CIDFont Files Specification. This CMap differs from an ordinary one in these ways:
// • The only pertinent entry in the CMap stream dictionary (see "Table 118 — Additional entries in a
// CMap stream dictionary") is UseCMap, which may be used if the CMap is based on another
// ToUnicode CMap.
// • The CMap file shall contain begincodespacerange and endcodespacerange operators that are
// consistent with the encoding that the font uses. In particular, for a simple font, the codespace shall
// be one byte long.
// • It shall use the beginbfchar, endbfchar, beginbfrange, and endbfrange operators to define the
// mapping from character codes to Unicode character sequences expressed in UTF-16BE encoding.
// For simple fonts, character codes shall be written as 1 byte in the ToUnicode CMap.
// For CID keyed fonts character codes may have 1 byte, 2 bytes, or more than 2 bytes in the ToUnicode
// CMap.
// EXAMPLE 1 This example illustrates a Type 0 font that uses the Identity-H CMap to map from character codes to CIDs
// and whose descendant CIDFont uses the Identity mapping from CIDs to TrueType glyph indices. Text strings
// shown using this font simply use a 2-byte glyph index for each glyph. In the absence of a ToUnicode entry,
// no information would be available about what the glyphs mean.
// 14 0 obj
// <</Type /Font
//  Subtype /Type0
//  BaseFont /Ryumin-Light
//  Encoding /Identity-H
//  DescendantFonts [15 0 R]
//  ToUnicode 16 0 R
// >>
// endobj
// 15 0 obj
// <</Type /Font
//  Subtype /CIDFontType2
//  BaseFont /Ryumin-Light
//  CIDSystemInfo 17 0 R
//  FontDescriptor 18 0 R
//  CIDToGIDMap /Identity
// >>
// endobj
// EXAMPLE 2 In this example, the value of the ToUnicode entry is a stream object that contains the definition of the CMap.
// The begincodespacerange and endcodespacerange operators define the source character code range to
// be the 2-byte character codes from <00 00> to <FF FF>. The specific mappings for several of the character
// © ISO 2020 – All rights reserved 357
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// codes are shown.
// 16 0 obj
// <<
//  Type /CMap
//  CMapName /Adobe-Identity-UCS2
//  CIDSystemInfo << /Registry (Adobe) /Ordering (UCS2) /Supplement 0 >>
//  Length 433
// >>
// stream
//  CIDInit /ProcSet findresource begin
// 12 dict begin
// begincmap
//  CIDSystemInfo
// <</Registry (Adobe)
//  Ordering (UCS2)
//  Supplement 0
// >> def
//  CMapName /Adobe-Identity-UCS2 def
//  CMapType 2 def
// 1 begincodespacerange
// <0000> <FFFF>
// endcodespacerange
// 2 beginbfrange
// <0000> <005E> <0020>
// <005F> <0061> [<00660066> <00660069> <00660066006C>]
// endbfrange
// 1 beginbfchar
// <3A51> <D840DC3E>
// endbfchar
// endcmap
// CMapName currentdict /CMap defineresource pop
// end
// end
// endstream
// endobj
// <00 00> to <00 5E> are mapped to the Unicode values SPACE (U+0020) to TILDE (U+007E) This is followed
// by the definition of a mapping where each character code represents more than one Unicode value:
// <005F> <0061> [<00660066> <00660069> <00660066006C>]
// In this case, the original character codes are the glyph indices for the ligatures ff, fi, and ffl. The entry defines
// the mapping from the character codes <00 5F>, <00 60>, and <00 61> to the strings of Unicode values with
// a Unicode scalar value for each character in the ligature: LATIN SMALL LETTER F (U+0066) LATIN SMALL
// LETTER F (U+0066) are the Unicode values for the character sequence f f, LATIN SMALL LETTER F (U+0066)
// LATIN SMALL LETTER I (U+0069) for f i, and LATIN SMALL LETTER F (U+0066) LATIN SMALL LETTER F
// (U+0066) LATIN SMALL LETTER L (U+006c) for f f l.
// Finally, the character code <3A 51> is mapped to the Unicode value UNICODE HAN CHARACTER ‘U+2003E’
// (U+2003E), which is expressed by the byte sequence <D840DC3E> in UTF-16BE encoding.
// Example 2 in this subclause illustrates several extensions to the way destination values may be
// defined. To support mappings from a source code to a string of destination codes, this extension has
// been made to the ranges defined after a beginbfchar operator:
// n beginbfchar
// srcCode dstString
// endbfchar
// where dstString may be a string of up to 512 bytes. Likewise, mappings after the beginbfrange
// operator may be defined as:
// 358 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// n beginbfrange
// srcCode1 srcCode2 dstString
// endbfrange
// In this case, the last byte of the string shall be incremented for each consecutive code in the source
// code range.
// When defining ranges of this type, the value of the last byte in the string shall be less than or equal to
// 255 - (srcCode2 - srcCode1). This ensures that the last byte of the string shall not be incremented past
// 255; otherwise, the result of mapping is undefined.
// To support more compact representations of mappings from a range of source character codes to a
// discontiguous range of destination codes, the CMaps used for the ToUnicode entry may use this syntax
// for the mappings following a beginbfrange definition.
// n beginbfrange
// srcCode1 srcCode2 [dstString1 dstString2…dstStringm]
// endbfrange
// Consecutive codes starting with srcCode1 and ending with srcCode2 shall be mapped to the destination
// strings in the array starting with dstString1 and ending with dstStringm . The value of dstString can be
// a string of up to 512 bytes. The value of m represents the number of continuous character codes in the
// source character code range.
// 𝑚 = 𝑠𝑟𝑐𝐶𝑜𝑑𝑒2 − 𝑠𝑟𝑐𝐶𝑜𝑑𝑒1 + 1
// NOTE If number of dstString in array is different from m, the result of mapping is undefined.
