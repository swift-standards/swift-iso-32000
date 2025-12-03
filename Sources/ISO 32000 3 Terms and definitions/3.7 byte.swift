// ISO 32000-2:2020, 3.7 byte

public import ISO_32000_Shared

extension ISO_32000.`3` {
    /// A group of 8 binary digits (an 8-bit value) which collectively can be
    /// configured to represent one of 256 different values.
    ///
    /// ## ISO 32000-2:2020
    /// **3.7 byte**
    ///
    /// > group of 8 binary digits (an 8-bit value) which collectively can be
    /// > configured to represent one of 256 different values
    ///
    /// ## Discussion
    ///
    /// In PDF, bytes are the fundamental unit of data. A PDF file is a sequence
    /// of bytes, and many PDF objects (such as strings and streams) contain
    /// sequences of bytes.
    ///
    /// The valid range is 0–255 (0x00–0xFF).
    ///
    /// ## See Also
    /// - ``ISO_32000/`3`/BinaryData``
    /// - ``ISO_32000/`3`/StringObject``
    public typealias Byte = UInt8
}
