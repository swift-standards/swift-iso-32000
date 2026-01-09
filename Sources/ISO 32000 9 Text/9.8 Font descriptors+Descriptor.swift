// 9.8 Font descriptors - FontDescriptor type
//
// Per ISO 32000-2:2020, Section 9.8:
// > A font descriptor specifies metrics and other attributes of a simple font
// > or a CIDFont as a whole, as distinct from the metrics of individual glyphs.

public import ISO_14496_22
public import ISO_32000_7_Syntax
public import ISO_32000_Shared

extension ISO_32000.`9`.`8` {
    /// Font descriptor containing font-wide metrics and attributes.
    ///
    /// Per ISO 32000-2:2020, Table 121:
    /// > Entries common to all font descriptors
    ///
    /// A font descriptor is required for embedded fonts and contains
    /// information needed by PDF readers to properly render the font.
    public struct Descriptor: Sendable, Equatable {
        /// PostScript name of the font.
        ///
        /// Per ISO 32000-2:2020, Table 121:
        /// > (Required) The PostScript name of the font. This name shall be
        /// > the same as the value of BaseFont in the font or CIDFont dictionary
        /// > that refers to this font descriptor.
        public let fontName: ISO_32000.`7`.`3`.COS.Name

        /// Font descriptor flags.
        ///
        /// Per ISO 32000-2:2020, Table 121:
        /// > (Required) A collection of flags defining various characteristics
        /// > of the font (see 9.8.2, "Font descriptor flags").
        public let flags: Flags

        /// Font bounding box (in font design units).
        ///
        /// Per ISO 32000-2:2020, Table 121:
        /// > (Required, except for Type 3 fonts) A rectangle, expressed in the
        /// > glyph coordinate system, that shall specify the font bounding box.
        public let fontBBox: BoundingBox

        /// Italic angle in degrees counter-clockwise from vertical.
        ///
        /// Per ISO 32000-2:2020, Table 121:
        /// > (Required) The angle, expressed in degrees counter-clockwise from
        /// > the vertical, of the dominant vertical strokes of the font.
        public let italicAngle: Double

        /// Maximum height above the baseline.
        ///
        /// Per ISO 32000-2:2020, Table 121:
        /// > (Required, except for Type 3 fonts) The maximum height above the
        /// > baseline reached by glyphs in this font.
        public let ascent: ISO_32000.FontDesign.Height

        /// Maximum depth below the baseline (negative value).
        ///
        /// Per ISO 32000-2:2020, Table 121:
        /// > (Required, except for Type 3 fonts) The maximum depth below the
        /// > baseline reached by glyphs in this font. The value shall be a
        /// > negative number.
        public let descent: ISO_32000.FontDesign.Height

        /// Spacing between baselines of consecutive lines.
        ///
        /// Per ISO 32000-2:2020, Table 121:
        /// > (Optional) The spacing between baselines of consecutive lines of
        /// > text. Default value: 0.
        public let leading: ISO_32000.FontDesign.Height

        /// Vertical coordinate of the top of flat capital letters.
        ///
        /// Per ISO 32000-2:2020, Table 121:
        /// > (Required for fonts that have Latin characters, except for Type 3
        /// > fonts) The y coordinate of the top of flat capital letters.
        public let capHeight: ISO_32000.FontDesign.Height

        /// Vertical coordinate of the top of flat non-ascending lowercase letters.
        ///
        /// Per ISO 32000-2:2020, Table 121:
        /// > (Optional) The font's x height: the vertical coordinate of the top
        /// > of flat nonascending lowercase letters (like the letter x).
        public let xHeight: ISO_32000.FontDesign.Height

        /// Thickness of dominant vertical stems.
        ///
        /// Per ISO 32000-2:2020, Table 121:
        /// > (Required, except for Type 3 fonts) The thickness, measured
        /// > horizontally, of the dominant vertical stems of glyphs.
        public let stemV: ISO_32000.FontDesign.Width

        /// Thickness of dominant horizontal stems.
        ///
        /// Per ISO 32000-2:2020, Table 121:
        /// > (Optional) The thickness, measured vertically, of the dominant
        /// > horizontal stems of glyphs.
        public let stemH: ISO_32000.FontDesign.Width?

        /// Width to use for missing glyphs.
        ///
        /// Per ISO 32000-2:2020, Table 121:
        /// > (Optional) The width to use for character codes whose widths are
        /// > not specified in the font's Widths array.
        public let missingWidth: ISO_32000.FontDesign.Width

        /// Create a font descriptor with all properties.
        public init(
            fontName: ISO_32000.`7`.`3`.COS.Name,
            flags: Flags,
            fontBBox: BoundingBox,
            italicAngle: Double,
            ascent: ISO_32000.FontDesign.Height,
            descent: ISO_32000.FontDesign.Height,
            leading: ISO_32000.FontDesign.Height = .init(0),
            capHeight: ISO_32000.FontDesign.Height,
            xHeight: ISO_32000.FontDesign.Height,
            stemV: ISO_32000.FontDesign.Width,
            stemH: ISO_32000.FontDesign.Width? = nil,
            missingWidth: ISO_32000.FontDesign.Width = .init(0)
        ) {
            self.fontName = fontName
            self.flags = flags
            self.fontBBox = fontBBox
            self.italicAngle = italicAngle
            self.ascent = ascent
            self.descent = descent
            self.leading = leading
            self.capHeight = capHeight
            self.xHeight = xHeight
            self.stemV = stemV
            self.stemH = stemH
            self.missingWidth = missingWidth
        }
    }
}

// MARK: - Bounding Box

