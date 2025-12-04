// ISO_32000.EdgeInsets.swift
// Generic edge insets (margins/padding) parameterized by unit type

public import Geometry

extension ISO_32000 {
    /// Edge insets representing margins or padding from rectangle edges,
    /// parameterized by its unit type
    ///
    /// Useful for defining page margins, content insets, bleed areas,
    /// and annotation padding.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let margins = ISO_32000.EdgeInsets<Double>(
    ///     top: 72,      // 1 inch
    ///     leading: 72,
    ///     bottom: 72,
    ///     trailing: 72
    /// )
    /// let contentArea = pageRect.inset(by: margins)
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 14.11.2 — Page boundaries
    public typealias EdgeInsets<Unit> = Geometry<Unit>.EdgeInsets
}
