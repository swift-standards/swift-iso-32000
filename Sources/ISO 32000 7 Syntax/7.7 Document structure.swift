// ISO 32000-2:2020, 7.7 Document structure
//
// Sections:
//   7.7.1 General
//   7.7.2 Document catalog
//   7.7.3 Page tree
//   7.7.4 Inheritance of page attributes
//
// NOTE: The Page struct is defined in the main ISO_32000 module
// (ISO_32000.Page.swift) because it depends on types from multiple
// chapters (ContentStream, Resources, Annotation).

public import ISO_32000_Shared

extension ISO_32000.`7` {
    /// ISO 32000-2:2020, 7.7 Document structure
    public enum `7` {}
}

extension ISO_32000.`7`.`7` {
    /// ISO 32000-2:2020, 7.7.3 Page tree
    public enum `3` {}
}
