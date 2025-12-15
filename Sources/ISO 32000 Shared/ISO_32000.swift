// ISO 32000-2:2020 — Document management — Portable document format — Part 2: PDF 2.0

public import Dimension
@_exported public import Geometry

/// The root namespace for ISO 32000-2:2020 (PDF 2.0) definitions.
///
/// ISO 32000 specifies a digital form for representing documents called the
/// Portable Document Format (PDF). This namespace provides Swift types that
/// encode the standard's definitions organized by clause:
///
/// - ``Clause7``: Syntax (objects, filters, file structure, encryption)
/// - ``Clause8``: Graphics (paths, colours, patterns, images, XObjects)
/// - ``Clause9``: Text (fonts, text operators, font descriptors)
/// - ``Clause10``: Rendering (halftones, transfer functions)
/// - ``Clause11``: Transparency (compositing, soft masks)
/// - ``Clause12``: Interactive features (annotations, actions, forms, signatures)
/// - ``Clause13``: Multimedia (sounds, movies, 3D artwork)
/// - ``Clause14``: Document interchange (metadata, tagged PDF, accessibility)
public enum ISO_32000 {}

// MARK: - User Space (8.3.2.3)

extension ISO_32000 {
    /// User space namespace (ISO 32000-2:2020, 8.3.2.3)
    ///
    /// Per ISO 32000-2:2020, Section 8.3.2.3, user space is a device-independent
    /// coordinate system that provides consistent positioning regardless of
    /// output device.
    ///
    /// The default unit is 1/72 inch, approximately the same as a typographer's point.
    ///
    /// - Note: Core types declared here for cross-clause availability.
    ///   The authoritative section is 8.3 Coordinate systems.
    public typealias UserSpace = Geometry<Double, ISO_32000_Shared.UserSpace>
}

/// PDF User Space coordinate system (ISO 32000-2:2020, 8.3.2.3)
///
/// Quantized to 0.01 points (1/7200 inch) to ensure adjacent
/// geometric elements share exact boundary values.
public enum UserSpace: Quantized {
    public typealias Scalar = Double
    public static var quantum: Double { 0.01 }
}

// Minimal UserSpace types needed for cross-clause use.
// These MUST be in Shared to break circular dependencies.
// The authoritative documentation is in 8.3 Coordinate systems.

// Note: Geometry.Unit typealias removed in favor of specific types:
// - Width/Height for dimensional measurements
// - Scale<1, Scalar> for dimensionless ratios
// - Opacity<Scalar> for 0-1 alpha values

extension ISO_32000.UserSpace {
    /// User space unit (1/72 inch) - Double tagged with UserSpace
    ///
    /// Per ISO 32000-2:2020, Section 8.3.2.3, the default unit is 1/72 inch.
    //    public typealias Unit = Tagged<ISO_32000_Shared.UserSpace, Double>

    /// Coordinate in user space (2D point)
    public typealias Coordinate = ISO_32000.Point<ISO_32000_Shared.UserSpace>
}

extension ISO_32000.UserSpace.Rectangle {
    /// The lower-left corner of the rectangle (PDF origin convention).
    public var origin: ISO_32000.UserSpace.Coordinate {
        .init(x: llx, y: lly)
    }
}
