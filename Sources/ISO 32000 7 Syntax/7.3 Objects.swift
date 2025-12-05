// ISO 32000-2:2020, 7.3 Objects
//
// Sections:
//   7.3.1  General
//   7.3.2  Boolean objects
//   7.3.3  Numeric objects
//   7.3.4  String objects
//   7.3.5  Name objects
//   7.3.6  Array objects
//   7.3.7  Dictionary objects
//   7.3.8  Stream objects
//   7.3.9  Null object
//   7.3.10 Indirect objects

public import ISO_32000_Shared
public import INCITS_4_1986
public import Standards
public import Formatting
import IEEE_754

extension ISO_32000.`7` {
    /// ISO 32000-2:2020, 7.3 Objects
    ///
    /// Per Section 7.3.1:
    /// > PDF includes nine basic types of objects: Boolean values, Integer and Real numbers,
    /// > Strings, Names, Arrays, Dictionaries, Streams, the null object, and Indirect objects.
    ///
    /// This namespace also provides the Carousel Object System (COS) API for working
    /// with these primitive types in a type-safe manner.
    public enum `3` {}
}

// MARK: - Table 3: Escape Sequences

extension ISO_32000.`7`.`3` {
    public enum Table {}
}

extension ISO_32000.`7`.`3`.Table {
    /// ISO 32000-2:2020, Table 3 — Escape sequences in literal strings
    public enum `3` {}
}

extension ISO_32000.`7`.`3`.Table.`3` {
    /// Escape table for literal strings (ISO 32000-2 Table 3)
    ///
    /// Per Section 7.3.4.2:
    /// > Within a literal string, the REVERSE SOLIDUS is used as an escape character.
    public static let escapeTable: [UInt8: [UInt8]] = [
        .ascii.lf: [.ascii.backslash, .ascii.n],     // \n
        .ascii.cr: [.ascii.backslash, .ascii.r],     // \r
        .ascii.htab: [.ascii.backslash, .ascii.t],   // \t
        .ascii.bs: [.ascii.backslash, .ascii.b],     // \b
        .ascii.ff: [.ascii.backslash, .ascii.f],     // \f
        .ascii.leftParenthesis: [.ascii.backslash, .ascii.leftParenthesis],   // \(
        .ascii.rightParenthesis: [.ascii.backslash, .ascii.rightParenthesis], // \)
        .ascii.backslash: [.ascii.backslash, .ascii.backslash],               // \\
    ]
}

// MARK: - 7.3.3 Numeric Objects

extension ISO_32000.`7`.`3` {
    /// ISO 32000-2:2020, 7.3.3 Numeric objects
    ///
    /// Per Section 7.3.3:
    /// > PDF provides two types of numeric objects: integer and real.
    /// > An integer shall be written as one or more decimal digits optionally
    /// > preceded by a sign. The value shall be interpreted as a signed decimal integer.
    /// > A real value shall be written as one or more decimal digits with an optional sign
    /// > and a leading, trailing, or embedded PERIOD (2Eh) (decimal point).
    public enum `3` {}
}

extension ISO_32000.`7`.`3`.`3` {
    /// PDF number format style
    ///
    /// Per ISO 32000-2:2020 Section 7.3.3:
    /// > An integer shall be written as one or more decimal digits optionally preceded by a sign.
    /// >
    /// > A real value shall be written as one or more decimal digits with an optional sign and a
    /// > leading, trailing, or embedded PERIOD (2Eh) (decimal point).
    /// >
    /// > Wherever a real number is expected, an integer may be used instead.
    /// > For example, it is not necessary to write the number 1.0 in real format;
    /// > the integer 1 is sufficient.
    /// >
    /// > A PDF writer shall not use the PostScript language syntax for numbers with
    /// > non-decimal radices (such as 16#FFFE) or in exponential format (such as 6.02E23).
    ///
    /// This format style outputs numbers following PDF syntax rules:
    /// - Integers output without decimal point (e.g., `42` not `42.0`)
    /// - Reals output with decimal point, trailing zeros stripped
    /// - **Never** uses exponential notation (e.g., `0.00001` not `1E-5`)
    /// - Maximum 5 decimal places (per Annex C portability recommendations)
    /// - No grouping separators
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let x: UserSpace.X = 72.5
    /// let formatted = x.formatted(.pdf)  // "72.5"
    ///
    /// let whole: Double = 42.0
    /// whole.formatted(.pdf)  // "42" (integer form)
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.3.3 — Numeric objects
    public struct RealFormatStyle: FormatStyle, Sendable {
        public typealias FormatInput = Double
        public typealias FormatOutput = String

