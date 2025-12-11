// ISO_32000.Page.swift
//
// Page is defined here in the main module because it depends on types
// from multiple chapters (ContentStream, Resources, Annotation).
// This file corresponds to ISO 32000-2:2020, 7.7.3 Page tree.

import ISO_32000_8_Graphics
public import ISO_32000_12_Interactive_features

// MARK: - Page (7.7.3)

extension ISO_32000 {
    /// A PDF page (ISO 32000-2:2020, 7.7.3)
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
        public var mediaBox: ISO_32000.UserSpace.Rectangle

        /// Crop box - visible region when displayed or printed
        ///
        /// Defaults to mediaBox if not specified.
        public var cropBox: ISO_32000.UserSpace.Rectangle?

        /// Bleed box - region to clip when output in production
        ///
        /// Defaults to cropBox if not specified.
        public var bleedBox: ISO_32000.UserSpace.Rectangle?

        /// Trim box - intended dimensions of finished page
        ///
        /// Defaults to cropBox if not specified.
        public var trimBox: ISO_32000.UserSpace.Rectangle?

        /// Art box - extent of meaningful content
        ///
        /// Defaults to cropBox if not specified.
        public var artBox: ISO_32000.UserSpace.Rectangle?

        // MARK: - Other Properties

        /// Page rotation in degrees (0, 90, 180, 270)
        public var rotation: Degree?

        /// Page content streams
        public var contents: [ISO_32000.ContentStream]

        /// Page resources (fonts, etc.)
        public var resources: ISO_32000.Resources

        /// Page annotations (links, text, etc.)
        public var annotations: [ISO_32000.Annotation]

        // MARK: - Initializers

        /// Create a page
        public init(
            mediaBox: ISO_32000.UserSpace.Rectangle = .a4,
            cropBox: ISO_32000.UserSpace.Rectangle? = nil,
            bleedBox: ISO_32000.UserSpace.Rectangle? = nil,
            trimBox: ISO_32000.UserSpace.Rectangle? = nil,
            artBox: ISO_32000.UserSpace.Rectangle? = nil,
            rotation: Degree? = nil,
            contents: [ISO_32000.ContentStream] = [],
            resources: ISO_32000.Resources = ISO_32000.Resources(),
            annotations: [ISO_32000.Annotation] = []
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
            mediaBox: ISO_32000.UserSpace.Rectangle = .a4,
            content: ISO_32000.ContentStream,
            resources: ISO_32000.Resources = ISO_32000.Resources(),
            annotations: [ISO_32000.Annotation] = []
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
        public static func empty(size: ISO_32000.UserSpace.Rectangle = .a4) -> Page {
            Page(mediaBox: size)
        }
    }
}

// MARK: - Typealiases for Nested Types

extension ISO_32000.Page {
    /// Page boundary names (Table 147)
    public typealias Boundary = ISO_32000.`12`.`2`.Boundary

    /// Page range for printing (Table 147)
    public typealias Range = ISO_32000.`12`.`2`.PageRange
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
