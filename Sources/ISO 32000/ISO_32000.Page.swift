// ISO_32000.Page.swift

extension ISO_32000 {
    /// A PDF page
    ///
    /// Per ISO 32000-1 Section 7.7.3.3, a page object contains the
    /// visible contents and attributes of a single page.
    public struct Page: Sendable {
        /// Page media box (page size)
        public var mediaBox: Rectangle

        /// Optional crop box (visible area)
        public var cropBox: Rectangle?

        /// Page rotation in degrees (0, 90, 180, 270)
        public var rotation: Int?

        /// Page content streams
        public var contents: [ContentStream]

        /// Page resources (fonts, etc.)
        public var resources: Resources

        /// Create a page
        public init(
            mediaBox: Rectangle = .a4,
            cropBox: Rectangle? = nil,
            rotation: Int? = nil,
            contents: [ContentStream] = [],
            resources: Resources = Resources()
        ) {
            self.mediaBox = mediaBox
            self.cropBox = cropBox
            self.rotation = rotation
            self.contents = contents
            self.resources = resources
        }

        /// Create a page with a single content stream
        public init(
            mediaBox: Rectangle = .a4,
            content: ContentStream,
            resources: Resources = Resources()
        ) {
            self.mediaBox = mediaBox
            self.cropBox = nil
            self.rotation = nil
            self.contents = [content]
            self.resources = resources
        }

        /// Create an empty page
        public static func empty(size: Rectangle = .a4) -> Page {
            Page(mediaBox: size)
        }
    }
}

// MARK: - Resources

extension ISO_32000 {
    /// Page resources
    ///
    /// Resources define fonts, images, and other objects available to
    /// the page content.
    public struct Resources: Sendable {
        /// Font dictionary: name -> font reference
        public var fonts: [COS.Name: Font]

        /// Create empty resources
        public init() {
            self.fonts = [:]
        }

        /// Create resources with fonts
        public init(fonts: [COS.Name: Font]) {
            self.fonts = fonts
        }

        /// Add a font and return its resource name
        @discardableResult
        public mutating func addFont(_ font: Font) -> COS.Name {
            let name = font.resourceName
            fonts[name] = font
            return name
        }
    }
}
