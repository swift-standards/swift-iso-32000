// ISO 32000-2:2020, 7.9 Common data structures
//
// Sections:
//   7.9.1  General
//   7.9.2  String object types
//   7.9.3  Text streams
//   7.9.4  Dates
//   7.9.5  Rectangles
//   7.9.6  Name trees
//   7.9.7  Number trees

public import ISO_32000_Shared

extension ISO_32000.`7` {
    /// ISO 32000-2:2020, 7.9 Common data structures
    public enum `9` {}
}

// MARK: - 7.9.4 Dates

extension ISO_32000.`7`.`9` {
    /// ISO 32000-2:2020, 7.9.4 Dates
    public enum `4` {}
}

extension ISO_32000.`7`.`9`.`4` {
    /// PDF Date representation
    ///
    /// Per ISO 32000-2 Section 7.9.4:
    /// > Date values used in a PDF file shall conform to a standard date format,
    /// > which closely follows that of the international standard ASN.1 (Abstract
    /// > Syntax Notation One). A date shall be a text string of the form:
    /// > `D:YYYYMMDDHHmmSSOHH'mm`
    ///
    /// ## Format Components
    ///
    /// - `YYYY`: Four-digit year
    /// - `MM`: Two-digit month (01–12)
    /// - `DD`: Two-digit day (01–31)
    /// - `HH`: Two-digit hour (00–23)
    /// - `mm`: Two-digit minute (00–59)
    /// - `SS`: Two-digit second (00–59)
    /// - `O`: Relationship to UTC (`+`, `-`, or `Z`)
    /// - `HH'mm`: Offset from UTC in hours and minutes
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.9.4 — Dates
    public struct Date: Sendable, Hashable {
        public var year: Int
        public var month: Int
        public var day: Int
        public var hour: Int
        public var minute: Int
        public var second: Int

        public init(
            year: Int,
            month: Int,
            day: Int,
            hour: Int = 0,
            minute: Int = 0,
            second: Int = 0
        ) {
            self.year = year
            self.month = month
            self.day = day
            self.hour = hour
            self.minute = minute
            self.second = second
        }
    }
}

extension ISO_32000.`7`.`9`.`4`.Date: CustomStringConvertible {
    /// Format as PDF date string: `D:YYYYMMDDHHmmss`
    public var description: Swift.String {
        func pad(_ value: Int, width: Int) -> Swift.String {
            var s = Swift.String(value)
            while s.count < width {
                s = "0" + s
            }
            return s
        }
        return "D:\(pad(year, width: 4))\(pad(month, width: 2))\(pad(day, width: 2))\(pad(hour, width: 2))\(pad(minute, width: 2))\(pad(second, width: 2))"
    }
}

// MARK: - 7.9.5 Rectangles

extension ISO_32000.`7`.`9` {
    /// ISO 32000-2:2020, 7.9.5 Rectangles
    public enum `5` {}
}

extension ISO_32000.`7`.`9`.`5` {
    /// PDF Point (x, y coordinate)
    ///
    /// All values are in default user space units (1/72 inch).
    /// In PDF's native coordinate system, the origin is at bottom-left
    /// with y increasing upward.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.9.5 — Rectangles (coordinate geometry)
    public struct Point: Sendable, Hashable, Codable {
        /// X coordinate in points
        public var x: Double

        /// Y coordinate in points
        public var y: Double

        /// Create a point
        public init(x: Double, y: Double) {
            self.x = x
            self.y = y
        }

        /// Origin point (0, 0)
        public static let zero = Self(x: 0, y: 0)

        /// Offset this point by the given amounts
        public func offset(x dx: Double = 0, y dy: Double = 0) -> Self {
            Self(x: x + dx, y: y + dy)
        }
    }
}

// MARK: - Point Coordinate Conversion

extension ISO_32000.`7`.`9`.`5`.Point {
    /// Create a point from top-left coordinates
    ///
    /// Converts from top-left origin (y increases downward) to
    /// PDF's bottom-left origin (y increases upward).
    ///
    /// - Parameters:
    ///   - x: X coordinate from left edge
    ///   - y: Y coordinate from top edge (increasing downward)
    ///   - pageHeight: Total page height for coordinate conversion
    public static func fromTopLeft(x: Double, y: Double, pageHeight: Double) -> Self {
        Self(x: x, y: pageHeight - y)
    }

