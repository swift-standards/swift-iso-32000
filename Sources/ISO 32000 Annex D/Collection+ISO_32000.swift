// Collection+ISO_32000.swift
// ISO 32000-2:2020 Annex D - Generic collection wrappers for PDF encodings
//
// Provides typed wrappers for byte collections in specific PDF encodings,
// following the pattern established by INCITS_4_1986.ASCII<Source>.

public import ISO_32000_Shared

// MARK: - WinAnsi Collection Wrapper

extension ISO_32000 {
    /// A wrapper providing WinAnsiEncoding operations on a byte collection.
    ///
    /// This follows the pattern of `INCITS_4_1986.ASCII<Source>`, making bytes
    /// the canonical representation with String as a derived view.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let bytes: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]  // "Hello"
    /// let winAnsi = bytes.winAnsi
    /// print(winAnsi.isValid)  // true
    /// ```
    @frozen
    public struct WinAnsi<Source: Collection> where Source.Element == UInt8 {
        public let source: Source

        @inlinable
        public init(_ source: Source) {
            self.source = source
        }
    }
}

extension ISO_32000.WinAnsi {
    /// Whether all bytes decode to valid Unicode scalars in WinAnsiEncoding
    @inlinable
    public var isValid: Bool {
        source.allSatisfy { ISO_32000.WinAnsiEncoding.decode($0) != nil }
    }
}

extension Collection where Element == UInt8 {
    /// Access this byte collection as WinAnsiEncoding
    @inlinable
    public var winAnsi: ISO_32000.WinAnsi<Self> { .init(self) }
}

// MARK: - PDFDoc Collection Wrapper

extension ISO_32000 {
    /// A wrapper providing PDFDocEncoding operations on a byte collection.
    @frozen
    public struct PDFDoc<Source: Collection> where Source.Element == UInt8 {
        public let source: Source

        @inlinable
        public init(_ source: Source) {
            self.source = source
        }
    }
}

extension ISO_32000.PDFDoc {
    /// Whether all bytes decode to valid Unicode scalars in PDFDocEncoding
    @inlinable
    public var isValid: Bool {
        source.allSatisfy { ISO_32000.PDFDocEncoding.decode($0) != nil }
    }
}

extension Collection where Element == UInt8 {
    /// Access this byte collection as PDFDocEncoding
    @inlinable
    public var pdfDoc: ISO_32000.PDFDoc<Self> { .init(self) }
}

// MARK: - Standard Collection Wrapper

extension ISO_32000 {
    /// A wrapper providing StandardEncoding operations on a byte collection.
    @frozen
    public struct Standard<Source: Collection> where Source.Element == UInt8 {
        public let source: Source

        @inlinable
        public init(_ source: Source) {
            self.source = source
        }
    }
}

extension ISO_32000.Standard {
    /// Whether all bytes decode to valid Unicode scalars in StandardEncoding
    @inlinable
    public var isValid: Bool {
        source.allSatisfy { ISO_32000.StandardEncoding.decode($0) != nil }
    }
}

extension Collection where Element == UInt8 {
    /// Access this byte collection as StandardEncoding
    @inlinable
    public var standard: ISO_32000.Standard<Self> { .init(self) }
}

// MARK: - MacRoman Collection Wrapper

extension ISO_32000 {
    /// A wrapper providing MacRomanEncoding operations on a byte collection.
    @frozen
    public struct MacRoman<Source: Collection> where Source.Element == UInt8 {
        public let source: Source

        @inlinable
        public init(_ source: Source) {
            self.source = source
        }
    }
}

extension ISO_32000.MacRoman {
    /// Whether all bytes decode to valid Unicode scalars in MacRomanEncoding
    @inlinable
    public var isValid: Bool {
        source.allSatisfy { ISO_32000.MacRomanEncoding.decode($0) != nil }
    }
}

extension Collection where Element == UInt8 {
    /// Access this byte collection as MacRomanEncoding
    @inlinable
    public var macRoman: ISO_32000.MacRoman<Self> { .init(self) }
}

// MARK: - MacExpert Collection Wrapper

extension ISO_32000 {
    /// A wrapper providing MacExpertEncoding operations on a byte collection.
    @frozen
    public struct MacExpert<Source: Collection> where Source.Element == UInt8 {
        public let source: Source

        @inlinable
        public init(_ source: Source) {
            self.source = source
        }
    }
}

extension ISO_32000.MacExpert {
    /// Whether all bytes decode to valid Unicode scalars in MacExpertEncoding
    @inlinable
    public var isValid: Bool {
        source.allSatisfy { ISO_32000.MacExpertEncoding.decode($0) != nil }
    }
}

extension Collection where Element == UInt8 {
    /// Access this byte collection as MacExpertEncoding
    @inlinable
    public var macExpert: ISO_32000.MacExpert<Self> { .init(self) }
}

// MARK: - Symbol Collection Wrapper

extension ISO_32000 {
    /// A wrapper providing SymbolEncoding operations on a byte collection.
    @frozen
    public struct Symbol<Source: Collection> where Source.Element == UInt8 {
        public let source: Source

        @inlinable
        public init(_ source: Source) {
            self.source = source
        }
    }
}

extension ISO_32000.Symbol {
    /// Whether all bytes decode to valid Unicode scalars in SymbolEncoding
    @inlinable
    public var isValid: Bool {
        source.allSatisfy { ISO_32000.SymbolEncoding.decode($0) != nil }
    }
}

extension Collection where Element == UInt8 {
    /// Access this byte collection as SymbolEncoding
    @inlinable
    public var symbol: ISO_32000.Symbol<Self> { .init(self) }
}

// MARK: - ZapfDingbats Collection Wrapper

extension ISO_32000 {
    /// A wrapper providing ZapfDingbatsEncoding operations on a byte collection.
    @frozen
    public struct ZapfDingbats<Source: Collection> where Source.Element == UInt8 {
        public let source: Source

        @inlinable
        public init(_ source: Source) {
            self.source = source
        }
    }
}

extension ISO_32000.ZapfDingbats {
    /// Whether all bytes decode to valid Unicode scalars in ZapfDingbatsEncoding
    @inlinable
    public var isValid: Bool {
        source.allSatisfy { ISO_32000.ZapfDingbatsEncoding.decode($0) != nil }
    }
}

extension Collection where Element == UInt8 {
    /// Access this byte collection as ZapfDingbatsEncoding
    @inlinable
    public var zapfDingbats: ISO_32000.ZapfDingbats<Self> { .init(self) }
}

