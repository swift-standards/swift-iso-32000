// ISO_32000.UserSpace.swift
// Top-level typealiases for user space types

import ISO_32000_8_Graphics

extension ISO_32000 {
    /// User space namespace (Section 8.3.2.3)
    ///
    /// This is a typealias to the authoritative implementation in
    /// `ISO_32000.8.3.2.3.UserSpace`.
    ///
    /// Per ISO 32000-2:2020, Section 8.3.2.3, user space is a device-independent
    /// coordinate system with a default unit of 1/72 inch.
    public typealias UserSpace = `8`.`3`.`2`.`3`.UserSpace
}

extension ISO_32000 {
    /// A coordinate in user space (x, y in 1/72 inch units)
    ///
    /// This is a typealias to `ISO_32000.Point<UserSpace.Unit>`.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let origin: ISO_32000.Coordinate = .zero
    /// let position: ISO_32000.Coordinate = .init(x: 72, y: 144)
    /// ```
    public typealias Coordinate = UserSpace.Coordinate
}

// Note: We don't create top-level typealiases for Size and Rectangle
// to avoid confusion with the generic versions in ISO_32000_Shared.
// Use ISO_32000.UserSpace.Size and ISO_32000.UserSpace.Rectangle explicitly.