    /// Convert to top-left coordinates
    ///
    /// Returns the y coordinate in top-left origin system (y increases downward).
    ///
    /// - Parameter pageHeight: Total page height for coordinate conversion
    /// - Returns: Y coordinate from top edge
    public func topLeftY(pageHeight: Double) -> Double {
        pageHeight - y
    }
}

extension ISO_32000.`7`.`9`.`5` {
    /// PDF Rectangle
    ///
    /// Per ISO 32000-2 Section 7.9.5:
    /// > Rectangles are used to describe locations on a page and bounding boxes
    /// > for a variety of objects. A rectangle shall be written as an array of
    /// > four numbers giving the coordinates of a pair of diagonally opposite
    /// > corners.
    ///
    /// The rectangle is defined by its lower-left and upper-right corners.
    /// Coordinates are in default user space units (1/72 inch).
    ///
    /// ## Corner Access
    ///
    /// ```swift
    /// let rect = Rectangle(x: 0, y: 0, width: 100, height: 50)
    ///
    /// rect.lower.left.x   // 0
    /// rect.lower.left.y   // 0
    /// rect.upper.right.x  // 100
    /// rect.upper.right.y  // 50
    ///
    /// // All four corners available:
    /// rect.lower.left.point   // Point(0, 0)
    /// rect.lower.right.point  // Point(100, 0)
    /// rect.upper.left.point   // Point(0, 50)
    /// rect.upper.right.point  // Point(100, 50)
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.9.5 — Rectangles
    public struct Rectangle: Sendable, Hashable, Codable {
        // Internal storage using PDF spec terminology
        public let llx: Double
        public let lly: Double
        public let urx: Double
        public let ury: Double

        /// Create a rectangle from corner coordinates
        public init(
            lowerLeftX: Double,
            lowerLeftY: Double,
            upperRightX: Double,
            upperRightY: Double
        ) {
            self.llx = lowerLeftX
            self.lly = lowerLeftY
            self.urx = upperRightX
            self.ury = upperRightY
        }
    }
}

// MARK: - Rectangle Convenience Initializers

extension ISO_32000.`7`.`9`.`5`.Rectangle {
    /// Create a rectangle from origin and size
    public init(x: Double, y: Double, width: Double, height: Double) {
        self.llx = x
        self.lly = y
        self.urx = x + width
        self.ury = y + height
    }

    /// Create a rectangle from origin point and size
    public init(origin: ISO_32000.`7`.`9`.`5`.Point, size: ISO_32000.Size) {
        self.llx = origin.x
        self.lly = origin.y
        self.urx = origin.x + size.width
        self.ury = origin.y + size.height
    }
}

// MARK: - Rectangle Properties

extension ISO_32000.`7`.`9`.`5`.Rectangle {
    /// Width of the rectangle
    public var width: Double { urx - llx }

    /// Height of the rectangle
    public var height: Double { ury - lly }

    /// Origin point (lower-left corner)
    ///
    /// Equivalent to `lower.left.point`
    public var origin: ISO_32000.`7`.`9`.`5`.Point {
        lower.left.point
    }

    /// The size of this rectangle
    public var size: ISO_32000.Size {
        .init(width: width, height: height)
    }
}

// MARK: - Rectangle Orientation

extension ISO_32000.`7`.`9`.`5`.Rectangle {
    /// Return the landscape version (width > height)
    ///
    /// Swaps width and height if currently in portrait orientation.
    /// Preserves the origin position.
    public var landscape: Self {
        if width >= height {
            return self
        }
        return Self(x: llx, y: lly, width: height, height: width)
    }

    /// Return the portrait version (height > width)
    ///
    /// Swaps width and height if currently in landscape orientation.
    /// Preserves the origin position.
    public var portrait: Self {
        if height >= width {
            return self
        }
        return Self(x: llx, y: lly, width: height, height: width)
    }
}

// MARK: - Rectangle Corner Access

extension ISO_32000.`7`.`9`.`5`.Rectangle {
    /// Access to lower edge coordinates
    public var lower: LowerEdge { LowerEdge(rectangle: self) }

