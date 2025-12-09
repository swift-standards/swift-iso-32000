// UInt8+ISO_32000.swift
// ISO 32000-2:2020 Annex D - Byte-level encoding protocols and accessors
//
// Provides byte-level protocols and ergonomic accessors for PDF character encodings,
// following the pattern established in swift-incits-4-1986 for ASCII.
//
// ## Philosophy
//
// Types conforming to Serializable protocols treat [UInt8] as the canonical form.
// String operations are derived through composition:
//
// ```
// String → [UInt8] (encoding) → Type  (parsing)
// Type → [UInt8] (bytes) → String     (serialization)
// ```

public import ISO_32000_Shared

// MARK: - UInt8 Encoding Wrapper

extension UInt8 {
    /// WinAnsiEncoding byte constants and operations
    ///
    /// Provides ergonomic access to WinAnsiEncoding (Windows CP1252) byte values
    /// for common characters, especially those that differ from ASCII.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Access common byte constants
    /// UInt8.winAnsi.euro        // 0x80 (€)
    /// UInt8.winAnsi.bullet      // 0x95 (•)
    /// UInt8.winAnsi.trademark   // 0x99 (™)
    /// UInt8.winAnsi.emdash      // 0x97 (—)
    ///
    /// // Decode a byte to Unicode
    /// let byte: UInt8 = 0x80
    /// byte.winAnsi.decoded      // "€" (Unicode.Scalar)
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.2 — Latin character set and encodings (WIN column)
    @frozen
    public struct WinAnsi: Sendable {
        public let byte: UInt8

        @inlinable
        public init(_ byte: UInt8) {
            self.byte = byte
        }
    }

    /// Access WinAnsiEncoding operations for this byte
    @inlinable
    public var winAnsi: WinAnsi {
        WinAnsi(self)
    }
}

// MARK: - WinAnsi Serializable Protocol

extension UInt8.WinAnsi {
    /// Protocol for types with canonical WinAnsiEncoding byte-level transformations
    ///
    /// Types conforming to this protocol work at the byte level as the primitive form,
    /// with string operations derived through composition via WinAnsiEncoding.
    ///
    /// ## Category Theory
    ///
    /// This protocol models the relationship between structured types and byte sequences:
    /// - **Serialize**: `(T, Buffer) → Buffer` (buffer mutation, context-free)
    /// - **Parse**: `(Context, [UInt8]) → T` (may require context to interpret bytes)
    ///
    /// ## Usage
    ///
    /// ```swift
    /// struct PDFTextString: UInt8.WinAnsi.Serializable {
    ///     let rawValue: String
    ///
    ///     init<Bytes: Collection>(winAnsi bytes: Bytes, in context: Void) throws(Error) {
    ///         self.rawValue = ISO_32000.WinAnsiEncoding.decode(bytes)
    ///     }
    ///
    ///     static func serialize<Buffer: RangeReplaceableCollection>(
    ///         winAnsi value: Self,
    ///         into buffer: inout Buffer
    ///     ) where Buffer.Element == UInt8 {
    ///         if let bytes = ISO_32000.WinAnsiEncoding.encode(value.rawValue) {
    ///             buffer.append(contentsOf: bytes)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.2 — Latin character set and encodings (WIN column)
    public protocol Serializable: Sendable {
        /// The error type for parsing failures
        associatedtype Error: Swift.Error

        /// The context type required for parsing (default: Void)
        associatedtype Context: Sendable = Void

        /// Parse from canonical WinAnsiEncoding byte representation with context
        ///
        /// - Parameters:
        ///   - bytes: The WinAnsiEncoding byte representation
        ///   - context: Parsing context (use `()` for context-free types)
        /// - Throws: Self.Error if the bytes are malformed
        init<Bytes: Collection>(
            winAnsi bytes: Bytes,
            in context: Context
        ) throws(Error) where Bytes.Element == UInt8

        /// Serialize this value into a WinAnsiEncoding byte buffer
        ///
        /// - Parameters:
        ///   - serializable: The value to serialize
        ///   - buffer: The buffer to append bytes to
        static func serialize<Buffer: RangeReplaceableCollection>(
            winAnsi serializable: Self,
            into buffer: inout Buffer
        ) where Buffer.Element == UInt8
    }

    /// Protocol for WinAnsi types that need synthesized RawRepresentable conformance
    ///
    /// Use this protocol for struct types that need `rawValue` synthesized from
    /// their WinAnsi serialization.
    public protocol RawRepresentable: Serializable, Swift.RawRepresentable {}
}

// MARK: - WinAnsi Context-Free Convenience

extension UInt8.WinAnsi.Serializable where Context == Void {
    /// Parse from canonical WinAnsiEncoding byte representation (context-free)
    @inlinable
    public init<Bytes: Collection>(winAnsi bytes: Bytes) throws(Error) where Bytes.Element == UInt8 {
        try self.init(winAnsi: bytes, in: ())
    }
}

// MARK: - WinAnsi Conversion Convenience

extension Array where Element == UInt8 {
    /// Encode a string to WinAnsiEncoding bytes
    ///
    /// Returns `nil` if any character cannot be encoded.
    ///
    /// - Parameter string: The string to encode
    @inlinable
    public init?(winAnsi string: some StringProtocol) {
        self.init(string, encoding: ISO_32000.WinAnsiEncoding.self)
    }

