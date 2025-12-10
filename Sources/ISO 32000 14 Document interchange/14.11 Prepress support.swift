// ISO 32000-2:2020, 14.11 Prepress support

import ISO_32000_Shared
//
//14.11 Prepress support
//14.11.1 General
//This subclause describes features of PDF that support prepress production workflows:
//• The specification of page boundaries governing various aspects of the prepress process, such as
//cropping, bleed, and trimming (14.11.2, "Page boundaries")
//• Facilities for including printer’s marks, such as registration targets, gray ramps, colour bars, and
//cut marks to assist in the production process (14.11.3, "Printer’s marks")
//814 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//• Information for generating colour separations for pages in a document (14.11.4, "Separation
//dictionaries")
//• Output intents for matching the colour characteristics of a document with those of a target output
//device or production environment in which it will be printed (14.11.5, "Output intents")
//• Support for the generation of traps to minimise the visual effects of misregistration between
//multiple colourants (14.11.6, "Trapping support")
//• The Open Prepress Interface (OPI) for creating low-resolution proxies for high-resolution images
//(14.11.7, "Open prepress interface (OPI)"). This feature is deprecated with PDF 2.0.
//• When overprinting (see 8.6.7, "Overprint control") is enabled, and the device is a subtractive
//colour device, "rendering for separations" may be implemented (see 10.8.2, "Separations"). In
//addition, a PDF processor may optionally support "separation simulation" for any device (see
//10.8.3, "Separation simulation").
//14.11.2 Page boundaries
//14.11.2.1 General
//A PDF page may be prepared either for a finished medium, such as a sheet of paper, or as part of a
//prepress process in which the content of the page is placed on an intermediate medium, such as film or
//an imposed reproduction plate. In the latter case, it is important to distinguish between the
//intermediate page and the finished page. The intermediate page may often include additional
//production-related content, such as bleeds or printer marks, that falls outside the boundaries of the
//finished page. To handle such cases, a PDF page may define as many as five separate boundaries to
//control various aspects of the imaging process:
//• The media box defines the boundaries of the physical medium on which the page is to be printed.
//It may include any extended area surrounding the finished page for bleed, printing marks, or
//other such purposes. It may also include areas close to the edges of the medium that cannot be
//marked because of physical limitations of the output device. Content falling outside this boundary
//may safely be discarded without affecting the meaning of the PDF file.
//• The crop box defines the region to which the contents of the page shall be clipped (cropped) when
//displayed or printed. Unlike the other boxes, the crop box has no defined meaning in terms of
//physical page geometry or intended use; it merely imposes clipping on the page contents.
//However, in the absence of additional information (such as imposition instructions specified in a
//JDF job ticket), the crop box determines how the page’s contents shall be positioned on the output
//medium. The default value is the page’s media box.
//• The bleed box (PDF 1.3) defines the region to which the contents of the page shall be clipped when
//output in a production environment. This may include any extra bleed area needed to
//accommodate the physical limitations of cutting, folding, and trimming equipment. The actual
//printed page may include printing marks that fall outside the bleed box. The default value is the
//page’s crop box.
//• The trim box (PDF 1.3) defines the intended dimensions of the finished page after trimming. It
//may be smaller than the media box to allow for production-related content, such as printing
//instructions, cut marks, or colour bars. The default value is the page’s crop box.
//• The art box (PDF 1.3) defines the extent of the page’s meaningful content (including potential
//white-space) as intended by the page’s creator. The default value is the page’s crop box.
//The page object dictionary specifies these boundaries in the MediaBox, CropBox, BleedBox, TrimBox,
//and ArtBox entries, respectively (see "Table 31 — Entries in a page object"). All of them are rectangles
//expressed in default user space units. The crop, bleed, trim, and art boxes should not ordinarily extend
//© ISO 2020 – All rights reserved 815
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//beyond the boundaries of the media box. If the bounds of the crop, trim, bleed or art box extends
//outside of the bounds of the media box, a processor shall treat the box as its intersection with the
//media box.
//"Figure 116 — Page boundaries" illustrates the relationships among these boundaries. (The
//crop box is not shown in the figure because it has no defined relationship with any of the other
//boundaries.)
//Headline
//Art box
//Trim box
//This might be a caption
//Bleed: 10.75x8.25
//Trim: 10.5x8
//marks
//Bleed box
//Mediabox
//Figure 116 — Page boundaries
//NOTE How the various boundaries are used depends on the purpose to which the page is being put.
//The following are typical purposes:
//o Placing the content of a page in another application. The art box determines the
//boundary of the content that is to be placed in the application. Depending on the
//applicable usage conventions, the placed content can be clipped to either the art
//box or the bleed box. For example, a quarter-page advertisement to be placed on a
//magazine page might be clipped to the art box on the two sides of the ad that face
//into the middle of the page and to the bleed box on the two sides that bleed over the
//edge of the page. The media box and trim box are ignored.
//o Printing a finished page. This case is typical of desktop or shared page printers, in
//which the page content is positioned directly on the final output medium. The art
//816 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//box and bleed box are ignored. The media box can be used as advice for selecting
//media of the appropriate size. The crop box and trim box, if present, needs to be the
//same as the media box.
//o Printing an intermediate page for use in a prepress process. The art box is ignored.
//The bleed box defines the boundary of the content to be imaged. The trim box
//specifies the positioning of the content on the medium; it can also be used to
//generate cut or fold marks outside the bleed box. Content falling within the media
//box but outside the bleed box might or might not be imaged, depending on the
//specific production process being used.
//o Building an imposition of multiple pages on a press sheet. The art box is ignored. The
//bleed box defines the clipping boundary of the content to be imaged; content
//outside the bleed box is ignored. The trim box specifies the positioning of the page’s
//content within the imposition. Cut and fold marks are typically generated for the
//imposition as a whole.
//14.11.2.2 Display of page boundaries
//Interactive PDF processors may offer the ability to display guidelines on the screen for the various
//page boundaries. The optional BoxColorInfo entry in a page object (see 7.7.3.3, "Page objects") holds a
//box colour information dictionary (PDF 1.4) specifying the colours and other visual characteristics to be
//used for such display. interactive PDF processors typically provide a user interface to allow the user to
//set these characteristics interactively.
//NOTE This information is page-specific and can vary from one page to another.
//As shown in "Table 396 — Entries in a box colour information dictionary", the box colour information
//dictionary may contain an optional entry for each of the possible page boundaries other than the media
//box. The value of each entry is a box style dictionary, whose contents are shown in "Table 397 —
//Entries in a box style dictionary". If a given entry is absent, the interactive PDF processor shall use its
//own current default settings instead.
//Table 396 — Entries in a box colour information dictionary
//Key Type Value
//CropBox dictionary (Optional) A box style dictionary (see "Table 397 — Entries in a box style dictionary")
//specifying the visual characteristics for displaying guidelines for the page’s crop box.
//This entry shall be ignored if no crop box is defined in the page object.
//BleedBox dictionary (Optional) A box style dictionary (see "Table 397 — Entries in a box style dictionary")
//specifying the visual characteristics for displaying guidelines for the page’s bleed box.
//This entry shall be ignored if no bleed box is defined in the page object.
//TrimBox dictionary (Optional) A box style dictionary (see "Table 397 — Entries in a box style dictionary")
//specifying the visual characteristics for displaying guidelines for the page’s trim box.
//This entry shall be ignored if no trim box is defined in the page object.
//ArtBox dictionary (Optional) A box style dictionary (see "Table 397 — Entries in a box style dictionary")
//specifying the visual characteristics for displaying guidelines for the page’s art box.
//This entry shall be ignored if no art box is defined in the page object.
//© ISO 2020 – All rights reserved 817
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 397 — Entries in a box style dictionary
//Key Type Value
//C array (Optional) An array of three numbers in the range 0.0 to 1.0, representing the
//components in the DeviceRGB colour space of the colour that shall be used for
//displaying the guidelines. Default value: [0.0 0.0 0.0].
//W number (Optional) The guideline width in default user space units. Default value: 1.
//S name (Optional) The guideline style:
//S (Solid) A solid rectangle.
//D (Dashed) A dashed rectangle. The dash pattern shall be specified by the D
//entry.
//Other guideline styles may be defined in the future. Default value: S.
//D array (Optional) A dash array defining a pattern of dashes and gaps that shall be
//used in drawing dashed guidelines (guideline style D). The dash array shall be
//specified in default user space units, in the same format as in the line dash
//pattern parameter of the graphics state (see 8.4.3.6, "Line dash pattern"). The
//dash phase shall not be specified and shall be assumed to be 0.
//EXAMPLE A D entry of [3 2] specifies guidelines drawn with 3-unit dashes
//alternating with 2-unit gaps.
//Default value: [3].
//14.11.3 Printer’s marks
//Printer’s marks are graphic symbols or text added to a page to assist production personnel in
//identifying components of a multiple-plate job and maintaining consistent output during production.
//Examples commonly used in the printing industry include:
//• Registration targets for aligning plates
//• Gray ramps and colour bars for measuring colours and ink densities
//• Cut marks showing where the output medium is to be trimmed
//Although PDF writers traditionally include such marks in the content stream of a document, they are
//logically separate from the content of the page itself and typically appear outside the boundaries (the
//crop box, trim box, and art box) defining the extent of that content (see 14.11.2, "Page boundaries").
//Printer’s mark annotations (PDF 1.4) provide a mechanism for incorporating printer’s marks into the
//PDF representation of a page, while keeping them separate from the actual page content. Each page in
//a PDF document may contain any number of such annotations, each of which represents a single
//printer’s mark. The annotation rectangle should not intersect the TrimBox.
//NOTE 1 Because printer’s marks typically fall outside the page’s content boundaries, each mark is
//represented as a separate annotation. Otherwise — if, for example, the cut marks at the four
//corners of the page were defined in a single annotation — the annotation rectangle would
//encompass the entire contents of the page and could interfere with the user’s ability to select
//content or interact with other annotations on the page. Defining printer’s marks in separate
//annotations also facilitates the implementation of a drag-and-drop user interface for specifying
//them.
//818 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//The visual presentation of a printer’s mark shall be defined by a form XObject specified as an
//appearance stream in the N (normal) entry of the printer’s mark annotation’s appearance dictionary
//(see 12.5.5, "Appearance streams"). More than one appearance may be defined for the same printer’s
//mark to meet the requirements of different regions or production facilities. In this case, the appearance
//dictionary’s N entry holds a subdictionary containing the alternative appearances, each identified by an
//arbitrary key. The AS (appearance state) entry in the annotation dictionary designates one of them to
//be displayed or printed.
//NOTE 2 The printer’s mark annotation’s appearance dictionary can include R (rollover) or D (down)
//entries, but appearances defined in either of these entries are never displayed or printed.
//Like all annotations, a printer’s mark annotation shall be defined by an annotation dictionary (see
//12.5.2, "Annotation dictionaries"); its annotation type is PrinterMark. The AP (appearances) and F
//(flags) entries (which is ordinarily optional) shall be present, as shall the AS (appearance state) entry if
//the appearance dictionary AP contains more than one appearance stream. The Print and ReadOnly
//flags in the F entry shall be set and all others clear (see 12.5.3, "Annotation flags"). "Table 398 —
//Additional entries specific to a printer’s mark annotation" shows an additional annotation dictionary
//entry specific to this type of annotation.
//Table 398 — Additional entries specific to a printer’s mark annotation
//Key Type Value
//Subtype name (Required) The type of annotation that this dictionary describes; shall be
//PrinterMark for a printer’s mark annotation.
//MN name (Optional) An arbitrary name identifying the type of printer’s mark, such as
//ColorBar or RegistrationTarget.
//The form dictionary defining a printer’s mark may contain the optional entries shown in "Table 399 —
//Additional entries specific to a printer’s mark form dictionary" in addition to the entries common to all
//form dictionaries (see 8.10.2, "Form dictionaries").
//Table 399 — Additional entries specific to a printer’s mark form dictionary
//Key Type Value
//MarkStyle text string (Optional; PDF 1.4) A text string representing the printer’s mark in human-
//readable form and suitable for presentation to the user.
//Colorants dictionary (Optional; PDF 1.4) A dictionary identifying the individual colourants
//associated with a printer’s mark, such as a colour bar. For each entry in this
//dictionary, the key is a colourant name and the value is an array defining a
//Separation colour space for that colourant (see 8.6.6.4, "Separation colour
//spaces"). The key shall match the colourant name given in that colour space.
//14.11.4 Separation dictionaries
//The features described in this clause are deprecated with PDF 2.0.
//© ISO 2020 – All rights reserved 819
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//In high-end printing workflows, pages are ultimately produced as sets of separations, one per
//colourant (see 8.6.6.4, "Separation colour spaces"). Ordinarily, each page in a PDF file shall be treated
//as a composite page that paints graphics objects using all the process colourants and perhaps some
//spot colourants as well. In other words, all separations for a page shall be generated from a single PDF
//description of that page.
//In some workflows, however, pages are preseparated before generating the PDF file. In a preseparated
//PDF file, the separations for a page shall be described as separate page objects, each painting only a
//single colourant (usually specified in the DeviceGray colour space). In this case, additional information
//is needed to identify the actual colourant associated with each separation and to group together the
//page objects representing all the separations for a given page. This information shall be contained in a
//separation dictionary (PDF 1.3) in the SeparationInfo entry of each page object (see 7.7.3.3, "Page
//objects"). "Table 400 — Entries in a separation dictionary" shows the contents of this type of
//dictionary.
//Table 400 — Entries in a separation dictionary
//Key Type Value
//Pages array (Required) An array of indirect references to page objects representing
//separations of the same document page. One of the page objects in the array
//shall be the one with which this separation dictionary is associated, and all
//of them shall have separation dictionaries (SeparationInfo entries)
//containing Pages arrays identical to this one.
//DeviceColorant name or
//string
//(Required) The name of the device colourant that shall be used in rendering
//this separation, such as Cyan or PANTONE 35 CV.
//ColorSpace array (Optional) An array defining a Separation or DeviceN colour space (see
//8.6.6.4, "Separation colour spaces" and 8.6.6.5, "DeviceN colour spaces"). It
//provides additional information about the colour specified by
//DeviceColorant — in particular, the alternate colour space and tint
//transformation function that shall be used to represent the colourant as a
//process colour. This information enables an interactive PDF processor to
//preview the separation in a colour that approximates the device colourant.
//The value of DeviceColorant shall match the space’s colourant name (if it is
//a Separation space) or be one of the space’s colourant names (if it is a
//DeviceN space).
//14.11.5 Output intents
//Output intents (PDF 1.4) provide a means for matching the colour characteristics of page content in a
//PDF document with those of a target output device. The optional OutputIntents entry in the document
//catalog dictionary (see 7.7.2, "Document catalog dictionary") or a Page dictionary (see 7.7.3.3, "Page
//objects") holds an array of output intent dictionaries, each describing the colour reproduction
//characteristics of a possible output device. The contents of these dictionaries will often vary for
//different devices. The dictionary’s S entry specifies an output intent subtype that determines the
//format and meaning of the remaining entries.
//NOTE 1 This use of multiple output intents allows the output to be customised to the expected workflow
//and the specific tools available. For example, one processor can process PDF files conforming to a
//820 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//recognised standard such as PDF/X-1a which is based upon CMYK processing, while another
//uses the PDF/A (ISO 19005) standard to produce RGB output for document distribution on the
//Web. Each of these workflows can require different sets of output intent information. Multiple
//output intents also allow the same PDF file to be distributed unmodified to multiple destinations.
//The choice of which output intent to use in a given workflow is outside the scope of ISO 32000-2
//and therefore PDF intentionally does not include a selector for choosing a particular output
//intent from within the PDF file. It nevertheless does offer a provision for specifying a default
//output intent to be use if no other provisions are in effect.
//At the time of publication, three output intent subtypes in the document catalog dictionary have been
//defined: GTS_PDFX, GTS_PDFA1, and ISO_PDFE1.
//"Table 401 — Entries in an output intent dictionary"
//lists the keys used in these subtypes of output intent dictionaries. Other subtypes may be added in the
//future; the names of any such additional subtypes shall conform to the naming guidelines described in
//Annex E, "Extending PDF".
//NOTE 2 GTS_PDFX corresponds to the PDF/X format standards (ISO 15930, all parts), GTS_PDFA1
//corresponds to the PDF/A standards (ISO 19005, all parts), and ISO_PDFE1 corresponds to the
//PDF/E standards (ISO 24517, all parts). Use of one of these subtypes is assumed to imply
//semantics for the content of the output intent dictionary that are specified by those standards.
//Table 401 — Entries in an output intent dictionary
//Key Type Value
//Type name (Optional) The type of PDF object that this dictionary describes; if
//present, shall be OutputIntent for an output intent dictionary.
//S name (Required) The output intent subtype. The value may be GTS_PDFX,
//GTS_PDFA1, ISO_PDFE1 or a key defined by an ISO 32000 extension.
//OutputCondition text string (Optional) A text string concisely identifying the intended output
//device or production condition in human-readable form. This is the
//preferred method of defining such a string for presentation to the
//user.
//OutputConditionIdentifier text string (Required) A text string identifying the intended output device or
//production condition in human- or machine-readable form. If
//human-readable, this string may be used in lieu of an
//OutputCondition string for presentation to the user.
//A typical value for this entry may be the name of a production
//condition maintained in an industry-standard registry such as the
//ICC Characterization Data Registry. If the designated condition
//matches that in effect at production time, the production software is
//responsible for providing the corresponding ICC profile as defined in
//the registry.
//If the intended production condition is not a recognised standard, the
//value of this entry may be Custom or an application-specific,
//machine-readable name. The DestOutputProfile entry defines the
//ICC profile, and the Info entry shall be used for further human-
//readable identification.
//RegistryName text string (Optional) A text string (conventionally a uniform resource identifier,
//or URI) identifying the registry in which the condition designated by
//OutputConditionIdentifier is defined.
//© ISO 2020 – All rights reserved 821
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//Info text string (Required if OutputConditionIdentifier does not specify a standard
//production condition; optional otherwise) A human-readable text
//string containing additional information or comments about the
//intended target device or production condition.
//DestOutputProfile stream (Required if OutputConditionIdentifier does not specify a standard
//production condition; optional otherwise) An ICC profile stream
//defining the transformation from the PDF document’s source colours
//to output device colourants.
//The format of the profile stream is the same as that used in
//specifying an ICCBased colour space (see 8.6.5.5, "ICCBased colour
//spaces"). The output transformation uses the profile’s "from CIE"
//information (BToA in ICC terminology); the "to CIE" (AToB)
//information may optionally be used to remap source colour values to
//some other destination colour space, such as for screen preview or
//hardcopy proofing.
//DestOutputProfileRef dictionary (Optional; PDF 2.0) A dictionary containing information about one or
//more referenced ICC profiles. See "Table 402 — Entries in a
//DestOutputProfileRef dictionary"
//.
//MixingHints dictionary (Optional, PDF 2.0) A DeviceN Mixing Hints dictionary ("Table 72 —
//Entries in a DeviceN mixing hints dictionary") which shall not
//contain a DotGain key.
//NOTE 1 This is because dot gain information is better handled according to
//ISO 17972-4.
//In addition, each key in the Solidities dictionary referenced from the
//MixingHints dictionary shall not also be present in the SpectralData
//dictionary within the same output intent.
//NOTE 2 This is because it would not be clear which one is to be used, so
//only allowing one place where such data are present avoids the
//conflict.
//This document intentionally does not specify how a PDF processor
//may make use of the data provided in the MixingHints dictionary,
//and a PDF processor may ignore such data altogether.
//EXAMPLE 1 The data in the MixingHints dictionary could be used in
//the process of rendering or color converting the colourants
//specified in the Solidities dictionary referenced from the
//MixingHints dictionary.
//822 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//SpectralData dictionary (Optional, PDF 2.0) A dictionary where each key represents a
//colourant name as defined in 8.6.6.4,
//"Separation colour spaces" and
//where the value of each key shall be a stream whose contents shall
//represent CxF/X-4 spot colour characterisation data that conform to
//ISO 17972-4. This stream shall contain exactly one
//SpotInkCharacterisation element whose SpotInkName matches
//the colourant name (see 7.3.5,
//"Name objects"). In addition, this
//stream may contain zero or more further SpotInkCharacterisation
//elements, and/or other data.
//NOTE 3 This facilitates referencing the same CxF/X-4 data stream from
//more than one entry in the SpectralData dictionary, as long as for
//each such entry there is a matching SpotInkCharacterisation
//entry in the CxF/X-4 data stream.
//In addition, each key in this dictionary shall not also be present in the
//Solidities dictionary referenced from the MixingHints dictionary
//within the same output intent.
//NOTE 4 This is because it would not be clear which one is to be used, so by
//only allowing one place where such data are present it avoids the
//conflict.
//This document intentionally does not specify how a PDF processor
//may make use of the data provided in the SpectralData dictionary,
//and a PDF processor may ignore such data altogether.
//EXAMPLE 2 The data in the SpectralData dictionary could be used in
//the process of rendering or colour converting the colourants
//specified in the SpectralData dictionary.
//Table 402 — Entries in a DestOutputProfileRef dictionary
//Key Type Value
//CheckSum string (Optional, PDF 2.0) An MD5 hash consisting of a 16 byte string that shall be computed
//as described in "7.11.4, "Embedded file streams" for the uncompressed ICC profile file.
//NOTE 1 Any MD5 embedded within the ICC profile itself is computed differently and is
//inappropriate for use as the value of the CheckSum key.
//NOTE 2 This is strictly a checksum, and is not used for security purposes.
//ColorantTable array (Optional, PDF 2.0) An array of colourant names, each of which shall be encoded as a
//name object. The order and names of the colourants in ColorantTable shall be
//identical to those in the ICC colorantTableTag in the ICC profile.
//ICCVersion string (Optional, PDF 2.0) The value of bytes 8 to 11, ICC profile version number, from the
//header of the ICC profile.
//ProfileCS string (Optional, PDF 2.0) The four-byte colour space signature of the ICC profile, including
//any space characters.
//ProfileName text
//string
//(Optional, PDF 2.0) The value of the ICC profileDescriptionTag from the ICC profile.
//© ISO 2020 – All rights reserved 823
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//URLs array (Optional, PDF 2.0) An array, containing at least one element, where each element shall
//be an embedded file specification (7.11.4,
//"Embedded file streams") or a URL file
//specification (7.11.5, "URL specifications").
//NOTE: ICC profiles referenced via the URLs array do not have to conform to the ICCBased
//requirements of "Table 67 — ICC profile types" and thus can also support N-
//component output profiles.
//In addition to the output intent subtype being different in PDF/X, PDF/A and PDF/E, these standards
//also impose additional requirements on the presence (or absence) of the various keys in the output
//intent dictionary and the values thereof. The ICC profile information in an output intent dictionary
//should supplement rather than replace that in an ICCBased or default colour space (see 8.6.5.5,
//"ICCBased colour spaces" and 8.6.5.6, "Default colour spaces"). Those mechanisms are specifically
//intended for describing the characteristics of source colour component values. An output intent may be
//used in conjunction with them to convert source colours to those required for the intended output
//device.
//The data in an output intent dictionary shall be for informational purposes only, and PDF processors
//are free to disregard it. If a PDF processor chooses to respect output intents, then when processing a
//page that has an associated (page-level) output intent, that page-level output intent shall be used.
//NOTE 3 There is no expectation that PDF production tools automatically convert colours expressed in the
//same source colour space to the specified target space before generating output. In some
//workflows, such conversion is undesirable.
//EXAMPLE 1 This Example shows a PDF/X output intent dictionary based on an industry-standard production condition
//(CGATS TR 001) from the ICC Characterization Data Registry. Example 2 shows one for a custom production
//condition.
//<< /Type /OutputIntent %Output intent dictionary
///S /GTS_PDFX
///OutputCondition (CGATS TR 001 (SWOP))
///OutputConditionIdentifier (CGATS TR 001)
///RegistryName (http://www.color.org)
///DestOutputProfile 100 0 R
//>>
//100 0 obj %ICC profile stream
//<</N 4
///Length 1605
///Filter /ASCIIHexDecode
//>>
//stream
//00 00 02 0C 61 70 … >
//endstream
//endobj
//EXAMPLE 2
//<< /Type /OutputIntent %Output intent dictionary
///S /GTS_PDFX
///OutputCondition (Coated)
///OutputConditionIdentifier (Custom)
///Info (Coated 150lpi)
///DestOutputProfile 100 0 R
//>>
//824 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//100 0 obj %ICC profile stream
//<< /N 4
///Length 1605
///Filter /ASCIIHexDecode
//>>
//stream
//00 00 02 0C 61 70…>
//endstream
//endobj
//14.11.6 Trapping support
//14.11.6.1 General
//The features described in this clause are deprecated with PDF 2.0.
//On devices such as offset printing presses, which mark multiple colourants on a single sheet of physical
//medium, mechanical limitations of the device can cause imprecise alignment, or misregistration,
//between colourants. This can produce unwanted visual artifacts such as brightly coloured gaps or
//bands around the edges of printed objects. In high-quality reproduction of colour documents, such
//artifacts are commonly avoided by creating an overlap, called a trap, between areas of adjacent colour.
//NOTE "Figure 117 — Trapping example" shows an example of trapping. The light and medium grays
//represent two different colourants, which are used to paint the background and the glyph
//denoting the letter A. The first figure shows the intended result, with the two colourants
//properly registered. The second figure shows what happens when the colourants are
//misregistered. In the third figure, traps have been overprinted along the boundaries, obscuring
//the artifacts caused by the misregistration. (For emphasis, the traps are shown here in dark gray;
//in actual practice, their colour will be similar to one of the adjoining colours.)
//Figure 117 — Trapping example
//Trapping may be implemented by the application generating a PDF file, by some intermediate
//application that adds traps to a PDF document, or by the raster image processor (RIP) that produces
//final output. In the last two cases, the trapping process is controlled by a set of trapping instructions,
//which define two kinds of information:
//• Trapping zones within which traps should be created
//• Trapping parameters specifying the nature of the traps within each zone
//Trapping zones and trapping parameters are discussed fully in 6.3.2 and 6.3.3, respectively, of the
//PostScript Language Reference, Third Edition. Trapping instructions are not directly specified in a PDF
//© ISO 2020 – All rights reserved 825
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//file (as they are in a PostScript file). Instead, they shall be specified in a job ticket that accompanies the
//PDF file or is embedded within it.
//NOTE The primary format of job tickets is JDF (Job Definition Format) described in the CIP4 document
//JDF Specification.
//When trapping is performed before the production of final output, the resulting traps shall be placed in
//the PDF file for subsequent use. The traps themselves shall be described as a content stream in a trap
//network annotation (see 14.11.6.2, "Trap network annotations"). The stream dictionary may include
//additional entries describing the method that was used to produce the traps and other information
//about their appearance.
//14.11.6.2 Trap network annotations
//The features described in this subclause are deprecated with PDF 2.0.
//A complete set of traps generated for a given page under a specified set of trapping instructions is
//called a trap network (PDF 1.3). It is a form XObject containing graphics objects for painting the
//required traps on the page. A page may have more than one trap network based on different trapping
//instructions, presumably intended for different output devices. All of the trap networks for a given
//page shall be contained in a single trap network annotation (see 12.5, "Annotations"). There may be at
//most one trap network annotation per page, which shall be the last element in the page’s Annots array
//(see 7.7.3.3, "Page objects"). This ensures that the trap network shall be printed after all of the page’s
//other contents.
//The form XObject defining a trap network shall be specified as an appearance stream in the N (normal)
//entry of the trap network annotation’s appearance dictionary (12.5.5, "Appearance streams"). If more
//than one trap network is defined for the same page, the N entry holds a subdictionary containing the
//alternate trap networks, each identified by an arbitrary key. The AS (appearance state) entry in the
//annotation dictionary designates one of them as the current trap network to be displayed or printed.
//NOTE 1 The trap network annotation’s appearance dictionary can include R (rollover) or D (down)
//entries, but appearances defined in either of these entries are never printed.
//Like all annotations, a trap network annotation shall be defined by an annotation dictionary (see
//12.5.2, "Annotation dictionaries"); its annotation type is TrapNet. The AP (appearances), AS
//(appearance state), and F (flags) entries (which ordinarily are optional) shall be present, with the Print
//and ReadOnly flags set and all others clear (see 12.5.3, "Annotation flags"). "Table 403 — Additional
//entries specific to a trap network annotation" shows the additional annotation dictionary entries
//specific to this type of annotation.
//The Version and AnnotStates entries, if present, shall be used to detect changes in the content of a
//page that might require regenerating its trap networks. The Version array identifies elements of the
//page’s content that might be changed by an editing application and thus invalidate its trap networks.
//Because there is at most one Version array per trap network annotation (and thus per page), any PDF
//writer that generates a new trap network shall also verify the validity of existing trap networks by
//enumerating the objects identified in the array and verifying that the results exactly match the array’s
//current contents. Any trap networks found to be invalid shall be regenerated.
//The LastModified entry may be used in place of the Version array to track changes to a page’s trap
//network. (The trap network annotation shall include either a LastModified entry or the combination
//826 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//of Version and AnnotStates, but not all three.) If the modification date in the LastModified entry of
//the page object (see 7.7.3.3, "Page objects") is more recent than the one in the trap network annotation
//dictionary, the page’s trap networks are invalid and shall be regenerated.
//NOTE 2 Not all editing applications correctly maintain these modification dates.
//This method of tracking trap network modifications may be used reliably only in a controlled workflow
//environment where the integrity of the modification dates is assured.
//Table 403 — Additional entries specific to a trap network annotation
//Key Type Value
//Subtype name (Required) The type of annotation that this dictionary describes; shall be
//TrapNet for a trap network annotation.
//LastModified date (Required if Version and AnnotStates are absent; shall be absent if Version and
//AnnotStates are present; PDF 1.4) The date and time (see 7.9.4, "Dates") when
//the trap network was most recently modified.
//Version array (Required if AnnotStates is present; shall be absent if LastModified is present)
//An unordered array of all objects present in the page description at the time the
//trap networks were generated and that, if changed, could affect the appearance
//of the page. If present, the array shall include the following objects:
//• All content streams identified in the page object’s Contents entry (see 7.7.3.3,
//"Page objects")
//• All resource objects (other than procedure sets) in the page’s resource dictionary
//(see 7.8.3, "Resource dictionaries")
//• All resource objects (other than procedure sets) in the resource dictionaries of
//any form XObjects on the page (see 8.10, "Form XObjects")
//• All OPI dictionaries associated with XObjects on the page (see 14.11.7, "Open
//prepress interface (OPI)"). This entry is deprecated in PDF 2.0.
//AnnotStates array (Required if Version is present; shall be absent if LastModified is present) An
//array of name objects representing the appearance states (value of the AS
//entry) for annotations associated with the page. The appearance states shall be
//listed in the same order as the annotations in the page’s Annots array (see
//7.7.3.3, "Page objects"). For an annotation with no AS entry, the corresponding
//array element should be null. No appearance state shall be included for the
//trap network annotation itself.
//FontFauxing array (Optional) An array of font dictionaries representing fonts that were fauxed
//(replaced by substitute fonts) during the generation of trap networks for the
//page.
//14.11.6.3 Trap network appearances
//The features described in this subclause are deprecated with PDF 2.0.
//Each entry in the N (normal) subdictionary of a trap network annotation’s appearance dictionary holds
//an appearance stream defining a trap network associated with the given page. Like all appearances, a
//trap network is a stream object defining a form XObject (see 8.10, "Form XObjects"). The body of the
//stream contains the graphics objects needed to paint the traps making up the trap network. Its
//© ISO 2020 – All rights reserved 827
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//dictionary entries include, besides the standard entries for a form dictionary, the additional entries
//shown in "Table 404 — Additional entries specific to a trap network appearance stream"
//.
//Table 404 — Additional entries specific to a trap network appearance stream
//Key Type Value
//PCM name (Required) The name of the process colour model that was assumed when this
//trap network was created; equivalent to the PostScript language page device
//parameter ProcessColorModel (see clause 6.2.5 of the PostScript Language
//Reference, Third Edition). Valid values are DeviceGray, DeviceRGB, DeviceCMYK,
//DeviceCMY, DeviceRGBK, and DeviceN.
//SeparationColorNames array (Optional) An array of names identifying the colourants that were assumed when
//this network was created; equivalent to the PostScript language page device
//parameter of the same name (see clause 6.2.5 of the PostScript Language
//Reference, Third Edition). Colourants implied by the process colour model PCM
//are available automatically and need not be explicitly declared. If this entry is
//absent, the colourants implied by PCM shall be assumed.
//TrapRegions array (Optional; deprecated in PDF 2.0) An array of indirect references to TrapRegion
//objects defining the page’s trapping zones and the associated trapping
//parameters, as described in Adobe Technical Note #5620, Portable Job Ticket
//Format. These references refer to objects comprising portions of a PJTF job ticket
//that shall be embedded in the PDF file. When the trapping zones and parameters
//are defined by an external job ticket (or by some other means, such as JDF), this
//entry shall be absent.
//TrapStyles text
//string
//(Optional) A human-readable text string that applications may use to describe this
//trap network to the user.
//EXAMPLE To allow switching between trap networks.
//A PDF writer that supports preseparation shall perform that operation after trapping, and not before.
//It is also responsible for calculating new Version arrays for the separation trap networks.
//NOTE Preseparated PDF pages in preseparated PDF files (see 14.11.4, "Separation dictionaries")
//cannot be trapped because traps are defined along the borders between different colours and a
//preseparated PDF file uses only one colour.
//14.11.7 Open prepress interface (OPI)
//The features described in this subclause are deprecated with PDF 2.0.
//The workflow in a prepress environment often involves multiple applications in areas such as graphic
//design, page layout, word processing, photo manipulation, and document construction. As pieces of the
//final document are moved from one application to another, it is useful to separate the data of high-
//resolution images, which can be quite large — in some cases, many times the size of the rest of the
//document combined — from that of the document itself. The Open Prepress Interface (OPI) is a
//mechanism, originally developed by Aldus Corporation, for creating low-resolution placeholders, or
//proxies, for such high-resolution images. The proxy typically consists of a downsampled version of the
//full-resolution image, to be used for screen display and proofing. Before the document is printed, it
//828 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//passes through a filter known as an OPI server, which replaces the proxies with the original full-
//resolution images.
//NOTE 1 In PostScript programs, OPI proxies are defined by PostScript language code surrounded by
//special OPI comments, which specify such information as the placement and cropping of the
//image and adjustments to its size, rotation, colour, and other attributes.
//In PDF, proxies shall be embedded in a document as image or form XObjects with an associated OPI
//dictionary (PDF 1.2). This dictionary contains the same information that the OPI comments convey in
//PostScript language. Two versions of OPI shall be supported, versions 1.3 and 2.0. In OPI 1.3, a proxy
//consisting of a single image, with no changes in the graphics state, may be represented as an image
//XObject; otherwise it shall be a form XObject. In OPI 2.0, the proxy always entails changes in the
//graphics state and hence shall be represented as a form XObject.
//An XObject representing an OPI proxy shall contain an OPI entry in its image or form dictionary (see
//"Table 87 — Additional entries specific to an image dictionary" and "Table 93 — Additional entries
//specific to a Type 1 form dictionary"). The value of this entry is an OPI version dictionary ("Table 405
//— Entry in an OPI version dictionary") identifying the version of OPI to which the proxy corresponds.
//This dictionary consists of a single entry, whose key is the name 1.3 or 2.0 and whose value is the OPI
//dictionary defining the proxy’s OPI attributes.
//Table 405 — Entry in an OPI version dictionary
//Key Type Value
//version
//number
//dictionary (Required; PDF 1.2) An OPI dictionary specifying the attributes of this
//proxy (see "Table 406 — Entries in a version 1.3 OPI dictionary" and
//"Table 407 — Entries in a version 2.0 OPI dictionary"). The key for this
//entry shall be the name 1.3 or 2.0, identifying the version of OPI to which
//the proxy corresponds.
//NOTE 2 As in any other PDF dictionary, the key in an OPI version dictionary is a name object. The OPI
//version dictionary would thus be written in the PDF file in either the form
//<</1.3 d 0 R>> %OPI 1.3 dictionary
//or
//<</2.0 d 0 R>> %OPI 2.0 dictionary
//where d is the object number of the corresponding OPI dictionary.
//"Table 406 — Entries in a version 1.3 OPI dictionary" and "Table 407 — Entries in a version 2.0 OPI
//dictionary") describe the contents of the OPI dictionaries for OPI 1.3 and OPI 2.0, respectively, along
//with the corresponding PostScript language OPI comments. The dictionary entries shall be listed in the
//order in which the corresponding OPI comments appear in a PostScript program. OPI: Open Prepress
//Interface Specification 1.3 and Adobe Technical Note #5660, Open Prepress Interface (OPI) Specification,
//Version 2.0 shall define the complete details on the meanings of these entries and their effects on OPI
//servers.
//© ISO 2020 – All rights reserved 829
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 406 — Entries in a version 1.3 OPI dictionary
//Key Type OPI Comment Value
//Type name (Optional) The type of PDF object that this
//dictionary describes; if present, shall be OPI for
//an OPI dictionary.
//Version number (Required) The version of OPI to which this
//dictionary refers; shall be the number 1.3 (not the
//name 1.3, as in an OPI version dictionary).
//F file
//specification
//%ALDImageFilename (Required) The external file containing the image
//corresponding to this proxy.
//ID byte string %ALDImageID (Optional) An identifying string denoting the
//image.
//Comments text string %ALDObjectComments (Optional) A human-readable comment, typically
//containing instructions or suggestions to the
//operator of the OPI server on how to handle the
//image.
//Size array %ALDImageDimensions (Required) An array of two integers of the form
//[pixelsWide pixelsHigh]
//specifying the dimensions of the image in pixels.
//CropRect rectangle %ALDImageCropRect (Required) An array of four integers of the form
//[left top right bottom]
//specifying the portion of the image that shall be
//used.
//CropFixed array %ALDImageCropFixed (Optional) An array with the same form and
//meaning as CropRect, but expressed in real
//numbers instead of integers. Default value: the
//value of CropRect.
//830 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type OPI Comment Value
//Position array %ALDImagePosition (Required) An array of eight numbers of the form
//[llx lly ulx uly urx ury lrx lry]
//specifying the location on the page of the cropped
//image, where (llx, lly ) are the user space
//coordinates of the lower-left corner, (ulx, uly ) are
//those of the upper-left corner, (urx, ury ) are those
//of the upper-right corner, and (lrx, lry ) are those
//of the lower-right corner. The specified
//coordinates shall define a parallelogram; that is,
//they shall satisfy the conditions
//𝑢𝑙𝑥− 𝑙𝑙𝑥
//= 𝑢𝑟 𝑥− 𝑙𝑟 𝑥
//and
//𝑢𝑙𝑦− 𝑙𝑙𝑦
//= 𝑢𝑟 𝑦− 𝑙𝑟 𝑦
//The combination of Position and CropRect
//determines the image’s scaling, rotation,
//reflection, and skew.
//Resolution array %ALDImageResolution (Optional) An array of two numbers of the form
//[horizRes vertRes]
//specifying the resolution of the image in samples
//per inch.
//ColorType name %ALDImageColorType (Optional) The type of colour specified by the
//Color entry. Valid values are Process, Spot, and
//Separation. Default value: Spot.
//Color array %ALDImageColor (Optional) An array of four numbers and a byte
//string of the form
//[C M Y K colorName]
//specifying the value and name of the colour in
//which the image is to be rendered. The values of
//C, M, Y, and K shall all be in the range 0.0 to 1.0.
//Default value: [0.0 0.0 0.0 1.0 ( Black )].
//Tint number %ALDImageTint (Optional) A number in the range 0.0 to 1.0
//specifying the concentration of the colour
//specified by Color in which the image is to be
//rendered. Default value: 1.0.
//Overprint boolean %ALDImageOverprint (Optional) A flag specifying whether the image is
//to overprint (true) or knock out (false)
//underlying marks on other separations. Default
//value: false.
//© ISO 2020 – All rights reserved 831
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type OPI Comment Value
//ImageType array %ALDImageType (Optional) An array of two integers of the form
//[samples bits]
//specifying the number of samples per pixel and
//bits per sample in the image.
//GrayMap array %ALDImageGrayMap (Optional) An array of 2n integers in the range 0
//to 65,535 (where n is the number of bits per
//sample) recording changes made to the
//brightness or contrast of the image.
//Transparency boolean %ALDImageTransparency (Optional) A flag specifying whether white pixels
//in the image shall be treated as transparent.
//Default value: true.
//Tags array %ALDImageAsciiTag<NNN> (Optional) An array of pairs of the form
//[tagNum1 tagText1…tagNumn tagTextn]
//where each tagNum is an integer representing a
//TIFF tag number and each tagText is an ASCII
//string representing the corresponding ASCII tag
//value.
//Table 407 — Entries in a version 2.0 OPI dictionary
//Key Type OPI Comment Value
//Type name (Optional) The type of PDF object that this
//dictionary describes; if present, shall be
//OPI for an OPI dictionary.
//Version number (Required) The version of OPI to which this
//dictionary refers; shall be the number 2 or
//2.0 (not the name 2.0, as in an OPI version
//dictionary).
//F file
//MainImage %%ImageFilename byte string (Required) The external file containing the
//low-resolution proxy image.
//specification
//%%MainImage (Optional) The pathname of the file
//containing the full-resolution image
//corresponding to this proxy, or any other
//identifying string that uniquely identifies
//the full-resolution image.
//832 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type OPI Comment Value
//Tags array %%TIFFASCIITag (Optional) An array of pairs of the form
//[tagNum1 tagText1…tagNumn tagTextn]
//where each tagNum is an integer
//representing a TIFF tag number and each
//tagText is an ASCII string or an array of
//ASCII strings representing the
//corresponding ASCII tag value.
//Size array %%ImageDimensions (Optional) An array of two numbers of the
//form
//[width height]
//specifying the dimensions of the image in
//pixels.
//CropRect rectangle %%ImageCropRect (Optional) An array of four numbers of the
//form
//[left top right bottom]
//specifying the portion of the image that
//shall be used.
//The Size and CropRect entries shall either
//both be present or both be absent. If
//present, they shall satisfy the conditions
//0 ≤ left <right ≤ width
//and
//0 ≤ top <bottom ≤ height
//In this coordinate space, the positive y axis
//extends vertically downward; hence, the
//requirement that top < bottom.
//Overprint boolean %%ImageOverprint (Optional) A flag specifying whether the
//image is to overprint (true) or knock out
//(false) underlying marks on other
//separations. Default value: false.
//© ISO 2020 – All rights reserved 833
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type OPI Comment Value
//Inks name or
//array
//%%ImageInks (Optional) A name object or array
//specifying the colourants to be applied to
//the image. The value may be the name
//full_color or registration or an array of the
//form
//[/monochrome name1 tint1…namen tintn]
//where each name is a string representing
//the name of a colourant and each tint is a
//real number in the range 0.0 to 1.0
//specifying the concentration of that
//colourant to be applied.
//IncludedImageDimensions array %%IncludedImageDim
//ensions
//(Optional) An array of two integers of the
//form
//[pixelsWide pixelsHigh]
//specifying the dimensions of the included
//image in pixels.
//IncludedImageQuality number %%IncludedImageQua
//lity
//(Optional) A number indicating the quality
//of the included image. Valid values are 1, 2,
//and 3.
//14.12 Document parts
