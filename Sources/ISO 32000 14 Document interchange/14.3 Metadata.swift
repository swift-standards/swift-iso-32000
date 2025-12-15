// ISO 32000-2:2020, 14.3 Metadata
//
// Sections:
//   14.3.1  General
//   14.3.2  Metadata streams
//   14.3.3  Document information dictionary

public import ISO_32000_7_Syntax
public import ISO_32000_Shared

extension ISO_32000.`14` {
    /// ISO 32000-2:2020, 14.3 Metadata
    public enum `3` {}
}

// MARK: - 14.3.3 Document Information Dictionary

extension ISO_32000.`14`.`3` {
    /// ISO 32000-2:2020, 14.3.3 Document information dictionary
    public enum `3` {}
}

extension ISO_32000.`14`.`3`.`3` {
    /// Document information dictionary
    ///
    /// Per ISO 32000-2 Section 14.3.3:
    /// > The optional Info entry in the trailer of a PDF file shall hold a
    /// > dictionary containing metadata for the document.
    ///
    /// ## Standard Entries
    ///
    /// - **Title**: Document's title
    /// - **Author**: Name of the person who created the document
    /// - **Subject**: Subject of the document
    /// - **Keywords**: Keywords associated with the document
    /// - **Creator**: Application that created the original document
    /// - **Producer**: Application that produced the PDF
    /// - **CreationDate**: Date and time of document creation
    /// - **ModDate**: Date and time of most recent modification
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 14.3.3 — Document information dictionary
    public struct Info: Sendable {
        /// Document's title
        public var title: String?

        /// Name of the person who created the document
        public var author: String?

        /// Subject of the document
        public var subject: String?

        /// Keywords associated with the document
        public var keywords: String?

        /// Application that created the original document
        public var creator: String?

        /// Application that produced the PDF
        public var producer: String?

        /// Date and time the document was created
        public var creationDate: ISO_32000.`7`.`9`.`4`.Date?

        /// Date and time the document was most recently modified
        public var modificationDate: ISO_32000.`7`.`9`.`4`.Date?

        /// Create a document information dictionary
        public init(
            title: String? = nil,
            author: String? = nil,
            subject: String? = nil,
            keywords: String? = nil,
            creator: String? = nil,
            producer: String? = nil,
            creationDate: ISO_32000.`7`.`9`.`4`.Date? = nil,
            modificationDate: ISO_32000.`7`.`9`.`4`.Date? = nil
        ) {
            self.title = title
            self.author = author
            self.subject = subject
            self.keywords = keywords
            self.creator = creator
            self.producer = producer
            self.creationDate = creationDate
            self.modificationDate = modificationDate
        }
    }
}

