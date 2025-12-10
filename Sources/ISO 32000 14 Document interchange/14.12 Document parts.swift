// ISO 32000-2:2020, 14.12 Document parts

import ISO_32000_Shared


//14.12 Document parts
//14.12.1 General
//Many PDF documents are often comprised of multiple sub-documents, or document parts, where each
//document part may have a varying number of pages. Examples include subdocuments for different
//recipients in transactional or variable data printing, document parts which have different
//requirements when processed (such as the cover sheet and pages of a booklet), or simply a collation of
//multiple documents. When a PDF file is produced, a PDF application will need to define a specific
//ordering of all pages from all document parts, but any such ordering may not meet all future usage
//requirements. Such PDF files are usually optimised to a particular workflow or to specific capabilities
//of a target printing device setup and thus are not portable across different production workflows or
//digital printing devices once they are created.
//As a structured page description format, PDF encodes the many pages of documents in a manner that
//allows a PDF processor efficient random access to pages. The random access efficiency of PDF provides
//an ideal page content resource format for job ticket-based workflow where the order of page
//processing may be different from the order presented in the PDF data. This re-ordering may be
//specified in a separate data file such as a JDF job ticket or be viewed using a PDF processor.
//The use of a separate job ticket file for specifying page ordering and processing requirements allows
//for an exchanged PDF 2.0 document to be more easily late stage targeted or re-targeted to a production
//workflow, digital printing device, or other messaging channel. Re-targeting or reprinting is then
//possible without the need to recreate or modify the PDF 2.0 document. Such workflows may need to
//834 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//identify specific page ranges in a PDF file in order to associate them with specific parts of the job ticket.
//Document parts provide the metadata required to make that identification.
//NOTE The document part tree structure specified in this clause is based on, and compatible with, the
//structure specified in ISO 16612-2. Changes are to make it less prescriptive.
//14.12.2 DPart tree structure
//The pages of a sequence of independent document parts are defined in a PDF file using a hierarchy of
//DPart dictionaries referred to as document part dictionaries. The root node of this hierarchy of
//dictionaries is identified by the DPartRoot dictionary referenced from the catalog dictionary. The
//document part hierarchy is a data structure that defines the sequence of pages in the PDF file,
//including any documents and/or document parts of which it is composed. DPart dictionaries that are
//leaf nodes of this hierarchy may refer to a specific range of one or more PDF page objects as identified
//by their Start and End keys. The ranges of PDF page objects referenced from the various DPart
//dictionary leaf nodes shall not overlap and therefore shall not share the same PDF page objects. Each
//page object defined in the PDF file shall be included in the page range defined by one and only one
//DPart dictionary.
//The various DPart dictionary nodes of the hierarchy are fully connected by explicit references to the
//immediate descendant DPart nodes and to the parent node.
//NOTE 1 Although ISO 32000 also defines structured access to page objects via the pages tree, a PDF
//processor can also access page object entries indirectly from the DPart leaf nodes of the
//document part hierarchy for structured presentation of pages.
//The value of the optional DPartRoot key in the catalog dictionary shall be an indirect object reference
//to a DPartRootNode dictionary.
//A child DPart dictionary shall not be referenced by more than one parent DPart dictionary.
//NOTE 2 A DPart dictionary is not permitted to have more than one parent and can have any number of
//children because DPart dictionaries are part of a tree structure.
//14.12.3 Connecting the DPart tree structure to pages
//A page object shall only be referenced in the range of pages specified by the Start and End keys of a
//single DPart dictionary entry.
//Each page object that is contained within the page range specified by the Start and End keys of a single
//DPart entry shall have a DPart key that has a value that is an indirect reference to the leaf node DPart
//dictionary whose range of pages includes this page object.
//NOTE 1 The DPart key in a page object allows a PDF processor to directly retrieve the section of the
//document part hierarchy that applies to this page object. For example, for certain
//implementation approaches to cut and stack imposition, this allows for efficient retrieval of DPM
//based on page indices. This also allows for ready access of DPM data in PDF processors.
//If more than one page object is included in the range of pages referenced by the Start and End keys of a
//DPart dictionary entry, the page number of each page object referenced within that range shall be
//monotonically increasing, as defined by the document’s page tree, beginning with the page object
//referenced by the Start key. The order of page objects as defined by the page tree shall be in the same
//© ISO 2020 – All rights reserved 835
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//order in which page objects are referenced from leaf node DPart dictionaries in a depth-first traversal
//of the document part hierarchy.
//NOTE 2 By ordering the PDF pages as referenced from the DPart tree structure to be respective of the
//order they are referenced from the normal page tree, the pages will be enumerated the same
//using either mechanism.
//14.12.4 Data structures
//14.12.4.1 General
//"Table 408 — Entries in a DPartRoot dictionary" defines entries in a DPartRoot dictionary.
//Table 408 — Entries in a DPartRoot dictionary
//Key Type Value
//Type name (Optional; PDF 2.0) If present, it shall have the value DPartRoot to identify the
//dictionary as a DPartRoot dictionary.
//DPartRootNode dictionary (Required; PDF 2.0) Shall be an indirect reference to the DPart dictionary that
//is the root node of the document part tree structure.
//RecordLevel integer (Optional; PDF 2.0) This attribute may be used when a single PDF file encodes
//multiple documents. It identifies the zero based level of the document part
//hierarchy where each DPart node of that level corresponds to a component or
//hierarchy of components.
//NodeNameList array (Optional; PDF 2.0) An array of names where each name entry shall
//correspond to a DPart node level of the document part hierarchy beginning
//with the DPart dictionary identified by the value of the DPartRoot
//dictionary's DPartRootNode key.
//If present, the number of entries present in this array shall be equal to the
//number of DPart node levels in the document part hierarchy.
//Each name in this array shall conform to the rules for an XML Name token.
//"Table 409 — Entries in a DPart dictionary" defines entries in a DPart dictionary.
//Table 409 — Entries in a DPart dictionary
//Key Type Value
//Type name (Optional; PDF 2.0) If present, it shall have the value DPart to identify the dictionary
//as a DPart dictionary.
//Parent dictionary (Required; PDF 2.0) If this DPart dictionary is referenced from the DPartRootNode
//key of the DPartRoot dictionary, then the value of this Parent key shall be an
//indirect reference to the DPartRoot dictionary. In all other cases the value of this
//Parent key shall be an indirect reference to the DPart dictionary that is its
//immediate ancestor in the hierarchy.
//DParts array (Shall not be present if a Start key is present; PDF 2.0) An array of arrays. Each
//element in the array is an array of indirect references to immediate descendant
//DPart dictionaries. The array shall not be empty.
//836 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//Start dictionary (Shall not be present if a DParts key is present; shall be an indirect reference; PDF 2.0)
//If present, the Start key shall be an indirect reference to the page object that defines
//the first page of the range of pages belonging to this DPart dictionary.
//End dictionary (Required if there is a Start key and the page range has more than one page, not
//present otherwise; shall be an indirect reference; PDF 2.0) If present, the End key shall
//be an indirect reference to the page object that defines the last PDF page of the range
//of pages belonging to this DPart dictionary.
//DPM dictionary (Optional; PDF 2.0) If present shall specify a document part metadata dictionary.
//NOTE See 14.12.4.2, "Document part metadata" for a description of the use of DPM
//dictionaries for specifying DPM.
//AF array of
//dictionaries
//(Optional; PDF 2.0) An array of one or more file specification dictionaries (7.11.3,
//"File specification dictionaries") which denote the associated files for this document
//part (DPart). See 14.13, "Associated files" and 14.13.8, "Associated files linked to
//DParts"
//.
//Metadata stream (Optional; PDF 2.0; shall be an indirect reference) A metadata stream that shall
//contain metadata for this document part (see 14.3.2, "Metadata streams").
//NOTE The use of the DParts key, to refer to a descendant DPart dictionary, and the use of the Start and
//End keys, to refer to a range of pages, are exclusive. The restrictions on the use of the Start and
//End keys only permit DPart dictionary leaf nodes to refer to a range of one or more PDF pages.
//Non-leaf DPart dictionary nodes of the hierarchy cannot refer to a range of PDF pages, only to
//descendent DPart dictionaries.
//14.12.4.2 Document part metadata
//Document Part Metadata (DPM) is a means by which PDF writers, such as PDF authoring applications,
//communicate information about the various document parts to a downstream production workflow.
//NOTE 1 Job ticket formats such as JDF have specific constructs designed for use with structured page
//description language formats that contain metadata in their document part structure. In support
//of that, PDF provides document part metadata (DPM) that can occur as a DPM dictionary entry in
//any DPart dictionary of the document part hierarchy.
//DPM is application-specific information communicated between the creator of PDF data and a
//receiving system, and may be used to classify the PDF file and its various document parts. The
//receiving system may, for example, use this information in the purposing of page content to print or to
//some other messaging channel. The DPM may also be referenced in a job definition, such as a JDF job
//ticket, to vary processing control as necessary for print production.
//The DPM specified within a DPM dictionary shall only apply to the DPart node in which it is defined.
//The name of all keys present in the DPM dictionary or any other dictionaries contained within a DPM
//dictionary shall conform to the rules of an XML name token as well as the rules for PDF name objects.
//NOTE 2 This ensures that the representative XML name for the PDF key is a sequence of XML characters
//where all PDF name # escape sequences present in the PDF key name are expanded. For more
//information on # escape sequences refer to 7.3.5, "Name objects"
//.
//© ISO 2020 – All rights reserved 837
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//The values of keys present in the DPM dictionary, or of any dictionary or array object present in the
//DPM dictionary, shall only be of type text string, date string, array, dictionary, boolean, integer or real
//as defined in 7.3, "Objects". Other PDF value types shall not be used.
