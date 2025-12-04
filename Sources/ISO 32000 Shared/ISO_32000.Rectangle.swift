// ISO_32000.Rectangle.swift
// Generic rectangle parameterized by unit type

public import Geometry

extension ISO_32000 {
    /// A generic rectangle parameterized by its unit type
    ///
    /// Defined by lower-left and upper-right corners, this structure can be
    /// specialized for different coordinate systems.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let rect: ISO_32000.Rectangle<ISO_32000.UserSpace.Unit> = .init(
    ///     x: 0, y: 0, width: 595, height: 842
    /// )
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.9.5 — Rectangles
    public typealias Rectangle<Unit> = Geometry<Unit>.Rectangle
}