        /// Maximum decimal places for real numbers (per Annex C recommendations)
        private static let maxDecimalPlaces = 5

        /// Multiplier for extracting fractional digits (10^maxDecimalPlaces)
        private static let multiplier: Double = 100_000

        public init() {}

        public func format(_ value: Double) -> String {
            // Handle special cases per IEEE 754 classification (Annex C references IEEE 754)
            guard IEEE_754.Classification.isFinite(value) else {
                // PDF doesn't support infinity/NaN - output 0 as fallback
                return "0"
            }

            // Check if value is effectively an integer
            // Per spec: "it is not necessary to write the number 1.0 in real format"
            let rounded = value.rounded()
            if value == rounded && abs(value) < Double(Int64.max) {
                return String(Int64(value))
            }

            // Format as real number without exponential notation
            // Per spec: "shall not use... exponential format (such as 6.02E23)"
            return formatReal(value)
        }

        /// Format a real number without exponential notation
        private func formatReal(_ value: Double) -> String {
            let isNegative = value < 0
            let absValue = abs(value)

            // Split into integer and fractional parts
            let intPart = Int64(absValue)
            let fracPart = absValue - Double(intPart)

            // Calculate fractional digits (up to maxDecimalPlaces)
            let fracDigits = Int64((fracPart * Self.multiplier).rounded())

            var result = isNegative ? "-" : ""
            result += String(intPart)

            if fracDigits != 0 {
                result += "."
                var fracStr = String(fracDigits)
                // Pad with leading zeros if needed
                while fracStr.count < Self.maxDecimalPlaces {
                    fracStr = "0" + fracStr
                }
                // Strip trailing zeros
                while fracStr.hasSuffix("0") {
                    fracStr.removeLast()
                }
                result += fracStr
            }

            return result
        }
    }
}

extension FormatStyle where Self == ISO_32000.`7`.`3`.`3`.RealFormatStyle {
    /// PDF number format style
    ///
    /// Formats numbers according to ISO 32000-2:2020 Section 7.3.3 (Numeric objects):
    /// - Integers output without decimal point
    /// - Never uses exponential notation
    /// - Maximum 5 decimal places, trailing zeros stripped
    public static var pdf: ISO_32000.`7`.`3`.`3`.RealFormatStyle {
        ISO_32000.`7`.`3`.`3`.RealFormatStyle()
    }
}

// MARK: - 7.3.5 Name Objects

extension ISO_32000.`7`.`3` {
    /// ISO 32000-2:2020, 7.3.5 Name objects
    public enum `5` {}
}

extension ISO_32000.`7`.`3`.`5` {
    /// PDF Name object - a unique identifier
    ///
    /// Per ISO 32000-2 Section 7.3.5:
    /// > A name object is an atomic symbol uniquely defined by a sequence of any
    /// > characters (8-bit values) except NULL (character code 0).
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
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.3.5 — Name objects
    public struct Name: Sendable, Hashable, Codable {
        /// The raw string value of the name
        public let rawValue: String

        /// Package-internal limits
        package enum Limits {
            /// Maximum name length in UTF-8 bytes (ISO 32000-2 Annex C)
            static let maxLength = 127
        }

