// ISO_32000.Version.swift

extension ISO_32000 {
    /// PDF version identifier
    ///
    /// Per ISO 32000, the PDF version determines which features are available.
    /// The version appears in the file header as `%PDF-X.Y`.
    public enum Version: String, Sendable, Hashable, Codable, CaseIterable {
        /// PDF 1.4 (Acrobat 5)
        case v1_4 = "1.4"

        /// PDF 1.5 (Acrobat 6)
        case v1_5 = "1.5"

        /// PDF 1.6 (Acrobat 7)
        case v1_6 = "1.6"

        /// PDF 1.7 (ISO 32000-1:2008)
        case v1_7 = "1.7"

        /// PDF 2.0 (ISO 32000-2:2017)
        case v2_0 = "2.0"

        /// Default version for new documents
        public static let `default`: Version = .v1_7

        /// Header string for this version (e.g., "%PDF-1.7")
        public var header: String {
            "%PDF-\(rawValue)"
        }
    }
}
