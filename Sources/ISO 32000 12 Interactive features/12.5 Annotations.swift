// ISO 32000-2:2020, 12.5 Annotations
//
// Sections:
//   12.5.1  General
//   12.5.2  Annotation flags
//   12.5.3  Border styles
//   12.5.4  Appearance streams
//   12.5.5  Appearance characteristics
//   12.5.6  Annotation types
//     12.5.6.1  General
//     12.5.6.2  Markup annotations
//     12.5.6.3  Text annotations
//     12.5.6.4  Link annotations
//     ...

public import ISO_32000_Shared
public import ISO_32000_8_Graphics
public import Geometry

extension ISO_32000.`12` {
    /// ISO 32000-2:2020, 12.5 Annotations
    public enum `5` {}
}

// MARK: - 12.5.6 Annotation Types

extension ISO_32000.`12`.`5` {
    /// Annotation types (Section 12.5.6)
    public enum `6` {}
}

extension ISO_32000.`12`.`5`.`6` {
    /// ISO 32000-2:2020, 12.5.6.4 Link annotations
    public enum `4` {}
}

// MARK: - Annotation Enum

extension ISO_32000.`12`.`5` {
    /// PDF Annotation
    ///
    /// Per ISO 32000-2 Section 12.5.1:
    /// > An annotation associates an object such as a note, sound, or movie with
    /// > a location on a page of a PDF document, or provides a way to interact
    /// > with the user by means of the mouse and keyboard.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 12.5 — Annotations
    public enum Annotation: Sendable {
        /// Link annotation with URI action (Section 12.5.6.4)
        case link(LinkAnnotation)
    }
}

// MARK: - Link Annotation

extension ISO_32000.`12`.`5`.`6`.`4` {
    /// Link annotation
    ///
    /// Per ISO 32000-2 Section 12.5.6.4:
    /// > A link annotation represents either a hypertext link to a destination
    /// > elsewhere in the document or an action to be performed.
    ///
    /// This implementation supports URI actions for external hyperlinks.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 12.5.6.4 — Link annotations
    public struct LinkAnnotation: Sendable {
        /// Rectangle defining the clickable area in user space coordinates
        ///
        /// Uses `UserSpace.Rectangle` to enforce type-safe coordinate handling.
        public var rect: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Rectangle

        /// The URI to open
        public var uri: String

        /// Border width in user space units (default: no visible border)
        public var borderWidth: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit

        /// Create a link annotation
        ///
        /// - Parameters:
        ///   - rect: The clickable area in user space coordinates
        ///   - uri: The URI to navigate to when clicked
        ///   - borderWidth: Border width in user space units (default: 0, no border)
        public init(
            rect: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Rectangle,
            uri: String,
            borderWidth: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit = 0
        ) {
            self.rect = rect
            self.uri = uri
            self.borderWidth = borderWidth
        }
    }
}

// MARK: - Convenience Typealias

extension ISO_32000.`12`.`5` {
    /// Link annotation (Section 12.5.6.4)
    public typealias LinkAnnotation = ISO_32000.`12`.`5`.`6`.`4`.LinkAnnotation
}
