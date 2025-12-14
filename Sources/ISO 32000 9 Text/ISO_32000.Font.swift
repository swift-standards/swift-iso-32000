// ISO_32000.Font.swift
// Typealias to authoritative implementation in Section 9.6


public import ISO_32000_Shared

extension ISO_32000 {
    /// PDF Font (Section 9.6 Simple fonts)
    ///
    /// This is a typealias to the authoritative implementation in
    /// `ISO_32000.9.6.Font`.
    public typealias Font = `9`.`6`.Font
}

extension ISO_32000 {
    /// Font design space (ISO 32000-2:2020, Section 9.8.3)
    ///
    /// Per ISO 32000-2:2020, Section 9.8.3, font metrics are specified in
    /// font design units. For Type 1 fonts, the em square is 1000 units.
    /// For TrueType fonts, it is typically 2048 units.
    ///
    /// Font design units are integer-valued (e.g., glyph widths like 556, 722).
    public typealias FontDesign = Geometry<Int, ISO_32000.`9`.`8`.FontDesign>
}
