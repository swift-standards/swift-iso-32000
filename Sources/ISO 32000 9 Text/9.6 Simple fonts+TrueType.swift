// 9.6 Simple fonts - TrueType integration
//
// Per ISO 32000-2:2020, Section 9.6.3:
// > PDF TrueType fonts are those with a Subtype value of TrueType in the font dictionary.
// > PDF fonts of this type shall support both the TrueType font format (see Apple Computer, Inc.,
// > TrueType Reference Manual) as well as the OpenType font format (as defined by ISO/IEC 14496-22).
//
// This file provides integration between ISO 14496-22 (Open Font Format) and ISO 32000 (PDF).

public import ISO_14496_22
public import ISO_32000_7_Syntax
public import ISO_32000_Shared

// MARK: - Embedded TrueType Font

extension ISO_32000.`9`.`6` {
    /// An embedded TrueType font parsed from font file data.
    ///
    /// Per ISO 32000-2:2020, Section 9.9.1 (Table 124):
    /// > FontFile2: (PDF 1.1) TrueType font program, as described in the TrueType Reference Manual.
    ///
    /// The font program shall include these tables: "glyf", "head", "hhea", "hmtx", "loca", and "maxp".
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let fontData: [UInt8] = ... // TrueType font bytes
    /// let embedded = try ISO_32000.Font.Embedded(data: fontData)
    /// let font = try ISO_32000.Font(embedded: embedded, resourceName: .init("F15"))
    /// let width = font.width(of: "Hello", atSize: .init(12))
    /// ```
    public struct Embedded: Sendable {
        /// The parsed font file
        public let fontFile: ISO_14496_22.FontFile

        /// The raw font file data (for embedding in PDF)
        public let data: [UInt8]

        /// PostScript name of the font (from name table)
        public let postScriptName: String

        /// PDF metrics derived from font tables
        public let metrics: ISO_32000.`9`.`8`.Metrics

        /// Whether this is a fixed-pitch (monospaced) font
        public let isMonospaced: Bool

        /// Create an embedded font from raw TrueType/OpenType data.
        ///
        /// - Parameter data: The raw font file bytes
        /// - Throws: `ISO_14496_22.FontFile.ParsingError` if the font cannot be parsed
        public init(data: [UInt8]) throws {
            let fontFile = try ISO_14496_22.FontFile(data: data)

            self.fontFile = fontFile
            self.data = data
            self.postScriptName = fontFile.postScriptName
            self.isMonospaced = fontFile.post.isFixedPitch
            self.metrics = ISO_32000.`9`.`8`.Metrics(fontFile: fontFile)
        }

        /// Create a font descriptor for this embedded font.
        ///
        /// - Parameter fontName: The sanitized PostScript name for PDF
        /// - Returns: A font descriptor suitable for PDF embedding
        public func descriptor(fontName: ISO_32000.`7`.`3`.COS.Name) -> ISO_32000.`9`.`8`.Descriptor {
            ISO_32000.`9`.`8`.Descriptor(fontFile: fontFile, fontName: fontName)
        }

        /// Create a subset of this font containing only the specified characters.
        ///
        /// Font subsetting significantly reduces PDF file size by including only
        /// the glyphs that are actually used. A typical font is 200KB+ but a subset
        /// with just ASCII characters might be 5-20KB.
        ///
        /// - Parameter characters: The characters to include in the subset
        /// - Returns: A new `Embedded` instance with subset font data
        /// - Throws: `ISO_14496_22.FontSubsetter.SubsetError` if subsetting fails
        ///
        /// ## Example
        ///
        /// ```swift
        /// let fontData: [UInt8] = ... // Full TrueType font (500KB)
        /// let embedded = try Embedded(data: fontData)
        /// let usedChars: Set<Character> = ["H", "e", "l", "o", " ", "W", "r", "d", "!"]
        /// let subset = try embedded.subsetted(for: usedChars)
        /// // subset.data is now ~5KB instead of 500KB
        /// ```
        public func subsetted(for characters: Set<Character>) throws -> Embedded {
            let subsetter = ISO_14496_22.FontSubsetter(fontFile: fontFile)
            let subsetData = try subsetter.subset(characters: characters)

            // Parse the subset font to get updated metrics
            return try Embedded(data: subsetData)
        }
    }
}

// MARK: - Metrics from FontFile

