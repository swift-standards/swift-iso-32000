// ISO_32000.Encoding.swift
// ISO 32000-2:2020 Annex D - Character sets and encodings
//
// This file defines the PDFEncoding protocol and common types for PDF character encodings.
// Per ISO 32000-2 Section D.1, these encodings shall be predefined in any PDF processor.

public import ISO_32000_Shared

// MARK: - Encoding Protocol

extension ISO_32000 {
    /// PDF Character Encoding Protocol
    ///
    /// Per ISO 32000-2 Annex D.1, these encodings shall be predefined in any PDF processor.
    /// Encodings define the mapping between single-byte character codes (0-255) and
    /// Unicode scalar values.
    ///
    /// ## Predefined Encodings
    ///
    /// | Encoding | Description |
    /// |----------|-------------|
    /// | StandardEncoding | Built-in encoding for Type 1 Latin-text fonts |
    /// | MacRomanEncoding | Mac OS standard Latin encoding |
    /// | WinAnsiEncoding | Windows Code Page 1252 |
    /// | PDFDocEncoding | Text strings outside content streams |
    /// | MacExpertEncoding | Expert fonts with small caps, ligatures, fractions |
    /// | SymbolEncoding | Symbol font built-in encoding |
    /// | ZapfDingbatsEncoding | ZapfDingbats font built-in encoding |
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Encode a Unicode character to a byte
    /// if let byte = ISO_32000.WinAnsiEncoding.encode("€") {
    ///     print(byte)  // 128
    /// }
    ///
    /// // Decode a byte to Unicode
    /// if let scalar = ISO_32000.WinAnsiEncoding.decode(0x80) {
    ///     print(scalar)  // "€"
    /// }
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Annex D (normative) - Character sets and encodings
    public protocol Encoding: Sendable {
        /// The encoding name as used in PDF (e.g., "WinAnsiEncoding")
        ///
        /// This name is used in PDF encoding dictionaries:
        /// ```
        /// << /Type /Encoding /BaseEncoding /WinAnsiEncoding >>
        /// ```
        static var name: String { get }

        /// Convert a Unicode scalar to an encoded byte
        ///
        /// - Parameter scalar: The Unicode scalar value to encode
        /// - Returns: The encoded byte, or `nil` if the character cannot be encoded
        static func encode(_ scalar: Unicode.Scalar) -> UInt8?

        /// Convert an encoded byte to a Unicode scalar
        ///
        /// - Parameter byte: The encoded byte value (0-255)
        /// - Returns: The Unicode scalar, or `nil` if the byte is undefined in this encoding
        static func decode(_ byte: UInt8) -> Unicode.Scalar?

        /// Check if a Unicode scalar can be encoded
        ///
        /// - Parameter scalar: The Unicode scalar value to check
        /// - Returns: `true` if the scalar can be encoded, `false` otherwise
        static func canEncode(_ scalar: Unicode.Scalar) -> Bool

        /// The complete decode table (256 entries, nil for undefined)
        ///
        /// Index by byte value to get the corresponding Unicode scalar.
        /// This is useful for batch decoding operations.
        static var decodeTable: [Unicode.Scalar?] { get }
    }
}

// MARK: - Default Implementation

extension ISO_32000.Encoding {
    /// Default implementation using encode()
    @inlinable
    public static func canEncode(_ scalar: Unicode.Scalar) -> Bool {
        encode(scalar) != nil
    }
}

// MARK: - Byte-Level Encoding Extensions

extension ISO_32000.Encoding {
    /// Encode Unicode scalars to bytes
    ///
    /// - Parameter scalars: The Unicode scalars to encode
    /// - Returns: The encoded bytes, or `nil` if any scalar cannot be encoded
    @inlinable
    public static func encode<Scalars: Sequence>(
        _ scalars: Scalars
    ) -> [UInt8]? where Scalars.Element == Unicode.Scalar {
        var result: [UInt8] = []
        for scalar in scalars {
            guard let byte = encode(scalar) else { return nil }
            result.append(byte)
        }
        return result
    }

