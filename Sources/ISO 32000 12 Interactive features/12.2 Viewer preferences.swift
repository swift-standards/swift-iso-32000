// ISO 32000-2:2020, 12.2 Viewer preferences

import ISO_32000_Shared

//12.2 Viewer preferences
//The ViewerPreferences entry in a document’s catalog dictionary (see 7.7.2, "Document catalog
//dictionary") designates a viewer preferences dictionary (PDF 1.2) controlling the way the document
//shall be presented on the screen or in print. If no such dictionary is specified, PDF processors should
//behave in accordance with their own current user preference settings. "Table 147 — Entries in a
//viewer preferences dictionary" shows the contents of the viewer preferences dictionary.
//Table 147 — Entries in a viewer preferences dictionary
//Key Type Value
//HideToolbar boolean (Optional) A flag specifying whether to hide the interactive PDF
//processor’s tool bars when the document is active.
//Default value: false.
//HideMenubar boolean (Optional) A flag specifying whether to hide the interactive PDF
//processor’s menu bar when the document is active.
//Default value: false.
//© ISO 2020 – All rights reserved 437
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//438 © ISO 2020 – All rights reserved
//Key Type Value
//HideWindowUI boolean (Optional) A flag specifying whether to hide user interface elements
//in the document’s window (such as scroll bars and navigation
//controls), leaving only the document’s contents displayed. D
//efault value: false.
//FitWindow boolean (Optional) A flag specifying whether to resize the document’s
//window to fit the size of the first displayed page. Default value: false.
//CenterWindow boolean (Optional) A flag specifying whether to position the document’s
//window in the centre of the screen. Default value: false.
//DisplayDocTitle boolean (Optional; PDF 1.4) A flag specifying whether the window’s title bar
//should display the document title taken from the dc:title element of
//the XMP metadata stream (see 14.3.2, "Metadata streams"). If false,
//the title bar should instead display the name of the PDF file
//containing the document. Default value: false.
//NonFullScreenPageMode name (Optional) The document’s page mode, specifying how to display the
//document on exiting full-screen mode:
//UseNone Neither document outline nor thumbnail images visible
//UseOutlines Document outline visible
//UseThumbs Thumbnail images visible
//UseOC Optional content group panel visible
//This entry is meaningful only if the value of the PageMode entry in
//the catalog dictionary (see 7.7.2, "Document catalog dictionary") is
//FullScreen; it shall be ignored otherwise. Default value: UseNone.
//Direction name (Optional; PDF 1.3) The predominant logical content order for text:
//L2R Left to right
//R2L Right to left (including vertical writing systems, such as
//Chinese, Japanese, and Korean)
//This entry has no direct effect on the document’s contents or page
//numbering but may be used to determine the relative positioning of
//pages when displayed side by side or printed n-up. Default value:
//L2R.
//ViewArea name (Optional; PDF 1.4; deprecated in PDF 2.0) The name of the page
//boundary representing the area of a page that shall be displayed
//when viewing the document on the screen. The value is the key
//designating the relevant page boundary in the page object (see
//7.7.3, "Page tree" and 14.11.2, "Page boundaries"). If the specified
//page boundary is not defined in the page object, its default value
//shall be used, as specified in "Table 31 — Entries in a page object"
//.
//Default value: CropBox.
//This entry is intended primarily for use by prepress applications
//that interpret or manipulate the page boundaries as described in
//14.11.2, "Page boundaries"
//.
//The presence of this value in a PDF may cause a PDF to display
//differently from how it will be printed.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 439
//Key Type Value
//ViewClip name (Optional; PDF 1.4; deprecated in PDF 2.0) The name of the page
//boundary to which the contents of a page shall be clipped when
//viewing the document on the screen. The value is the key
//designating the relevant page boundary in the page object (see
//7.7.3, "Page tree" and 14.11.2, "Page boundaries"). If the specified
//page boundary is not defined in the page object, its default value
//shall be used, as specified in "Table 31 — Entries in a page object"
//.
//Default value: CropBox.
//This entry is intended primarily for use by prepress applications
//that interpret or manipulate the page boundaries as described in
//14.11.2, "Page boundaries"
//.
//The presence of this value in a PDF may cause a PDF to display
//differently from how it will be printed.
//PrintArea name (Optional; PDF 1.4; deprecated in PDF 2.0) The name of the page
//boundary representing the area of a page that shall be rendered
//when printing the document. The value is the key designating the
//relevant page boundary in the page object (see 7.7.3, "Page tree"
//and 14.11.2, "Page boundaries"). If the specified page boundary is
//not defined in the page object, its default value shall be used, as
//specified in "Table 31 — Entries in a page object". Default value:
//CropBox.
//This entry is intended primarily for use by prepress applications
//that interpret or manipulate the page boundaries as described in
//14.11.2, "Page boundaries"
//.
//The presence of this value in a PDF may cause a PDF to display
//differently from how it will be printed.
//PrintClip name (Optional; PDF 1.4; deprecated in PDF 2.0) The name of the page
//boundary to which the contents of a page shall be clipped when
//printing the document. The value is the key designating the relevant
//page boundary in the page object (see 7.7.3, "Page tree" and 14.11.2,
//"Page boundaries"). If the specified page boundary is not defined in
//the page object, its default value shall be used, as specified in "Table
//31 — Entries in a page object". Default value: CropBox.
//This entry is intended primarily for use by prepress applications
//that interpret or manipulate the page boundaries as described in
//14.11.2, "Page boundaries"
//.
//The presence of this value in a PDF may cause a PDF to display
//differently from how it will be printed.
//PrintScaling name (Optional; PDF 1.6) The page scaling option that shall be selected
//when a print dialogue is displayed for this document. Valid values
//are None, which indicates no page scaling, and AppDefault, which
//indicates the interactive PDF processor’s default print scaling. If this
//entry has an unrecognised value, AppDefault shall be used. Default
//value: AppDefault.
//If the print dialogue is suppressed and its parameters are provided
//from some other source, this entry nevertheless shall be honoured.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//440 © ISO 2020 – All rights reserved
//Key Type Value
//Duplex name (Optional; PDF 1.7) The paper handling option that shall be used
//when printing the PDF file from the print dialogue. The following
//values are valid:
//Simplex Print single-sided
//DuplexFlipShortEdge Duplex and flip on the short edge of the
//sheet
//DuplexFlipLongEdge Duplex and flip on the long edge of the sheet
//Default value: implementation dependent
//PickTrayByPDFSize boolean (Optional; PDF 1.7) A flag specifying whether the PDF page size shall
//be used to select the input paper tray. This setting influences only
//the preset values used to populate the print dialogue presented by
//an interactive PDF processor. If PickTrayByPDFSize is true, the
//check box in the print dialogue associated with input paper tray
//shall be checked.
//This setting has no effect on operating systems that do not provide
//the ability to pick the input tray by size.
//Default value: implementation dependent
//PrintPageRange array (Optional; PDF 1.7) The page numbers used to initialise the print
//dialogue box when the PDF file is printed. The array shall contain an
//even number of integers to be interpreted in pairs, with each pair
//specifying the first and last pages in a sub-range of pages to be
//printed. The first page of the PDF file shall be denoted by 1.
//Default value: implementation dependent
//NOTE Although PrintPageRange uses 1-based page numbering, other
//features of PDF use zero-based page numbering.
//NumCopies integer (Optional; PDF 1.7) The number of copies that shall be printed when
//the print dialog is opened for this PDF file.
//Default value: implementation dependent, but typically 1
//Enforce array (Optional; PDF 2.0) An array of names of Viewer preference settings
//that shall be enforced by PDF processors and that shall not be
//overridden by subsequent selections in the application user
//interface. "Table 148 — Names defined for an Enforce array"
//specifies names that shall be valid to use in this array.
//The Enforce array shall only include names that occur in "Table 148 — Names defined for an Enforce
//array". Future additions to this table shall be limited to keys in the viewer preferences dictionary with
//the following qualities:
//• can be assigned values (default or specified) that cannot be used in a denial-of-service attack, and
//• have default values that cannot be overridden using the application user interface.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 148 — Names defined for an Enforce array
//Name Description
//PrintScaling (Optional; PDF 2.0) This name may appear in the Enforce array only if the corresponding
//entry in the viewer preferences dictionary ("Table 147 — Entries in a viewer preferences
//dictionary") specifies a valid value other than AppDefault.