        /// Creates a name without validation (internal use only)
        @usableFromInline
        init(__unchecked: Void, rawValue: String) {
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

// MARK: - Name Error

extension ISO_32000.`7`.`3`.`5`.Name {
    public enum Error: Swift.Error, Sendable, Equatable {
        case empty
        case tooLong(_ byteCount: Int)
        case containsNullByte
        case containsWhitespace
    }
}

extension ISO_32000.`7`.`3`.`5`.Name.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "Name cannot be empty"
        case .tooLong(let count):
            return "Name too long: \(count) bytes (max \(ISO_32000.`7`.`3`.`5`.Name.Limits.maxLength))"
        case .containsNullByte:
            return "Name cannot contain null bytes"
        case .containsWhitespace:
            return "Name cannot contain whitespace"
        }
    }
}

// MARK: - Name CustomStringConvertible

extension ISO_32000.`7`.`3`.`5`.Name: CustomStringConvertible {
    public var description: String {
        "/\(rawValue)"
    }
}

// MARK: - Well-Known Names

extension ISO_32000.`7`.`3`.`5`.Name {
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

    // Standard 14 font names (Table 111)
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

// MARK: - 7.3.8 Stream Objects

extension ISO_32000.`7`.`3` {
    /// ISO 32000-2:2020, 7.3.8 Stream objects
    public enum `8` {}
}

extension ISO_32000.`7`.`3`.`8` {
    /// PDF Stream object
    ///
    /// Per ISO 32000-2 Section 7.3.8:
    /// > A stream object, like a string object, is a sequence of bytes.
    /// > Furthermore, a stream may be of unlimited length, whereas a string
    /// > shall be subject to an implementation limit.
    ///
    /// Streams are used for page contents, images, embedded files, and other binary data.
    ///
    /// ## Serialization
    ///
    /// ```
    /// << /Length 44 >>
    /// stream
    /// BT /F1 12 Tf 100 700 Td (Hello World) Tj ET
    /// endstream
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.3.8 — Stream objects
    public struct Stream: Sendable, Hashable {
        /// Stream dictionary (contains /Length, /Filter, etc.)
        public var dictionary: ISO_32000.`7`.`3`.COS.Dictionary

        /// Raw stream data (may be compressed)
        public var data: [UInt8]

        /// Create a stream with dictionary and data
        public init(dictionary: ISO_32000.`7`.`3`.COS.Dictionary = [:], data: [UInt8] = []) {
            self.dictionary = dictionary
            self.data = data
        }

        /// Create a stream with just data (dictionary will have /Length set)
        public init(data: [UInt8]) {
            self.dictionary = [:]
            self.data = data
        }
    }
}

extension ISO_32000.`7`.`3`.`8`.Stream: CustomStringConvertible {
    public var description: String {
        "\(dictionary) stream<\(data.count) bytes>"
    }
}

// MARK: - 7.3.10 Indirect Objects

extension ISO_32000.`7`.`3` {
    /// ISO 32000-2:2020, 7.3.10 Indirect objects
    public enum `10` {}
}

extension ISO_32000.`7`.`3`.`10` {
    /// Indirect object reference
    ///
    /// Per ISO 32000-2 Section 7.3.10:
    /// > Any object in a PDF file may be labelled as an indirect object.
    /// > This gives the object a unique object identifier by which other
    /// > objects can refer to it.
    ///
    /// ## Serialization
    ///
    /// ```
    /// 12 0 R
    /// ```
    ///
    /// Where 12 is the object number and 0 is the generation number.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.3.10 — Indirect objects
    public struct IndirectReference: Sendable, Hashable, Codable {
        /// Object number (unique identifier within the PDF)
        public let objectNumber: Int

        /// Generation number (for incremental updates, usually 0)
        public let generation: Int

