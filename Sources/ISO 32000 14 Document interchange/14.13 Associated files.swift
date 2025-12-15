// ISO 32000-2:2020, 14.13 Associated files

import ISO_32000_Shared

// 14.13 Associated files
// 14.13.1 General
// Associated files provide a means to associate content in other formats with objects of a PDF file and to
// identify the relationship between them. Such associated files are designated using file specification
// dictionaries (see 7.11.3, "File specification dictionaries"), and AF keys are used in object dictionaries to
// connect the associated file’s specification dictionaries with those objects. Some PDF objects that can
// provide the AF keys are:
// • the PDF document catalog dictionary (14.13.3, "Associated files linked to the PDF document’s
// catalog")
// • a page dictionary (14.13.4, "Associated files linked to a page dictionary")
// • a graphics object (using a marked-content property list dictionary, 14.13.5, "Associated files
// linked to graphics objects")
// • a structure element dictionary (14.13.6, "Associated files linked to structure elements")
// • an XObject dictionary (14.13.7, "Associated files linked to XObjects")
// • a DParts dictionary (14.13.8, "Associated files linked to DParts")
// • an annotation dictionary (14.13.9, "Associated files linked to an annotation dictionary")
// • a metadata stream dictionary (14.3.2, "Metadata streams")
// For associated files, their associated file specification dictionaries should include the AFRelationship
// key indicating one of several possible relationships that the file has to the associated PDF object (See
// 7.11.3, "File specification dictionaries").
// NOTE This document clarified the above paragraph (2020).
// 14.13.2 Embedded associated files
// The file specification for an associated file represents either a file external to the PDF file or an
// embedded file stream (see 7.11.4, "Embedded file streams") within the PDF file.
// NOTE 1 A file specification dictionary allows for both embedded data (via the EF key) and
// referenced/external data (via the F and UF keys). Both types are allowed for associated files but
// the embedded form is recommended.
// When using an embedded file stream as an associated file, its dictionary should contain a Params key
// whose value shall be a dictionary containing at least a ModDate key whose value shall be the latest
// modification date of the source file. (See "Table 44 — Additional entries in an embedded file stream
// dictionary" and "Table 45 — Entries in an embedded file parameter dictionary"). The embedded file
// stream dictionary shall include a valid MIME type value for the Subtype key. If the MIME type is not
// known, the value "application/octet-stream" shall be used.
// NOTE 2 As described in Internet RFC 2046, 4.5.1, the "octet-stream" subtype indicates arbitrary binary
// data.
// 838 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// In addition, an embedded file stream may be referenced from the document’s EmbeddedFiles names
// tree (see the EmbeddedFiles key in 7.7.4, "Name dictionary").
// NOTE 3 Doing so will enable a user to extract the file directly as any other attachment to the document
// and also allow it to be considered when doing an "attachments only" encryption.
// EXAMPLE A PDF document is to be created from a text processing application file that contains textual content, a
// mathematical equation, and a chart derived from a spreadsheet application. In this case the resulting PDF
// document might contain the following embedded files:
// ▪ Text processing application file embedded with an AFRelationship value Source and associated with
// the document catalog
// ▪ MathML version of the equation embedded with an AFRelationship value Supplement, and
// associated using a structure element or a form XObject depending on how the equation is rendered
// in the page’s content stream.
// ▪ Spreadsheet application file embedded with a AFRelationship value Source and associated with the
// Image or form XObject presenting the chart.
// ▪ CSV file embedded with a AFRelationship value Data and associated with the Image or form XObject
// for presenting the chart.
// 14.13.3 Associated files linked to the PDF document’s catalog
// One or more files may be associated with the PDF document as a whole by including a file specification
// dictionary (7.11.3, "File specification dictionaries") for each file as one of the members of the array
// value of the AF key in the document catalog (7.7.2, "Document catalog dictionary"). The relationship
// that the associated files have to the PDF document is supplied by the AFRelationship key in each file
// specification dictionary.
// 14.13.4 Associated files linked to a page dictionary
// One or more files may be associated with any PDF page by including a file specification dictionary
// (7.11.3, "File specification dictionaries") for each file as one of the members of the array value of the AF
// key in the appropriate page dictionary (7.7.3.3, "Page objects"). The relationship that the associated
// files have to the page is supplied by the AFRelationship key in each file specification dictionary.
// NOTE Associated files serve not only as alternative to PieceInfo (which is vendor specific) but also
// enable richer semantic content when doing page/document merging or conversion of simple
// page-based elements (e.g., images).
// 14.13.5 Associated files linked to graphics objects
// One or more files may be associated with sections of content in a content stream by enclosing those
// sections between the marked-content operators BDC and EMC (see 14.6, "Marked content") with a
// marked-content tag of AF.
// NOTE 1 This applies to a page’s content stream, a form or pattern’s content stream, glyph descriptions in
// a Type 3 font as specified by its CharProcs entry, or an annotation’s appearance (AP).
// NOTE 2 The BMC operator does not take properties and therefore cannot be used with the AF key.
// Unlike other types of marked-content tags, the DP or MP marked-content operators shall not be used
// with the AF tag when that tag is used to refer to a file specification dictionary.
// © ISO 2020 – All rights reserved 839
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// Goto errata
// NOTE 3 The combination of a DP or MP operator with an AF tag (when used to refer to a file
// specification dictionary) is forbidden, as these operators only mark a single point and thus don’t
// enable connections between any specific sequence of content operators and their associated file.
// The property list associated with the marked-content shall specify an array of file specification
// dictionaries to which the content is associated. The named resource in the Property List (see 14.6.2,
// "Property lists") shall specify an array of file specification dictionaries to which the content is
// associated. The relationship that the associated files have to the PDF content is supplied by the
// AFRelationship key in each file specification dictionary.
// Although the marked-content tag shall be AF, other applications of marked-content are not precluded
// from using AF as a tag. The marked-content is connected with associated files only if the tag is AF and
// the property list is defined as a valid array of file specification dictionaries. To avoid conflict with other
// features that use marked-content, such as 14.7, "Logical structure"
// , where content is to be tagged with
// source content markers as well as other markers, the other markers should be nested inside the source
// content markers.
// When writing a PDF, the use of structure and associating the AF with the structure element (see
// 14.13.6, "Associated files linked to structure elements") is preferred instead of the use of explicit
// marked-content.
// 14.13.6 Associated files linked to structure elements
// One or more files may be associated with structure elements (see 14.7.2, "Structure hierarchy") to
// accommodate content that spans pages such as in an article, section or table, in which cases logical
// structural elements should be used to make an association with files. This entry represents the
// associated files for the entire structure element. To associate files with structure elements, the
// structure element dictionary shall contain an AF entry which represents the associated files for that
// structure element. The relationship that the associated files have to the structure element is supplied
// by the AFRelationship key in each file specification dictionary.
// 14.13.7 Associated files linked to XObjects
// One or more files may be associated with Type 1 form XObjects and image XObjects (see 8.8, "External
// objects"). To associate files with XObjects, the XObject stream dictionary shall contain an AF entry
// whose value is an array of file specification dictionaries. This entry represents the associated files for
// the entire XObject. The relationship that the associated files have to the XObject is supplied by the
// AFRelationship key in each file specification dictionary.
// 14.13.8 Associated files linked to DParts
// One or more files may be associated with any DPart (see 14.12, "Document parts"). To associate files
// with a DPart, the appropriate DPart dictionary shall contain an AF entry whose value is an array of file
// specification dictionaries. This entry represents the associated files for the entire DPart. The
// relationship that the associated files have to the DPart is supplied by the AFRelationship key in each
// file specification dictionary.
// NOTE This could be useful when merging multiple documents together, the original PDF or even the
// original source material could be embedded here.
// 840 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// 14.13.9 Associated files linked to an annotation dictionary
// One or more files may be associated with annotations.
// NOTE For some annotation types (such as 13.7.2, "RichMedia annotations") it is useful to have the data
// used for dynamic rendering be easily identifiable by a reader.
// To associate files with annotations, the annotation dictionary shall contain an AF entry which
// represents the associated files for that annotation. The relationship that the associated files have to the
// annotation is supplied by the AFRelationship key in each file specification dictionary.
// 14.13.10 Associated file examples
// EXAMPLE 1 Associated file linked to the PDF document as a whole
// 19 0 obj %Document Catalog
// <<
/// Type /Catalog
/// Pages 6 0 R
/// Names 30 0 R
/// Metadata 11 0 R
/// AF [20 0 R]
// >>
// 20 0 obj %File Specification Dictionary
// <<
/// Type /Filespec
/// F (My Presentation.ppt)
/// UF (My Presentation.ppt)
/// AFRelationship /Source
/// EF <</F 21 0 R>>
// >>
// endobj
// 21 0 obj %embedded file stream
// <<
/// Filter /FlateDecode
/// Length 1975
/// Type /EmbeddedFile
/// Subtype /application#2Fvnd.ms-powerpoint
/// Params
// <<
/// CheckSum <ad032d7a6ea930489df4bfd6acb585b9>
/// Size 3979
/// CreationDate (D:20010727133719)
/// ModDate (D:20010727133720)
// >>
// >>
// stream
// …
// endstream
// endobj
// EXAMPLE 2 Associated file linked to a Content Stream
// 10 0 obj
// <<
/// Type /Page
/// Resources
// << % This dictionary maps the name AF1 to an
/// Properties <</NamedAF [12 0 R]>> % embedded file specification (object 12)
// …
// >> % End of Resources dictionary
// © ISO 2020 – All rights reserved 841
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
/// Contents 11 0 R
// …
// >> % End of Page dictionary
// endobj
// 11 0 obj % Content stream object
// << /Length 165 >>
// stream
// … % Within a content stream
/// AF /NamedAF BDC % Begin content marked with an associated file
// BT
/// F1 1 Tf
// 12 0 0 12 100 600 Tm
// (Hello) Tj
// ET
// EMC % End of associated content
// …
// endstream
// endobj
// 12 0 obj % File specification dictionary
// <<
/// Type /Filespec
/// F (datatable.doc)
/// UF (datatable.doc)
/// AFRelationship /Data
/// EF <</F 5 0 R>>
// >>
// endobj
// <<
// 5 0 obj % Embedded file stream
/// Filter /FlateDecode
/// Length 20000
/// Type /EmbeddedFile
/// Subtype /application#2Fvnd.ms-word
/// Params
// <<
/// CheckSum <ad032d7a6ea930489df4bfd6acb585b9>
/// Size 32000
/// CreationDate (D:200504 16133719)
/// ModDate (D:20050908133720)
// >>
// >>
// stream
// …
// endstream
// endobj
// EXAMPLE 3 Associated file linked to an XObject
// 19 0 obj %some XObject
// <<
/// Type /XObject
/// Subtype /Form
// …
/// AF [20 0 R]
// >>
// <<
// 20 0 obj %File Specification Dictionary
/// Type /Filespec
/// F (equation.mathml)
/// UF (equation.mathml)
/// AFRelationship /Supplement
/// EF <</F 21 0 R>>
// 842 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// >>
// endobj
// 21 0 obj %embedded file stream
// <<
/// Filter /FlateDecode
/// Length 1975
/// Type /EmbeddedFile
/// Subtype /application#2Fxhtml+xml
/// Params
// <<
/// CheckSum <ad032d7a6ea930489df4bfd6acb585b9>
/// Size 3979
/// CreationDate (D:20010727133719)
/// ModDate (D:20010727133720)
// >>
// >>
// stream
// …
// endstream
// endobj
// © ISO 2020 – All rights reserved
