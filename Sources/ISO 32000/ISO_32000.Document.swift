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

        /// Viewer preferences
        ///
        /// Per ISO 32000-2:2020 Section 12.2, specifies how the document
        /// should be displayed when opened.
        public var viewer: Viewer?

        /// Create a document
        public init(
            version: Version = .default,
            info: Info? = nil,
            pages: [Page] = [],
            outline: Outline.Root? = nil,
            viewer: Viewer? = nil
        ) {
            self.version = version
            self.info = info
            self.pages = pages
            self.outline = outline
            self.viewer = viewer
        }
    }
}

