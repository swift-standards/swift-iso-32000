// ISO 32000-2:2020, 8.3 Coordinate systems

import Dimension_Primitives
public import Geometry_Primitives
public import ISO_32000_Shared

@_spi(Internal) import struct Dimension_Primitives.Tagged

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

// MARK: - Length/Width/Height Unit Conversions

extension ISO_32000.UserSpace.Length {
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
    public var inches: Self { Self(_rawValue / 72) }

    /// The measurement in millimeters
    @inlinable
    public var millimeters: Self { Self(_rawValue / 2.83465) }

    /// The measurement in centimeters
    @inlinable
    public var centimeters: Self { Self(_rawValue / 28.3465) }
}

extension ISO_32000.UserSpace.Width {
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
}

extension ISO_32000.UserSpace.Height {
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
    public var landscape: Self {
        // Compare raw values since Extent.X and Extent.Y are different types
        if width >= height { return self }
        var result = self
        // Retag: Y extent becomes X, X extent becomes Y
        result.halfExtents = Geometry.Size(
            width: halfExtents.height.retag(Extent.X<UserSpace>.self),
            height: halfExtents.width.retag(Extent.Y<UserSpace>.self)
        )
        return result
    }

    /// Return the portrait version (height > width)
    public var portrait: Self {
        if height >= width { return self }
        var result = self
        result.halfExtents = Geometry.Size(
            width: halfExtents.height.retag(Extent.X<UserSpace>.self),
            height: halfExtents.width.retag(Extent.Y<UserSpace>.self)
        )
        return result
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
    ///   - topY: Y displacement from top edge (increasing downward)
    ///   - pageTop: Y coordinate of the page top edge
    public static func fromTopLeft(
        x: ISO_32000.UserSpace.X,
        topY: ISO_32000.UserSpace.Dy,
        pageTop: ISO_32000.UserSpace.Y
    ) -> Self {
        Self(x: x, y: pageTop - topY)
    }

    /// Convert to top-left y displacement
    ///
    /// Returns the y displacement from the top edge (y increases downward).
    ///
    /// - Parameter pageTop: Y coordinate of the page top edge
    /// - Returns: Y displacement from top edge
    public func topLeftY(
        pageTop: ISO_32000.UserSpace.Y
    ) -> ISO_32000.UserSpace.Dy {
        pageTop - y
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
    ///   - topY: Y displacement from top edge (downward)
    ///   - width: Width of rectangle
    ///   - height: Height of rectangle
    ///   - pageTop: Y coordinate of page top edge
    public static func fromTopLeft(
        x: ISO_32000.UserSpace.X,
        topY: ISO_32000.UserSpace.Dy,
        width: ISO_32000.UserSpace.Width,
        height: ISO_32000.UserSpace.Height,
        pageTop: ISO_32000.UserSpace.Y
    ) -> Self {
        // In top-left coords: topY is displacement from top, rectangle extends downward
        // In bottom-left coords: need to find bottom-left corner
        // bottomLeftY = pageTop - topY - height
        let topLeftY: ISO_32000.UserSpace.Y = pageTop - topY
        let bottomLeftY: ISO_32000.UserSpace.Y =
            topLeftY - height.retag(Displacement.Y<UserSpace>.self)
        return Self(
            x: x,
            y: bottomLeftY,
            width: width,
            height: height
        )
    }

    /// The displacement from top edge to the rectangle's top edge
    ///
    /// - Parameter pageTop: Y coordinate of page top edge
    /// - Returns: Y displacement from top edge
    public func topY(
        pageTop: ISO_32000.UserSpace.Y
    ) -> ISO_32000.UserSpace.Dy {
        pageTop - ury
    }

    /// The top-left corner in top-left coordinate system
    ///
    /// - Parameter pageTop: Y coordinate of page top edge
    /// - Returns: Coordinate with x and displacement from top as y
    public func topLeftOrigin(
        pageTop: ISO_32000.UserSpace.Y
    ) -> (x: ISO_32000.UserSpace.X, topY: ISO_32000.UserSpace.Dy) {
        (x: llx, topY: pageTop - ury)
    }
}
