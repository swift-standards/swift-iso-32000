// ISO_32000.COS.Stream.swift

extension ISO_32000.COS {
    /// PDF Stream object
    ///
    /// Per ISO 32000-1 Section 7.3.8, a stream is a dictionary followed by
    /// a sequence of bytes. Streams are used for page contents, images,
    /// embedded files, and other binary data.
    ///
    /// ## Serialization
    ///
    /// ```
    /// << /Length 44 >>
    /// stream
    /// BT /F1 12 Tf 100 700 Td (Hello World) Tj ET
    /// endstream
    /// ```
    public struct Stream: Sendable, Hashable {
        /// Stream dictionary (contains /Length, /Filter, etc.)
        public var dictionary: Dictionary

        /// Raw stream data (may be compressed)
        public var data: [UInt8]

        /// Create a stream with dictionary and data
        public init(dictionary: Dictionary = Dictionary(), data: [UInt8] = []) {
            self.dictionary = dictionary
            self.data = data
        }

        /// Create a stream with just data (dictionary will have /Length set)
        public init(data: [UInt8]) {
            self.dictionary = Dictionary()
            self.data = data
        }
    }
}

// MARK: - CustomStringConvertible

extension ISO_32000.COS.Stream: CustomStringConvertible {
    public var description: String {
        "\(dictionary) stream<\(data.count) bytes>"
    }
}