    /// Encode Unicode scalars to bytes with fallback
    ///
    /// Scalars that cannot be encoded are replaced with `?` (0x3F).
    ///
    /// - Parameter scalars: The Unicode scalars to encode
    /// - Returns: The encoded bytes (never nil, uses fallback for unencodable scalars)
    @inlinable
    public static func encodeWithFallback<Scalars: Sequence>(
        _ scalars: Scalars
    ) -> [UInt8] where Scalars.Element == Unicode.Scalar {
        var result: [UInt8] = []
        for scalar in scalars {
            result.append(encode(scalar) ?? 0x3F)
        }
        return result
    }
}

// MARK: - StringProtocol Extensions (Bytes → String)

extension String {
    /// Initialize from bytes using a PDF encoding
    ///
    /// Returns `nil` if any byte cannot be decoded.
    ///
    /// - Parameters:
    ///   - encoding: The PDF encoding type to use
    ///   - bytes: The bytes to decode
    @inlinable
    public init?<E: ISO_32000.Encoding, Bytes: Collection>(
        _ encoding: E.Type,
        bytes: Bytes
    ) where Bytes.Element == UInt8 {
        var scalars = String.UnicodeScalarView()
        scalars.reserveCapacity(bytes.count)
        for byte in bytes {
            guard let scalar = E.decode(byte) else { return nil }
            scalars.append(scalar)
        }
        self.init(scalars)
    }

    /// Initialize from bytes using a PDF encoding, with replacement for invalid bytes
    ///
    /// Invalid bytes are replaced with U+FFFD (replacement character).
    ///
    /// - Parameters:
    ///   - encoding: The PDF encoding type to use
    ///   - bytes: The bytes to decode
    ///   - withReplacement: Must be `true` to use replacement mode
    @inlinable
    public init<E: ISO_32000.Encoding, Bytes: Collection>(
        _ encoding: E.Type,
        bytes: Bytes,
        withReplacement: Bool
    ) where Bytes.Element == UInt8 {
        var scalars = String.UnicodeScalarView()
        scalars.reserveCapacity(bytes.count)
        for byte in bytes {
            scalars.append(E.decode(byte) ?? "\u{FFFD}")
        }
        self.init(scalars)
    }
}

// MARK: - Glyph Name

extension ISO_32000 {
    /// Adobe glyph name for PDF font encoding
    ///
    /// Glyph names are used in encoding difference arrays and font programs.
    /// These names follow the Adobe Glyph List specification.
    ///
    /// Glyph names are stored as ASCII bytes (the canonical representation).
    /// Use `String.init(_:)` to convert to a String when needed.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let name = ISO_32000.GlyphName.Euro
    /// print(String(name))   // "Euro"
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.2 — Latin character set and encodings
    @frozen
    public struct GlyphName: Hashable, Sendable {
        /// The glyph name as ASCII bytes (canonical representation)
        public let bytes: [UInt8]

        /// Initialize from ASCII bytes
        @inlinable
        public init(bytes: [UInt8]) {
            self.bytes = bytes
        }

        /// Initialize from a static ASCII string literal
        ///
        /// This initializer is intended for compile-time constant glyph names.
        /// The string must contain only ASCII characters.
        @inlinable
        public init(_ name: StaticString) {
            self.bytes = name.withUTF8Buffer { Array($0) }
        }
    }
}

// MARK: - GlyphName String Conversion

extension String {
    /// Initialize a String from a GlyphName
    ///
    /// Since glyph names are ASCII, this conversion is always valid.
    @inlinable
    public init(_ glyphName: ISO_32000.GlyphName) {
        self.init(decoding: glyphName.bytes, as: UTF8.self)
    }
}

extension ISO_32000.GlyphName: CustomStringConvertible {
    @inlinable
    public var description: String {
        String(self)
    }
}

