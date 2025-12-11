// ISO_32000.Point.swift
// Generic 2D point parameterized by coordinate space

public import Geometry

extension ISO_32000 {
    /// A generic 2D point parameterized by its coordinate space
    ///
    /// This generic structure can be specialized for different coordinate systems:
    /// - User space: `Point<UserSpace>` (default, 1/72 inch)
    /// - Device space: `Point<DeviceSpace>` (pixels)
    /// - Text space: `Point<TextSpace>`
    /// - Glyph space: `Point<GlyphSpace>`
    ///
    /// ## Example
    ///
    /// ```swift
    /// let coord: ISO_32000.Point<ISO_32000.UserSpace> = .init(x: 72, y: 144)
    /// // Or using the typealias:
    /// let coord: ISO_32000.UserSpace.Coordinate = .init(x: 72, y: 144)
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.3 — Coordinate systems
    public typealias Point<Space> = Geometry<Double, Space>.Point<2>
}
