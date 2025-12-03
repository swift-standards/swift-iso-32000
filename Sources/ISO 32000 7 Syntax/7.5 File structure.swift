// ISO 32000-2:2020, 7.5 File structure
//
// Sections:
//   7.5.1  General
//   7.5.2  File header
//   7.5.3  File body
//   7.5.4  Cross-reference table
//   7.5.5  File trailer
//   7.5.6  Incremental updates
//   7.5.7  Cross-reference streams
//   7.5.8  Compatibility with applications that do not support compressed
//          cross-reference streams and object streams

public import ISO_32000_Shared

extension ISO_32000.`7` {
    /// ISO 32000-2:2020, 7.5 File structure
    public enum `5` {}
}

// MARK: - 7.5.2 File Header

extension ISO_32000.`7`.`5` {
    /// ISO 32000-2:2020, 7.5.2 File header
    public enum `2` {}
}

extension ISO_32000.`7`.`5`.`2` {
    /// PDF version identifier
    ///
    /// Per ISO 32000-2 Section 7.5.2:
    /// > The first line of a PDF file shall be a header identifying the version
    /// > of the PDF specification to which the file conforms.
    ///
    /// The version appears in the file header as `%PDF-X.Y`.
    ///
    /// ## Versions
    ///
    /// - PDF 1.4: Acrobat 5
    /// - PDF 1.5: Acrobat 6
    /// - PDF 1.6: Acrobat 7
    /// - PDF 1.7: ISO 32000-1:2008
    /// - PDF 2.0: ISO 32000-2:2017/2020
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.5.2 — File header
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

        /// Header bytes for this version
        public var headerBytes: [UInt8] {
            Array(header.utf8)
        }
    }
}