    /// Encode a string to WinAnsiEncoding bytes with fallback
    ///
    /// Characters that cannot be encoded are replaced with `?` (0x3F).
    ///
    /// - Parameters:
    ///   - string: The string to encode
    ///   - withFallback: Must be `true` to use fallback mode
    @inlinable
    public init(winAnsi string: some StringProtocol, withFallback: Bool) {
        self.init(string, encoding: ISO_32000.WinAnsiEncoding.self, withFallback: withFallback)
    }
}

extension String {
    /// Decode WinAnsiEncoding bytes to a string
    ///
    /// Returns `nil` if any byte is undefined in WinAnsiEncoding.
    ///
    /// - Parameter bytes: The WinAnsiEncoding bytes to decode
    @inlinable
    public init?<Bytes: Collection>(winAnsi bytes: Bytes) where Bytes.Element == UInt8 {
        self.init(bytes, encoding: ISO_32000.WinAnsiEncoding.self)
    }

    /// Decode WinAnsiEncoding bytes to a string with replacement
    ///
    /// Undefined bytes are replaced with U+FFFD.
    ///
    /// - Parameters:
    ///   - bytes: The WinAnsiEncoding bytes to decode
    ///   - withReplacement: Must be `true` to use replacement mode
    @inlinable
    public init<Bytes: Collection>(winAnsi bytes: Bytes, withReplacement: Bool) where Bytes.Element == UInt8 {
        self.init(bytes, encoding: ISO_32000.WinAnsiEncoding.self, withReplacement: withReplacement)
    }
}

extension UInt8 {
    /// PDFDocEncoding byte constants and operations
    ///
    /// Provides ergonomic access to PDFDocEncoding byte values for text strings
    /// outside content streams.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Access byte constants (note: differs from WinAnsi!)
    /// UInt8.pdfDoc.euro         // 0xA0 (€) - different from WinAnsi!
    /// UInt8.pdfDoc.bullet       // 0x80 (•)
    ///
    /// // Decode a byte
    /// let byte: UInt8 = 0x80
    /// byte.pdfDoc.decoded       // "•" (Unicode.Scalar)
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.3 — PDFDocEncoding
    @frozen
    public struct PDFDoc: Sendable {
        public let byte: UInt8

        @inlinable
        public init(_ byte: UInt8) {
            self.byte = byte
        }
    }

    /// Access PDFDocEncoding operations for this byte
    @inlinable
    public var pdfDoc: PDFDoc {
        PDFDoc(self)
    }
}

// MARK: - PDFDoc Serializable Protocol

extension UInt8.PDFDoc {
    /// Protocol for types with canonical PDFDocEncoding byte-level transformations
    ///
    /// Types conforming to this protocol work at the byte level as the primitive form,
    /// with string operations derived through composition via PDFDocEncoding.
    ///
    /// PDFDocEncoding is used for text strings outside content streams, such as
    /// document info dictionary values, bookmarks, and annotations.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.3 — PDFDocEncoding
    public protocol Serializable: Sendable {
        associatedtype Error: Swift.Error
        associatedtype Context: Sendable = Void

        init<Bytes: Collection>(
            pdfDoc bytes: Bytes,
            in context: Context
        ) throws(Error) where Bytes.Element == UInt8

        static func serialize<Buffer: RangeReplaceableCollection>(
            pdfDoc serializable: Self,
            into buffer: inout Buffer
        ) where Buffer.Element == UInt8
    }

    public protocol RawRepresentable: Serializable, Swift.RawRepresentable {}
}

extension UInt8.PDFDoc.Serializable where Context == Void {
    @inlinable
    public init<Bytes: Collection>(pdfDoc bytes: Bytes) throws(Error) where Bytes.Element == UInt8 {
        try self.init(pdfDoc: bytes, in: ())
    }
}

// MARK: - PDFDoc Conversion Convenience

extension Array where Element == UInt8 {
    /// Encode a string to PDFDocEncoding bytes
    ///
    /// Returns `nil` if any character cannot be encoded.
    @inlinable
    public init?(pdfDoc string: some StringProtocol) {
        self.init(string, encoding: ISO_32000.PDFDocEncoding.self)
    }

    /// Encode a string to PDFDocEncoding bytes with fallback
    @inlinable
    public init(pdfDoc string: some StringProtocol, withFallback: Bool) {
        self.init(string, encoding: ISO_32000.PDFDocEncoding.self, withFallback: withFallback)
    }
}

extension String {
    /// Decode PDFDocEncoding bytes to a string
    @inlinable
    public init?<Bytes: Collection>(pdfDoc bytes: Bytes) where Bytes.Element == UInt8 {
        self.init(bytes, encoding: ISO_32000.PDFDocEncoding.self)
    }

    /// Decode PDFDocEncoding bytes to a string with replacement
    @inlinable
    public init<Bytes: Collection>(pdfDoc bytes: Bytes, withReplacement: Bool) where Bytes.Element == UInt8 {
        self.init(bytes, encoding: ISO_32000.PDFDocEncoding.self, withReplacement: withReplacement)
    }
}

