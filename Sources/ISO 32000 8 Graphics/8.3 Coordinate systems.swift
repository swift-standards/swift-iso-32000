// ISO 32000-2:2020, 8.3 Coordinate systems

public import Geometry
public import ISO_32000_Shared

extension ISO_32000.`8` {
    /// ISO 32000-2:2020, 8.3 Coordinate systems
    public enum `3` {}
}

extension ISO_32000.`8`.`3` {
    /// ISO 32000-2:2020, 8.3.2 Coordinate spaces
    public enum `2` {}
}

extension ISO_32000.`8`.`3`.`2` {
    /// ISO 32000-2:2020, 8.3.2.3 User space
    public enum `3` {}
}

// MARK: - 8.3.2.3 User Space

extension ISO_32000.`8`.`3`.`2`.`3` {
    /// User space (ISO 32000-2:2020, 8.3.2.3)
    ///
    /// Per ISO 32000-2:2020, Section 8.3.2.3, user space is a device-independent
    /// coordinate system that provides consistent positioning regardless of
    /// output device.
    ///
    /// The default unit is 1/72 inch, approximately the same as a typographer's point.
    public typealias UserSpace = ISO_32000.UserSpace
}

// MARK: - Core Type Aliases
// These types are defined in ISO_32000_Shared for cross-clause availability.
// We re-export them here under the section namespace for organizational clarity.

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace {
    /// User space unit - see ISO_32000.UserSpace.Unit
    public typealias Unit = ISO_32000.UserSpace.Unit

    /// Rectangle in user space
    public typealias Rectangle = ISO_32000.UserSpace.Rectangle

    /// Coordinate in user space
    public typealias Coordinate = ISO_32000.UserSpace.Coordinate

    /// Size in user space
    public typealias Size = ISO_32000.Size<Unit>

    /// X coordinate
    public typealias X = ISO_32000.UserSpace.X

    /// Y coordinate
    public typealias Y = ISO_32000.UserSpace.Y

    /// Width
    public typealias Width = ISO_32000.UserSpace.Width

    /// Height
    public typealias Height = ISO_32000.UserSpace.Height

    /// Edge insets
    public typealias EdgeInsets = ISO_32000.UserSpace.EdgeInsets

    /// Affine transformation matrix
    public typealias AffineTransform = ISO_32000.AffineTransform<Unit>

    /// Displacement vector
    public typealias Vector = ISO_32000.Vector<Unit>

    /// Infinite line
    public typealias Line = ISO_32000.Line<Unit>

    /// Line segment
    public typealias LineSegment = ISO_32000.LineSegment<Unit>
}

// MARK: - Unit Extensions (additional functionality beyond Shared)

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
    /// One inch (72 user space units)
    public static let inch: Self = 72

    /// Create from inches (1 inch = 72 units)
    @inlinable
    public static func inches(_ value: Double) -> Self { Self(value * 72) }

    /// Create from millimeters (1mm ≈ 2.83465 units)
    @inlinable
    public static func millimeters(_ value: Double) -> Self { Self(value * 2.83465) }

    /// Create from centimeters (1cm ≈ 28.3465 units)
    @inlinable
    public static func centimeters(_ value: Double) -> Self { Self(value * 28.3465) }

    /// Create from pixels at given DPI (default 96 DPI)
    @inlinable
    public static func pixels(_ value: Double, dpi: Double = 96) -> Self { Self(value * 72 / dpi) }

    /// The measurement in inches
    @inlinable
    public var inches: Double { value / 72 }

    /// The measurement in millimeters
    @inlinable
    public var millimeters: Double { value / 2.83465 }

    /// The measurement in centimeters
    @inlinable
    public var centimeters: Double { value / 28.3465 }

    /// Multiply by a scalar
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Self, rhs: Double) -> Self { Self(lhs.value * rhs) }

    /// Multiply scalar by unit
    @inlinable
    @_disfavoredOverload
    public static func * (lhs: Double, rhs: Self) -> Self { Self(lhs * rhs.value) }

    /// Divide by a scalar
    @inlinable
    @_disfavoredOverload
    public static func / (lhs: Self, rhs: Double) -> Self { Self(lhs.value / rhs) }

    /// Negate
    @inlinable
    @_disfavoredOverload
    public static prefix func - (value: Self) -> Self { Self(-value.value) }
}

// MARK: - Standard Paper Sizes (ISO 216 / ANSI)

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Rectangle {
    /// A4 paper size (210mm × 297mm)
    public static let a4 = Self(x: 0, y: 0, width: 595.276, height: 841.890)

    /// A3 paper size (297mm × 420mm)
    public static let a3 = Self(x: 0, y: 0, width: 841.890, height: 1190.551)

    /// A5 paper size (148mm × 210mm)
    public static let a5 = Self(x: 0, y: 0, width: 419.528, height: 595.276)

    /// US Letter size (8.5" × 11")
    public static let letter = Self(x: 0, y: 0, width: 612, height: 792)

    /// US Legal size (8.5" × 14")
    public static let legal = Self(x: 0, y: 0, width: 612, height: 1008)

    /// US Tabloid size (11" × 17")
    public static let tabloid = Self(x: 0, y: 0, width: 792, height: 1224)
}