        /// Create a reference to an object
        public init(objectNumber: Int, generation: Int = 0) {
            self.objectNumber = objectNumber
            self.generation = generation
        }
    }
}

extension ISO_32000.`7`.`3`.`10`.IndirectReference: CustomStringConvertible {
    public var description: String {
        "\(objectNumber) \(generation) R"
    }
}

// MARK: - COS Namespace

extension ISO_32000.`7`.`3` {
    /// Carousel Object System (COS) - PDF's low-level object model
    ///
    /// COS defines the fundamental data types used in PDF files:
    /// - Boolean, Integer, Real, String, Name, Array, Dictionary, Stream
    /// - Null and Indirect References
    ///
    /// All PDF content is built from these primitive types.
    ///
    /// ## See Also
    ///
    /// - ISO 32000-2:2020 Section 7.3: Objects
    public enum CarouselObjectSystem {}
}

/// Typealiases for convenient COS access
extension ISO_32000.`7`.`3` {
    public typealias COS = CarouselObjectSystem
}

// MARK: - COS Type Aliases

extension ISO_32000.`7`.`3`.COS {
    /// Name object (Section 7.3.5)
    public typealias Name = ISO_32000.`7`.`3`.`5`.Name

    /// Stream object (Section 7.3.8)
    public typealias Stream = ISO_32000.`7`.`3`.`8`.Stream

    /// Indirect reference (Section 7.3.10)
    public typealias IndirectReference = ISO_32000.`7`.`3`.`10`.IndirectReference
}

// MARK: - COS Dictionary (7.3.7)

extension ISO_32000.`7`.`3`.COS {
    /// PDF Dictionary object
    ///
    /// Per ISO 32000-2 Section 7.3.7:
    /// > A dictionary object is an associative table containing pairs of
    /// > objects, known as the dictionary's entries.
    ///
    /// ## Serialization
    ///
    /// ```
    /// << /Type /Catalog /Pages 2 0 R >>
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.3.7 — Dictionary objects
    public struct Dictionary: Sendable, Hashable {
        public var storage: Swift.Dictionary<Name, Object>

        public init() {
            self.storage = [:]
        }

        public init(_ storage: Swift.Dictionary<Name, Object>) {
            self.storage = storage
        }

        public subscript(key: Name) -> Object? {
            get { storage[key] }
            set { storage[key] = newValue }
        }

        public var keys: Swift.Dictionary<Name, Object>.Keys {
            storage.keys
        }

        public var values: Swift.Dictionary<Name, Object>.Values {
            storage.values
        }

        public var count: Int {
            storage.count
        }

        public var isEmpty: Bool {
            storage.isEmpty
        }

        /// Iterate over entries in a consistent order (sorted by key)
        public var sortedEntries: [(key: Name, value: Object)] {
            storage.sorted { $0.key.rawValue < $1.key.rawValue }
        }
    }
}

extension ISO_32000.`7`.`3`.COS.Dictionary: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (ISO_32000.`7`.`3`.COS.Name, ISO_32000.`7`.`3`.COS.Object)...) {
        self.storage = .init(uniqueKeysWithValues: elements)
    }
}

// MARK: - COS Object

extension ISO_32000.`7`.`3`.COS {
    /// A PDF object (COS object)
    ///
    /// Per ISO 32000-2 Section 7.3, PDF supports these object types:
    /// - Boolean, Integer, Real (numeric)
    /// - String (literal or hexadecimal)
    /// - Name (symbolic identifier)
    /// - Array (ordered collection)
    /// - Dictionary (key-value mapping)
    /// - Stream (dictionary + binary data)
    /// - Null
    /// - Indirect Reference (pointer to another object)
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.3 — Objects
    public enum Object: Sendable, Hashable {
        /// Null object (Section 7.3.9)
        case null

        /// Boolean value (Section 7.3.2)
        case boolean(Bool)

        /// Integer value (Section 7.3.3)
        case integer(Int64)

        /// Real (floating-point) value (Section 7.3.3)
        case real(Double)

        /// PDF Name object (Section 7.3.5)
        case name(Name)

        /// PDF String object (Section 7.3.4)
        case string(StringValue)

        /// Array of objects (Section 7.3.6)
        case array([Object])

        /// Dictionary (name -> object mapping) (Section 7.3.7)
        case dictionary(Dictionary)

