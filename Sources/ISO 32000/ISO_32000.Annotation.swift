// ISO_32000.Annotation.swift
// Typealias to authoritative implementation in Section 12.5

import ISO_32000_12_Interactive_features

extension ISO_32000 {
    /// PDF Annotation (Section 12.5)
    ///
    /// This is a typealias to the authoritative implementation in
    /// `ISO_32000.12.5.Annotation`.
    public typealias Annotation = ISO_32000.`12`.`5`.Annotation

    /// Link annotation (Section 12.5.6.4)
    ///
    /// This is a typealias to the authoritative implementation in
    /// `ISO_32000.12.5.6.4.LinkAnnotation`.
    public typealias LinkAnnotation = ISO_32000.`12`.`5`.`6`.`4`.LinkAnnotation
}

extension ISO_32000.Annotation {
    public typealias Link = ISO_32000.`12`.`5`.`6`.`4`.LinkAnnotation
}