// MARK: - Common Glyph Names

extension ISO_32000.GlyphName {
    // Uppercase letters
    public static let A = ISO_32000.GlyphName("A")
    public static let B = ISO_32000.GlyphName("B")
    public static let C = ISO_32000.GlyphName("C")
    public static let D = ISO_32000.GlyphName("D")
    public static let E = ISO_32000.GlyphName("E")
    public static let F = ISO_32000.GlyphName("F")
    public static let G = ISO_32000.GlyphName("G")
    public static let H = ISO_32000.GlyphName("H")
    public static let I = ISO_32000.GlyphName("I")
    public static let J = ISO_32000.GlyphName("J")
    public static let K = ISO_32000.GlyphName("K")
    public static let L = ISO_32000.GlyphName("L")
    public static let M = ISO_32000.GlyphName("M")
    public static let N = ISO_32000.GlyphName("N")
    public static let O = ISO_32000.GlyphName("O")
    public static let P = ISO_32000.GlyphName("P")
    public static let Q = ISO_32000.GlyphName("Q")
    public static let R = ISO_32000.GlyphName("R")
    public static let S = ISO_32000.GlyphName("S")
    public static let T = ISO_32000.GlyphName("T")
    public static let U = ISO_32000.GlyphName("U")
    public static let V = ISO_32000.GlyphName("V")
    public static let W = ISO_32000.GlyphName("W")
    public static let X = ISO_32000.GlyphName("X")
    public static let Y = ISO_32000.GlyphName("Y")
    public static let Z = ISO_32000.GlyphName("Z")

    // Lowercase letters
    public static let a = ISO_32000.GlyphName("a")
    public static let b = ISO_32000.GlyphName("b")
    public static let c = ISO_32000.GlyphName("c")
    public static let d = ISO_32000.GlyphName("d")
    public static let e = ISO_32000.GlyphName("e")
    public static let f = ISO_32000.GlyphName("f")
    public static let g = ISO_32000.GlyphName("g")
    public static let h = ISO_32000.GlyphName("h")
    public static let i = ISO_32000.GlyphName("i")
    public static let j = ISO_32000.GlyphName("j")
    public static let k = ISO_32000.GlyphName("k")
    public static let l = ISO_32000.GlyphName("l")
    public static let m = ISO_32000.GlyphName("m")
    public static let n = ISO_32000.GlyphName("n")
    public static let o = ISO_32000.GlyphName("o")
    public static let p = ISO_32000.GlyphName("p")
    public static let q = ISO_32000.GlyphName("q")
    public static let r = ISO_32000.GlyphName("r")
    public static let s = ISO_32000.GlyphName("s")
    public static let t = ISO_32000.GlyphName("t")
    public static let u = ISO_32000.GlyphName("u")
    public static let v = ISO_32000.GlyphName("v")
    public static let w = ISO_32000.GlyphName("w")
    public static let x = ISO_32000.GlyphName("x")
    public static let y = ISO_32000.GlyphName("y")
    public static let z = ISO_32000.GlyphName("z")

    // Digits
    public static let zero = ISO_32000.GlyphName("zero")
    public static let one = ISO_32000.GlyphName("one")
    public static let two = ISO_32000.GlyphName("two")
    public static let three = ISO_32000.GlyphName("three")
    public static let four = ISO_32000.GlyphName("four")
    public static let five = ISO_32000.GlyphName("five")
    public static let six = ISO_32000.GlyphName("six")
    public static let seven = ISO_32000.GlyphName("seven")
    public static let eight = ISO_32000.GlyphName("eight")
    public static let nine = ISO_32000.GlyphName("nine")

