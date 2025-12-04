// ISO_32000.Vector.swift
// Generic 2D displacement vector parameterized by unit type

public import Geometry

extension ISO_32000 {
    /// A generic 2D displacement vector parameterized by its unit type
    ///
    /// Vectors represent displacement or direction, distinct from points which
    /// represent position. This generic structure can be specialized for different
    /// coordinate systems:
    /// - User space: `Vector<UserSpace.Unit>` (default, 1/72 inch)
    /// - Device space: `Vector<DeviceSpace.Unit>` (pixels)
    ///
    /// ## Example
    ///
    /// ```swift
    /// let offset: ISO_32000.Vector<Double> = .init(dx: 10, dy: 20)
    /// let point = ISO_32000.Point<Double>(x: 0, y: 0)
    /// let translated = point + offset
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.3 — Coordinate systems
    public typealias Vector<Unit> = Geometry<Unit>.Vector<2>
}
