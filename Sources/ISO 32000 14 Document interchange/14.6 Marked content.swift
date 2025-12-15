// ISO 32000-2:2020, 14.6 Marked content

import ISO_32000_Shared

// 14.6 Marked content
// 14.6.1 General
// Marked-content operators (PDF 1.2) may identify a portion of a PDF content stream as a marked-
// content element of interest to a particular PDF processor. Marked-content elements and the operators
// that mark them shall fall into two categories:
// • The MP and DP operators shall designate a single marked-content point in the content stream.
// • The BMC, BDC, and EMC operators shall bracket a marked-content sequence of objects within the
// content stream.
// NOTE 1 This is a sequence not simply of bytes in the content stream but of complete graphics objects.
// Each object is fully qualified by the parameters of the graphics state in which it is rendered.
// NOTE 2 A graphics application, for example, can use marked-content to identify a set of related objects as
// a group to be processed as a single unit. A text-processing application can use it to maintain a
// connection between a footnote marker in the body of a document and the corresponding
// footnote text at the bottom of the page. The PDF logical structure facilities use marked-content
// sequences to associate graphical content with structure elements (see 14.7.5, "Structure
// content").
// All marked-content operators except EMC shall take a tag operand indicating the role or significance of
// the marked-content element to the PDF processor. All such tags should have second-class names
// registered with ISO (see Annex E, "Extending PDF") to avoid conflicts between different applications
// marking the same content stream. In addition to the tag operand, the DP and BDC operators shall
// specify a property list containing further information associated with the marked-content. Property
// lists are discussed further in 14.6.2, "Property lists"
// .
// NOTE 3 The tag operand of marked-content operators have no relationship to Tagged PDF (see 14.8
// "Tagged PDF") and thus is not rolemapped.
// 720 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// Marked-content operators may appear only between graphics objects in the content stream. They may
// not occur within a graphics object or between a graphics state operator and its operands. Marked-
// content sequences may be nested one within another, but each sequence shall be entirely contained
// within a single content stream. "Table 352 — Marked-content operators" summarises the marked-
// content operators.
// NOTE 4 A marked-content sequence cannot cross page boundaries.
// The Contents entry of a page object (see 7.7.3.3, "Page objects"), whether a single stream or an array of
// streams, is considered a single stream with respect to marked-content sequences.
// Table 352 — Marked-content operators
// Operands Operator Description
// tag MP Designate a marked-content point. tag shall be a name object indicating the role
// or significance of the point.
// tag properties DP Designate a marked-content point with an associated property list. tag shall be a
// name object indicating the role or significance of the point. properties shall be
// either an inline dictionary representing the property list or a name object
// associated with it in the Properties subdictionary of the current resource
// dictionary (see 14.6.2, "Property lists").
// Tag BMC Begin a marked-content sequence terminated by a balancing EMC operator. tag
// shall be a name object indicating the role or significance of the sequence.
// tag properties BDC Begin a marked-content sequence with an associated property list, terminated by
// a balancing EMC operator. tag shall be a name object indicating the role or
// significance of the sequence. properties shall be either an inline dictionary
// representing the property list or a name object associated with it in the
// Properties subdictionary of the current resource dictionary (see 14.6.2,
// "Property lists").
// — EMC End a marked-content sequence begun by a BMC or BDC operator.
// Goto errata
// When the marked-content operators BMC, BDC, and EMC are combined with the text object operators
// BT and ET (see 9.4, "Text objects"), each pair of matching operators (BMC…EMC, BDC…EMC, or
// BT…ET) shall be properly (separately) nested. Therefore, the sequences
// BMC
// BT
// …
// ET
// EMC
// and
// BT
// BMC
// EMC
// …
// ET
// are valid, but
// BMC
// BT
// © ISO 2020 – All rights reserved 721
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// …
// EMC
// ET
// and
// BT
// BMC
// …
// ET
// EMC
// are not valid.
// 14.6.2 Property lists
// The marked-content operators DP and BDC associate a property list with a marked-content element
// within a content stream. The property list is a dictionary containing information (either private or of
// types defined in this document) meaningful to the PDF processor. PDF processors should use the
// dictionary entries in a consistent way; the values associated with a given key should always be of the
// same type (or small set of types).
// NOTE 1 Property lists are used by several PDF features, including optional content (see 8.11,
// content", tagged PDF (see 14.8,
// "Tagged PDF"), object metadata (see 14.3.2,
// "Optional
// "Metadata streams")
// and Associated Files (see 14.13.5, "Associated files linked to graphics objects").
// If all of the values in a property list dictionary are direct objects, the dictionary may be written inline in
// the content stream as a direct object. If any of the values are indirect references to objects outside the
// content stream, the property list dictionary shall be defined as a named resource in the Properties
// subdictionary of the current resource dictionary (see 7.8.3, "Resource dictionaries") and referenced by
// name as the properties operand of the DP or BDC operator.
// NOTE 2 (2020) This means that indirect references of the form of 10 0 R can never occur within content
// streams.
