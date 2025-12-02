// ISO_32000.COS.IndirectReference.swift

extension ISO_32000.COS {
    /// Indirect object reference
    ///
    /// Per ISO 32000-1 Section 7.3.10, indirect references allow objects
    /// to be shared and referenced from multiple locations in the PDF.
    ///
    /// ## Serialization
    ///
    /// ```
    /// 12 0 R
    /// ```
    ///
    /// Where 12 is the object number and 0 is the generation number.
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

// MARK: - CustomStringConvertible

extension ISO_32000.COS.IndirectReference: CustomStringConvertible {
    public var description: String {
        "\(objectNumber) \(generation) R"
    }
}
