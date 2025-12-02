// ISO_32000.swift

/// ISO 32000: Document management — Portable document format (PDF)
///
/// This package implements the PDF object model as defined in ISO 32000-1:2008
/// and ISO 32000-2:2020. PDF is a file format for representing documents in a
/// manner independent of application software, hardware, and operating systems.
///
/// ## Key Types
///
/// - ``COS``: Carousel Object System - the low-level PDF object types
/// - ``Document``: High-level document structure
/// - ``Page``: PDF page representation
/// - ``Writer``: Serializes documents to PDF bytes
///
/// ## Example
///
/// ```swift
/// let document = ISO_32000.Document(
///     pages: [
///         ISO_32000.Page(
///             mediaBox: .a4,
///             contents: ISO_32000.ContentStream {
///                 $0.beginText()
///                 $0.setFont(.helvetica, size: 12)
///                 $0.showText("Hello, World!")
///                 $0.endText()
///             }
///         )
///     ]
/// )
///
/// var pdf: [UInt8] = []
/// var writer = ISO_32000.Writer()
/// writer.write(document, into: &pdf)
/// ```
///
/// ## See Also
///
/// - [ISO 32000-2:2020](https://www.iso.org/standard/75839.html)
public enum ISO_32000 {}
