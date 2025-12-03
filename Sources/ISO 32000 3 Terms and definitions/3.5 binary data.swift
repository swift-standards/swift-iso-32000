// ISO 32000-2:2020, 3.5 binary data

public import ISO_32000_Shared

extension ISO_32000.`3` {
    /// A sequence of bytes.
    ///
    /// ## ISO 32000-2:2020
    /// **3.5 binary data**
    ///
    /// > sequence of bytes
    ///
    /// ## Discussion
    ///
    /// Binary data in PDF represents raw byte sequences that may contain any
    /// values from 0–255. This is distinct from text strings which have specific
    /// encoding requirements.
    ///
    /// Binary data appears in:
    /// - Stream contents (images, fonts, compressed data)
    /// - Hexadecimal string literals
    /// - Encrypted content
    ///
    /// ## See Also
    /// - ``Byte``
    /// - ``ISO_32000/`3`/StreamObject``
    /// - ``ISO_32000/`3`/StringObject``
    public struct `Binary data`<Source>
    where Source: Collection, Source.Element == ISO_32000.`3`.Byte {
        public let source: Source
    }
}

extension ISO_32000.`3`.`Binary data`: ExpressibleByArrayLiteral
where Source == [ISO_32000.`3`.Byte] {
    public typealias ArrayLiteralElement = ISO_32000.`3`.Byte

    public init(arrayLiteral elements: ISO_32000.`3`.Byte...) {
        self.source = elements
    }
}
