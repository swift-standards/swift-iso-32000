// ISO_32000.Dimensions.swift
// Generic dimension types (X, Y, Width, Height) parameterized by unit type

public import Geometry

extension ISO_32000 {
    /// A type-safe horizontal coordinate value, parameterized by its unit type
    ///
    /// Prevents accidentally mixing x and y coordinates at compile time.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.3 — Coordinate systems
    public typealias X<Unit> = Geometry<Unit>.X

    /// A type-safe vertical coordinate value, parameterized by its unit type
    ///
    /// Prevents accidentally mixing x and y coordinates at compile time.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.3 — Coordinate systems
    public typealias Y<Unit> = Geometry<Unit>.Y

    /// A type-safe width measurement, parameterized by its unit type
    ///
    /// Prevents accidentally mixing width and height at compile time.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.9.5 — Rectangles
    public typealias Width<Unit> = Geometry<Unit>.Width

    /// A type-safe height measurement, parameterized by its unit type
    ///
    /// Prevents accidentally mixing width and height at compile time.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.9.5 — Rectangles
    public typealias Height<Unit> = Geometry<Unit>.Height
}