extension UInt8 {
    /// StandardEncoding byte constants and operations
    ///
    /// Provides access to StandardEncoding (Type 1 font built-in encoding).
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.2 — Latin character set and encodings (STD column)
    @frozen
    public struct Standard: Sendable {
        public let byte: UInt8

        @inlinable
        public init(_ byte: UInt8) {
            self.byte = byte
        }
    }

    /// Access StandardEncoding operations for this byte
    @inlinable
    public var standard: Standard {
        Standard(self)
    }
}

// MARK: - Standard Serializable Protocol

extension UInt8.Standard {
    /// Protocol for types with canonical StandardEncoding byte-level transformations
    ///
    /// StandardEncoding is the built-in encoding for Type 1 Latin-text fonts.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.2 — Latin character set and encodings (STD column)
    public protocol Serializable: Sendable {
        associatedtype Error: Swift.Error
        associatedtype Context: Sendable = Void

        init<Bytes: Collection>(
            standard bytes: Bytes,
            in context: Context
        ) throws(Error) where Bytes.Element == UInt8

        static func serialize<Buffer: RangeReplaceableCollection>(
            standard serializable: Self,
            into buffer: inout Buffer
        ) where Buffer.Element == UInt8
    }

    public protocol RawRepresentable: Serializable, Swift.RawRepresentable {}
}

extension UInt8.Standard.Serializable where Context == Void {
    @inlinable
    public init<Bytes: Collection>(
        standard bytes: Bytes
    ) throws(Error) where Bytes.Element == UInt8 {
        try self.init(standard: bytes, in: ())
    }
}

// MARK: - Standard Conversion Convenience

extension Array where Element == UInt8 {
    /// Encode a string to StandardEncoding bytes
    @inlinable
    public init?(standard string: some StringProtocol) {
        self.init(string, encoding: ISO_32000.StandardEncoding.self)
    }

    /// Encode a string to StandardEncoding bytes with fallback
    @inlinable
    public init(standard string: some StringProtocol, withFallback: Bool) {
        self.init(string, encoding: ISO_32000.StandardEncoding.self, withFallback: withFallback)
    }
}

extension String {
    /// Decode StandardEncoding bytes to a string
    @inlinable
    public init?<Bytes: Collection>(standard bytes: Bytes) where Bytes.Element == UInt8 {
        self.init(bytes, encoding: ISO_32000.StandardEncoding.self)
    }

    /// Decode StandardEncoding bytes to a string with replacement
    @inlinable
    public init<Bytes: Collection>(standard bytes: Bytes, withReplacement: Bool) where Bytes.Element == UInt8 {
        self.init(bytes, encoding: ISO_32000.StandardEncoding.self, withReplacement: withReplacement)
    }
}

extension UInt8 {
    /// MacRomanEncoding byte constants and operations
    ///
    /// Provides access to MacRomanEncoding (Mac OS standard Latin encoding).
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.2 — Latin character set and encodings (MAC column)
    @frozen
    public struct MacRoman: Sendable {
        public let byte: UInt8

        @inlinable
        public init(_ byte: UInt8) {
            self.byte = byte
        }
    }

    /// Access MacRomanEncoding operations for this byte
    @inlinable
    public var macRoman: MacRoman {
        MacRoman(self)
    }
}

// MARK: - MacRoman Serializable Protocol

extension UInt8.MacRoman {
    /// Protocol for types with canonical MacRomanEncoding byte-level transformations
    ///
    /// MacRomanEncoding is the Mac OS standard Latin encoding.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.2 — Latin character set and encodings (MAC column)
    public protocol Serializable: Sendable {
        associatedtype Error: Swift.Error
        associatedtype Context: Sendable = Void

        init<Bytes: Collection>(
            macRoman bytes: Bytes,
            in context: Context
        ) throws(Error) where Bytes.Element == UInt8

        static func serialize<Buffer: RangeReplaceableCollection>(
            macRoman serializable: Self,
            into buffer: inout Buffer
        ) where Buffer.Element == UInt8
    }

    public protocol RawRepresentable: Serializable, Swift.RawRepresentable {}
}

extension UInt8.MacRoman.Serializable where Context == Void {
    @inlinable
    public init<Bytes: Collection>(macRoman bytes: Bytes) throws(Error) where Bytes.Element == UInt8 {
        try self.init(macRoman: bytes, in: ())
    }
}

// MARK: - MacRoman Conversion Convenience

extension Array where Element == UInt8 {
    /// Encode a string to MacRomanEncoding bytes
    @inlinable
    public init?(macRoman string: some StringProtocol) {
        self.init(string, encoding: ISO_32000.MacRomanEncoding.self)
    }

    /// Encode a string to MacRomanEncoding bytes with fallback
    @inlinable
    public init(macRoman string: some StringProtocol, withFallback: Bool) {
        self.init(string, encoding: ISO_32000.MacRomanEncoding.self, withFallback: withFallback)
    }
}

extension String {
    /// Decode MacRomanEncoding bytes to a string
    @inlinable
    public init?<Bytes: Collection>(macRoman bytes: Bytes) where Bytes.Element == UInt8 {
        self.init(bytes, encoding: ISO_32000.MacRomanEncoding.self)
    }

