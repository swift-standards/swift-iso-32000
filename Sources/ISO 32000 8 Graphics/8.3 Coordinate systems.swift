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
        x: ISO_32000.UserSpace.X,
        y: ISO_32000.UserSpace.Y,
        pageHeight: ISO_32000.UserSpace.Height
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
        pageHeight: ISO_32000.UserSpace.Height
    ) -> ISO_32000.UserSpace.Y {
        pageHeight - y
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
    ///   - topY: Distance from top edge (as Height displacement)
    ///   - width: Width of rectangle
    ///   - height: Height of rectangle
    ///   - pageTop: Y coordinate of page top edge
    public static func fromTopLeft(
        x: ISO_32000.UserSpace.X,
        topY: ISO_32000.UserSpace.Height,
        width: ISO_32000.UserSpace.Width,
        height: ISO_32000.UserSpace.Height,
        pageTop: ISO_32000.UserSpace.Y
    ) -> Self {
        // In top-left coords: topY is distance from top, rectangle extends downward
        // In bottom-left coords: need to find bottom-left corner
        let bottomLeftY: ISO_32000.UserSpace.Y = pageTop - topY - height
        return Self(
            x: x,
            y: bottomLeftY,
            width: width,
            height: height
        )
    }

    /// The distance from top edge to the rectangle's top edge
    ///
    /// - Parameter pageTop: Y coordinate of page top edge
    /// - Returns: Distance from top edge (as Height)
    public func topY(
        pageTop: ISO_32000.UserSpace.Y
    ) -> ISO_32000.UserSpace.Height {
        pageTop - ury
    }

    /// The top-left corner in top-left coordinate system
    ///
    /// - Parameter pageTop: Y coordinate of page top edge
    /// - Returns: Coordinate with x and distance from top as y
    public func topLeftOrigin(
        pageTop: ISO_32000.UserSpace.Y
    ) -> (x: ISO_32000.UserSpace.X, topY: ISO_32000.UserSpace.Height) {
        (x: llx, topY: pageTop - ury)
    }
}
