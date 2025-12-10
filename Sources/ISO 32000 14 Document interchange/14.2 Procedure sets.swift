// ISO 32000-2:2020, 14.2 Procedure sets

import ISO_32000_Shared

//
//14.2 Procedure sets
//This feature has been deprecated since PDF 1.4.
//The PDF operators used in content streams are grouped into categories of related operators called
//procedure sets (see "Table 346 — Predefined procedure set"). Each procedure set corresponds to a
//named resource containing the implementations of the operators in that procedure set. The ProcSet
//entry in a content stream’s resource dictionary (see 7.8.3, "Resource dictionaries") shall hold an array
//consisting of the names of the procedure sets used in that content stream. These procedure sets shall
//be used only when the content stream is printed to a PostScript language compatible output device.
//The names identify PostScript language procedure sets that shall be sent to the device to interpret the
//PDF operators in the content stream. Each element of this array shall be one of the predefined names
//shown in "Table 346 — Predefined procedure set"
//.
//© ISO 2020 – All rights reserved 713
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//714 © ISO 2020 – All rights reserved
//Table 346 — Predefined procedure set
//Name Category of operators
//PDF Painting and graphics state
//Text Text
//ImageB Grayscale images or image masks
//ImageC Colour images
//ImageI Indexed (colour-table) images


