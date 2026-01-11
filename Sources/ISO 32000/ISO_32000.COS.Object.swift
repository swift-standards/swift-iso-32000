// ISO_32000.COS.Object.swift
// Object is defined in Section 7.3 and re-exported via COS typealias.
// This file provides additional COS.Object convenience initializers.

import ISO_32000_8_Graphics

@_spi(Internal) public import struct Geometry_Primitives.Tagged

// MARK: - Rectangle Conversions

extension ISO_32000.COS.Object {
    /// Create a COS array from a UserSpace rectangle
    ///
    /// PDF rectangles are represented as arrays of four numbers:
    /// `[llx lly urx ury]`
    ///
    /// - Parameter rect: The rectangle in user space coordinates
    public init(_ rect: ISO_32000.UserSpace.Rectangle) {
        self = .array([
            .real(rect.llx._rawValue),
            .real(rect.lly._rawValue),
            .real(rect.urx._rawValue),
            .real(rect.ury._rawValue),
        ])
    }
}
