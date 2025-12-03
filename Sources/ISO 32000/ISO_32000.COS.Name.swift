// ISO_32000.COS.Name.swift

public import INCITS_4_1986

extension ISO_32000.COS {
    /// PDF Name object - a unique identifier
    ///
    /// Per ISO 32000-1 Section 7.3.5, a name is an atomic symbol uniquely
    /// defined by a sequence of characters. Names are case-sensitive.
    ///
    /// ## Constraints
    ///
    /// - Maximum length: 127 bytes (UTF-8 encoded)
    /// - Cannot contain null bytes (0x00)
    /// - Cannot contain whitespace characters
    ///
    /// ## Serialization
    ///
    /// Names are serialized with a leading solidus (/):
    /// - `/Type`
    /// - `/Page`
    ///
    /// Special characters are escaped as `#XX` where XX is the hex code.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let name = try ISO_32000.COS.Name("Type")
    /// // Serializes as: /Type
    /// ```
    public struct Name: Sendable, Hashable, Codable {
        /// The raw string value of the name
        public let rawValue: String

        /// Package-internal limits
        package enum Limits {
            /// Maximum name length in UTF-8 bytes (ISO 32000-1 Annex C)
            static let maxLength = 127
        }

        /// Creates a name without validation (internal use only)
        private init(__unchecked: Void, rawValue: String) {
            self.rawValue = rawValue
        }

        /// Creates a name with validation
        ///
        /// - Parameter rawValue: The name string (without leading /)
        /// - Throws: `Error` if validation fails
        public init(_ rawValue: String) throws(Error) {
            guard !rawValue.isEmpty else {
                throw .empty
            }

            guard rawValue.utf8.count <= Limits.maxLength else {
                throw .tooLong(rawValue.utf8.count)
            }

            for byte in rawValue.utf8 {
                if byte == 0x00 {
                    throw .containsNullByte
                }
                if byte.ascii.isWhitespace {
                    throw .containsWhitespace
                }
            }

            self.init(__unchecked: (), rawValue: rawValue)
        }
    }
}

// MARK: - Well-Known Names

extension ISO_32000.COS.Name {
    // Document structure
    public static let type = Self(__unchecked: (), rawValue: "Type")
    public static let catalog = Self(__unchecked: (), rawValue: "Catalog")
    public static let pages = Self(__unchecked: (), rawValue: "Pages")
    public static let page = Self(__unchecked: (), rawValue: "Page")
    public static let outlines = Self(__unchecked: (), rawValue: "Outlines")

    // Page attributes
    public static let parent = Self(__unchecked: (), rawValue: "Parent")
    public static let kids = Self(__unchecked: (), rawValue: "Kids")
    public static let count = Self(__unchecked: (), rawValue: "Count")
    public static let mediaBox = Self(__unchecked: (), rawValue: "MediaBox")
    public static let cropBox = Self(__unchecked: (), rawValue: "CropBox")
    public static let contents = Self(__unchecked: (), rawValue: "Contents")
    public static let resources = Self(__unchecked: (), rawValue: "Resources")
    public static let rotate = Self(__unchecked: (), rawValue: "Rotate")

    // Resources
    public static let font = Self(__unchecked: (), rawValue: "Font")
    public static let xObject = Self(__unchecked: (), rawValue: "XObject")
    public static let extGState = Self(__unchecked: (), rawValue: "ExtGState")
    public static let procSet = Self(__unchecked: (), rawValue: "ProcSet")

    // Font attributes
    public static let subtype = Self(__unchecked: (), rawValue: "Subtype")
    public static let type1 = Self(__unchecked: (), rawValue: "Type1")
    public static let trueType = Self(__unchecked: (), rawValue: "TrueType")
    public static let baseFont = Self(__unchecked: (), rawValue: "BaseFont")
    public static let encoding = Self(__unchecked: (), rawValue: "Encoding")
    public static let winAnsiEncoding = Self(__unchecked: (), rawValue: "WinAnsiEncoding")