// MARK: - Rectangle Orientation

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Rectangle {
    /// Return the landscape version (width > height)
    ///
    /// Swaps width and height if currently in portrait orientation.
    /// Preserves the origin position.
    public var landscape: Self {
        if width.value >= height.value {
            return self
        }
        return Self(x: llx, y: lly, width: .init(height.value), height: .init(width.value))
    }

    /// Return the portrait version (height > width)
    ///
    /// Swaps width and height if currently in landscape orientation.
    /// Preserves the origin position.
    public var portrait: Self {
        if height.value >= width.value {
            return self
        }
        return Self(x: llx, y: lly, width: .init(height.value), height: .init(width.value))
    }
}

// MARK: - AffineTransform Extensions for Unit
// These provide the FloatingPoint-like functionality needed for transforms

extension Geometry<ISO_32000.UserSpace.Unit>.AffineTransform {
    /// Create a translation transform
    @inlinable
    public static func translation(
        x: ISO_32000.UserSpace.Unit,
        y: ISO_32000.UserSpace.Unit
    ) -> Self {
        Self(a: .init(1), b: .init(0), c: .init(0), d: .init(1), tx: x, ty: y)
    }

    /// Create a scale transform
    @inlinable
    public static func scale(
        x: ISO_32000.UserSpace.Unit,
        y: ISO_32000.UserSpace.Unit
    ) -> Self {
        Self(a: x, b: .init(0), c: .init(0), d: y, tx: .init(0), ty: .init(0))
    }

    /// Concatenate with another transform (self * other)
    @inlinable
    public func concatenating(_ other: Self) -> Self {
        Self(
            a: .init(a.value * other.a.value + b.value * other.c.value),
            b: .init(a.value * other.b.value + b.value * other.d.value),
            c: .init(c.value * other.a.value + d.value * other.c.value),
            d: .init(c.value * other.b.value + d.value * other.d.value),
            tx: .init(tx.value * other.a.value + ty.value * other.c.value + other.tx.value),
            ty: .init(tx.value * other.b.value + ty.value * other.d.value + other.ty.value)
        )
    }
}

// MARK: - Coordinate Conversion

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Coordinate {
    /// Create a coordinate from top-left coordinates
    ///
    /// Converts from top-left origin (y increases downward) to
    /// PDF's bottom-left origin (y increases upward).
    ///
    /// - Parameters:
    ///   - x: X coordinate from left edge
    ///   - y: Y coordinate from top edge (increasing downward)
    ///   - pageHeight: Total page height for coordinate conversion
    public static func fromTopLeft(
        x: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit,
        y: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit,
        pageHeight: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit
    ) -> Self {
        Self(x: x, y: pageHeight - y)
    }

    /// Convert to top-left y coordinate
    ///
    /// Returns the y coordinate in top-left origin system (y increases downward).
    ///
    /// - Parameter pageHeight: Total page height for coordinate conversion
    /// - Returns: Y coordinate from top edge
    public func topLeftY(
        pageHeight: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit
    ) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
        pageHeight - y.value
    }
}

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Rectangle {
    /// Create a rectangle from top-left coordinates
    ///
    /// Converts from top-left origin (y increases downward) to
    /// PDF's bottom-left origin (y increases upward).
    ///
    /// - Parameters:
    ///   - x: X coordinate of top-left corner
    ///   - y: Y coordinate from top edge (increasing downward)
    ///   - width: Width of rectangle
    ///   - height: Height of rectangle
    ///   - pageHeight: Total page height for coordinate conversion
    public static func fromTopLeft(
        x: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit,
        y: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit,
        width: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit,
        height: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit,
        pageHeight: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit
    ) -> Self {
        // In top-left coords: y is distance from top, rectangle extends downward
        // In bottom-left coords: need to find bottom-left corner
        let bottomLeftY = pageHeight - y - height
        return Self(x: x, y: bottomLeftY, width: width, height: height)
    }

    /// The top-left Y coordinate (in top-left coordinate system)
    ///
    /// - Parameter pageHeight: Total page height for coordinate conversion
    /// - Returns: Y coordinate from top edge
    public func topLeftY(
        pageHeight: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit
    ) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Y {
        pageHeight - ury
    }

    /// The top-left corner coordinate (in top-left coordinate system)
    ///
    /// - Parameter pageHeight: Total page height for coordinate conversion
    public func topLeftOrigin(
        pageHeight: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit
    ) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Coordinate {
        ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Coordinate(x: llx, y: pageHeight - ury)
    }
}
