// ISO 32000-2:2020, 9.10 Extraction of text content

import ISO_32000_Shared

//9.10 Extraction of text content
//9.10.1 General
//The preceding subclauses describe all the facilities for showing text and causing glyphs to be painted
//on the page. In addition to rendering text, PDF processors often need to determine the information
//content of text — that is, its meaning according to some standard character identification as opposed
//to its rendered appearance. This need arises during operations such as searching, indexing, and
//© ISO 2020 – All rights reserved 355
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//exporting of text to other file formats.
//Unicode defines a system for numbering all of the common characters used in a large number of
//languages. It is a suitable scheme for representing the information content of text, but not its
//appearance, since Unicode values identify characters, not glyphs. For information about Unicode, see
//the Unicode Standard by the Unicode Consortium.
//When extracting character content, a PDF processor can easily convert text to Unicode values if a font’s
//characters are identified according to a standard character set that is known to the PDF processor. This
//character identification can occur if either the font uses a standard named encoding or the characters
//in the font are identified by standard character names or CIDs in a well-known collection. 9.10.2,
//"Mapping character codes to Unicode values", describes in detail the overall algorithm for mapping
//character codes to Unicode values.
//If a font is not defined in one of these ways, the glyphs can still be shown, but the characters cannot be
//converted to Unicode values without additional information using the following methods:
//• This information can be provided as an optional ToUnicode entry in the font dictionary (PDF 1.2;
//see 9.10.3, "ToUnicode CMaps"), whose value shall be a stream object containing a special kind of
//CMap file that maps character codes to Unicode values.
//• An ActualText entry for a structure element or marked-content sequence (see 14.9.4,
//"Replacement text") may be used to specify the text content directly.
//9.10.2 Mapping character codes to Unicode values
//A PDF processor can use these methods, in the priority given, to map a character code to a Unicode
//value. Tagged PDF documents, in particular, shall provide at least one of these methods (see 14.8.2.6,
//"Unicode mapping in tagged PDF"):
//• If the font dictionary contains a ToUnicode CMap (see 9.10.3, "ToUnicode CMaps"), use that CMap
//to convert the character code to Unicode.
//• If the font is a simple font and the glyph selection algorithm (see 9.6.5, "Character encoding") uses
//a glyph name, that name can be looked up in the Adobe Glyph List and Adobe Glyph List for New
//Fonts to obtain the corresponding Unicode value.
//• If the font is a composite font that uses one of the predefined CMaps listed in "Table 116 —
//Predefined CJK CMap names" (except Identity–H and Identity–V) or whose descendant CIDFont
//uses the Adobe-GB1, Adobe-CNS1, Adobe-Japan1, Adobe-Korea1 (deprecated in PDF 2.0 (2020)) or
//Adobe-KR (added in PDF 2.0 (2020)) character collection:
//a. Map the character code to a character identifier (CID) according to the font’s CMap.
//b. Obtain the registry and ordering of the character collection used by the font’s CMap (for
//example, Adobe and Japan1) from its CIDSystemInfo dictionary.
//c. Construct a second CMap name by concatenating the registry and ordering obtained in step (b)
//in the format registry–ordering–UCS2 (for example, Adobe–Japan1–UCS2).
//d. Obtain the CMap with the name constructed in step (c) (available from a variety of online
//sources, e.g. https://github.com/adobe-type-tools/mapping-resources-pdf).
//e. Map the CID obtained in step (a) according to the CMap obtained in step (d), producing a
//Unicode value.
//Type 0 fonts whose descendant CIDFonts use the Adobe-GB1, Adobe-CNS1, Adobe-Japan1, Adobe-
//356 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Korea1 (deprecated in PDF 2.0 (2020)) or Adobe-KR (added in PDF 2.0 (2020)) character collection (as
//specified in the CIDSystemInfo dictionary) shall have a supplement number corresponding to the
//version of PDF supported by the PDF processor.
//If these methods fail to produce a Unicode value, there is no way to determine what the character code
//represents in which case a PDF processor may choose a character code of their choosing.
//9.10.3 ToUnicode CMaps
//The CMap defined in the ToUnicode entry of the font dictionary shall follow the syntax for CMaps
//introduced in 9.7.5, "CMaps" and fully documented in Adobe Technical Note #5014, Adobe CMap and
//CIDFont Files Specification. This CMap differs from an ordinary one in these ways:
//• The only pertinent entry in the CMap stream dictionary (see "Table 118 — Additional entries in a
//CMap stream dictionary") is UseCMap, which may be used if the CMap is based on another
//ToUnicode CMap.
//• The CMap file shall contain begincodespacerange and endcodespacerange operators that are
//consistent with the encoding that the font uses. In particular, for a simple font, the codespace shall
//be one byte long.
//• It shall use the beginbfchar, endbfchar, beginbfrange, and endbfrange operators to define the
//mapping from character codes to Unicode character sequences expressed in UTF-16BE encoding.
//For simple fonts, character codes shall be written as 1 byte in the ToUnicode CMap.
//For CID keyed fonts character codes may have 1 byte, 2 bytes, or more than 2 bytes in the ToUnicode
//CMap.
//EXAMPLE 1 This example illustrates a Type 0 font that uses the Identity-H CMap to map from character codes to CIDs
//and whose descendant CIDFont uses the Identity mapping from CIDs to TrueType glyph indices. Text strings
//shown using this font simply use a 2-byte glyph index for each glyph. In the absence of a ToUnicode entry,
//no information would be available about what the glyphs mean.
//14 0 obj
//<</Type /Font
///Subtype /Type0
///BaseFont /Ryumin-Light
///Encoding /Identity-H
///DescendantFonts [15 0 R]
///ToUnicode 16 0 R
//>>
//endobj
//15 0 obj
//<</Type /Font
///Subtype /CIDFontType2
///BaseFont /Ryumin-Light
///CIDSystemInfo 17 0 R
///FontDescriptor 18 0 R
///CIDToGIDMap /Identity
//>>
//endobj
//EXAMPLE 2 In this example, the value of the ToUnicode entry is a stream object that contains the definition of the CMap.
//The begincodespacerange and endcodespacerange operators define the source character code range to
//be the 2-byte character codes from <00 00> to <FF FF>. The specific mappings for several of the character
//© ISO 2020 – All rights reserved 357
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//codes are shown.
//16 0 obj
//<<
///Type /CMap
///CMapName /Adobe-Identity-UCS2
///CIDSystemInfo << /Registry (Adobe) /Ordering (UCS2) /Supplement 0 >>
///Length 433
//>>
//stream
///CIDInit /ProcSet findresource begin
//12 dict begin
//begincmap
///CIDSystemInfo
//<</Registry (Adobe)
///Ordering (UCS2)
///Supplement 0
//>> def
///CMapName /Adobe-Identity-UCS2 def
///CMapType 2 def
//1 begincodespacerange
//<0000> <FFFF>
//endcodespacerange
//2 beginbfrange
//<0000> <005E> <0020>
//<005F> <0061> [<00660066> <00660069> <00660066006C>]
//endbfrange
//1 beginbfchar
//<3A51> <D840DC3E>
//endbfchar
//endcmap
//CMapName currentdict /CMap defineresource pop
//end
//end
//endstream
//endobj
//<00 00> to <00 5E> are mapped to the Unicode values SPACE (U+0020) to TILDE (U+007E) This is followed
//by the definition of a mapping where each character code represents more than one Unicode value:
//<005F> <0061> [<00660066> <00660069> <00660066006C>]
//In this case, the original character codes are the glyph indices for the ligatures ff, fi, and ffl. The entry defines
//the mapping from the character codes <00 5F>, <00 60>, and <00 61> to the strings of Unicode values with
//a Unicode scalar value for each character in the ligature: LATIN SMALL LETTER F (U+0066) LATIN SMALL
//LETTER F (U+0066) are the Unicode values for the character sequence f f, LATIN SMALL LETTER F (U+0066)
//LATIN SMALL LETTER I (U+0069) for f i, and LATIN SMALL LETTER F (U+0066) LATIN SMALL LETTER F
//(U+0066) LATIN SMALL LETTER L (U+006c) for f f l.
//Finally, the character code <3A 51> is mapped to the Unicode value UNICODE HAN CHARACTER ‘U+2003E’
//(U+2003E), which is expressed by the byte sequence <D840DC3E> in UTF-16BE encoding.
//Example 2 in this subclause illustrates several extensions to the way destination values may be
//defined. To support mappings from a source code to a string of destination codes, this extension has
//been made to the ranges defined after a beginbfchar operator:
//n beginbfchar
//srcCode dstString
//endbfchar
//where dstString may be a string of up to 512 bytes. Likewise, mappings after the beginbfrange
//operator may be defined as:
//358 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//n beginbfrange
//srcCode1 srcCode2 dstString
//endbfrange
//In this case, the last byte of the string shall be incremented for each consecutive code in the source
//code range.
//When defining ranges of this type, the value of the last byte in the string shall be less than or equal to
//255 - (srcCode2 - srcCode1). This ensures that the last byte of the string shall not be incremented past
//255; otherwise, the result of mapping is undefined.
//To support more compact representations of mappings from a range of source character codes to a
//discontiguous range of destination codes, the CMaps used for the ToUnicode entry may use this syntax
//for the mappings following a beginbfrange definition.
//n beginbfrange
//srcCode1 srcCode2 [dstString1 dstString2…dstStringm]
//endbfrange
//Consecutive codes starting with srcCode1 and ending with srcCode2 shall be mapped to the destination
//strings in the array starting with dstString1 and ending with dstStringm . The value of dstString can be
//a string of up to 512 bytes. The value of m represents the number of continuous character codes in the
//source character code range.
//𝑚 = 𝑠𝑟𝑐𝐶𝑜𝑑𝑒2 − 𝑠𝑟𝑐𝐶𝑜𝑑𝑒1 + 1
//NOTE If number of dstString in array is different from m, the result of mapping is undefined.
