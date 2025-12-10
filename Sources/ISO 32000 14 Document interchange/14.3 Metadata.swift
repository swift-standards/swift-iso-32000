// ISO 32000-2:2020, 14.3 Metadata
//
// Sections:
//   14.3.1  General
//   14.3.2  Metadata streams
//   14.3.3  Document information dictionary

public import ISO_32000_7_Syntax
public import ISO_32000_Shared

extension ISO_32000.`14` {
    /// ISO 32000-2:2020, 14.3 Metadata
    public enum `3` {}
}

// MARK: - 14.3.3 Document Information Dictionary

extension ISO_32000.`14`.`3` {
    /// ISO 32000-2:2020, 14.3.3 Document information dictionary
    public enum `3` {}
}

extension ISO_32000.`14`.`3`.`3` {
    /// Document information dictionary
    ///
    /// Per ISO 32000-2 Section 14.3.3:
    /// > The optional Info entry in the trailer of a PDF file shall hold a
    /// > dictionary containing metadata for the document.
    ///
    /// ## Standard Entries
    ///
    /// - **Title**: Document's title
    /// - **Author**: Name of the person who created the document
    /// - **Subject**: Subject of the document
    /// - **Keywords**: Keywords associated with the document
    /// - **Creator**: Application that created the original document
    /// - **Producer**: Application that produced the PDF
    /// - **CreationDate**: Date and time of document creation
    /// - **ModDate**: Date and time of most recent modification
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 14.3.3 — Document information dictionary
    public struct Info: Sendable {
        /// Document's title
        public var title: String?

        /// Name of the person who created the document
        public var author: String?

        /// Subject of the document
        public var subject: String?

        /// Keywords associated with the document
        public var keywords: String?

        /// Application that created the original document
        public var creator: String?

        /// Application that produced the PDF
        public var producer: String?

        /// Date and time the document was created
        public var creationDate: ISO_32000.`7`.`9`.`4`.Date?

        /// Date and time the document was most recently modified
        public var modificationDate: ISO_32000.`7`.`9`.`4`.Date?

        /// Create a document information dictionary
        public init(
            title: String? = nil,
            author: String? = nil,
            subject: String? = nil,
            keywords: String? = nil,
            creator: String? = nil,
            producer: String? = nil,
            creationDate: ISO_32000.`7`.`9`.`4`.Date? = nil,
            modificationDate: ISO_32000.`7`.`9`.`4`.Date? = nil
        ) {
            self.title = title
            self.author = author
            self.subject = subject
            self.keywords = keywords
            self.creator = creator
            self.producer = producer
            self.creationDate = creationDate
            self.modificationDate = modificationDate
        }
    }
}