    /// Access to upper edge coordinates
    public var upper: UpperEdge { UpperEdge(rectangle: self) }

    /// Lower edge accessor providing `.left` corner access
    public struct LowerEdge: Sendable {
        let rectangle: ISO_32000.`7`.`9`.`5`.Rectangle

        /// Lower-left corner
        public var left: Corner {
            Corner(x: rectangle.llx, y: rectangle.lly)
        }

        /// Lower-right corner
        public var right: Corner {
            Corner(x: rectangle.urx, y: rectangle.lly)
        }
    }

    /// Upper edge accessor providing `.right` corner access
    public struct UpperEdge: Sendable {
        let rectangle: ISO_32000.`7`.`9`.`5`.Rectangle

        /// Upper-left corner
        public var left: Corner {
            Corner(x: rectangle.llx, y: rectangle.ury)
        }

        /// Upper-right corner
        public var right: Corner {
            Corner(x: rectangle.urx, y: rectangle.ury)
        }
    }

    /// A corner with x and y coordinates
    public struct Corner: Sendable, Hashable {
        public let x: Double
        public let y: Double

        /// Convert to Point
        public var point: ISO_32000.`7`.`9`.`5`.Point {
            ISO_32000.`7`.`9`.`5`.Point(x: x, y: y)
        }
    }
}

// MARK: - Standard Paper Sizes (ISO 216 / ANSI)

extension ISO_32000.`7`.`9`.`5`.Rectangle {
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

// MARK: - Coordinate Conversion

extension ISO_32000.`7`.`9`.`5`.Rectangle {
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
        x: Double,
        y: Double,
        width: Double,
        height: Double,
        pageHeight: Double
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
    public func topLeftY(pageHeight: Double) -> Double {
        pageHeight - ury
    }

    /// The top-left corner point (in top-left coordinate system)
    ///
    /// - Parameter pageHeight: Total page height for coordinate conversion
    public func topLeftOrigin(pageHeight: Double) -> ISO_32000.`7`.`9`.`5`.Point {
        ISO_32000.`7`.`9`.`5`.Point(x: llx, y: pageHeight - ury)
    }
}

// MARK: - Functional Updates

extension ISO_32000.`7`.`9`.`5`.Rectangle {
    /// Create a new rectangle with a different lower-left corner
    public func with(lowerLeft point: ISO_32000.`7`.`9`.`5`.Point) -> Self {
        Self(
            lowerLeftX: point.x,
            lowerLeftY: point.y,
            upperRightX: urx,
            upperRightY: ury
        )
    }

    /// Create a new rectangle with a different upper-right corner
    public func with(upperRight point: ISO_32000.`7`.`9`.`5`.Point) -> Self {
        Self(
            lowerLeftX: llx,
            lowerLeftY: lly,
            upperRightX: point.x,
            upperRightY: point.y
        )
    }

    /// Create a new rectangle with a different width (expanding from lower-left)
    public func with(width: Double) -> Self {
        Self(
            lowerLeftX: llx,
            lowerLeftY: lly,
            upperRightX: llx + width,
            upperRightY: ury
        )
    }

    /// Create a new rectangle with a different height (expanding from lower-left)
    public func with(height: Double) -> Self {
        Self(
            lowerLeftX: llx,
            lowerLeftY: lly,
            upperRightX: urx,
            upperRightY: lly + height
        )
    }

    /// Create a new rectangle with a different size (expanding from lower-left)
    public func with(size: ISO_32000.Size) -> Self {
        Self(
            lowerLeftX: llx,
            lowerLeftY: lly,
            upperRightX: llx + size.width,
            upperRightY: lly + size.height
        )
    }

    /// Create a new rectangle offset by the given amounts
    public func offset(x: Double = 0, y: Double = 0) -> Self {
        Self(
            lowerLeftX: llx + x,
            lowerLeftY: lly + y,
            upperRightX: urx + x,
            upperRightY: ury + y
        )
    }

    /// Create a new rectangle inset by the given amounts
    public func inset(x: Double = 0, y: Double = 0) -> Self {
        Self(
            lowerLeftX: llx + x,
            lowerLeftY: lly + y,
            upperRightX: urx - x,
            upperRightY: ury - y
        )
    }
}