extension ISO_32000.`9`.`8`.Descriptor {
    /// Font bounding box in font design units.
    ///
    /// Per ISO 32000-2:2020, Section 7.9.5:
    /// > A rectangle shall be written as an array of four numbers giving the
    /// > coordinates of a pair of diagonally opposite corners.
    public struct BoundingBox: Sendable, Equatable {
        /// Lower-left x coordinate
        public let llx: Int
        /// Lower-left y coordinate
        public let lly: Int
        /// Upper-right x coordinate
        public let urx: Int
        /// Upper-right y coordinate
        public let ury: Int

        public init(llx: Int, lly: Int, urx: Int, ury: Int) {
            self.llx = llx
            self.lly = lly
            self.urx = urx
            self.ury = ury
        }
    }
}

// MARK: - Font Descriptor Flags

extension ISO_32000.`9`.`8`.Descriptor {
    /// Font descriptor flags.
    ///
    /// Per ISO 32000-2:2020, Table 122:
    /// > Meanings of font descriptor flags
    public struct Flags: OptionSet, Sendable, Equatable {
        public let rawValue: UInt32

        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// Bit 1: Fixed-width font.
        ///
        /// > All glyphs have the same width (as opposed to proportional fonts).
        public static let fixedPitch = Flags(rawValue: 1 << 0)

        /// Bit 2: Font contains serifs.
        ///
        /// > Glyphs have serifs (e.g., Times Roman).
        public static let serif = Flags(rawValue: 1 << 1)

        /// Bit 3: Font contains glyphs outside the Adobe standard Latin character set.
        ///
        /// > Font uses non-Latin character set (e.g., Symbol).
        public static let symbolic = Flags(rawValue: 1 << 2)

        /// Bit 4: Glyphs resemble cursive handwriting.
        ///
        /// > Font appears cursive/script-like.
        public static let script = Flags(rawValue: 1 << 3)

        /// Bit 6: Font uses the Adobe standard Latin character set.
        ///
        /// > Mutually exclusive with Symbolic flag.
        public static let nonsymbolic = Flags(rawValue: 1 << 5)

        /// Bit 7: Glyphs are italic or oblique.
        ///
        /// > Font contains italic or oblique glyphs.
        public static let italic = Flags(rawValue: 1 << 6)

        /// Bit 17: Font contains no lowercase letters.
        ///
        /// > Font is all-caps.
        public static let allCap = Flags(rawValue: 1 << 16)

        /// Bit 18: Font contains both uppercase and lowercase letters scaled to same size.
        ///
        /// > Font uses small caps.
        public static let smallCap = Flags(rawValue: 1 << 17)

        /// Bit 19: Bold glyphs shall be painted with extra pixels.
        ///
        /// > Used for very small text sizes to make bold more visible.
        public static let forceBold = Flags(rawValue: 1 << 18)
    }
}

// MARK: - FontDescriptor from FontFile

extension ISO_32000.`9`.`8`.Descriptor {
    /// Create a font descriptor from a parsed TrueType/OpenType font file.
    ///
    /// - Parameters:
    ///   - fontFile: The parsed font file
    ///   - fontName: The PostScript name (already sanitized for PDF)
    public init(
        fontFile: ISO_14496_22.FontFile,
        fontName: ISO_32000.`7`.`3`.COS.Name
    ) {
        // Determine flags
        var flags: Flags = []

        if fontFile.post.isFixedPitch {
            flags.insert(.fixedPitch)
        }

        // Most Latin fonts are nonsymbolic
        flags.insert(.nonsymbolic)

        // Check for italic from post table
        if fontFile.post.italicAngle != 0 {
            flags.insert(.italic)
        }

        // Scale factor: PDF uses 1000-unit glyph space, fonts use unitsPerEm
        let unitsPerEm = Int(fontFile.head.unitsPerEm)
        func scale(_ value: Int) -> Int {
            (value * 1000) / unitsPerEm
        }

        // Get bounding box from head table (scaled to 1000 units)
        let fontBBox = BoundingBox(
            llx: scale(Int(fontFile.head.xMin)),
            lly: scale(Int(fontFile.head.yMin)),
            urx: scale(Int(fontFile.head.xMax)),
            ury: scale(Int(fontFile.head.yMax))
        )

        // Get vertical metrics (scaled to 1000 units)
        let ascent = ISO_32000.FontDesign.Height(scale(Int(fontFile.hhea.ascender)))
        let descent = ISO_32000.FontDesign.Height(scale(Int(fontFile.hhea.descender)))
        let leading = ISO_32000.FontDesign.Height(scale(Int(fontFile.hhea.lineGap)))

        // Approximate cap height and x-height (ideally from OS/2 table)
        let capHeight = ascent
        let xHeight = ISO_32000.FontDesign.Height(ascent._rawValue * 2 / 3)

        // Estimate stemV (vertical stem width) - typically around 80-100 for regular weight
        // This is a rough approximation; accurate values require analyzing glyph outlines
        let stemV = ISO_32000.FontDesign.Width(80)

        // Default width for missing glyphs (scaled to 1000 units)
        let missingWidth = ISO_32000.FontDesign.Width(
            scale(Int(fontFile.hmtx.advanceWidth(for: 0)))
        )

        self.init(
            fontName: fontName,
            flags: flags,
            fontBBox: fontBBox,
            italicAngle: fontFile.post.italicAngle,
            ascent: ascent,
            descent: descent,
            leading: leading,
            capHeight: capHeight,
            xHeight: xHeight,
            stemV: stemV,
            missingWidth: missingWidth
        )
    }
}
