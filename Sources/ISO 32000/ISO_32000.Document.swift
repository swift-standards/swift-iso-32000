// ISO_32000.Document.swift

extension ISO_32000 {
    /// A PDF document
    ///
    /// The Document structure represents the logical content of a PDF file.
    /// Use `Writer` to serialize it to bytes.
    public struct Document: Sendable {
        /// PDF version
        public var version: Version

        /// Document metadata
        public var info: Info?

        /// Document pages
        public var pages: [Page]

        /// Document outline (bookmarks)
        ///
        /// Per ISO 32000-2:2020 Section 12.3.3, a document may contain
        /// an outline that allows users to navigate interactively.
        public var outline: Outline.Root?

        /// Create a document
        public init(
            version: Version = .default,
            info: Info? = nil,
            pages: [Page] = [],
            outline: Outline.Root? = nil
        ) {
            self.version = version
            self.info = info
            self.pages = pages
            self.outline = outline
        }
    }
}

extension ISO_32000.Document {
    /// Create a document with a single page
    public init(
        version: ISO_32000.Version = .default,
        info: ISO_32000.Document.Info? = nil,
        page: ISO_32000.Page,
    ) {
        self.version = version
        self.info = info
        self.pages = [page]
    }
}
