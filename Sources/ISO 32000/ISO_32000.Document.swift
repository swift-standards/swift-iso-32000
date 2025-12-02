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

        /// Create a document with a single page
        public init(
            version: Version = .default,
            page: Page,
            info: Info? = nil
        ) {
            self.version = version
            self.pages = [page]
            self.info = info
        }
    }
}

// MARK: - Document Info

extension ISO_32000 {
    /// Document information dictionary
    ///
    /// Per ISO 32000-1 Section 14.3.3, contains metadata about the document.
    public struct Info: Sendable {
        public var title: String?
        public var author: String?
        public var subject: String?
        public var keywords: String?
        public var creator: String?
        public var producer: String?
        public var creationDate: Date?
        public var modificationDate: Date?

        public init(
            title: String? = nil,
            author: String? = nil,
            subject: String? = nil,
            keywords: String? = nil,
            creator: String? = nil,
            producer: String? = nil,
            creationDate: Date? = nil,
            modificationDate: Date? = nil
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

        /// Simple date representation for PDF
        public struct Date: Sendable, Hashable {
            public var year: Int
            public var month: Int
            public var day: Int
            public var hour: Int
            public var minute: Int
            public var second: Int

            public init(
                year: Int,
                month: Int,
                day: Int,
                hour: Int = 0,
                minute: Int = 0,
                second: Int = 0
            ) {
                self.year = year
                self.month = month
                self.day = day
                self.hour = hour
                self.minute = minute
                self.second = second
            }

            /// Format as PDF date string: D:YYYYMMDDHHmmss
            public var pdfString: Swift.String {
                func pad(_ value: Int, width: Int) -> Swift.String {
                    var s = Swift.String(value)
                    while s.count < width {
                        s = "0" + s
                    }
                    return s
                }
                return "D:\(pad(year, width: 4))\(pad(month, width: 2))\(pad(day, width: 2))\(pad(hour, width: 2))\(pad(minute, width: 2))\(pad(second, width: 2))"
            }
        }
    }
}
