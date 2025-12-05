// ISO_32000.COS.Object.swift
// Object is defined in Section 7.3 and re-exported via COS typealias.
// This file provides additional COS.Object convenience initializers.

import ISO_32000_8_Graphics
public import Geometry

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
            .real(rect.llx.value.value),
            .real(rect.lly.value.value),
            .real(rect.urx.value.value),
            .real(rect.ury.value.value)
        ])
    }

    /// Create a COS array from a generic rectangle with Double units
    ///
    /// - Parameter rect: The rectangle with Double coordinates
    public init(_ rect: Geometry<Double>.Rectangle) {
        self = .array([
            .real(rect.llx.value),
            .real(rect.lly.value),
            .real(rect.urx.value),
            .real(rect.ury.value)
        ])
    }
}