    /// Decode MacRomanEncoding bytes to a string with replacement
    @inlinable
    public init<Bytes: Collection>(macRoman bytes: Bytes, withReplacement: Bool) where Bytes.Element == UInt8 {
        self.init(bytes, encoding: ISO_32000.MacRomanEncoding.self, withReplacement: withReplacement)
    }
}

extension UInt8 {
    /// SymbolEncoding byte constants and operations
    ///
    /// Provides access to SymbolEncoding (Symbol font built-in encoding).
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.5 — Symbol set and encoding
    @frozen
    public struct Symbol: Sendable {
        public let byte: UInt8

        @inlinable
        public init(_ byte: UInt8) {
            self.byte = byte
        }
    }

    /// Access SymbolEncoding operations for this byte
    @inlinable
    public var symbol: Symbol {
        Symbol(self)
    }
}

// MARK: - Symbol Serializable Protocol

extension UInt8.Symbol {
    /// Protocol for types with canonical SymbolEncoding byte-level transformations
    ///
    /// SymbolEncoding is the built-in encoding for the Symbol font.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.5 — Symbol set and encoding
    public protocol Serializable: Sendable {
        associatedtype Error: Swift.Error
        associatedtype Context: Sendable = Void

        init<Bytes: Collection>(
            symbol bytes: Bytes,
            in context: Context
        ) throws(Error) where Bytes.Element == UInt8

        static func serialize<Buffer: RangeReplaceableCollection>(
            symbol serializable: Self,
            into buffer: inout Buffer
        ) where Buffer.Element == UInt8
    }

    public protocol RawRepresentable: Serializable, Swift.RawRepresentable {}
}

extension UInt8.Symbol.Serializable where Context == Void {
    @inlinable
    public init<Bytes: Collection>(symbol bytes: Bytes) throws(Error) where Bytes.Element == UInt8 {
        try self.init(symbol: bytes, in: ())
    }
}

// MARK: - Symbol Conversion Convenience

extension Array where Element == UInt8 {
    /// Encode a string to SymbolEncoding bytes
    @inlinable
    public init?(symbol string: some StringProtocol) {
        self.init(string, encoding: ISO_32000.SymbolEncoding.self)
    }

    /// Encode a string to SymbolEncoding bytes with fallback
    @inlinable
    public init(symbol string: some StringProtocol, withFallback: Bool) {
        self.init(string, encoding: ISO_32000.SymbolEncoding.self, withFallback: withFallback)
    }
}

extension String {
    /// Decode SymbolEncoding bytes to a string
    @inlinable
    public init?<Bytes: Collection>(symbol bytes: Bytes) where Bytes.Element == UInt8 {
        self.init(bytes, encoding: ISO_32000.SymbolEncoding.self)
    }

    /// Decode SymbolEncoding bytes to a string with replacement
    @inlinable
    public init<Bytes: Collection>(symbol bytes: Bytes, withReplacement: Bool) where Bytes.Element == UInt8 {
        self.init(bytes, encoding: ISO_32000.SymbolEncoding.self, withReplacement: withReplacement)
    }
}

extension UInt8 {
    /// ZapfDingbatsEncoding byte constants and operations
    ///
    /// Provides access to ZapfDingbatsEncoding (ZapfDingbats font encoding).
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.6 — ZapfDingbats set and encoding
    @frozen
    public struct ZapfDingbats: Sendable {
        public let byte: UInt8

        @inlinable
        public init(_ byte: UInt8) {
            self.byte = byte
        }
    }

    /// Access ZapfDingbatsEncoding operations for this byte
    @inlinable
    public var zapfDingbats: ZapfDingbats {
        ZapfDingbats(self)
    }
}

// MARK: - ZapfDingbats Serializable Protocol

extension UInt8.ZapfDingbats {
    /// Protocol for types with canonical ZapfDingbatsEncoding byte-level transformations
    ///
    /// ZapfDingbatsEncoding is the built-in encoding for the ZapfDingbats font.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.6 — ZapfDingbats set and encoding
    public protocol Serializable: Sendable {
        associatedtype Error: Swift.Error
        associatedtype Context: Sendable = Void

        init<Bytes: Collection>(
            zapfDingbats bytes: Bytes,
            in context: Context
        ) throws(Error) where Bytes.Element == UInt8

        static func serialize<Buffer: RangeReplaceableCollection>(
            zapfDingbats serializable: Self,
            into buffer: inout Buffer
        ) where Buffer.Element == UInt8
    }

    public protocol RawRepresentable: Serializable, Swift.RawRepresentable {}
}

extension UInt8.ZapfDingbats.Serializable where Context == Void {
    @inlinable
    public init<Bytes: Collection>(zapfDingbats bytes: Bytes) throws(Error) where Bytes.Element == UInt8 {
        try self.init(zapfDingbats: bytes, in: ())
    }
}

// MARK: - ZapfDingbats Conversion Convenience

extension Array where Element == UInt8 {
    /// Encode a string to ZapfDingbatsEncoding bytes
    @inlinable
    public init?(zapfDingbats string: some StringProtocol) {
        self.init(string, encoding: ISO_32000.ZapfDingbatsEncoding.self)
    }

