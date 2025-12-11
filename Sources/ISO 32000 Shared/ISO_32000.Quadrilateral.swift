// ISO_32000.Quadrilateral.swift
// Quadrilateral type for PDF quad points

public import Geometry

extension ISO_32000 {
    /// A quadrilateral defined by four points, parameterized by scalar type
    ///
    /// Used in PDF for QuadPoints entries that define regions of interest
    /// (e.g., for link annotations, text markup annotations, redaction annotations).
    ///
    /// Points are ordered clockwise starting from the bottom-left corner:
    /// - p1: bottom-left
    /// - p2: bottom-right
    /// - p3: top-right
    /// - p4: top-left
    public struct Quadrilateral<Scalar: Sendable & Hashable & Codable>: Sendable, Hashable, Codable {
        /// Bottom-left corner
        public var p1: ISO_32000.Point<Scalar>

        /// Bottom-right corner
        public var p2: ISO_32000.Point<Scalar>

        /// Top-right corner
        public var p3: ISO_32000.Point<Scalar>

        /// Top-left corner
        public var p4: ISO_32000.Point<Scalar>

        /// Creates a quadrilateral from four points
        public init(
            p1: ISO_32000.Point<Scalar>,
            p2: ISO_32000.Point<Scalar>,
            p3: ISO_32000.Point<Scalar>,
            p4: ISO_32000.Point<Scalar>
        ) {
            self.p1 = p1
            self.p2 = p2
            self.p3 = p3
            self.p4 = p4
        }

        /// Creates a quadrilateral from a rectangle
        ///
        /// The points are assigned clockwise starting from the bottom-left corner.
        public init(rectangle: Geometry<Scalar>.Rectangle) where Scalar: AdditiveArithmetic {
            self.p1 = ISO_32000.Point<Scalar>(x: rectangle.llx, y: rectangle.lly)  // bottom-left
            self.p2 = ISO_32000.Point<Scalar>(x: rectangle.urx, y: rectangle.lly)  // bottom-right
            self.p3 = ISO_32000.Point<Scalar>(x: rectangle.urx, y: rectangle.ury)  // top-right
            self.p4 = ISO_32000.Point<Scalar>(x: rectangle.llx, y: rectangle.ury)  // top-left
        }

        /// Returns the points as a flat array in PDF QuadPoints order
        ///
        /// PDF QuadPoints arrays are ordered as: x1, y1, x2, y2, x3, y3, x4, y4
        public var flattenedPoints: [Scalar] {
            [p1.x.value, p1.y.value, p2.x.value, p2.y.value, p3.x.value, p3.y.value, p4.x.value, p4.y.value]
        }
    }
}

extension ISO_32000.Quadrilateral where Scalar: Comparable & AdditiveArithmetic {
    /// The bounding rectangle of the quadrilateral
    public var boundingBox: Geometry<Scalar>.Rectangle {
        let minX = min(min(p1.x.value, p2.x.value), min(p3.x.value, p4.x.value))
        let maxX = max(max(p1.x.value, p2.x.value), max(p3.x.value, p4.x.value))
        let minY = min(min(p1.y.value, p2.y.value), min(p3.y.value, p4.y.value))
        let maxY = max(max(p1.y.value, p2.y.value), max(p3.y.value, p4.y.value))
        return Geometry<Scalar>.Rectangle(
            llx: Geometry<Scalar>.X(minX),
            lly: Geometry<Scalar>.Y(minY),
            urx: Geometry<Scalar>.X(maxX),
            ury: Geometry<Scalar>.Y(maxY)
        )
    }
}

// MARK: - Geometry Extension
// Provide access via Geometry namespace for compatibility

extension Geometry where Scalar: Sendable & Hashable & Codable {
    /// A quadrilateral defined by four points
    public typealias Quadrilateral = ISO_32000.Quadrilateral<Scalar>
}
