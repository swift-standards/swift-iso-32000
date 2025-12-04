// ISO_32000.Page.swift

import ISO_32000_8_Graphics
public import Geometry

extension ISO_32000 {
    /// A PDF page
    ///
    /// Per ISO 32000-1 Section 7.7.3.3, a page object contains the
    /// visible contents and attributes of a single page.
    ///
    /// ## Page Boxes (Section 14.11.2)
    ///
    /// PDF defines five page boundary boxes:
    /// - **mediaBox**: Physical medium size (required)
    /// - **cropBox**: Visible region when displayed/printed (defaults to mediaBox)
    /// - **bleedBox**: Region for production clipping (defaults to cropBox)
    /// - **trimBox**: Intended finished page dimensions (defaults to cropBox)
    /// - **artBox**: Meaningful content extent (defaults to cropBox)
    public struct Page: Sendable {
        // MARK: - Page Boxes (Section 14.11.2)

        /// Media box - boundaries of physical medium (required)
        ///
        /// Defines the size of the page. Origin is at lower-left.
        public var mediaBox: UserSpace.Rectangle

        /// Crop box - visible region when displayed or printed
        ///
        /// Defaults to mediaBox if not specified.
        public var cropBox: UserSpace.Rectangle?

        /// Bleed box - region to clip when output in production
        ///
        /// Defaults to cropBox if not specified.
        public var bleedBox: UserSpace.Rectangle?

        /// Trim box - intended dimensions of finished page
        ///
        /// Defaults to cropBox if not specified.
        public var trimBox: UserSpace.Rectangle?

        /// Art box - extent of meaningful content
        ///
        /// Defaults to cropBox if not specified.
        public var artBox: UserSpace.Rectangle?

        // MARK: - Other Properties

        /// Page rotation in degrees (0, 90, 180, 270)
        public var rotation: Int?

        /// Page content streams
        public var contents: [ContentStream]

        /// Page resources (fonts, etc.)
        public var resources: Resources

        /// Page annotations (links, etc.)
        public var annotations: [Annotation]

        // MARK: - Initializers

        /// Create a page
        public init(
            mediaBox: UserSpace.Rectangle = .a4,
            cropBox: UserSpace.Rectangle? = nil,
            bleedBox: UserSpace.Rectangle? = nil,
            trimBox: UserSpace.Rectangle? = nil,
            artBox: UserSpace.Rectangle? = nil,
            rotation: Int? = nil,
            contents: [ContentStream] = [],
            resources: Resources = Resources(),
            annotations: [Annotation] = []
        ) {
            self.mediaBox = mediaBox
            self.cropBox = cropBox
            self.bleedBox = bleedBox
            self.trimBox = trimBox
            self.artBox = artBox
            self.rotation = rotation
            self.contents = contents
            self.resources = resources
            self.annotations = annotations
        }

        /// Create a page with a single content stream
        public init(
            mediaBox: UserSpace.Rectangle = .a4,
            content: ContentStream,
            resources: Resources = Resources(),
            annotations: [Annotation] = []
        ) {
            self.mediaBox = mediaBox
            self.cropBox = nil
            self.bleedBox = nil
            self.trimBox = nil
            self.artBox = nil
            self.rotation = nil
            self.contents = [content]
            self.resources = resources
            self.annotations = annotations
        }

        /// Create an empty page
        public static func empty(size: UserSpace.Rectangle = .a4) -> Page {
            Page(mediaBox: size)
        }
    }
}

// MARK: - Convenience Properties

extension ISO_32000.Page {
    /// Page width (from mediaBox)
    public var width: ISO_32000.UserSpace.Unit { mediaBox.width.value }

    /// Page height (from mediaBox)
    public var height: ISO_32000.UserSpace.Unit { mediaBox.height.value }

    /// Effective crop box (cropBox or mediaBox if not set)
    public var effectiveCropBox: ISO_32000.UserSpace.Rectangle {
        cropBox ?? mediaBox
    }

    /// Effective bleed box (bleedBox or effectiveCropBox if not set)
    public var effectiveBleedBox: ISO_32000.UserSpace.Rectangle {
        bleedBox ?? effectiveCropBox
    }

    /// Effective trim box (trimBox or effectiveCropBox if not set)
    public var effectiveTrimBox: ISO_32000.UserSpace.Rectangle {
        trimBox ?? effectiveCropBox
    }

    /// Effective art box (artBox or effectiveCropBox if not set)
    public var effectiveArtBox: ISO_32000.UserSpace.Rectangle {
        artBox ?? effectiveCropBox
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