    // Special characters
    public static let space = ISO_32000.GlyphName("space")
    public static let exclam = ISO_32000.GlyphName("exclam")
    public static let quotedbl = ISO_32000.GlyphName("quotedbl")
    public static let numbersign = ISO_32000.GlyphName("numbersign")
    public static let dollar = ISO_32000.GlyphName("dollar")
    public static let percent = ISO_32000.GlyphName("percent")
    public static let ampersand = ISO_32000.GlyphName("ampersand")
    public static let quotesingle = ISO_32000.GlyphName("quotesingle")
    public static let parenleft = ISO_32000.GlyphName("parenleft")
    public static let parenright = ISO_32000.GlyphName("parenright")
    public static let asterisk = ISO_32000.GlyphName("asterisk")
    public static let plus = ISO_32000.GlyphName("plus")
    public static let comma = ISO_32000.GlyphName("comma")
    public static let hyphen = ISO_32000.GlyphName("hyphen")
    public static let period = ISO_32000.GlyphName("period")
    public static let slash = ISO_32000.GlyphName("slash")
    public static let colon = ISO_32000.GlyphName("colon")
    public static let semicolon = ISO_32000.GlyphName("semicolon")
    public static let less = ISO_32000.GlyphName("less")
    public static let equal = ISO_32000.GlyphName("equal")
    public static let greater = ISO_32000.GlyphName("greater")
    public static let question = ISO_32000.GlyphName("question")
    public static let at = ISO_32000.GlyphName("at")
    public static let bracketleft = ISO_32000.GlyphName("bracketleft")
    public static let backslash = ISO_32000.GlyphName("backslash")
    public static let bracketright = ISO_32000.GlyphName("bracketright")
    public static let asciicircum = ISO_32000.GlyphName("asciicircum")
    public static let underscore = ISO_32000.GlyphName("underscore")
    public static let grave = ISO_32000.GlyphName("grave")
    public static let braceleft = ISO_32000.GlyphName("braceleft")
    public static let bar = ISO_32000.GlyphName("bar")
    public static let braceright = ISO_32000.GlyphName("braceright")
    public static let asciitilde = ISO_32000.GlyphName("asciitilde")

    // Currency and symbols
    public static let Euro = ISO_32000.GlyphName("Euro")
    public static let cent = ISO_32000.GlyphName("cent")
    public static let sterling = ISO_32000.GlyphName("sterling")
    public static let currency = ISO_32000.GlyphName("currency")
    public static let yen = ISO_32000.GlyphName("yen")
    public static let florin = ISO_32000.GlyphName("florin")

    // Punctuation
    public static let bullet = ISO_32000.GlyphName("bullet")
    public static let ellipsis = ISO_32000.GlyphName("ellipsis")
    public static let emdash = ISO_32000.GlyphName("emdash")
    public static let endash = ISO_32000.GlyphName("endash")
    public static let quoteleft = ISO_32000.GlyphName("quoteleft")
    public static let quoteright = ISO_32000.GlyphName("quoteright")
    public static let quotedblleft = ISO_32000.GlyphName("quotedblleft")
    public static let quotedblright = ISO_32000.GlyphName("quotedblright")
    public static let quotesinglbase = ISO_32000.GlyphName("quotesinglbase")
    public static let quotedblbase = ISO_32000.GlyphName("quotedblbase")
    public static let dagger = ISO_32000.GlyphName("dagger")
    public static let daggerdbl = ISO_32000.GlyphName("daggerdbl")
    public static let perthousand = ISO_32000.GlyphName("perthousand")
    public static let guilsinglleft = ISO_32000.GlyphName("guilsinglleft")
    public static let guilsinglright = ISO_32000.GlyphName("guilsinglright")
    public static let guillemotleft = ISO_32000.GlyphName("guillemotleft")
    public static let guillemotright = ISO_32000.GlyphName("guillemotright")

    // Ligatures
    public static let fi = ISO_32000.GlyphName("fi")
    public static let fl = ISO_32000.GlyphName("fl")
    public static let ff = ISO_32000.GlyphName("ff")
    public static let ffi = ISO_32000.GlyphName("ffi")
    public static let ffl = ISO_32000.GlyphName("ffl")

