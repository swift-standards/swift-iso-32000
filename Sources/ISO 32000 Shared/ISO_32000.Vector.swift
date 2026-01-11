// ISO_32000.Vector.swift
// Generic 2D displacement vector parameterized by coordinate space

public import Geometry_Primitives

extension ISO_32000 {
    /// A generic 2D displacement vector parameterized by its coordinate space
    ///
    /// Vectors represent displacement or direction, distinct from points which
    /// represent position. This generic structure can be specialized for different
    /// coordinate systems:
    /// - User space: `Vector<UserSpace>` (default, 1/72 inch)
    /// - Device space: `Vector<DeviceSpace>` (pixels)
    ///
    /// ## Example
    ///
    /// ```swift
    /// let offset: ISO_32000.Vector<UserSpace> = .init(dx: 10, dy: 20)
    /// let point = ISO_32000.Point<UserSpace>(x: 0, y: 0)
    /// let translated = point + offset
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.3 — Coordinate systems
    public typealias Vector<Space> = Geometry<Double, Space>.Vector<2>
}