extension ISO_32000.`9`.`8`.Metrics {
    /// Create font metrics from a parsed TrueType/OpenType font file.
    ///
    /// Converts glyph widths from TrueType format (indexed by glyph ID) to PDF format
    /// (indexed by Unicode scalar value) using the font's cmap table.
    ///
    /// - Parameter fontFile: The parsed font file
    public init(fontFile: ISO_14496_22.FontFile) {
        // Build Unicode-to-width mapping using cmap
        var widths: [UInt32: Int] = [:]

        // Map each character in the cmap to its advance width
        for (codePoint, glyphIndex) in fontFile.cmap.unicodeMapping {
            let advanceWidth = fontFile.hmtx.advanceWidth(for: glyphIndex)
            widths[codePoint] = Int(advanceWidth)
        }

        // Get vertical metrics from hhea table
        let ascender = Int(fontFile.hhea.ascender)
        let descender = Int(fontFile.hhea.descender)
        let lineGap = Int(fontFile.hhea.lineGap)

        // Cap height and x-height are typically in the OS/2 table, but we can
        // approximate from ascender if not available
        // For now, use ascender as cap height approximation
        let capHeight = ascender
        let xHeight = ascender * 2 / 3  // Approximate x-height as 2/3 of ascender

        // Get default width (width of .notdef glyph at index 0)
        let defaultWidth = Int(fontFile.hmtx.advanceWidth(for: 0))

        // Get units per em from head table
        let unitsPerEm = Int(fontFile.head.unitsPerEm)

        self.init(
            widths: widths,
            defaultWidth: defaultWidth,
            ascender: ascender,
            descender: descender,
            capHeight: capHeight,
            xHeight: xHeight,
            leading: lineGap,
            unitsPerEm: unitsPerEm
        )
    }
}

// MARK: - PostScript Name Sanitization

extension ISO_32000.`9`.`6` {
    /// Sanitize a PostScript font name for use in PDF.
    ///
    /// Per ISO 32000-2:2020, Section 9.6.3:
    /// > If the PostScript language name of the instance contains SPACEs (20h),
    /// > the SPACEs shall be replaced by LOW LINEs (underscores) (5Fh)
    ///
    /// - Parameter name: The raw PostScript name from the font
    /// - Returns: Sanitized name suitable for PDF
    static func sanitizePostScriptName(_ name: String) -> String {
        var result = ""
        result.reserveCapacity(name.count)
        for char in name {
            if char == " " {
                result.append("_")
            } else {
                result.append(char)
            }
        }
        return result
    }
}

// MARK: - Font Factory for Embedded Fonts

extension ISO_32000.`9`.`6`.Font {
    /// Create a font from an embedded TrueType/OpenType font file.
    ///
    /// Per ISO 32000-2:2020, Section 9.6.3:
    /// > The value of Subtype shall be TrueType.
    ///
    /// - Parameters:
    ///   - embedded: The parsed embedded font
    ///   - resourceName: Resource name for this font in page resources (e.g., "F15")
    ///   - weight: Font weight (defaults to `.regular`)
    ///   - style: Font style (defaults to `.normal`)
    /// - Returns: A font instance configured for the embedded font
    /// - Throws: `ISO_32000.`7`.`3`.COS.Name.Error` if the PostScript name is invalid
    public init(
        embedded: ISO_32000.`9`.`6`.Embedded,
        resourceName: ISO_32000.`7`.`3`.COS.Name,
        weight: Weight = .regular,
        style: Style = .normal
    ) throws {
        // Sanitize PostScript name per ISO 32000-2:2020 Section 9.6.3
        let sanitizedName = ISO_32000.`9`.`6`.sanitizePostScriptName(embedded.postScriptName)

        self.init(
            baseFontName: try ISO_32000.`7`.`3`.COS.Name(sanitizedName),
            resourceName: resourceName,
            metrics: embedded.metrics,
            isMonospaced: embedded.isMonospaced,
            weight: weight,
            style: style,
            family: .custom,
            embeddedSource: embedded
        )
    }

    /// Create a font by parsing TrueType/OpenType data.
    ///
    /// This is a convenience initializer that parses the font data and creates
    /// an embedded font in one step.
    ///
    /// - Parameters:
    ///   - data: The raw TrueType/OpenType font bytes
    ///   - resourceName: Resource name for this font in page resources
    ///   - weight: Font weight (defaults to `.regular`)
    ///   - style: Font style (defaults to `.normal`)
    /// - Throws: Parsing errors if the font cannot be parsed, or name errors if invalid
    public init(
        data: [UInt8],
        resourceName: ISO_32000.`7`.`3`.COS.Name,
        weight: Weight = .regular,
        style: Style = .normal
    ) throws {
        let embedded = try ISO_32000.`9`.`6`.Embedded(data: data)
        try self.init(embedded: embedded, resourceName: resourceName, weight: weight, style: style)
    }
}

