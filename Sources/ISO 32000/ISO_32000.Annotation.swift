// ISO_32000.Annotation.swift

extension ISO_32000 {
    /// PDF Annotation
    ///
    /// Per ISO 32000-1 Section 12.5, annotations are interactive elements
    /// associated with a page.
    public enum Annotation: Sendable {
        /// Link annotation with URI action
        case link(LinkAnnotation)
    }

    /// Link annotation
    ///
    /// A clickable region that opens a URI when clicked.
    public struct LinkAnnotation: Sendable {
        /// Rectangle defining the clickable area (in PDF coordinates, bottom-left origin)
        public var rect: Rectangle

        /// The URI to open
        public var uri: String

        /// Border style (default: no visible border)
        public var borderWidth: Double

        /// Create a link annotation
        public init(rect: Rectangle, uri: String, borderWidth: Double = 0) {
            self.rect = rect
            self.uri = uri
            self.borderWidth = borderWidth
        }
    }
}
