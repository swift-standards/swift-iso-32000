// ISO 32000-2:2020, 8.3 Coordinate systems

public import ISO_32000_Shared
public import Geometry

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
    /// User space namespace
    ///
    /// Per ISO 32000-2:2020, Section 8.3.2.3, user space is a device-independent
    /// coordinate system that provides consistent positioning regardless of
    /// output device.
    public enum UserSpace {}
}

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace {
    /// User space unit (1/72 inch)
    ///
    /// Per ISO 32000-2:2020, Section 8.3.2.3:
    /// > The default for the size of the unit in default user space (UserUnit)
    /// > is 1⁄72 inch, approximately the same as a typographer's point.
    ///
    /// This type provides type-safety for measurements in PDF's default user space,
    /// distinguishing scalar size/distance values from raw `Double` values.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let fontSize: UserSpace.Unit = 12
    /// let margin = UserSpace.Unit.inches(1)  // 72 units
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.3.2.3 — User space
    public struct Unit: Sendable, Codable {
        /// The measurement value in user space units (1/72 inch)
        public let value: Double

        /// Create a user space unit measurement
        ///
        /// - Parameter value: The measurement in user space units (1/72 inch)
        @inlinable
        public init(_ value: Double) {
            self.value = value
        }
    }
}

// MARK: - AdditiveArithmetic

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit: AdditiveArithmetic {
    /// Zero
    public static var zero: Self { Self(0) }

    /// Add two measurements
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs.value + rhs.value)
    }

    /// Subtract two measurements
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs.value - rhs.value)
    }
}

// MARK: - Scalar Arithmetic

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
    /// Multiply by a scalar
    @inlinable
    public static func * (lhs: Self, rhs: Double) -> Self {
        Self(lhs.value * rhs)
    }

    /// Multiply scalar by unit
    @inlinable
    public static func * (lhs: Double, rhs: Self) -> Self {
        Self(lhs * rhs.value)
    }

    /// Divide by a scalar
    @inlinable
    public static func / (lhs: Self, rhs: Double) -> Self {
        Self(lhs.value / rhs)
    }

    /// Negate
    @inlinable
    public static prefix func - (value: Self) -> Self {
        Self(-value.value)
    }
}

// MARK: - Comparable

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit: Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - Hashable

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

// MARK: - Unit Constants

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
    /// One inch (72 user space units)
    ///
    /// Per ISO 32000-2:2020, Section 8.3.2.3:
    /// > The default for the size of the unit in default user space (UserUnit)
    /// > is 1⁄72 inch.
    public static let inch: Self = 72
}

// MARK: - Unit Conversions

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
    /// Create from inches (1 inch = 72 units)
    @inlinable
    public static func inches(_ value: Double) -> Self {
        Self(value * 72)
    }

    /// Create from millimeters (1mm ≈ 2.83465 units)
    @inlinable
    public static func millimeters(_ value: Double) -> Self {
        Self(value * 2.83465)
    }

    /// Create from centimeters (1cm ≈ 28.3465 units)
    @inlinable
    public static func centimeters(_ value: Double) -> Self {
        Self(value * 28.3465)
    }

    /// Create from pixels at given DPI (default 96 DPI: 1px = 0.75 units)
    @inlinable
    public static func pixels(_ value: Double, dpi: Double = 96) -> Self {
        Self(value * 72 / dpi)
    }

    /// The measurement in inches
    @inlinable
    public var inches: Double {
        value / 72
    }

    /// The measurement in millimeters
    @inlinable
    public var millimeters: Double {
        value / 2.83465
    }

    /// The measurement in centimeters
    @inlinable
    public var centimeters: Double {
        value / 28.3465
    }
}

// MARK: - ExpressibleByFloatLiteral

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: Double) {
        self.value = value
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Int) {
        self.value = Double(value)
    }
}

// MARK: - User Space Geometry Types

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace {
    /// A coordinate in user space
    ///
    /// A point defined by x and y values in user space units (1/72 inch).
    ///
    /// ## Example
    ///
    /// ```swift
    /// let origin: UserSpace.Coordinate = .zero
    /// let position = UserSpace.Coordinate(x: 72, y: 144)  // 1 inch right, 2 inches up
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.3.2.3 — User space
    public typealias Coordinate = ISO_32000.Point<ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit>

    /// A size in user space
    ///
    /// Width and height in user space units (1/72 inch).
    public typealias Size = ISO_32000.Size<ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit>

    /// A rectangle in user space
    ///
    /// Defined by lower-left and upper-right corners in user space units.
    public typealias Rectangle = ISO_32000.Rectangle<ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit>

    // MARK: - Transformations

    /// A 2D affine transformation matrix in user space
    ///
    /// Represents transformations that preserve parallel lines:
    /// translation, rotation, scaling, shearing, and combinations thereof.
    public typealias AffineTransform = ISO_32000.AffineTransform<ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit>

    // MARK: - Vectors & Angles

    /// A displacement vector in user space
    ///
    /// Represents direction and magnitude, distinct from position (Point).
    public typealias Vector = ISO_32000.Vector<ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit>

    // MARK: - Lines

    /// An infinite line in user space
    ///
    /// Defined by a point and direction vector.
    public typealias Line = ISO_32000.Line<ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit>

    /// A bounded line segment in user space
    ///
    /// Defined by start and end points.
    public typealias LineSegment = ISO_32000.LineSegment<ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit>

    // MARK: - Layout

    /// Edge insets (margins/padding) in user space
    ///
    /// Represents distances from rectangle edges for margins, padding, or insets.
    public typealias EdgeInsets = ISO_32000.EdgeInsets<ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit>

    // MARK: - Type-safe Dimensions

    /// A type-safe horizontal coordinate in user space
    public typealias X = ISO_32000.X<ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit>

    /// A type-safe vertical coordinate in user space
    public typealias Y = ISO_32000.Y<ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit>

    /// A type-safe width measurement in user space
    public typealias Width = ISO_32000.Width<ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit>

    /// A type-safe height measurement in user space
    public typealias Height = ISO_32000.Height<ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit>
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
        return Self(x: llx, y: lly, width: height.value, height: width.value)
    }

    /// Return the portrait version (height > width)
    ///
    /// Swaps width and height if currently in landscape orientation.
    /// Preserves the origin position.
    public var portrait: Self {
        if height.value >= width.value {
            return self
        }
        return Self(x: llx, y: lly, width: height.value, height: width.value)
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
    ) -> ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
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
