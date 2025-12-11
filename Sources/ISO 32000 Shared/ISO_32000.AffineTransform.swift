// ISO_32000.AffineTransform.swift
// Generic 2D affine transformation parameterized by coordinate space

public import Geometry

extension ISO_32000 {
    /// A generic 2D affine transformation matrix parameterized by its coordinate space
    ///
    /// This generic structure can be specialized for different coordinate systems:
    /// - User space: `AffineTransform<UserSpace>` (default, 1/72 inch)
    /// - Device space: `AffineTransform<DeviceSpace>` (pixels)
    ///
    /// The matrix is represented as:
    /// ```
    /// | a  b  0 |
    /// | c  d  0 |
    /// | tx ty 1 |
    /// ```
    ///
    /// ## Example
    ///
    /// ```swift
    /// let transform = ISO_32000.AffineTransform<UserSpace>.identity
    ///     .translated(x: 100, y: 50)
    ///     .rotated(by: .fortyFive)
    ///     .scaled(by: 2.0)
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.3.3 — Common transformations
    public typealias AffineTransform<Space> = Affine<Double, Space>.Transform
}