    /// Encode a string to ZapfDingbatsEncoding bytes with fallback
    @inlinable
    public init(zapfDingbats string: some StringProtocol, withFallback: Bool) {
        self.init(string, encoding: ISO_32000.ZapfDingbatsEncoding.self, withFallback: withFallback)
    }
}

extension String {
    /// Decode ZapfDingbatsEncoding bytes to a string
    @inlinable
    public init?<Bytes: Collection>(zapfDingbats bytes: Bytes) where Bytes.Element == UInt8 {
        self.init(bytes, encoding: ISO_32000.ZapfDingbatsEncoding.self)
    }

    /// Decode ZapfDingbatsEncoding bytes to a string with replacement
    @inlinable
    public init<Bytes: Collection>(zapfDingbats bytes: Bytes, withReplacement: Bool) where Bytes.Element == UInt8 {
        self.init(bytes, encoding: ISO_32000.ZapfDingbatsEncoding.self, withReplacement: withReplacement)
    }
}

// MARK: - WinAnsi Instance Operations

extension UInt8.WinAnsi {
    /// Decode this byte to its Unicode scalar in WinAnsiEncoding
    @inlinable
    public var decoded: Unicode.Scalar? {
        ISO_32000.WinAnsiEncoding.decode(byte)
    }

    /// Check if this byte is defined in WinAnsiEncoding
    @inlinable
    public var isDefined: Bool {
        ISO_32000.WinAnsiEncoding.decode(byte) != nil
    }
}

// MARK: - WinAnsi Static Constants (PDF 1.3+ mappings)

extension UInt8.WinAnsi {
    // MARK: Extended Latin (0x80-0x9F) - PDF 1.3+

    /// EURO SIGN (0x80) - €
    /// Added in PDF 1.3
    public static let euro: UInt8 = 0x80

    /// SINGLE LOW-9 QUOTATION MARK (0x82) - ‚
    public static let quotesinglbase: UInt8 = 0x82

    /// LATIN SMALL LETTER F WITH HOOK (0x83) - ƒ
    public static let florin: UInt8 = 0x83

    /// DOUBLE LOW-9 QUOTATION MARK (0x84) - „
    public static let quotedblbase: UInt8 = 0x84

    /// HORIZONTAL ELLIPSIS (0x85) - …
    public static let ellipsis: UInt8 = 0x85

    /// DAGGER (0x86) - †
    public static let dagger: UInt8 = 0x86

    /// DOUBLE DAGGER (0x87) - ‡
    public static let daggerdbl: UInt8 = 0x87

    /// MODIFIER LETTER CIRCUMFLEX ACCENT (0x88) - ˆ
    public static let circumflex: UInt8 = 0x88

    /// PER MILLE SIGN (0x89) - ‰
    public static let perthousand: UInt8 = 0x89

    /// LATIN CAPITAL LETTER S WITH CARON (0x8A) - Š
    public static let Scaron: UInt8 = 0x8A

    /// SINGLE LEFT-POINTING ANGLE QUOTATION MARK (0x8B) - ‹
    public static let guilsinglleft: UInt8 = 0x8B

    /// LATIN CAPITAL LIGATURE OE (0x8C) - Œ
    public static let OE: UInt8 = 0x8C

    /// LATIN CAPITAL LETTER Z WITH CARON (0x8E) - Ž
    /// Added in PDF 1.3
    public static let Zcaron: UInt8 = 0x8E

    /// LEFT SINGLE QUOTATION MARK (0x91) - '
    public static let quoteleft: UInt8 = 0x91

    /// RIGHT SINGLE QUOTATION MARK (0x92) - '
    public static let quoteright: UInt8 = 0x92

    /// LEFT DOUBLE QUOTATION MARK (0x93) - "
    public static let quotedblleft: UInt8 = 0x93

    /// RIGHT DOUBLE QUOTATION MARK (0x94) - "
    public static let quotedblright: UInt8 = 0x94

    /// BULLET (0x95) - •
    /// Note: PDF spec uses BULLET (U+2022), not MIDDLE DOT
    public static let bullet: UInt8 = 0x95

    /// EN DASH (0x96) - –
    public static let endash: UInt8 = 0x96

    /// EM DASH (0x97) - —
    public static let emdash: UInt8 = 0x97

    /// SMALL TILDE (0x98) - ˜
    public static let tilde: UInt8 = 0x98

    /// TRADE MARK SIGN (0x99) - ™
    public static let trademark: UInt8 = 0x99

    /// LATIN SMALL LETTER S WITH CARON (0x9A) - š
    public static let scaron: UInt8 = 0x9A

    /// SINGLE RIGHT-POINTING ANGLE QUOTATION MARK (0x9B) - ›
    public static let guilsinglright: UInt8 = 0x9B

    /// LATIN SMALL LIGATURE OE (0x9C) - œ
    public static let oe: UInt8 = 0x9C

    /// LATIN SMALL LETTER Z WITH CARON (0x9E) - ž
    /// Added in PDF 1.3
    public static let zcaron: UInt8 = 0x9E