    // Accented uppercase
    public static let Aacute = ISO_32000.GlyphName("Aacute")
    public static let Acircumflex = ISO_32000.GlyphName("Acircumflex")
    public static let Adieresis = ISO_32000.GlyphName("Adieresis")
    public static let Agrave = ISO_32000.GlyphName("Agrave")
    public static let Aring = ISO_32000.GlyphName("Aring")
    public static let Atilde = ISO_32000.GlyphName("Atilde")
    public static let AE = ISO_32000.GlyphName("AE")
    public static let Ccedilla = ISO_32000.GlyphName("Ccedilla")
    public static let Eacute = ISO_32000.GlyphName("Eacute")
    public static let Ecircumflex = ISO_32000.GlyphName("Ecircumflex")
    public static let Edieresis = ISO_32000.GlyphName("Edieresis")
    public static let Egrave = ISO_32000.GlyphName("Egrave")
    public static let Eth = ISO_32000.GlyphName("Eth")
    public static let Iacute = ISO_32000.GlyphName("Iacute")
    public static let Icircumflex = ISO_32000.GlyphName("Icircumflex")
    public static let Idieresis = ISO_32000.GlyphName("Idieresis")
    public static let Igrave = ISO_32000.GlyphName("Igrave")
    public static let Ntilde = ISO_32000.GlyphName("Ntilde")
    public static let Oacute = ISO_32000.GlyphName("Oacute")
    public static let Ocircumflex = ISO_32000.GlyphName("Ocircumflex")
    public static let Odieresis = ISO_32000.GlyphName("Odieresis")
    public static let Ograve = ISO_32000.GlyphName("Ograve")
    public static let Oslash = ISO_32000.GlyphName("Oslash")
    public static let Otilde = ISO_32000.GlyphName("Otilde")
    public static let OE = ISO_32000.GlyphName("OE")
    public static let Scaron = ISO_32000.GlyphName("Scaron")
    public static let Thorn = ISO_32000.GlyphName("Thorn")
    public static let Uacute = ISO_32000.GlyphName("Uacute")
    public static let Ucircumflex = ISO_32000.GlyphName("Ucircumflex")
    public static let Udieresis = ISO_32000.GlyphName("Udieresis")
    public static let Ugrave = ISO_32000.GlyphName("Ugrave")
    public static let Yacute = ISO_32000.GlyphName("Yacute")
    public static let Ydieresis = ISO_32000.GlyphName("Ydieresis")
    public static let Zcaron = ISO_32000.GlyphName("Zcaron")
    public static let Lslash = ISO_32000.GlyphName("Lslash")

