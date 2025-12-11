// ISO 32000-2:2020, 12.11 Document requirements

import ISO_32000_Shared


//12.11 Document requirements
//12.11.1 General
//A PDF processor that supports document requirements shall evaluate them before execution of any
//ECMAScripts.
//The Requirements entry in the document catalog (see 7.7.2, "Document catalog dictionary") shall be
//an array of requirement dictionaries, whose entries are shown in "Table 273 — Entries common to all
//requirement dictionaries"
//.
//Table 273 — Entries common to all requirement dictionaries
//Key Type Description
//Type name (Optional) The type of PDF object that this dictionary describes. If present,
//shall be Requirement for a requirement dictionary.
//S name (Required) The type of requirement that this dictionary describes. See "Table
//276 — Entries in a requirement handler dictionary" for valid values.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 607
//Key Type Description
//V name or
//dictionary
//(Optional; PDF 2.0) The minimum version level of support needed to satisfy
//the requirement. See 12.11.4, "Requirement versions". If this entry is absent,
//determining if the requirement is satisfied shall be done without regard to
//version number.
//Unless otherwise mentioned in the entries in "Table 276 — Entries in a
//requirement handler dictionary", the value shall represent the PDF version.
//RH dictionary
//or array
//(Optional) An alternative requirement handler dictionary or an array of such
//dictionaries. Each dictionary identifies a requirement handler that shall be
//disabled (not invoked) if the interactive PDF processor can check the
//requirement specified in the S entry (whether or not it can satisfy that
//requirement). See 12.11.5, "Requirement handlers"
//.
//Default value: an empty array.
//Penalty integer (Optional; PDF 2.0) An integer value that shall be between 0 and 100
//(inclusive) that represents the penalty value to be applied when this
//requirement cannot be met by a PDF processor.
//Default value is 100.
//There are two additional keys that may appear in a requirements dictionary that are specific to certain
//types of requirements (i.e., value of the S key). These are described in "Table 274 — Entries for specific
//types of requirements"
//.
//Table 274 — Entries for specific types of requirements
//Key Type Description
//Encrypt dictionary (Required, if the S key has the value Encryption: PDF 2.0) An encryption
//dictionary ("Table 20 — Entries common to all encryption dictionaries")
//that defines all of the relevant aspects of the encryption method needed to
//process the document.
//DigSig dictionary (Optional, but only used when the S key has the value of DigSig,
//DigSigValidation or DigSigMDP; PDF 2.0) A signature dictionary ("Table 255
//— Entries in a signature dictionary") that defines all of the relevant aspects
//that are needed in order to process the digital signature requirements.
//12.11.2 Requirement types
//The S entry in a requirement dictionary identifies ("Table 273 — Entries common to all requirement
//dictionaries") a feature of the PDF language or a capability that may be present in a PDF processor.
//Such entries enable the document to identify feature(s) of PDF beyond those commonly expected, such
//as 2D graphics rendering, and are required for correct handling in accordance with this document. In
//addition, although not required for viewing, a document may also use requirement values that
//stipulate required features of interactive PDF processors such as the ability to interact with or modify
//the document.
//"Table 275 — Requirement types" lists requirement types that have been defined through PDF 2.0.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//608 © ISO 2020 – All rights reserved
//Table 275 — Requirement types
//Type Description
//OCInteract Requires an interactive PDF processor to be able to display the list of optional
//content groups (OCGs) in the Order array as described in "Table 99 — Entries in an
//optional content configuration dictionary"
//.
//In addition, requires that an interactive PDF processor support the SetOCGState
//action (see 12.6.4.13, "Set-OCG-state actions").
//Additional information about OCGs can be found in 8.11.2, "Optional content groups"
//and 8.11.4.4, "Usage and usage application dictionaries"
//.
//OCAutoStates Requires an interactive PDF processor to implement the various Usage values that
//can be present as the value of the AS key in an OCD as described in "Table 99 —
//Entries in an optional content configuration dictionary" and 8.11.4.4, "Usage and
//usage application dictionaries"
//.
//AcroFormInteract Requires support for user interaction with forms (see 12.7, "Forms") defined as
//interactive form dictionaries including updating field appearances when values
//change. In addition, support for Trigger Actions (12.6.3, "Trigger events") is required.
//NOTE 1 This requirement does not cover presentation of a form’s static appearance. That
//presentation uses annotation appearances (12.5.5, "Appearance streams"), which all
//PDF processors are assumed to support.
//Navigation Requires support for the presentation and handling of basic navigational elements
//including link annotations (12.5.6.5, "Link annotations") and outlines (12.3.3,
//"Document outline"). In addition, support shall be provided for GoTo, GoToR and
//URI actions (12.6.4, "Action types") in any of these elements or as a document, page
//or annotation trigger events (12.6.3, "Trigger events").
//Markup Requires support for the creation, modification and deletion of markup annotations
//(12.5.6.2, "Markup annotations") including text annotations. In addition, any time the
//visual appearance of the annotation changes, the appearance stream shall be
//updated.
//3DMarkup Requires support for the creation, modification and deletion of text notes and
//markup annotations on 3D objects (13.6.7.3.6, "3D comment note"). In addition, any
//time where the visual appearance of the annotation changes, the appearance stream
//shall be updated.
//Multimedia Requires support for multimedia (Screen) annotations (12.5.6.18, "Screen
//annotations"). See also 13.2, "Multimedia". The support that is required is for the
//general multimedia framework, not for an external player for any specific type of
//multimedia content. Negotiation of the choice of an external player is handled by the
//must honour (MH) and best efforts (BE) mechanism (13.2.2, "Viability") that is
//defined as part of the multimedia framework (13.2, "Multimedia").
//U3D Requires support for 3D data streams conforming to the U3D specification. This shall
//apply to the use of U3D in either 3D (13.6.3, "3D streams") or RichMedia annotations
//(13.7.2.2, "RichMediaSettings dictionary"). This also includes support for associated
//ECMAScripts.
//If a V key is present in its Requirements dictionary, it shall represent the version of
//U3D and not the PDF version.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 609
//Type Description
//PRC Requires support for 3D data streams conforming to the PRC specification. This shall
//apply to the use of PRC in either 3D (13.6.3, "3D streams") or RichMedia annotations
//(13.7.2.2, "RichMediaSettings dictionary"). This also includes support for associated
//ECMAScripts.
//If a V key is present in its Requirements dictionary, it shall represent the version of
//PRC and not the PDF version.
//Action Requires support for actions in general (12.6, "Actions"), other than GoTo and URI
//actions (which are subsumed under the Navigation and Attachment requirements),
//SetOCGState (subsumed under OCInteract) and ECMAScript actions (which are
//separately declared with the EnableJavaScripts requirement).
//EnableJavaScripts Requires support for execution of ECMAScripts appearing in ECMAScript actions and
//in the ECMAScript name tree for document-level ECMAScripts.
//NOTE 2 ECMAScripts contained in 3D & RichMedia annotations are handled by their
//respective requirements.
//Attachment Requires support for displaying (to the user) the list of file attachments (see 7.11.4,
//"Embedded file streams") and enabling users to extract any existing attachments. In
//addition, support is provided for GoToE actions (12.6.4, "Action types") when located
//in any navigational element or trigger event.
//NOTE 3 The list of file attachments is taken from the EmbeddedFiles names tree (see 7.7.4,
//"Name dictionary") and any FileAttachment annotation (see 12.5.6.15, "File
//attachment annotations").
//AttachmentEditing In addition to the requirements of the Attachment value, support for adding new
//attachments into the EmbeddedFiles names tree (see 7.7.4, "Name dictionary"),
//deleting existing ones as well as modification of attachment attributes (e.g., name &
//description) are also required.
//Collection Requires support for displaying the embedded files referenced from the document’s
//collection dictionary (12.3.5, "Collections") along with any associated metadata. Also
//requires that the user can extract or otherwise view the contents of each item in the
//collection.
//(PDF 2.0) For unencrypted wrapper documents for an encrypted payload document
//(see 7.6.7, "Unencrypted wrapper document") the Collection requirement should not
//be specified for the unencrypted wrapper document.
//NOTE 4 Although the unencrypted wrapper document is a collection, the intent of the
//wrapper is to enable PDF processors that are unable to decrypt the embedded
//encrypted payload document to present the content of the unencrypted wrapper
//document to assist users in understanding the cryptographic requirements of the
//encrypted payload document. Specifying the Collection requirement on the wrapper
//could discourage PDF processors incapable of displaying collections from presenting
//the unencrypted wrapper content.
//CollectionEditing In addition to the requirements of the Collection value, support for adding to the
//collection (12.3.5, "Collections"), deleting existing items as well as modification of
//collection item attributes and metadata, are also required.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//610 © ISO 2020 – All rights reserved
//Type Description
//DigSigValidation Requires support for the validation of digital signatures (both document and
//certifying) that have been applied to the PDF including the handling of supplied
//revocation information. See 12.8, "Digital signatures"
//, and 12.8.3.4.5, "Requirements
//for validation of PAdES signatures"
//.
//This does not require the support for 12.8.2.2.2, "Validating signatures that use the
//DocMDP transform method" which is a separate requirement: DigSigMDP.
//DigSig In addition to the validation requirements of DigSigValidation, this specifies the
//requirements to support the application of a digital signature to a document (also
//known as signing). See 12.8, "Digital signatures"
//.
//DigSigMDP In addition to the requirements of DigSig and DigSigValidation, this also requires
//support for modification detection analysis to determine if only allowable
//modifications have been made. See 12.8.2.2.2, "Validating signatures that use the
//DocMDP transform method"
//.
//RichMedia Requires support for playing rich media annotations as specified in 13.7.2,
//"RichMedia annotations"
//.
//Geospatial2D Requires support for processing provided geospatial information in the page content
//and associated resources. See 12.10, "Geospatial features"
//.
//Geospatial3D Requires support for processing provided geospatial information in any 3D
//annotations. See 12.10, "Geospatial features"
//. This type requires provision within the
//3D Annotation, and also applies 3D requirements to Geospatial information.
//DPartInteract Requires support for the display of the DParts hierarchy and its use for navigation of
//the document parts. See 14.12, "Document parts"
//.
//SeparationSimulation Requires support for simulation separations as described in 10.8, "Rendering for
//separations" and 10.8.3, "Separation simulation"
//.
//NOTE 5 This is sometimes referred to as "Overprint Preview"
//.
//Transitions Requires support for transitions/presentations (12.4.4, "Presentations") as well as
//transition actions (12.6.4.14, "Rendition actions")
//Encryption Requires support for the specific set of encryption parameters that are specified by
//the encryption dictionary provided as the value of the Encrypt key in the
//requirement dictionary (see "Table 273 — Entries common to all requirement
//dictionaries" and "Table 274 — Entries for specific types of requirements").
//(PDF 2.0) For unencrypted wrapper documents for an encrypted payload document
//(see 7.6.7, "Unencrypted wrapper document") the Encryption requirement should
//not be specified for the unencrypted wrapper document.
//NOTE 6 The intent of the wrapper is to enable PDF processors that are unable to decrypt the
//embedded encrypted payload document to present the content of the unencrypted
//wrapper document to assist users in understanding the cryptographic requirements
//of the encrypted payload document. Specifying the Encryption requirement on the
//wrapper could discourage PDF processors incapable of decrypting the embedded
//encrypted payload from presenting the unencrypted wrapper content.
//Additional requirement types, including ones identifying vendor-specific features, may be registered
//according to the rules described in Annex E, "Extending PDF".
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//12.11.3 Requirement penalty values
//Each Requirements dictionary shall contain an S key whose value should be chosen from a list of
//those defined in "Table 275 — Requirement types" but only for those features that are deemed critical
//for the successful rendering of the document. The values of the Penalty key is the penalty number
//expressed as an integer in the range [0, 100]. The presence of this requirements dictionary indicates
//that the associated feature is used or needed by the document.
//A value of zero for the Penalty key would indicate that although the document uses this feature the
//need is optional. A value of 100 indicates that this document will not produce the author’s intent unless
//the PDF processor can fully support this feature. Values between 0 and 100 are available to weight the
//value of this feature among other features in the same document requirements array as well as when
//contributing to the total penalty points to weigh against other documents in the choosing process if
//alternatives are available.
//In the situation where the penalty values are being used to evaluate the presentation of the base PDF
//document, and there exist no other alternates, if the penalty value exceeds 100 then the PDF processor
//should not attempt to display or process the document.
//12.11.4 Requirement versions
//A requirement dictionary may include a V entry (PDF 2.0) that specifies a version number for a specific
//technology related to the requirement in question. It might be a PDF version number, an XFA version
//number (for those requirement related to XFA), a version of U3D or PRC, or a vendor-specific extension
//level.
//Some PDF and XFA features have evolved over successive PDF versions. A PDF file may contain uses of
//a feature or an embedded data stream that can only be successfully interpreted by a PDF processor
//supporting a specific version of PDF or higher. This constraint may be indicated by including a V entry
//in the requirement dictionary identifying the PDF version.
//The value of V shall be one of the following:
//• A name that specifies a version number, represented as two or more decimal integers separated
//by a period. The number of decimals places is determined by the technology in question for which
//the version applies. For example, PDF and XFA versions are always two digits; others are always
//three.
//NOTE This is specified as a name, not as a number, in order to avoid any ambiguities caused by inexact
//internal representation of decimal fractions. No non-numerals, except for the decimal point, can
//be present.
//• An extensions dictionary that specifies a vendor-specific extension to a PDF version (see 7.12,
//"Extensions dictionary"). It shall only be used when describing a version of PDF for which a
//simple version (e.g., 1.7) is not sufficient and has no meaning for any other requirement. The
//extensions dictionary shall contain exactly one entry, whose key shall correspond to the
//registered prefix for the vendor that has defined this requirement type.
//If the V entry is not present, determining if the requirement is satisfied shall be done without regard to
//version number.
//© ISO 2020 – All rights reserved 611
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//612 © ISO 2020 – All rights reserved
//12.11.5 Requirement handlers
//An alternative requirement handler is an alternative means for determining if the requirements
//associated with a document’s features are satisfied. Traditionally, requirements handling has been
//accomplished with an ECMAScript segment in the document-level ECMAScripts stored in the
//document’s name dictionary.
//To create PDF documents that are compatible with processors that support PDF 1.7 and PDF 2.0, both
//the document requirements feature and the ECMAScript alternative requirements handler should be
//present in the document.
//A document using the document requirements feature can specify that an ECMAScript function is to be
//disabled by including an RH entry whose value is an alternative requirement handler dictionary (or an
//array of such dictionaries), each of which identifies a handler that shall be disabled. "Table 276 —
//Entries in a requirement handler dictionary" describes the entries in an alternative requirement
//handler dictionary.
//A requirement handler is a program that verifies certain requirements are satisfied. "Table 276 —
//Entries in a requirement handler dictionary" describes the entries in a requirement handler dictionary.
//Table 276 — Entries in a requirement handler dictionary
//Key Type Description
//Type name (Optional) The type of PDF object that this dictionary describes. If present,
//shall be ReqHandler for a requirement handler dictionary.
//S name (Required) The type of requirement handler that this dictionary describes.
//Valid requirement handler types shall be JS (for ECMAScript requirement
//handlers) and NoOp.
//A value of NoOp allows older PDF processors to ignore unrecognised
//requirements. This value does not add any specific entry to the
//requirement handler dictionary.
//Script text string (Optional; valid only if the S entry has a value of JS) The name of a
//document-level ECMAScript action stored in the document name
//dictionary (see 7.7.4, "Name dictionary"). If the PDF processor
//understands the parent document requirements dictionary and can verify
//the requirement specified in that dictionary, it shall disable execution of
//the requirement handler identified in this dictionary.
//If an alternative requirement handler dictionary has an S entry with an unrecognised type, it shall be
//ignored.
//12.11.6 Requirements processing
//Document requirements can be presented for an individual document as the value of the
//Requirements key in that document's catalog. Document requirements shall be evaluated before
//execution of any document ECMAScripts. If requirements cannot be met, as determined by the
//computation of the penalty value as described in 12.11.3, "Requirement penalty values", then the
//processing of the document shall not continue.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//For PDFs that are acceptable for processing, all subsequent processing shall occur without regard for
//the outcome of the requirements computation.
//NOTE 1 That is, there is no formal connection between the requirement type and the operation of the
//associated feature(s).
//If the reader encounters an unsupported feature (whether or not that feature was declared as a
//requirement), it shall take the normal fallback actions.
//NOTE 2 The most common fallback is to do nothing — that is, to ignore the use of the unsupported
//feature. Other common fallbacks can include presenting a static annotation appearance in place
//of a dynamic annotation.