    /// LATIN CAPITAL LETTER Y WITH DIAERESIS (0x9F) - Ÿ
    public static let Ydieresis: UInt8 = 0x9F

    // MARK: Latin-1 Supplement (0xA0-0xFF)

    /// NO-BREAK SPACE (0xA0)
    public static let nbsp: UInt8 = 0xA0

    /// INVERTED EXCLAMATION MARK (0xA1) - ¡
    public static let exclamdown: UInt8 = 0xA1

    /// CENT SIGN (0xA2) - ¢
    public static let cent: UInt8 = 0xA2

    /// POUND SIGN (0xA3) - £
    public static let sterling: UInt8 = 0xA3

    /// CURRENCY SIGN (0xA4) - ¤
    public static let currency: UInt8 = 0xA4

    /// YEN SIGN (0xA5) - ¥
    public static let yen: UInt8 = 0xA5

    /// SECTION SIGN (0xA7) - §
    public static let section: UInt8 = 0xA7

    /// COPYRIGHT SIGN (0xA9) - ©
    public static let copyright: UInt8 = 0xA9

    /// LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (0xAB) - «
    public static let guillemotleft: UInt8 = 0xAB

    /// REGISTERED SIGN (0xAE) - ®
    public static let registered: UInt8 = 0xAE

    /// DEGREE SIGN (0xB0) - °
    public static let degree: UInt8 = 0xB0

    /// PLUS-MINUS SIGN (0xB1) - ±
    public static let plusminus: UInt8 = 0xB1

    /// PILCROW SIGN (0xB6) - ¶
    public static let paragraph: UInt8 = 0xB6

    /// MIDDLE DOT (0xB7) - ·
    public static let periodcentered: UInt8 = 0xB7

    /// RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (0xBB) - »
    public static let guillemotright: UInt8 = 0xBB

    /// VULGAR FRACTION ONE QUARTER (0xBC) - ¼
    public static let onequarter: UInt8 = 0xBC

    /// VULGAR FRACTION ONE HALF (0xBD) - ½
    public static let onehalf: UInt8 = 0xBD

    /// VULGAR FRACTION THREE QUARTERS (0xBE) - ¾
    public static let threequarters: UInt8 = 0xBE

    /// INVERTED QUESTION MARK (0xBF) - ¿
    public static let questiondown: UInt8 = 0xBF

    /// MULTIPLICATION SIGN (0xD7) - ×
    public static let multiply: UInt8 = 0xD7

    /// DIVISION SIGN (0xF7) - ÷
    public static let divide: UInt8 = 0xF7
}

// MARK: - PDFDoc Instance Operations

extension UInt8.PDFDoc {
    /// Decode this byte to its Unicode scalar in PDFDocEncoding
    @inlinable
    public var decoded: Unicode.Scalar? {
        ISO_32000.PDFDocEncoding.decode(byte)
    }

    /// Check if this byte is defined in PDFDocEncoding
    @inlinable
    public var isDefined: Bool {
        ISO_32000.PDFDocEncoding.decode(byte) != nil
    }
}

// MARK: - PDFDoc Static Constants

extension UInt8.PDFDoc {
    // MARK: Diacritical Marks (0x18-0x1F) - Unique to PDFDocEncoding

    /// BREVE (0x18) - ˘
    public static let breve: UInt8 = 0x18

    /// CARON (0x19) - ˇ
    public static let caron: UInt8 = 0x19

    /// MODIFIER LETTER CIRCUMFLEX ACCENT (0x1A) - ˆ
    public static let circumflex: UInt8 = 0x1A

    /// DOT ABOVE (0x1B) - ˙
    public static let dotaccent: UInt8 = 0x1B

    /// DOUBLE ACUTE ACCENT (0x1C) - ˝
    public static let hungarumlaut: UInt8 = 0x1C

    /// OGONEK (0x1D) - ˛
    public static let ogonek: UInt8 = 0x1D

    /// RING ABOVE (0x1E) - ˚
    public static let ring: UInt8 = 0x1E

    /// SMALL TILDE (0x1F) - ˜
    public static let tilde: UInt8 = 0x1F

    // MARK: 0x80-0x9F range (differs from WinAnsi!)

    /// BULLET (0x80) - •
    /// Note: In PDFDocEncoding, bullet is at 0x80 (same byte as Euro in WinAnsi!)
    public static let bullet: UInt8 = 0x80

    /// DAGGER (0x81) - †
    public static let dagger: UInt8 = 0x81

    /// DOUBLE DAGGER (0x82) - ‡
    public static let daggerdbl: UInt8 = 0x82

    /// HORIZONTAL ELLIPSIS (0x83) - …
    public static let ellipsis: UInt8 = 0x83

    /// EM DASH (0x84) - —
    public static let emdash: UInt8 = 0x84

    /// EN DASH (0x85) - –
    public static let endash: UInt8 = 0x85

    /// LATIN SMALL LETTER F WITH HOOK (0x86) - ƒ
    public static let florin: UInt8 = 0x86

    /// FRACTION SLASH (0x87) - ⁄
    public static let fraction: UInt8 = 0x87

