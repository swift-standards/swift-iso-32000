// ISO_32000.Line.swift
// Generic line types (infinite Line and bounded LineSegment) parameterized by unit type

public import Geometry

extension ISO_32000 {
    /// An infinite line defined by a point and direction, parameterized by its unit type
    ///
    /// Useful for path operations, intersection calculations, and distance queries.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let line = ISO_32000.Line<Double>(
    ///     from: .init(x: 0, y: 0),
    ///     to: .init(x: 100, y: 100)
    /// )
    /// let distance = line.distance(to: somePoint)
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.5.2 — Path construction operators
    public typealias Line<Unit> = Geometry<Unit>.Line

    /// A bounded line segment defined by start and end points, parameterized by its unit type
    ///
    /// Useful for path construction, stroke operations, and distance calculations.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let segment = ISO_32000.LineSegment<Double>(
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
    public typealias LineSegment<Unit> = Geometry<Unit>.LineSegment
}
