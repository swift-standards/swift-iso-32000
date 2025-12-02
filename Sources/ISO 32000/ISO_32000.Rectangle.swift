// ISO_32000.Rectangle.swift

extension ISO_32000 {
    /// PDF Rectangle
    ///
    /// Per ISO 32000-1 Section 7.9.5, a rectangle is an array of four numbers
    /// `[llx lly urx ury]` specifying the lower-left and upper-right corners.
    ///
    /// Coordinates are in default user space units (1/72 inch).
    public struct Rectangle: Sendable, Hashable, Codable {
        /// Lower-left X coordinate
        public let llx: Double

        /// Lower-left Y coordinate
        public let lly: Double

        /// Upper-right X coordinate
        public let urx: Double

        /// Upper-right Y coordinate
        public let ury: Double

        /// Create a rectangle from corner coordinates
        public init(llx: Double, lly: Double, urx: Double, ury: Double) {
            self.llx = llx
            self.lly = lly
            self.urx = urx
            self.ury = ury
        }

        /// Create a rectangle from origin and size
        public init(x: Double, y: Double, width: Double, height: Double) {
            self.llx = x
            self.lly = y
            self.urx = x + width
            self.ury = y + height
        }

        /// Width of the rectangle
        public var width: Double { urx - llx }

        /// Height of the rectangle
        public var height: Double { ury - lly }

        /// Convert to COS array
        public var asArray: COS.Object {
            .array([
                .real(llx),
                .real(lly),
                .real(urx),
                .real(ury)
            ])
        }
    }
}

// MARK: - Standard Paper Sizes

extension ISO_32000.Rectangle {
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
