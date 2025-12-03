// ISO_32000.Rectangle.swift
// Typealias to authoritative implementation in Section 7.9.5

import ISO_32000_7_Syntax

extension ISO_32000 {
    /// PDF Rectangle (Section 7.9.5)
    ///
    /// This is a typealias to the authoritative implementation in
    /// `ISO_32000.7.9.5.Rectangle`.
    public typealias Rectangle = `7`.`9`.`5`.Rectangle
}

// MARK: - COS Integration

extension ISO_32000.COS.Object {
    /// Create a COS array from a rectangle `[llx, lly, urx, ury]`
    public init(_ rectangle: ISO_32000.Rectangle) {
        self = [
            .real(rectangle.lower.left.x),
            .real(rectangle.lower.left.y),
            .real(rectangle.upper.right.x),
            .real(rectangle.upper.right.y)
        ]
    }
}

extension ISO_32000.Size {
    /// Create a size from a rectangle's dimensions
    public init(_ rectangle: ISO_32000.Rectangle) {
        self = ISO_32000.Size(
            width: rectangle.width,
            height: rectangle.height
        )
    }
}
