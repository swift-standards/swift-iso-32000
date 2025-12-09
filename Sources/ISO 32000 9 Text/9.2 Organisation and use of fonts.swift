// ISO 32000-2:2020, 9.2 Organisation and use of fonts

import ISO_32000_Shared

//
//9.2 Organisation and use of fonts
//9.2.1 General
//A character is an abstract symbol, whereas a glyph is a specific graphical rendering of a character.
//EXAMPLE 1 The glyphs A, A, and A are renderings of the abstract "A" character.
//NOTE 1 Historically these two terms have often been used interchangeably in computer typography (as
//evidenced by the names chosen for some PDF dictionary keys and PostScript language
//operators), but advances in this area have made the distinction more meaningful. Consequently,
//this document distinguishes between characters and glyphs, though with some residual names
//which are inconsistent.
//Glyphs are organised into fonts. A font defines glyphs for a particular character set.
//EXAMPLE 2 The Helvetica and Times fonts define glyphs for a set of standard Latin characters.
//A font for use with a PDF processor is prepared in the form of a program. Such a font program shall be
//written in a special-purpose language, such as the Type 1, TrueType™, or OpenType® font format, that is
//understood by a specialised font interpreter.
//In PDF, the term font refers to a font dictionary, a PDF object that identifies the font program and
//contains additional information about it. There are several different font types, identified by the
//Subtype entry of the font dictionary.
//© ISO 2020 – All rights reserved 293
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//For most font types, the font program shall be defined in a separate font program, which may be either
//embedded in a PDF stream object or obtained from an external source. The font program contains
//glyph descriptions that generate glyphs.
//NOTE 2 It is important to carefully distinguish among: 1) PDF objects that compose the PDF structure
//flowing from a PDF font dictionary, 2) actual font files that can be external to the PDF or
//embedded in the PDF as a PDF stream object, and 3) terminology used to distinguish varying
//font and glyph technologies. For example, TrueType is a valid value of the Subtype key in a font
//dictionary, but is also the name used for a glyph technology and the name used for font programs
//employing that technology. It is often the case that select material from a font file is extracted
//and used to populate various PDF data structures and the terminology will shift from what is
//used for font file formats to what is used for the PDF objects.
//PDF supports 3 different graphic representations for the shapes of glyphs which have come to be
//called: Type 1, TrueType and CFF (a compact representation derived from Type 1). Further
//complicating this, TrueType fonts contain TrueType glyph descriptions, Type 1 fonts contain Type 1
//glyph descriptions and OpenType fonts can contain either TrueType glyph descriptions or CFF glyph
//descriptions. So the term TrueType can be used to distinguish a font file format, the glyph descriptions
//found in those files, the glyph descriptions found in some OpenType format fonts and the value of the
//Subtype key in a font dictionary. "Table 108 — Font types" provides a good summary of this
//information.
//In the descriptions below the discussion is about the PDF objects used to represent the font
//information and the glyph technology used, so the terminology is primarily referring to PDF objects.
//For example, the use of TrueType (as a glyph technology) is much more prevalent than the use of
//OpenType (as a file format).
//A content stream paints glyphs on the page by specifying a font dictionary and a string object that shall
//be interpreted as a sequence of one or more character codes identifying glyphs in the font. This
//operation is called showing the text string; the text strings drawn in this way are called show strings.
//The glyph description consists of a sequence of graphics operators that produce the specific shape for
//that character in this font. To render a glyph, the PDF processor executes the glyph description.
//NOTE 3 Programmers who have experience with scan conversion of general shapes need not be
//concerned about the amount of computation that this description seems to imply. However, this
//is only the abstract behaviour of glyph descriptions and font programs, not how they are
//implemented. In fact, an efficient implementation can be achieved through careful caching and
//reuse of previously rendered glyphs.
//9.2.2 Basics of showing text
//EXAMPLE 1 This example illustrates the most straightforward use of a font. The text ABC is placed 10 inches from the
//bottom of the page and 4 inches from the left edge, using 12-point Helvetica.
//BT
///F13 12 Tf
//288 720 Td
//( ABC ) Tj
//ET
//The five lines of EXAMPLE 1 perform these steps:
//a) Begin a text object.
//294 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//b) Set the font and font size to use, installing them as parameters in the text state. In this case, the font
//resource identified by the name F13 specifies the font externally known as Helvetica.
//c) Specify a starting position on the page, setting parameters in the text object.
//d) Paint the glyphs for a string of characters at that position.
//e) End the text object.
//This subclause explains these operations in more detail.
//To paint glyphs, a content stream shall first identify the font to be used. The Tf operator shall specify
//the name of a font resource — that is, an entry in the Font subdictionary of the current resource
//dictionary. The value of that entry shall be a font dictionary. The font dictionary shall identify the font’s
//externally known name, such as Helvetica, and shall supply some additional information that the PDF
//processor needs to paint glyphs from that font. The font dictionary may provide the definition of the
//font program itself.
//NOTE 1 The font resource name presented to the Tf operator is arbitrary, as are the names for all kinds
//of resources. It bears no relationship to an actual font name, such as Helvetica.
//EXAMPLE 2 This Example illustrates an excerpt from the current page’s resource dictionary, which defines the font
//dictionary that is referenced as F13 (see Example 1 in this subclause).
///Resources
//>>
//<</Font <</F13 23 0 R>>
//23 0 obj
//<</Type /Font
///Subtype /Type1
///BaseFont /Helvetica
//>>
//endobj
//A font defines the glyphs at one standard size. This standard is arranged so that the nominal height of
//tightly spaced lines of text is 1 unit. In the default user coordinate system, this means the standard
//glyph size is 1 unit in user space, or 1 ⁄ 72 inch. Starting with PDF 1.6, the size of this unit may be
//specified as greater than 1 ⁄ 72 inch by means of the UserUnit entry of the page dictionary; see "Table
//31 — Entries in a page object". The standard-size font shall then be scaled to be usable. The scale factor
//is specified as the second operand of the Tf operator, thereby setting the text font size parameter in the
//graphics state. Example 1 in this subclause establishes the Helvetica font with a 12-unit size in the
//graphics state.
//Once the font has been selected and scaled, it may be used to paint glyphs. The Td operator shall adjust
//the translation components of the text matrix, as described in 9.4.2, "Text-positioning operators"
//.
//When executed for the first time after BT, Td shall establish the text position in the current user
//coordinate system. This determines the position on the page at which to begin painting glyphs.
//The Tj operator shall take a string operand and shall paint the corresponding glyphs, using the current
//font and other text-related parameters in the graphics state.
//NOTE 2 The Tj operator treats each element of the string (an integer in the range 0 to 255) as a character
//code (see Example 1 in this subclause).
//Each byte shall select a glyph description in the font, and the glyph description shall be executed to
//paint that glyph on the page. This is the behaviour of Tj for simple fonts, such as ordinary Latin text
//© ISO 2020 – All rights reserved 295
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//fonts. Interpretation of the string as a sequence of character codes is more complex for composite
//fonts, described in 9.7, "Composite fonts"
//.
//What these steps produce on the page is not a 12-point glyph, but rather a 12-unit glyph, where the
//unit size shall be that of the text space at the time the glyphs are rendered on the page. The actual size
//of the glyph is determined by the text matrix (Tm) in the text object, several text state parameters, and
//the current transformation matrix (CTM) in the graphics state; see 9.4.4, "Text space details"
//.
//EXAMPLE 3 If the text space is later scaled to make the unit size 1 centimetre, painting glyphs from the same 12-unit font
//generates results that are 12 centimetres high.
//9.2.3 Achieving special graphical effects
//Normal uses of Tj and other glyph-painting operators cause black-filled glyphs to be painted. Other
//effects may be obtained by combining font operators with general graphics operators.
//The colour used for painting glyphs shall be the current colour in the graphics state: either the
//nonstroking colour or the stroking colour (or both), depending on the text rendering mode (see 9.3.6,
//"Text rendering mode"). The default colour shall be black (in DeviceGray), but other colours may be
//obtained by executing an appropriate colour-setting operator or operators (see 8.6.8, "Colour
//operators") before painting the glyphs.
//EXAMPLE 1 This example uses text rendering mode 0 and the g operator to fill glyphs in 50 percent gray, as shown in
//"Figure 51 — Glyphs painted in 50% gray"
//.
//BT
///F13 48 Tf
//20 40 Td
//0 Tr
//0.5 g
//(ABC) Tj
//ET
//Figure 51 — Glyphs painted in 50% gray
//Other graphical effects may be achieved by treating the glyph outline as a path instead of filling it. The
//text rendering mode parameter in the graphics state specifies whether glyph outlines shall be filled,
//stroked, used as a clipping boundary, or some combination of these effects. Only a subset of the
//possible rendering modes applies to Type 3 fonts.
//EXAMPLE 2 This example treats glyph outlines as a path to be stroked. The Tr operator sets the text rendering mode to
//1 (stroke). The w operator sets the line width to 2 units in user space. Given those graphics state parameters,
//the Tj operator strokes the glyph outlines with a line 2 units thick (see "Figure 52 — Glyph outlines treated
//296 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//as a stroked path").
//BT
///F13 48 Tf
//20 38 Td
//1 Tr
//2 w
//(ABC) Tj
//ET
//Figure 52 — Glyph outlines treated as a stroked path
//EXAMPLE 3 This example illustrates how the glyphs’ outlines can be used as a clipping boundary. The Tr operator sets
//the text rendering mode to 7 (clip), causing the subsequent Tj operator to impose the glyph outlines as the
//current clipping path. All subsequent painting operations mark the page only within this path, as illustrated
//in "Figure 53 — Graphics clipped by a glyph path". This state persists until an earlier clipping path is
//reinstated by the Q operator.
//BT
//ET
///F13 48 Tf
//20 38 Td
//7 Tr
//(ABC) Tj
//… Graphics operators to draw a starburst …
//Figure 53 — Graphics clipped by a glyph path
//9.2.4 Glyph positioning and metrics
//A glyph’s width — formally, its horizontal displacement — is the amount of space it occupies along the
//baseline of a line of text that is written horizontally. In other words, it is the distance the current text
//position shall move (by translating text space) when the glyph is painted.
//NOTE 1 The width is distinct from the dimensions of the glyph outline.
//In some fonts, the width is constant; it does not vary from glyph to glyph. Such fonts are called fixed-
//© ISO 2020 – All rights reserved 297
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//pitch or monospaced. They are used mainly for typewriter-style printing. However, most fonts used for
//high-quality typography associate a different width with each glyph. Such fonts are called proportional
//or variable-pitch fonts. In either case, the Tj operator shall position the consecutive glyphs of a string
//according to their widths.
//The width information for each glyph shall be stored both in the font dictionary and in the font
//program itself.
//These widths shall be consistent with the actual widths given in the font program.
//NOTE 2 Storing this information in the font dictionary, although redundant, enables a PDF processor to
//determine glyph positioning without having to look inside the font program.
//NOTE 3 Due to differences in the way that TrueType and the Widths array store width information,
//there can be cases where widths are not identical between the two. TrueType stores widths in
//units of 1024 or 2048 to an Em (a unit in the field of typography), equal to the currently specified
//point size, however the Widths array stores widths in units of 1000 to an Em. Using real
//numbers instead of integers can mitigate rounding errors caused by this difference, and is
//recommended when precise character positioning is required.
//NOTE 4 The operators for showing text are designed on the assumption that glyphs are ordinarily
//positioned according to their standard widths. However, means are provided to vary the
//positioning in certain limited ways. For example, the TJ operator enables the text position to be
//adjusted between any consecutive pair of glyphs corresponding to characters in a text string.
//There are graphics state parameters to adjust character and word spacing systematically.
//In addition to width, a glyph has several other metrics that influence glyph positioning and painting.
//For most font types, this information is largely internal to the font program and is not specified
//explicitly in the PDF font dictionary. However, in a Type 3 font, all metrics are specified explicitly (see
//9.6.4, "Type 3 fonts").
//The glyph coordinate system is the space in which an individual character’s glyph is defined. All path
//coordinates and metrics shall be interpreted in glyph space. For all font types except Type 3, the units
//of glyph space are one-thousandth of a unit of text space; for a Type 3 font, the transformation from
//glyph space to text space shall be defined by a font matrix specified in an explicit FontMatrix entry in
//the font. "Figure 54 — Glyph metrics" shows a typical glyph outline and its metrics.
//Figure 54 — Glyph metrics
//The glyph origin is the point (0, 0) in the glyph coordinate system. Tj and other text-showing operators
//shall position the origin of the first glyph to be painted at the origin of text space.
//EXAMPLE 1 This code adjusts the origin of text space to (40, 50) in the user coordinate system and then places the origin
//298 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//of the A glyph at that point:
//BT
//40 50 Td
//(ABC) Tj
//ET
//The glyph displacement is the distance from the glyph’s origin to the point at which the origin of the
//next glyph should normally be placed when painting the consecutive glyphs of a line of text. This
//distance is a vector (called the displacement vector) in the glyph coordinate system; it has horizontal
//and vertical components.
//NOTE 5 Most Western writing systems, including those based on the Latin alphabet, have a positive
//horizontal displacement and a zero vertical displacement. Some Asian writing systems have a
//non-zero vertical displacement. In all cases, the text-showing operators transform the
//displacement vector into text space and then translate text space by that amount.
//The glyph bounding box shall be the smallest rectangle (oriented with the axes of the glyph coordinate
//system) that just encloses the entire glyph shape. The bounding box shall be expressed in terms of its
//left, bottom, right, and top coordinates relative to the glyph origin in the glyph coordinate system.
//In some writing systems, text is frequently aligned in two different directions.
//NOTE 6 It is common to write Japanese and Chinese glyphs either horizontally or vertically.
//To handle this, a font may contain a second set of metrics for each glyph. Which set of metrics to use
//shall be selected according to a writing mode, where 0 shall specify horizontal writing and 1 shall
//specify vertical writing. This feature is available only for composite fonts, discussed in 9.7, "Composite
//fonts"
//.
//When a glyph has two sets of metrics, each set shall specify a glyph origin and a displacement vector
//for that writing mode. In vertical writing, the glyph position shall be described by a position vector
//from the origin used for horizontal writing (origin 0) to the origin used for vertical writing (origin 1).
//"Figure 55 — Metrics for horizontal and vertical writing modes" illustrates the metrics for the two
//writing modes:
//• The left diagram illustrates the glyph metrics associated with writing mode 0, horizontal writing.
//The coordinates ll and ur specify the bounding box of the glyph relative to origin 0. w0 is the
//displacement vector that specifies how the text position shall be changed after the glyph is
//painted in writing mode 0; its vertical component shall be 0.
//• The centre diagram illustrates writing mode 1, vertical writing. w1 shall be the displacement
//vector for writing mode 1; its horizontal component shall be 0.
//• In the right diagram, v is a position vector defining the position of origin 1 relative to origin 0.
//© ISO 2020 – All rights reserved 299
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Figure 55 — Metrics for horizontal and vertical writing modes