    /// SINGLE LEFT-POINTING ANGLE QUOTATION MARK (0x88) - ‹
    public static let guilsinglleft: UInt8 = 0x88

    /// SINGLE RIGHT-POINTING ANGLE QUOTATION MARK (0x89) - ›
    public static let guilsinglright: UInt8 = 0x89

    /// MINUS SIGN (0x8A) - −
    public static let minus: UInt8 = 0x8A

    /// PER MILLE SIGN (0x8B) - ‰
    public static let perthousand: UInt8 = 0x8B

    /// SINGLE LOW-9 QUOTATION MARK (0x8C) - ‚
    public static let quotesinglbase: UInt8 = 0x8C

    /// DOUBLE LOW-9 QUOTATION MARK (0x8D) - „
    public static let quotedblbase: UInt8 = 0x8D

    /// LEFT DOUBLE QUOTATION MARK (0x8E) - "
    public static let quotedblleft: UInt8 = 0x8E

    /// RIGHT DOUBLE QUOTATION MARK (0x8F) - "
    public static let quotedblright: UInt8 = 0x8F

    /// LEFT SINGLE QUOTATION MARK (0x90) - '
    public static let quoteleft: UInt8 = 0x90

    /// RIGHT SINGLE QUOTATION MARK (0x91) - '
    public static let quoteright: UInt8 = 0x91

    /// TRADE MARK SIGN (0x95) - ™
    public static let trademark: UInt8 = 0x95

    /// LATIN SMALL LIGATURE FI (0x96) - fi
    public static let fi: UInt8 = 0x96

    /// LATIN SMALL LIGATURE FL (0x97) - fl
    public static let fl: UInt8 = 0x97

    /// LATIN CAPITAL LIGATURE OE (0x9A) - Œ
    public static let OE: UInt8 = 0x9A

    /// LATIN CAPITAL LETTER S WITH CARON (0x9B) - Š
    public static let Scaron: UInt8 = 0x9B

    /// LATIN CAPITAL LETTER Y WITH DIAERESIS (0x9C) - Ÿ
    public static let Ydieresis: UInt8 = 0x9C

    /// LATIN SMALL LIGATURE OE (0x9E) - œ
    public static let oe: UInt8 = 0x9E

    /// LATIN SMALL LETTER S WITH CARON (0x9F) - š
    public static let scaron: UInt8 = 0x9F

    // MARK: 0xA0 - Euro (key difference from WinAnsi!)

    /// EURO SIGN (0xA0) - €
    /// Note: In PDFDocEncoding, Euro is at 0xA0 (WinAnsi has NBSP here!)
    public static let euro: UInt8 = 0xA0
}

// MARK: - Standard Instance Operations

extension UInt8.Standard {
    /// Decode this byte to its Unicode scalar in StandardEncoding
    @inlinable
    public var decoded: Unicode.Scalar? {
        ISO_32000.StandardEncoding.decode(byte)
    }

    /// Check if this byte is defined in StandardEncoding
    @inlinable
    public var isDefined: Bool {
        ISO_32000.StandardEncoding.decode(byte) != nil
    }
}

// MARK: - Standard Static Constants

extension UInt8.Standard {
    // Key differences from ASCII

    /// RIGHT SINGLE QUOTATION MARK (0x27) - '
    /// Note: StandardEncoding maps 0x27 to ' (U+2019), not ASCII apostrophe!
    public static let quoteright: UInt8 = 0x27

    /// LEFT SINGLE QUOTATION MARK (0x60) - '
    /// Note: StandardEncoding maps 0x60 to ' (U+2018), not ASCII grave!
    public static let quoteleft: UInt8 = 0x60

    // Ligatures and special characters

    /// LATIN SMALL LIGATURE FI (0xAE) - fi
    public static let fi: UInt8 = 0xAE

    /// LATIN SMALL LIGATURE FL (0xAF) - fl
    public static let fl: UInt8 = 0xAF

    /// FRACTION SLASH (0xA4) - ⁄
    public static let fraction: UInt8 = 0xA4

    /// EM DASH (0xD0) - —
    public static let emdash: UInt8 = 0xD0

    /// EN DASH (0xB1) - –
    public static let endash: UInt8 = 0xB1
}

// MARK: - MacRoman Instance Operations

extension UInt8.MacRoman {
    /// Decode this byte to its Unicode scalar in MacRomanEncoding
    @inlinable
    public var decoded: Unicode.Scalar? {
        ISO_32000.MacRomanEncoding.decode(byte)
    }

    /// Check if this byte is defined in MacRomanEncoding
    @inlinable
    public var isDefined: Bool {
        ISO_32000.MacRomanEncoding.decode(byte) != nil
    }
}

// MARK: - MacRoman Static Constants

extension UInt8.MacRoman {
    /// CURRENCY SIGN (0xDB) - ¤
    /// Note: PDF maintains original Mac Roman mapping, NOT Apple's later Euro
    public static let currency: UInt8 = 0xDB

    /// NO-BREAK SPACE (0xCA)
    public static let nbsp: UInt8 = 0xCA

    /// LATIN SMALL LIGATURE FI (0xDE) - fi
    public static let fi: UInt8 = 0xDE

