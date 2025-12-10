// ISO 32000-2:2020, 14.5 Page-piece dictionaries

import ISO_32000_Shared


//14.5 Page-piece dictionaries
//A page-piece dictionary (PDF 1.3) may be used to hold private PDF processor data. The data may be
//associated with a page or form XObject by means of the optional PieceInfo entry in the page object
//(see "Table 31 — Entries in a page object") or form dictionary (see "Table 93 — Additional entries
//specific to a Type 1 form dictionary"). Beginning with PDF 1.4, private data may also be associated with
//the PDF document by means of the PieceInfo entry in the document catalog dictionary (see "Table 29
//— Entries in the catalog dictionary").
//NOTE PDF writers can use this dictionary as a place to store private data in connection with that
//document, page, or form. Such private data can convey information meaningful to the PDF
//processor that produces it (such as information on object grouping for a graphics editor or the
//layer information used by Adobe Photoshop®) but can be ignored by general-purpose PDF
//processors.
//As "Table 350 — Entries in a page-piece dictionary" shows, a page-piece dictionary may contain any
//number of entries, each keyed by the name of a distinct PDF processor or of a well-known data type
//recognised by a family of PDF processors. The value associated with each key shall be a data dictionary
//containing the private data that shall be used by the PDF processor. The Private entry may have a
//value of any data type, but typically it is a dictionary containing all of the private data needed by the
//PDF processor other than the actual content of the document, page, or form.
//Table 350 — Entries in a page-piece dictionary
//Key Type Value
//any valid second-class name dictionary A data dictionary (see "Table 351 — Entries in a data dictionary").
//© ISO 2020 – All rights reserved 719
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 351 — Entries in a data dictionary
//Key Type Value
//LastModified date (Required) The date and time when the contents of the document, page, or
//form were most recently modified by this PDF processor.
//Private (any) (Optional) Any private data appropriate to the PDF processor, typically in the
//form of a dictionary.
//The LastModified entry indicates when a PDF processor last altered the content of the document, page
//or form. If the page-piece dictionary contains several data dictionaries, their modification dates can be
//compared with those in the corresponding entry of the page object or form dictionary (see "Table 31
//— Entries in a page object" and "Table 93 — Additional entries specific to a Type 1 form dictionary"),
//or the ModDate entry of the document information dictionary (see "Table 349 — Entries in the
//document information dictionary"), to ascertain whether the data dictionary corresponds to the
//current content of the document, page or form. Because some platforms may use only an approximate
//value for the date and time or may not deal correctly with differing time zones, modification dates shall
//be compared only for equality and not for sequential ordering.
