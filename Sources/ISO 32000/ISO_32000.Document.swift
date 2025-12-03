// ISO_32000.Document.swift

extension ISO_32000 {
    /// A PDF document
    ///
    /// The Document structure represents the logical content of a PDF file.
    /// Use `Writer` to serialize it to bytes.
    public struct Document: Sendable {
        /// PDF version
        public var version: Version
        
        /// Document pages
        public var pages: [Page]
        
        /// Document metadata
        public var info: Info?
        
        /// Create a document
        public init(
            version: Version = .default,
            pages: [Page] = [],
            info: Info? = nil
        ) {
            self.version = version
            self.pages = pages
            self.info = info
        }
    }
}

extension ISO_32000.Document {
    /// Create a document with a single page
    public init(
        version: ISO_32000.Version = .default,
        page: ISO_32000.Page,
        info: ISO_32000.Document.Info? = nil
    ) {
        self.version = version
        self.pages = [page]
        self.info = info
    }
}
