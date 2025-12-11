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

// MARK: - Page Types (7.7.3)
// These are in Shared for cross-clause availability.
// The Page struct itself is in the main ISO_32000 module.

extension ISO_32000 {
    /// Page-related types namespace
    ///
    /// The Page struct is defined in the main ISO_32000 module.
    /// These nested types are defined here for cross-clause availability.
    public enum Page {}
}

extension ISO_32000.Page {
    /// Page boundary names for view/print area and clip settings (Table 147)
    ///
    /// The value is the key designating the relevant page boundary in the
    /// page object (see 7.7.3, "Page tree" and 14.11.2, "Page boundaries").
    ///
    /// - Note: PDF 1.4; deprecated in PDF 2.0
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 147 — ViewArea, ViewClip, PrintArea, PrintClip
    public enum Boundary: String, Sendable, Hashable, Codable, CaseIterable {
        /// The media box
        case mediaBox = "MediaBox"

        /// The crop box (default)
        case cropBox = "CropBox"

        /// The bleed box
        case bleedBox = "BleedBox"

        /// The trim box
        case trimBox = "TrimBox"

        /// The art box
        case artBox = "ArtBox"
    }
}

extension ISO_32000.Page {
    /// A range of pages for printing (Table 147)
    ///
    /// Specifies the first and last pages in a sub-range of pages to be printed.
    /// Page numbers are 1-based (the first page of the PDF file is denoted by 1).
    ///
    /// - Note: PDF 1.7. Although PrintPageRange uses 1-based page numbering,
    ///   other features of PDF use zero-based page numbering.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 147 — PrintPageRange
    public struct Range: Sendable, Hashable, Codable {
        /// The first page in the range (1-based)
        public var first: Int

        /// The last page in the range (1-based)
        public var last: Int

        /// Creates a page range.
        ///
        /// - Parameters:
        ///   - first: The first page (1-based)
        ///   - last: The last page (1-based)
        public init(first: Int, last: Int) {
            self.first = first
            self.last = last
        }

        /// Creates a single-page range.
        ///
        /// - Parameter page: The page number (1-based)
        public init(page: Int) {
            self.first = page
            self.last = page
        }
    }
}
