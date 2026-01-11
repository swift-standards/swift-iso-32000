// ISO_32000.Dimensions.swift
// Generic dimension types (X, Y, Width, Height) parameterized by coordinate space

public import Geometry_Primitives

extension ISO_32000 {
    /// A type-safe horizontal coordinate value, parameterized by its coordinate space
    ///
    /// Prevents accidentally mixing x and y coordinates at compile time.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.3 — Coordinate systems
    public typealias X<Space> = Geometry<Double, Space>.X

    /// A type-safe vertical coordinate value, parameterized by its coordinate space
    ///
    /// Prevents accidentally mixing x and y coordinates at compile time.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.3 — Coordinate systems
    public typealias Y<Space> = Geometry<Double, Space>.Y

    /// A type-safe width measurement, parameterized by its coordinate space
    ///
    /// Prevents accidentally mixing width and height at compile time.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.9.5 — Rectangles
    public typealias Width<Space> = Geometry<Double, Space>.Width

    /// A type-safe height measurement, parameterized by its coordinate space
    ///
    /// Prevents accidentally mixing width and height at compile time.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.9.5 — Rectangles
    public typealias Height<Space> = Geometry<Double, Space>.Height
}
