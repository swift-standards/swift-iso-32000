// ISO_32000.Line.swift
// Generic line types (infinite Line and bounded LineSegment) parameterized by coordinate space

public import Geometry

extension ISO_32000 {
    /// An infinite line defined by a point and direction, parameterized by its coordinate space
    ///
    /// Useful for path operations, intersection calculations, and distance queries.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let line = ISO_32000.Line<UserSpace>(
    ///     from: .init(x: 0, y: 0),
    ///     to: .init(x: 100, y: 100)
    /// )
    /// let distance = line.distance(to: somePoint)
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.5.2 — Path construction operators
    public typealias Line<Space> = Geometry<Double, Space>.Line

    /// A bounded line segment defined by start and end points, parameterized by its coordinate space
    ///
    /// Useful for path construction, stroke operations, and distance calculations.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let segment = ISO_32000.LineSegment<UserSpace>(
    ///     start: .init(x: 0, y: 0),
    ///     end: .init(x: 100, y: 100)
    /// )
    /// let length = segment.length
    /// let midpoint = segment.midpoint
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.5.2 — Path construction operators
    public typealias LineSegment<Space> = Geometry<Double, Space>.LineSegment
}