    /// LATIN SMALL LIGATURE FL (0xDF) - fl
    public static let fl: UInt8 = 0xDF
}

// MARK: - Symbol Instance Operations

extension UInt8.Symbol {
    /// Decode this byte to its Unicode scalar in SymbolEncoding
    @inlinable
    public var decoded: Unicode.Scalar? {
        ISO_32000.SymbolEncoding.decode(byte)
    }

    /// Check if this byte is defined in SymbolEncoding
    @inlinable
    public var isDefined: Bool {
        ISO_32000.SymbolEncoding.decode(byte) != nil
    }
}

// MARK: - Symbol Static Constants

extension UInt8.Symbol {
    // Greek uppercase
    /// GREEK CAPITAL LETTER ALPHA (0x41) - Α
    public static let Alpha: UInt8 = 0x41
    /// GREEK CAPITAL LETTER BETA (0x42) - Β
    public static let Beta: UInt8 = 0x42
    /// GREEK CAPITAL LETTER GAMMA (0x47) - Γ
    public static let Gamma: UInt8 = 0x47
    /// GREEK CAPITAL LETTER DELTA (0x44) - Δ
    public static let Delta: UInt8 = 0x44
    /// GREEK CAPITAL LETTER OMEGA (0x57) - Ω
    public static let Omega: UInt8 = 0x57

    // Greek lowercase
    /// GREEK SMALL LETTER ALPHA (0x61) - α
    public static let alpha: UInt8 = 0x61
    /// GREEK SMALL LETTER BETA (0x62) - β
    public static let beta: UInt8 = 0x62
    /// GREEK SMALL LETTER GAMMA (0x67) - γ
    public static let gamma: UInt8 = 0x67
    /// GREEK SMALL LETTER DELTA (0x64) - δ
    public static let delta: UInt8 = 0x64
    /// GREEK SMALL LETTER PI (0x70) - π
    public static let pi: UInt8 = 0x70
    /// GREEK SMALL LETTER OMEGA (0x77) - ω
    public static let omega: UInt8 = 0x77

    // Mathematical symbols
    /// INFINITY (0xA5) - ∞
    public static let infinity: UInt8 = 0xA5
    /// PLUS-MINUS SIGN (0xB1) - ±
    public static let plusminus: UInt8 = 0xB1
    /// MULTIPLICATION SIGN (0xB4) - ×
    public static let multiply: UInt8 = 0xB4
    /// DIVISION SIGN (0xB8) - ÷
    public static let divide: UInt8 = 0xB8
    /// NOT EQUAL TO (0xB9) - ≠
    public static let notequal: UInt8 = 0xB9
    /// LESS-THAN OR EQUAL TO (0xA3) - ≤
    public static let lessequal: UInt8 = 0xA3
    /// GREATER-THAN OR EQUAL TO (0xB3) - ≥
    public static let greaterequal: UInt8 = 0xB3

    // Set theory
    /// INTERSECTION (0xC7) - ∩
    public static let intersection: UInt8 = 0xC7
    /// UNION (0xC8) - ∪
    public static let union: UInt8 = 0xC8
    /// ELEMENT OF (0xCE) - ∈
    public static let element: UInt8 = 0xCE
    /// NOT AN ELEMENT OF (0xCF) - ∉
    public static let notelement: UInt8 = 0xCF
}

// MARK: - ZapfDingbats Instance Operations

extension UInt8.ZapfDingbats {
    /// Decode this byte to its Unicode scalar in ZapfDingbatsEncoding
    @inlinable
    public var decoded: Unicode.Scalar? {
        ISO_32000.ZapfDingbatsEncoding.decode(byte)
    }

    /// Check if this byte is defined in ZapfDingbatsEncoding
    @inlinable
    public var isDefined: Bool {
        ISO_32000.ZapfDingbatsEncoding.decode(byte) != nil
    }
}

// MARK: - ZapfDingbats Static Constants

extension UInt8.ZapfDingbats {
    // Common symbols
    /// UPPER BLADE SCISSORS (0x21) - ✁
    public static let scissors: UInt8 = 0x21
    /// WRITING HAND (0x2A) - ✍
    public static let writingHand: UInt8 = 0x2A
    /// CHECK MARK (0x33) - ✓
    public static let checkmark: UInt8 = 0x33
    /// BALLOT X (0x37) - ✗
    public static let ballotX: UInt8 = 0x37
    /// BLACK STAR (0x48) - ★
    public static let blackStar: UInt8 = 0x48
    /// WHITE STAR (0x49) - ☆
    public static let whiteStar: UInt8 = 0x49

    // Playing card suits
    /// BLACK CLUB SUIT (0xAB) - ♣
    public static let club: UInt8 = 0xAB
    /// BLACK DIAMOND SUIT (0xAC) - ♦
    public static let diamond: UInt8 = 0xAC
    /// BLACK HEART SUIT (0xAD) - ♥
    public static let heart: UInt8 = 0xAD
    /// BLACK SPADE SUIT (0xAE) - ♠
    public static let spade: UInt8 = 0xAE

    // Arrows
    /// HEAVY WIDE-HEADED RIGHTWARDS ARROW (0xD5) - ➔
    public static let arrowRight: UInt8 = 0xD5
}