    // Accented lowercase
    public static let aacute = ISO_32000.GlyphName("aacute")
    public static let acircumflex = ISO_32000.GlyphName("acircumflex")
    public static let adieresis = ISO_32000.GlyphName("adieresis")
    public static let agrave = ISO_32000.GlyphName("agrave")
    public static let aring = ISO_32000.GlyphName("aring")
    public static let atilde = ISO_32000.GlyphName("atilde")
    public static let ae = ISO_32000.GlyphName("ae")
    public static let ccedilla = ISO_32000.GlyphName("ccedilla")
    public static let eacute = ISO_32000.GlyphName("eacute")
    public static let ecircumflex = ISO_32000.GlyphName("ecircumflex")
    public static let edieresis = ISO_32000.GlyphName("edieresis")
    public static let egrave = ISO_32000.GlyphName("egrave")
    public static let eth = ISO_32000.GlyphName("eth")
    public static let iacute = ISO_32000.GlyphName("iacute")
    public static let icircumflex = ISO_32000.GlyphName("icircumflex")
    public static let idieresis = ISO_32000.GlyphName("idieresis")
    public static let igrave = ISO_32000.GlyphName("igrave")
    public static let ntilde = ISO_32000.GlyphName("ntilde")
    public static let oacute = ISO_32000.GlyphName("oacute")
    public static let ocircumflex = ISO_32000.GlyphName("ocircumflex")
    public static let odieresis = ISO_32000.GlyphName("odieresis")
    public static let ograve = ISO_32000.GlyphName("ograve")
    public static let oslash = ISO_32000.GlyphName("oslash")
    public static let otilde = ISO_32000.GlyphName("otilde")
    public static let oe = ISO_32000.GlyphName("oe")
    public static let scaron = ISO_32000.GlyphName("scaron")
    public static let thorn = ISO_32000.GlyphName("thorn")
    public static let uacute = ISO_32000.GlyphName("uacute")
    public static let ucircumflex = ISO_32000.GlyphName("ucircumflex")
    public static let udieresis = ISO_32000.GlyphName("udieresis")
    public static let ugrave = ISO_32000.GlyphName("ugrave")
    public static let yacute = ISO_32000.GlyphName("yacute")
    public static let ydieresis = ISO_32000.GlyphName("ydieresis")
    public static let zcaron = ISO_32000.GlyphName("zcaron")
    public static let lslash = ISO_32000.GlyphName("lslash")
    public static let germandbls = ISO_32000.GlyphName("germandbls")
    public static let dotlessi = ISO_32000.GlyphName("dotlessi")

    // Diacritical marks
    public static let acute = ISO_32000.GlyphName("acute")
    public static let breve = ISO_32000.GlyphName("breve")
    public static let caron = ISO_32000.GlyphName("caron")
    public static let cedilla = ISO_32000.GlyphName("cedilla")
    public static let circumflex = ISO_32000.GlyphName("circumflex")
    public static let dieresis = ISO_32000.GlyphName("dieresis")
    public static let dotaccent = ISO_32000.GlyphName("dotaccent")
    public static let hungarumlaut = ISO_32000.GlyphName("hungarumlaut")
    public static let macron = ISO_32000.GlyphName("macron")
    public static let ogonek = ISO_32000.GlyphName("ogonek")
    public static let ring = ISO_32000.GlyphName("ring")
    public static let tilde = ISO_32000.GlyphName("tilde")

    // Fractions and math
    public static let onehalf = ISO_32000.GlyphName("onehalf")
    public static let onequarter = ISO_32000.GlyphName("onequarter")
    public static let threequarters = ISO_32000.GlyphName("threequarters")
    public static let onesuperior = ISO_32000.GlyphName("onesuperior")
    public static let twosuperior = ISO_32000.GlyphName("twosuperior")
    public static let threesuperior = ISO_32000.GlyphName("threesuperior")
    public static let fraction = ISO_32000.GlyphName("fraction")
    public static let plusminus = ISO_32000.GlyphName("plusminus")
    public static let multiply = ISO_32000.GlyphName("multiply")
    public static let divide = ISO_32000.GlyphName("divide")
    public static let minus = ISO_32000.GlyphName("minus")
    public static let degree = ISO_32000.GlyphName("degree")
    public static let mu = ISO_32000.GlyphName("mu")
    public static let logicalnot = ISO_32000.GlyphName("logicalnot")

    // Other symbols
    public static let copyright = ISO_32000.GlyphName("copyright")
    public static let registered = ISO_32000.GlyphName("registered")
    public static let trademark = ISO_32000.GlyphName("trademark")
    public static let section = ISO_32000.GlyphName("section")
    public static let paragraph = ISO_32000.GlyphName("paragraph")
    public static let brokenbar = ISO_32000.GlyphName("brokenbar")
    public static let ordfeminine = ISO_32000.GlyphName("ordfeminine")
    public static let ordmasculine = ISO_32000.GlyphName("ordmasculine")
    public static let exclamdown = ISO_32000.GlyphName("exclamdown")
    public static let questiondown = ISO_32000.GlyphName("questiondown")
    public static let periodcentered = ISO_32000.GlyphName("periodcentered")
}
