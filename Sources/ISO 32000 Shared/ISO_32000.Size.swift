// ISO_32000.Size.swift
// Generic size parameterized by unit type

public import Geometry

extension ISO_32000 {
    /// A generic 2D size parameterized by its unit type
    ///
    /// This generic structure can be specialized for different coordinate systems.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let pageSize: ISO_32000.Size<ISO_32000.UserSpace.Unit> = .init(width: 595, height: 842)
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.3 — Coordinate systems
    public typealias Size<Unit> = Geometry<Unit>.Size<2>
}
