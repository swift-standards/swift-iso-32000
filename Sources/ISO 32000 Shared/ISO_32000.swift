// ISO 32000-2:2020 — Document management — Portable document format — Part 2: PDF 2.0

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

public import Geometry

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
    public enum UserSpace {}
}

// Minimal UserSpace types needed for cross-clause use.
// These MUST be in Shared to break circular dependencies.
// The authoritative documentation is in 8.3 Coordinate systems.

extension ISO_32000.UserSpace {
    /// User space unit (1/72 inch)
    ///
    /// Per ISO 32000-2:2020, Section 8.3.2.3, the default unit is 1/72 inch.
    public struct Unit: Sendable, Codable, Hashable, Comparable, AdditiveArithmetic,
        ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral
    {
        public var value: Double

        @inlinable public init(_ value: Double) { self.value = value }
        @inlinable public init(floatLiteral value: Double) { self.value = value }
        @inlinable public init(integerLiteral value: Int) { self.value = Double(value) }

        public static var zero: Self { Self(0) }
        @inlinable public static func + (lhs: Self, rhs: Self) -> Self { Self(lhs.value + rhs.value) }
        @inlinable public static func - (lhs: Self, rhs: Self) -> Self { Self(lhs.value - rhs.value) }
        @inlinable public static func < (lhs: Self, rhs: Self) -> Bool { lhs.value < rhs.value }
    }

    /// Rectangle in user space
    public typealias Rectangle = Geometry<Unit>.Rectangle

    /// Coordinate in user space
    public typealias Coordinate = ISO_32000.Point<Unit>

    /// X coordinate
    public typealias X = ISO_32000.X<Unit>

    /// Y coordinate
    public typealias Y = ISO_32000.Y<Unit>

    /// Width
    public typealias Width = ISO_32000.Width<Unit>

    /// Height
    public typealias Height = ISO_32000.Height<Unit>

    /// Size (width and height)
    public typealias Size = ISO_32000.Size<Unit>

    /// Edge insets
    public typealias EdgeInsets = Geometry<Unit>.EdgeInsets
}