        /// Stream (dictionary + binary data) (Section 7.3.8)
        case stream(Stream)

        /// Indirect reference to another object (Section 7.3.10)
        case reference(IndirectReference)
    }
}

// MARK: - COS Object Convenience Initializers

extension ISO_32000.`7`.`3`.COS.Object {
    /// Create an integer object
    public static func integer(_ value: Int) -> Self {
        .integer(Int64(value))
    }

    /// Create a name object from a string
    public static func name(_ value: String) -> Self? {
        guard let name = try? ISO_32000.`7`.`3`.COS.Name(value) else { return nil }
        return .name(name)
    }

    /// Create a string object
    public static func string(_ value: String) -> Self {
        .string(ISO_32000.`7`.`3`.COS.StringValue(value))
    }
}

// MARK: - COS Object ExpressibleBy Protocols

extension ISO_32000.`7`.`3`.COS.Object: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .boolean(value)
    }
}

extension ISO_32000.`7`.`3`.COS.Object: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int64) {
        self = .integer(value)
    }
}

extension ISO_32000.`7`.`3`.COS.Object: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .real(value)
    }
}

extension ISO_32000.`7`.`3`.COS.Object: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: ISO_32000.`7`.`3`.COS.Object...) {
        self = .array(elements)
    }
}

// MARK: - COS StringValue (7.3.4)

extension ISO_32000.`7`.`3`.COS {
    /// PDF String object
    ///
    /// Per ISO 32000-2 Section 7.3.4, strings can be:
    /// - Literal strings: `(Hello World)`
    /// - Hexadecimal strings: `<48656C6C6F>`
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.3.4 — String objects
    public struct StringValue: Sendable, Hashable, Codable {
        /// The string content
        public let value: String

        /// Create a string value
        public init(_ value: String) {
            self.value = value
        }
    }
}

extension ISO_32000.`7`.`3`.COS.StringValue: CustomStringConvertible {
    public var description: String {
        "(\(value))"
    }
}

extension ISO_32000.`7`.`3`.COS.StringValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.value = value
    }
}

// MARK: - COS Serialization

extension ISO_32000.`7`.`3`.COS {
    /// Serialize a COS object to PDF syntax
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ object: Object,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        switch object {
        case .null:
            buffer.append(contentsOf: "null".utf8)

        case .boolean(true):
            buffer.append(contentsOf: "true".utf8)

        case .boolean(false):
            buffer.append(contentsOf: "false".utf8)

        case .integer(let value):
            buffer.append(contentsOf: Swift.String(value).utf8)

        case .real(let value):
            let formatted = formatReal(value)
            buffer.append(contentsOf: formatted.utf8)

        case .name(let name):
            Name.serialize(name, into: &buffer)

        case .string(let str):
            StringValue.serialize(str, into: &buffer)

        case .array(let elements):
            buffer.append(.ascii.leftBracket)
            for (i, element) in elements.enumerated() {
                if i > 0 {
                    buffer.append(.ascii.space)
                }
                serialize(element, into: &buffer)
            }
            buffer.append(.ascii.rightBracket)

        case .dictionary(let dict):
            Dictionary.serialize(dict, into: &buffer)

        case .stream(let stream):
            Stream.serialize(stream, into: &buffer)

        case .reference(let ref):
            buffer.append(contentsOf: "\(ref.objectNumber) \(ref.generation) R".utf8)
        }
    }

    /// Format a real number with appropriate precision
    ///
    /// Uses `ISO_32000.7.3.3.RealFormatStyle` for consistent PDF number formatting.
    private static func formatReal(_ value: Double) -> Swift.String {
        value.formatted(.pdf)
    }
}

// MARK: - UInt8.Serializable Conformances

extension ISO_32000.`7`.`3`.COS.Object: UInt8.Serializable {
    /// Serialize a COS object to PDF syntax
    ///
    /// Conforms to `UInt8.Serializable` for streaming output.
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ object: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        ISO_32000.`7`.`3`.COS.serialize(object, into: &buffer)
    }
}