    // Stream attributes
    public static let length = Self(__unchecked: (), rawValue: "Length")
    public static let filter = Self(__unchecked: (), rawValue: "Filter")
    public static let flateDecode = Self(__unchecked: (), rawValue: "FlateDecode")
    public static let decodeParms = Self(__unchecked: (), rawValue: "DecodeParms")

    // Standard 14 font names
    public static let helvetica = Self(__unchecked: (), rawValue: "Helvetica")
    public static let helveticaBold = Self(__unchecked: (), rawValue: "Helvetica-Bold")
    public static let helveticaOblique = Self(__unchecked: (), rawValue: "Helvetica-Oblique")
    public static let helveticaBoldOblique = Self(__unchecked: (), rawValue: "Helvetica-BoldOblique")
    public static let timesRoman = Self(__unchecked: (), rawValue: "Times-Roman")
    public static let timesBold = Self(__unchecked: (), rawValue: "Times-Bold")
    public static let timesItalic = Self(__unchecked: (), rawValue: "Times-Italic")
    public static let timesBoldItalic = Self(__unchecked: (), rawValue: "Times-BoldItalic")
    public static let courier = Self(__unchecked: (), rawValue: "Courier")
    public static let courierBold = Self(__unchecked: (), rawValue: "Courier-Bold")
    public static let courierOblique = Self(__unchecked: (), rawValue: "Courier-Oblique")
    public static let courierBoldOblique = Self(__unchecked: (), rawValue: "Courier-BoldOblique")
    public static let symbol = Self(__unchecked: (), rawValue: "Symbol")
    public static let zapfDingbats = Self(__unchecked: (), rawValue: "ZapfDingbats")

    // Procedure sets
    public static let pdf = Self(__unchecked: (), rawValue: "PDF")
    public static let text = Self(__unchecked: (), rawValue: "Text")
    public static let imageb = Self(__unchecked: (), rawValue: "ImageB")
    public static let imagec = Self(__unchecked: (), rawValue: "ImageC")
    public static let imagei = Self(__unchecked: (), rawValue: "ImageI")

    // Document info
    public static let title = Self(__unchecked: (), rawValue: "Title")
    public static let author = Self(__unchecked: (), rawValue: "Author")
    public static let subject = Self(__unchecked: (), rawValue: "Subject")
    public static let keywords = Self(__unchecked: (), rawValue: "Keywords")
    public static let creator = Self(__unchecked: (), rawValue: "Creator")
    public static let producer = Self(__unchecked: (), rawValue: "Producer")
    public static let creationDate = Self(__unchecked: (), rawValue: "CreationDate")
    public static let modDate = Self(__unchecked: (), rawValue: "ModDate")

    // Trailer
    public static let size = Self(__unchecked: (), rawValue: "Size")
    public static let root = Self(__unchecked: (), rawValue: "Root")
    public static let info = Self(__unchecked: (), rawValue: "Info")

    // Annotations
    public static let annots = Self(__unchecked: (), rawValue: "Annots")
    public static let annot = Self(__unchecked: (), rawValue: "Annot")
    public static let link = Self(__unchecked: (), rawValue: "Link")
    public static let rect = Self(__unchecked: (), rawValue: "Rect")
    public static let border = Self(__unchecked: (), rawValue: "Border")
    public static let a = Self(__unchecked: (), rawValue: "A")
    public static let s = Self(__unchecked: (), rawValue: "S")
    public static let uri = Self(__unchecked: (), rawValue: "URI")
}

// MARK: - Error

extension ISO_32000.COS.Name {
    public enum Error: Swift.Error, Sendable, Equatable {
        case empty
        case tooLong(_ byteCount: Int)
        case containsNullByte
        case containsWhitespace
    }
}

extension ISO_32000.COS.Name.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "Name cannot be empty"
        case .tooLong(let count):
            return "Name too long: \(count) bytes (max \(ISO_32000.COS.Name.Limits.maxLength))"
        case .containsNullByte:
            return "Name cannot contain null bytes"
        case .containsWhitespace:
            return "Name cannot contain whitespace"
        }
    }
}

// MARK: - CustomStringConvertible

extension ISO_32000.COS.Name: CustomStringConvertible {
    public var description: String {
        "/\(rawValue)"
    }
}