// 14.3 Metadata
// 14.3.1 General
// A PDF document may include general information, such as the document’s title, author, and creation
// and modification dates. Such global information about the document (as opposed to its actual content
// or structure) is called document metadata. Beginning with PDF 1.4, it is possible to include metadata
// for individual objects in a document. Such object-specific metadata is called object-level metadata.
// Metadata can be stored in a PDF document in the following ways:
// • For document data and for object-level metadata: In a metadata stream (PDF 1.4) associated with
// the document or a component of the document (14.3.2, "Metadata streams"). Metadata streams
// are the preferred method in PDF 2.0.
// • For document metadata only: In a document information dictionary associated with the document
// (14.3.3, "Document information dictionary"). Except for the CreationDate and ModDate entries,
// the use of the document information dictionary for document metadata is deprecated in PDF 2.0.
// PDF’s document information dictionaries provided the initial means of including metadata in a PDF
// file. When metadata streams began to be used in PDF 1.4, XMP was introduced to provide a much
// richer mechanism to represent metadata entries. Using XMP, a document’s title can be in more than
// one language or a document’s authors can be represented as a list. Machine-generated metadata for
// date and time of creation or last modification of a PDF document can adequately be represented in the
// document information dictionary and in the document’s metadata stream. In some cases document
// information dictionary entries are required, such as when PieceInfo dictionaries (see "14.5,
// "Page-
// piece dictionaries") are used; they can be present in both the document information dictionary and the
// document-level metadata stream as needed.
// 14.3.2 Metadata streams
// Metadata, both for an entire document and for objects within a document, can be stored in stream
// dictionaries (PDF 1.4). These streams are called metadata streams. Besides the entries common to all
// stream dictionaries (see "Table 5 — Entries common to all stream dictionaries"), a metadata stream
// dictionary shall contain the additional entries listed in "Table 347 — Additional entries in a metadata
// stream dictionary"
// .
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// © ISO 2020 – All rights reserved 715
// Table 347 — Additional entries in a metadata stream dictionary
// Key Type Value
// Type name (Required) The type of PDF object that this dictionary describes; shall
// be Metadata for a metadata stream.
// Subtype name (Required) The type of metadata stream that this dictionary describes;
// shall be XML.
// The contents of a metadata stream shall be the metadata represented in Extensible Markup Language
// (XML) and the grammar of the XML representing the metadata shall be defined according to the
// extensible metadata platform specification (ISO 16684-1).
// A metadata stream representing document-level metadata can be attached to a PDF document through
// the Metadata entry in the document catalog dictionary (see 7.7.2, "Document catalog dictionary").
// A metadata stream representing object-level metadata can be attached to the object through the
// Metadata entry in a stream or dictionary representing the object or associated with the object (see
// "Table 348 — Additional entry for components having metadata").
// Object level metadata can also be associated with marked-content within a content stream, by
// including a metadata stream in the property list dictionary for this marked-content. Because a stream
// dictionary is always an indirect object, a property list containing a metadata stream cannot be encoded
// inline in the content stream, but needs to be encoded as a named resource (see 14.6.2,
// "Property lists").
// In general, any PDF stream or dictionary may have metadata attached to it as long as the stream or
// dictionary represents an actual information resource. When there is ambiguity about exactly which
// stream or dictionary may bear the Metadata entry, the metadata shall be attached as closely as
// possible to the object that actually stores the data resource described.
// Table 348 — Additional entry for components having metadata
// Key Type Value
// Metadata stream (Optional; PDF 1.4) A metadata stream containing metadata for the
// component.
// NOTE 1 Metadata describing an ICCBased colour space would be attached to the ICC profile stream
// describing it, and metadata for embedded font files would be attached to font file streams rather
// than to font dictionaries. Metadata describing a tiling pattern would be attached to the pattern
// stream’s dictionary, but a shading needs to have metadata attached to the shading dictionary
// rather than to the shading pattern dictionary that refers to it.
// NOTE 2 In tables defining document objects, the Metadata entry is listed only for those document
// objects in which it is most likely to be used. However, a Metadata entry can appear in other
// objects as long as those objects are represented as streams or dictionaries.
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// 14.3.3 Document information dictionary
// The Info entry in the trailer of a PDF file (see 7.5.5, "File trailer") is optional. If present it shall hold a
// document information dictionary (see "Table 349 — Entries in the document information dictionary").
// Earlier versions of the PDF file format used the document information dictionary to represent
// document level metadata. In PDF 2.0 such use is deprecated except for two entries, CreationDate and
// ModDate. For any other document level metadata, a metadata stream (see 14.3.2 "Metadata streams")
// should be used instead.
// Where a document information dictionary contains keys other than CreationDate and ModDate, the
// value associated with any such key shall be a text string.
// Document information dictionaries are also used with Threads (see "Table 162 — Entries in a thread
// dictionary").
// Table 349 — Entries in the document information dictionary
// Key Type Value
// Title text string (Optional; PDF 1.1; deprecated in PDF 2.0) The document’s title.
// NOTE 1 The dc:title entry in the document’s metadata stream can be used to
// represent the document’s title.
// Author text string (Optional; deprecated in PDF 2.0) The name of the person who created
// the document.
// NOTE 2 The dc:creator entry in the document’s metadata stream can be
// used to represent the person or persons who created the document.
// This note was corrected in this document (2020).
// Subject text string (Optional; PDF 1.1; deprecated in PDF 2.0) The subject of the document.
// NOTE 3 The dc:description entry in the document’s metadata stream can be
// used to represent the subject the document.
// Keywords text string (Optional; PDF 1.1; deprecated in PDF 2.0) Keywords associated with
// the document.
// NOTE 4 The pdf:Keywords entry in the document’s metadata stream can be
// used to represent the keywords for the document.
// Creator text string (Optional; deprecated in PDF 2.0) If the document was converted to PDF
// from another format, the name of the PDF processor that created the
// original document from which it was converted.
// NOTE 5 The xmp:CreatorTool entry in the document’s metadata stream can
// be used to represent the creation tool of the document.
// Producer text string (Optional; deprecated in PDF 2.0) If the document was converted to PDF
// from another format, the name of the PDF processor that converted it
// to PDF.
// NOTE 6 The pdf:Producer entry in the document’s metadata stream can be
// used to represent the tool that saved the document as a PDF.
// 716 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// Key Type Value
// CreationDate date (Optional) The date and time the document was created, in human-
// readable form (see 7.9.4, "Dates").
// NOTE 7 The xmp:CreateDate entry in the document’s metadata stream can
// be used to represent document’s creation date and time.
// ModDate date (Required if PieceInfo is present in the document catalog dictionary;
// otherwise optional; PDF 1.1) The date and time the document was most
// recently modified, in human-readable form (see 7.9.4, "Dates").
// NOTE 8 The xmp:ModifyDate entry in the document’s metadata stream can
// be used to represent the date and time the document was most
// recently modified.
// Trapped name (Optional; PDF 1.3; deprecated in PDF 2.0) A name object indicating
// whether the document has been modified to include trapping
// information (see 14.11.6, "Trapping support"):
// True The document has been fully trapped; no further trapping
// shall be needed. This shall be the name True, not the
// boolean value true.
// False The document has not yet been trapped. This shall be the
// name False, not the boolean value false.
// Unknown Either it is unknown whether the document has been
// trapped or it has been partly but not yet fully trapped;
// some additional trapping may still be needed.
// Default value: Unknown.
// NOTE 9 The value of this entry can be set automatically by the software
// creating the document’s trapping information, or it can be known
// only to a human operator and entered manually.
// NOTE 10 The pdf:Trapped entry in the document’s metadata stream
// can be used to represent the trapping information for the document.
// EXAMPLE This example shows a document information dictionary containing just the creation and last modification
// date, together with the same document’s metadata stream containing the creation and last modification date
// and several other document level metadata fields.
// 101 0 obj %document information dictionary
// <</CreationDate (D:20140314124211+01'00)
/// ModDate (D:20140924212303+02'00)
// >>
// endobj
// 102 0 obj %document level metadata stream
// << /Type /Metadata
/// Subtype /XML
/// Length 103 0 R
// >>
// stream
// <?xpacket begin="Ôªø" id="W5M0MpCehiHzreSzNTczkc9d"?>
// <x:xmpmeta xmlns:x="adobe:ns:meta/" x:xmptk="My XMP Tool Kit v3.7">
// <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
// <rdf:Description rdf:about="" xmlns:xmp="http://ns.adobe.com/xap/1.0/">
// <xmp:CreateDate>2014-03-14T12:42:11+01:00</xmp:CreateDate>
// <xmp:ModifyDate>2014-09-24T21:23:03+02:00</xmp:ModifyDate>
// © ISO 2020 – All rights reserved 717
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// <xmp:CreatorTool>My Word Processor v10.7</xmp:CreatorTool>
// <xmp:MetadataDate>2014-09-24T21:23:03+02:00</xmp:MetadataDate>
// </rdf:Description>
// <rdf:Description rdf:about="" xmlns:pdf="http://ns.adobe.com/pdf/1.3/">
// <pdf:Producer>My Word Processor PDF Exporter Module v2.1</pdf:Producer>
// </rdf:Description>
// <rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/">
// <dc:format>application/pdf</dc:format>
// <dc:title>
// <rdf:Alt>
// <rdf:li xml:lang="x-default">Annual report 2014</rdf:li>
// <rdf:li xml:lang="en">Annual report 2014</rdf:li>
// <rdf:li xml:lang="de">Jahresbericht 2014</rdf:li>
// </rdf:Alt>
// </dc:title>
// <dc:creator>
// <rdf:Seq>
// <rdf:li>John Doe</rdf:li>
// <rdf:li>Mary Miller</rdf:li>
// </rdf:Seq>
// </dc:creator>
// </rdf:Description>
// </rdf:RDF>
// </x:xmpmeta>
// <?xpacket end="w"?>
// endstream
// endobj
// 14.3.4 Reconciling two sources of document metadata
// Information about time and date of creation might differ from the most recent modification of a PDF
// document. If this is the case, the following rules shall apply when writing a PDF document:
// • When writing the time and date of creation for the first time, typically when a new document is
// created, a PDF processor shall ensure that the data in the document information dictionary and
// the document level metadata stream – if both are written – are fully equivalent.
// • When writing modifications to an existing PDF document, if the PDF document already contains
// time and date of creation in both the document information dictionary and in the document’s
// metadata stream, and the two are not equivalent, a PDF processor should leave the inconsistent
// values unchanged.
// • When writing modifications to an existing PDF document, if the PDF document contains time and
// date of creation only in the document information dictionary or in the document’s metadata
// stream but not both, a PDF processor may add the information to the other, as long as both are
// fully equivalent.
// • When writing the time and date of the most recent modification, typically when an existing
// document has been modified, a PDF processor shall ensure that the data in the document
// information dictionary and the document level metadata stream – if both are written – are fully
// equivalent.
// If a PDF processor encounters inconsistent data for time and date of creation or for most recent
// modification in the document information dictionary and in the document’s metadata stream, it is at
// the discretion of the PDF processor how to use this data.