extension ISO_32000.`7`.`3`.COS.Dictionary: UInt8.Serializable {
    /// Serialize a PDF Dictionary to bytes
    ///
    /// Format: `<< /Key1 Value1 /Key2 Value2 >>`
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ dict: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        buffer.append(.ascii.lessThan)
        buffer.append(.ascii.lessThan)

        for (key, value) in dict.sortedEntries {
            buffer.append(.ascii.space)
            ISO_32000.`7`.`3`.COS.Name.serialize(key, into: &buffer)
            buffer.append(.ascii.space)
            ISO_32000.`7`.`3`.COS.Object.serialize(value, into: &buffer)
        }

        buffer.append(.ascii.greaterThan)
        buffer.append(.ascii.greaterThan)
    }
}

extension ISO_32000.`7`.`3`.`5`.Name: UInt8.Serializable {
    /// Serialize a PDF Name to bytes
    ///
    /// Names are serialized with a leading solidus: `/Name`
    /// Special characters are escaped as `#XX`.
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ name: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        buffer.append(.ascii.solidus)

        for byte in name.rawValue.utf8 {
            if shouldEscapeNameByte(byte) {
                buffer.append(.ascii.numberSign)
                let hi = byte >> 4
                let lo = byte & 0x0F
                buffer.append(hexChar(hi))
                buffer.append(hexChar(lo))
            } else {
                buffer.append(byte)
            }
        }
    }

    /// Check if a byte needs escaping in a name
    private static func shouldEscapeNameByte(_ byte: UInt8) -> Bool {
        if !byte.ascii.isVisible { return true }
        if byte == .ascii.numberSign { return true }
        if byte == .ascii.leftParenthesis || byte == .ascii.rightParenthesis { return true }
        if byte == .ascii.lessThan || byte == .ascii.greaterThan { return true }
        if byte == .ascii.leftBracket || byte == .ascii.rightBracket { return true }
        if byte == .ascii.leftBrace || byte == .ascii.rightBrace { return true }
        if byte == .ascii.solidus { return true }
        if byte == .ascii.percentSign { return true }
        return false
    }

    /// Get hex character for a nibble
    private static func hexChar(_ nibble: UInt8) -> UInt8 {
        nibble < 10 ? .ascii.0 + nibble : .ascii.A + nibble - 10
    }
}

extension ISO_32000.`7`.`3`.COS.StringValue: UInt8.Serializable {
    /// Serialize a PDF String to bytes
    ///
    /// Strings are serialized as literal strings: `(Hello)`
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ str: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        buffer.append(.ascii.leftParenthesis)
        for byte in str.value.utf8 {
            if let escaped = ISO_32000.`7`.`3`.Table.`3`.escapeTable[byte] {
                buffer.append(contentsOf: escaped)
            } else {
                buffer.append(byte)
            }
        }
        buffer.append(.ascii.rightParenthesis)
    }
}

extension ISO_32000.`7`.`3`.`8`.Stream: UInt8.Serializable {
    /// Serialize a PDF Stream to bytes
    ///
    /// Format:
    /// ```
    /// << /Length N ... >>
    /// stream
    /// ...data...
    /// endstream
    /// ```
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ stream: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        var dict = stream.dictionary
        dict[.length] = .integer(Int64(stream.data.count))
        ISO_32000.`7`.`3`.COS.Dictionary.serialize(dict, into: &buffer)

        buffer.append(contentsOf: "\nstream\n".utf8)
        buffer.append(contentsOf: stream.data)
        buffer.append(contentsOf: "\nendstream".utf8)
    }
}

extension ISO_32000.`7`.`3`.`10`.IndirectReference: UInt8.Serializable {
    /// Serialize an indirect reference: `12 0 R`
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ ref: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        buffer.append(contentsOf: "\(ref.objectNumber) \(ref.generation) R".utf8)
    }
}
