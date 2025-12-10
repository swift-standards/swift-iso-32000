// ISO 32000-2:2020, 9.7 Composite fonts

import ISO_32000_Shared

//9.7 Composite fonts
//9.7.1 General
//A composite font, also called a Type 0 font, is one whose glyphs are obtained from a font-like object
//© ISO 2020 – All rights reserved 327
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//called a CIDFont. A composite font shall be represented by a font dictionary whose Subtype value is
//Type0. The Type 0 font is known as the root font, and its associated CIDFont is called its descendant.
//NOTE 1 Composite fonts in PDF are analogous to composite fonts in PostScript but with some limitations.
//In particular, PDF requires that the character encoding be defined by a CMap, which is only one
//of several encoding methods available in PostScript. Also, the PostScript language allows a Type
//0 font to have multiple descendants, which can also be Type 0 fonts. PDF supports only a single
//descendant, which are always a CIDFont.
//When the current font is composite, the text-showing operators shall behave differently than with
//simple fonts. For simple fonts, each byte of a string to be shown selects one glyph, whereas for
//composite fonts, a sequence of one or more bytes are decoded to select a glyph from the descendant
//CIDFont.
//NOTE 2 This facility supports the use of very large character sets, such as those for the Chinese, Japanese,
//and Korean languages. It also simplifies the organisation of fonts that have complex encoding
//requirements.
//This subclause first introduces the architecture of CID-keyed fonts, which are the only kind of
//composite font supported in PDF. Then it describes the CIDFont and CMap dictionaries, which are the
//PDF objects that represent the correspondingly named components of a CID-keyed font. Finally, it
//describes the Type 0 font dictionary, which combines a CIDFont and a CMap to produce a font whose
//glyphs may be accessed by means of variable-length character codes in a string to be shown.
//9.7.2 CID-Keyed fonts overview
//CID-keyed fonts provide a convenient and efficient method for defining multiple-byte character
//encodings and fonts with a large number of glyphs. These capabilities provide great flexibility for
//representing text in writing systems for languages with large character sets, such as Chinese, Japanese,
//and Korean (CJK).
//The CID-keyed font architecture specifies the external representation of certain font programs, called
//CMap and CIDFont files, along with some conventions for combining and using those files. As
//mentioned earlier, PDF does not support the entire CID-keyed font architecture, which is independent
//of PDF; CID-keyed fonts may be used in other environments.
//NOTE For complete documentation on the architecture and the file formats, see Adobe Technical Note
//#5092, CID-Keyed Font Technology Overview, and Adobe Technical Note #5014, Adobe CMap and
//CIDFont Files Specification. This subclause describes only the PDF objects that represent these
//font programs.
//The term CID-keyed font reflects the fact that CID (character identifier) numbers are used to index and
//access the glyph descriptions in the font. This method is more efficient for large fonts than the method
//of accessing by character name, as is used for some simple fonts. CIDs range from 0 to a maximum
//value that may be subject to implementation limits (see Annex C, "Advice on maximising portability").
//A character collection is an ordered set of glyphs. The order of the glyphs in the character collection
//shall determine the CID number for each glyph. Each CID-keyed font shall explicitly reference the
//character collection on which its CID numbers are based; see 9.7.3, "CIDSystemInfo dictionaries"
//.
//A CMap (character map) file shall specify the correspondence between character codes and the CID
//numbers used to identify glyphs. It is equivalent to the concept of an encoding in simple fonts. Whereas
//a simple font allows a maximum of 256 glyphs to be encoded and accessible at one time, a CMap can
//328 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//describe a mapping from multiple-byte codes to thousands of glyphs in a large CID-keyed font.
//EXAMPLE A CMap can describe Shift-JIS, one of several widely used encodings for Japanese.
//A CMap file may reference an entire character collection or a subset of a character collection. The CMap
//file’s mapping yields a font number (which in PDF shall be 0) and a character selector (which in PDF
//shall be a CID). Furthermore, a CMap file may incorporate another CMap file by reference, without
//having to duplicate it. These features enable character collections to be combined or supplemented and
//make all the constituent characters accessible to text-showing operations through a single encoding.
//A CIDFont contains the glyph descriptions for a character collection. The glyph descriptions themselves
//are typically in a format similar to those used in simple fonts, such as Type 1. However, they are
//identified by CIDs rather than by names, and they are organised differently.
//In PDF, the data from a CMap file and CIDFont shall be represented by PDF objects as described in
//9.7.4, "CIDFonts" and 9.7.5, "CMaps". The CMap file and CIDFont programs themselves may be either
//referenced by name or embedded as stream objects in the PDF file.
//A CID-keyed font, then, shall be the combination of a CMap with a CIDFont containing glyph
//descriptions. It shall be represented as a Type 0 font. It contains an Encoding entry whose value shall
//be a CMap dictionary, and its DescendantFonts entry shall reference the CIDFont dictionary with
//which the CMap has been combined.
//9.7.3 CIDSystemInfo dictionaries
//CIDFont and CMap dictionaries shall contain a CIDSystemInfo entry specifying the character collection
//assumed by the CIDFont associated with the CMap — that is, the interpretation of the CID numbers
//used by the CIDFont. A character collection shall be uniquely identified by the Registry, Ordering, and
//Supplement entries in the CIDSystemInfo dictionary, as described in "Table 114 — Entries in a
//CIDSystemInfo dictionary". In order for a CIDFont and a CMap to be compatible, their Registry and
//Ordering values shall be the same. Identity CMaps (Identity-H and Identity-V) are compatible with all
//CIDFonts.
//The CIDSystemInfo entry in a CIDFont is a dictionary that shall specify the CIDFont’s character
//collection. The CIDFont need not contain glyph descriptions for all the CIDs in a collection; it may
//contain a subset. The CIDSystemInfo entry in a CMap file shall be either a single dictionary or an array
//of dictionaries, depending on whether it associates codes with a single character collection or with
//multiple character collections; see 9.7.5, "CMaps"
//.
//For proper behaviour, the CIDSystemInfo entry of a CMap shall be compatible with that of the CIDFont
//or CIDFonts with which it is used.
//© ISO 2020 – All rights reserved 329
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 114 — Entries in a CIDSystemInfo dictionary
//Key Type Value
//Registry ASCII string (Required) A string identifying the issuer of the character
//collection. The string shall begin with the 4 or 5 characters of a
//registered developer prefix followed by a LOW LINE (5Fh)
//followed by any other identifying characters chosen by the issuer.
//See Annex E, "Extending PDF", for how to obtain a unique
//developer prefix.
//Ordering ASCII string (Required) A string that uniquely names the character collection
//within the specified registry.
//Supplement integer (Required) The supplement number of the character collection. An
//original character collection has a supplement number of 0.
//Whenever additional CIDs are assigned in a character collection,
//the supplement number shall be increased. Supplements shall not
//alter the ordering of existing CIDs in the character collection. This
//value shall not be used in determining compatibility between
//character collections.
//9.7.4 CIDFonts
//9.7.4.1 General
//A CIDFont program contains glyph descriptions that are accessed using a CID as the character selector.
//There are two types of CIDFonts:
//• A Type 0 CIDFont contains glyph descriptions based on CFF
//NOTE The term "Type 0" when applied to a CIDFont has a different meaning than for a "Type 0 font"
//.
//• A Type 2 CIDFont contains glyph descriptions based on the TrueType glyph technology.
//A CIDFont dictionary is a PDF object that contains information about a CIDFont program. Although its
//Type value is Font, a CIDFont is not actually a font. It does not have an Encoding entry, it may not be
//listed in the Font subdictionary of a resource dictionary, and it may not be used as the operand of the
//Tf operator. It shall be used only as a descendant of a Type 0 font. The CMap in the Type 0 font shall be
//what defines the encoding that maps character codes to CIDs in the CIDFont. "Table 115 — Entries in a
//CIDFont dictionary" lists the entries in a CIDFont dictionary.
//Table 115 — Entries in a CIDFont dictionary
//Key Type Value
//Type name (Required) The type of PDF object that this dictionary describes;
//shall be Font for a CIDFont dictionary.
//Subtype name (Required) The type of CIDFont shall be CIDFontType0 or
//CIDFontType2.
//330 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//BaseFont name (Required) The PostScript name of the CIDFont. For Type 0
//CIDFonts, this shall be the value of the CIDFontName entry in the
//CIDFont program. For Type 2 CIDFonts, it shall be derived the
//same way as for a simple TrueType font; see 9.6.3, "TrueType
//fonts". In either case, the name may have a subset prefix if
//appropriate; see 9.9.2, "Font subsets"
//.
//CIDSystemInfo dictionary (Required) A dictionary containing entries that define the
//character collection of the CIDFont. See "Table 114 — Entries in a
//CIDSystemInfo dictionary"
//.
//FontDescriptor dictionary (Required; shall be an indirect reference) A font descriptor
//describing the CIDFont’s default metrics other than its glyph
//widths (see 9.8, "Font descriptors").
//DW number (Optional) The default width for glyphs in the CIDFont (see
//9.7.4.3, "Glyph metrics in CIDFonts"). Default value: 1000.
//W array (Optional) A description of the widths for the glyphs in the
//CIDFont.
//NOTE The array’s elements have a variable format that can specify
//individual widths for consecutive CIDs or one width for a range
//of CIDs (see 9.7.4.3, "Glyph metrics in CIDFonts").
//Default value: none (the DW value shall be used for all glyphs).
//DW2 array (Optional; applies only to CIDFonts used for vertical writing) An
//array of two numbers specifying the default metrics for vertical
//writing (see 9.7.4.3, "Glyph metrics in CIDFonts"). Default value:
//[880 -1000].
//W2 array (Optional; applies only to CIDFonts used for vertical writing) A
//description of the metrics for vertical writing for the glyphs in the
//CIDFont (see 9.7.4.3, "Glyph metrics in CIDFonts"). Default value:
//none (the DW2 value shall be used for all glyphs).
//CIDToGIDMap stream or
//name
//(Required for Type 2 CIDFonts with embedded font programs) A
//specification of the mapping from CIDs to glyph indices. If the
//value is a stream, the bytes in the stream shall contain the
//mapping from CIDs to glyph indices: the glyph index for a
//particular CID value c shall be a 2-byte value stored in bytes
//2 × 𝑐 and 2 × 𝑐 + 1, where the first byte shall be the high-order
//byte. If the value of CIDToGIDMap is a name, it shall be Identity,
//indicating that the mapping between CIDs and glyph indices is the
//identity mapping.
//9.7.4.2 Glyph selection in CIDFonts
//Type 0 and Type 2 CIDFonts handle the mapping from CIDs to glyph descriptions in somewhat
//different ways. For Type 0, the CIDFont program contains glyph descriptions that are identified by
//CIDs. The CIDFont program identifies the character collection by a CIDSystemInfo dictionary, which
//should be copied into the PDF CIDFont dictionary. CIDs shall be interpreted uniformly in all CIDFont
//programs supporting a given character collection, whether the program is embedded in the PDF file or
//© ISO 2020 – All rights reserved 331
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//obtained from an external source.
//When the CIDFont contains an embedded font program that is represented in the Compact Font
//Format (CFF), the FontFile3 entry in the font descriptor (see "Table 124 — Embedded font
//organisation for various font types") shall be either CIDFontType0C or OpenType. There are two cases,
//depending on the contents of the font program:
//• The "CFF" font program has a Top DICT that uses CIDFont operators: The CIDs shall be used to
//determine the GID value for the glyph procedure using the charset table in the CFF program. The
//GID value shall then be used to look up the glyph procedure using the CharStrings INDEX table (as
//defined by Adobe Technical Note #5177, The Type 2 Charstring Format).
//NOTE Although in many fonts the CID value and GID value are the same, the CID and GID values can
//differ.
//• The "CFF" font program has a Top DICT that does not use CIDFont operators: The CIDs shall be
//used directly as GID values, and the glyph procedure shall be retrieved using the CharStrings
//INDEX (refer to Adobe Technical Note #5177, The Type 2 Charstring Format).
//For Type 2, the CIDFont program is actually a TrueType font program, which has no native notion of
//CIDs. In a TrueType font program, glyph descriptions are identified by glyph index values. Glyph indices
//are internal to the font and are not defined consistently from one font to another. Instead, a TrueType
//font program contains a "cmap" table that provides mappings directly from character codes to glyph
//indices for one or more predefined encodings.
//TrueType font programs are integrated with the CID-keyed font architecture in one of two ways,
//depending on whether the font program is embedded in the PDF file:
//• If the TrueType font program is embedded, the Type 2 CIDFont dictionary shall contain a
//CIDToGIDMap entry that maps CIDs to the glyph indices for the appropriate glyph descriptions in
//that font program.
//• If the TrueType font program is not embedded but is referenced by name, and the Type 2 CIDFont
//dictionary contains a CIDToGIDMap entry, the CIDToGIDMap entry shall be ignored, since it is
//not meaningful to refer to glyph indices in an external font program. In this case, CIDs shall not
//participate in glyph selection, and only predefined CMaps may be used with this CIDFont (see
//9.7.5, "CMaps"). The PDF processor shall select glyphs by translating characters from the
//encoding specified by the predefined CMap to one of the encodings in the TrueType font’s "cmap"
//table. The means by which this is accomplished are implementation-dependent.
//Even though the CIDs are not used to select glyphs in a Type 2 CIDFont, they shall always be used to
//determine the glyph metrics, as described in the next subclause.
//Every CIDFont shall contain a glyph description for CID 0, which is analogous to the .notdef character
//name in simple fonts (see 9.7.6.3, "Handling undefined characters").
//9.7.4.3 Glyph metrics in CIDFonts
//As discussed in 9.2.4, "Glyph positioning and metrics", the width of a glyph refers to the horizontal
//displacement between the origin of the glyph and the origin of the next glyph when writing in
//horizontal mode. In this mode, the vertical displacement between origins shall be 0. Widths for a
//CIDFont are defined using the DW and W entries in the CIDFont dictionary. These widths shall be
//consistent with the actual widths given in the CIDFont program.
//332 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//The W array allows the definition of widths for individual CIDs. The elements of the W array shall be
//numbers organised in groups of two or three, where each group shall be in one of these two formats:
//c [w1 w2… wn]
//cfirst clast w
//In the first format, c shall be an integer specifying a starting CID value; it shall be followed by an array
//of n numbers that shall specify the widths for n consecutive CIDs, starting with c. The second format
//shall define the same width, w, as a number, for all CIDs in the range cfirst to clast. Specifying a given CID
//value more than once should not be done. In the case where it is done, the first specification is the one
//that shall be used.
//EXAMPLE 1 In this example, the glyphs having CIDs 120, 121, and 122 are 400, 325, and 500 units wide, respectively.
//CIDs in the range 7080 through 8032 inclusive all have a width of 1000 units.
//W entry example:
///W [120 [400 325 500]
//7080 8032 1000
//]
//Glyphs from a CIDFont may be shown in vertical writing mode. This is selected by the WMode entry in
//the associated CMap dictionary; see 9.7.5, "CMaps". To be used in this way, the CIDFont shall define the
//vertical displacement for each glyph and the position vector that relates the horizontal and vertical
//writing origins.
//The default position vector and vertical displacement vector shall be specified by the DW2 entry in the
//CIDFont dictionary. DW2 shall be an array of two values: the vertical component of the position vector
//v and the vertical component of the displacement vector w1 (see "Figure 55 — Metrics for horizontal
//and vertical writing modes"). The horizontal component of the position vector shall be half the glyph
//width, and that of the displacement vector shall be 0.
//EXAMPLE 2 If the DW2 entry is
///DW2 [880 -1000]
//then a glyph’s position vector and vertical displacement vector are
//v = (w0 ÷ 2, 880)
//w1 = (0,
//−1000)
//where w0 is the width (horizontal displacement) for the same glyph.
//NOTE A negative value for the vertical component places the origin of the next glyph below the current
//glyph because vertical coordinates in a standard coordinate system increase from bottom to top.
//The W2 array shall define vertical metrics for individual CIDs. The elements of the array shall be
//organised in groups of two or five, where each group shall be in one of these two formats:
//c [ w11y v1x v1y w12y v2x v2y … ]
//cfirst clast w11y v1x v1y
//In the first format, c is a starting CID and shall be followed by an array containing numbers interpreted
//in groups of three. Each group shall consist of the vertical component of the vertical displacement
//© ISO 2020 – All rights reserved 333
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//vector w1 (whose horizontal component shall be 0) followed by the horizontal and vertical
//components for the position vector v. Successive groups shall define the vertical metrics for
//consecutive CIDs starting with c. The second format defines a range of CIDs from cfirst to clast, that
//shall be followed by three numbers that define the vertical metrics for all CIDs in this range.
//EXAMPLE 3 This W2 entry defines the vertical displacement vector for the glyph with CID 120 as (0, -1000) and the
//position vector as (250, 772). It also defines the displacement vector for CIDs in the range 7080 through
//8032 as (0, -1000) and the position vector as (500, 900).
///W2 [120 [-1000 250 772]
//7080 8032 -1000 500 900
//]
//9.7.5 CMaps
//9.7.5.1 General
//A CMap shall specify the mapping from character codes to character selectors. In PDF, the character
//selectors shall be CIDs in a CIDFont (as mentioned earlier, PostScript CMaps can use names or codes as
//well). A CMap serves a function analogous to the Encoding dictionary for a simple font. The CMap shall
//not refer directly to a specific CIDFont; instead, it shall be combined with it as part of a CID-keyed font,
//represented in PDF as a Type 0 font dictionary (see 9.7.6, "Type 0 font dictionaries"). Within the CMap,
//the character mappings shall refer to the associated CIDFont by font number, which in PDF shall be 0.
//PDF also uses a special type of CMap to map character codes to Unicode values (see 9.10.3, "ToUnicode
//CMaps").
//A CMap shall specify the writing mode — horizontal or vertical — for any CIDFont with which the
//CMap is combined. The writing mode determines which metrics shall be used when glyphs are painted
//from that font.
//NOTE Writing mode is specified as part of the CMap because, in some cases, different shapes are used
//when writing horizontally and vertically. In such cases, the horizontal and vertical variants of a
//CMap specify different CIDs for a given character code.
//A CMap shall be specified in one of two ways:
//• As a name object identifying a predefined CMap, whose value shall be one of the predefined CMap
//names defined in "Table 116 — Predefined CJK CMap names"
//.
//• As a stream object whose contents shall be a CMap file.
//9.7.5.2 Predefined CMaps
//Several of the CMaps define mappings from Unicode encodings to character collections. Unicode values
//appearing in a text string shall be represented in big-endian order (high-order byte first). CMap names
//containing "UCS2" use UCS-2 encoding; names containing "UTF16" use UTF-16BE (big-endian)
//encoding.
//NOTE 1 "Table 116 — Predefined CJK CMap names" lists the names of the predefined CMaps. These
//CMaps map character codes to CIDs in a single descendant CIDFont. CMaps whose names end in
//H specify horizontal writing mode; those ending in V specify vertical writing mode.
//334 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 116 — Predefined CJK CMap names
//Name Description
//Chinese (Simplified)
//GB-EUC-H Microsoft Code Page 936 (lfCharSet 0x86), GB 2312-80 character set, EUC-CN
//encoding
//GB-EUC-V Vertical version of GB-EUC-H
//GBpc-EUC-H Mac OS, GB 2312-80 character set, EUC-CN encoding, Script Manager code 19
//GBpc-EUC-V Vertical version of GBpc-EUC-H
//GBK-EUC-H Microsoft Code Page 936 (lfCharSet 0x86), GBK character set, GBK encoding
//GBK-EUC-V Vertical version of GBK-EUC-H
//GBKp-EUC-H Same as GBK-EUC-H but replaces half-width Latin characters with proportional
//forms and maps character code 0x24 to a dollar sign ($) instead of a yuan symbol
//(¥)
//GBKp-EUC-V Vertical version of GBKp-EUC-H
//GBK2K-H GB 18030-2000 character set, mixed 1-, 2-, and 4-byte encoding
//GBK2K-V Vertical version of GBK2K-H
//UniGB-UCS2-H Unicode (UCS-2) encoding for the Adobe-GB1 character collection
//UniGB-UCS2-V Vertical version of UniGB-UCS2-H
//UniGB-UTF16-H Unicode (UTF-16BE) encoding for the Adobe-GB1 character collection; contains
//mappings for all characters in the GB18030-2000 character set
//UniGB-UTF16-V Vertical version of UniGB-UTF16-H
//Chinese (Traditional)
//B5pc-H Mac OS, Big Five character set, Big Five encoding, Script Manager code 2
//B5pc-V Vertical version of B5pc-H
//HKscs-B5-H Hong Kong SCS, an extension to the Big Five character set and encoding
//HKscs-B5-V Vertical version of HKscs-B5-H
//ETen-B5-H Microsoft Code Page 950 (lfCharSet 0x88), Big Five character set with ETen
//extensions
//ETen-B5-V Vertical version of ETen-B5-H
//ETenms-B5-H Same as ETen-B5-H but replaces half-width Latin characters with proportional
//forms
//ETenms-B5-V Vertical version of ETenms-B5-H
//© ISO 2020 – All rights reserved 335
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Name Description
//CNS-EUC-H CNS 11643-1992 character set, EUC-TW encoding
//CNS-EUC-V Vertical version of CNS-EUC-H
//UniCNS-UCS2-H Unicode (UCS-2) encoding for the Adobe-CNS1-6 character collection
//UniCNS-UCS2-V Vertical version of UniCNS-UCS2-H
//UniCNS-UTF16-H Unicode (UTF-16BE) encoding for the Adobe-CNS1-6 character collection;
//contains mappings for all the characters in the HKSCS-2001 character set and
//contains both 2- and 4-byte character codes
//UniCNS-UTF16-V Vertical version of UniCNS-UTF16-H
//Japanese
//83pv-RKSJ-H Mac OS, JIS X 0208 character set with KanjiTalk6 extensions, Shift-JIS encoding,
//Script Manager code 1
//90ms-RKSJ-H Microsoft Code Page 932 (lfCharSet 0x80), JIS X 0208 character set with NEC and
//IBM® extensions
//90ms-RKSJ-V Vertical version of 90ms-RKSJ-H
//90msp-RKSJ-H Same as 90ms-RKSJ-H but replaces half-width Latin characters with proportional
//forms
//90msp-RKSJ-V Vertical version of 90msp-RKSJ-H
//90pv-RKSJ-H Mac OS, JIS X 0208 character set with KanjiTalk7 extensions, Shift-JIS encoding,
//Script Manager code 1
//Add-RKSJ-H JIS X 0208 character set with Fujitsu FMR extensions, Shift-JIS encoding
//Add-RKSJ-V Vertical version of Add-RKSJ-H
//EUC-H JIS X 0208 character set, EUC-JP encoding
//EUC-V Vertical version of EUC-H
//Ext-RKSJ-H JIS C 6226 (JIS78) character set with NEC extensions, Shift-JIS encoding
//Ext-RKSJ-V Vertical version of Ext-RKSJ-H
//H JIS X 0208 character set, ISO-2022-JP encoding
//V Vertical version of H
//UniJIS-UCS2-H Unicode (UCS-2) encoding for the Adobe-Japan1 character collection
//UniJIS-UCS2-V Vertical version of UniJIS-UCS2-H
//UniJIS-UCS2-HW-H Same as UniJIS-UCS2-H but replaces proportional Latin characters with half-width
//forms
//336 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Name Description
//UniJIS-UCS2-HW-V Vertical version of UniJIS-UCS2-HW-H
//UniJIS-UTF16-H Unicode (UTF-16BE) encoding for the Adobe-Japan1 character collection;
//contains mappings for all characters in the JIS X 0213:1000 character set
//UniJIS-UTF16-V Vertical version of UniJIS-UTF16-H
//Korean
//KSC-EUC-H KS X 1001:1992 character set, EUC-KR encoding
//KSC-EUC-V Vertical version of KSC-EUC-H
//KSCms-UHC-H Microsoft Code Page 949 (lfCharSet 0x81), KS X 1001:1992 character set plus
//8822 additional hangul, Unified Hangul Code (UHC) encoding
//KSCms-UHC-V Vertical version of KSCms-UHC-H
//KSCms-UHC-HW-H Same as KSCms-UHC-H but replaces proportional Latin characters with half-width
//forms
//KSCms-UHC-HW-V Vertical version of KSCms-UHC-HW-H
//KSCpc-EUC-H Mac OS, KS X 1001:1992 character set with Mac OS KH extensions, Script Manager
//Code 3
//UniKS-UCS2-H Unicode (UCS-2) encoding for the Adobe-Korea1 character collection
//UniKS-UCS2-V Vertical version of UniKS-UCS2-H
//UniKS-UTF16-H Unicode (UTF-16BE) encoding for the Adobe-Korea1 character collection
//UniKS-UTF16-V Vertical version of UniKS-UTF16-H
//Generic
//Identity-H The horizontal identity mapping for 2-byte CIDs; may be used with CIDFonts
//using any Registry, Ordering, and Supplement values. It maps 2-byte character
//codes ranging from 0 to 65,535 to the same 2-byte CID value, interpreted high-
//order byte first.
//Identity-V Vertical version of Identity-H. The mapping is the same as for Identity-H.
//NOTE 2 The Identity-H and Identity-V CMaps can be used to refer to glyphs directly by their CIDs when
//showing a text string.
//When the current font is a Type 0 font whose Encoding entry is Identity-H or Identity-V, the string to
//be shown shall contain pairs of bytes representing CIDs, high-order byte first. When the descendant
//font of a Type 0 font is a Type 2 CIDFont in which the CIDToGIDMap entry is Identity and if the
//TrueType font is embedded in the PDF file, the 2-byte CID values shall be identical glyph indices for the
//glyph descriptions in the TrueType font program.
//© ISO 2020 – All rights reserved 337
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 117 — Character collections for predefined CMaps, by PDF version
//Table intentionally empty to retain table numbering in this document (2020).
//Information is now located in the appropriate normative reference for each character collection.
//A PDF processor shall support Adobe-CNS1-7, Adobe-GB1-5, Adobe-Japan1-7 and Adobe-KR-9
//character collections. ". Adobe-Japan2-0 and Adobe-Korea1-2 are deprecated in this document (2020).
//As noted in 9.7.3, "CIDSystemInfo dictionaries", a character collection is identified by registry,
//ordering, and supplement number, and supplements are cumulative; that is, a higher-numbered
//supplement includes the CIDs contained in lower-numbered supplements, as well as some additional
//CIDs. Consequently, text encoded according to the predefined CMaps for a given PDF version shall be
//valid when interpreted by a PDF processor supporting the same or a later PDF version. When
//interpreted by a PDF processor supporting an earlier PDF version, such text causes an error if a CMap
//is encountered that is not predefined for that PDF version. If character codes are encountered that
//were added in a higher-numbered supplement than the one corresponding to the supported PDF
//version, no characters are displayed for those codes; see 9.7.6.3, "Handling undefined characters"
//.
//Other supplements of these character collections may be used, but if the supplement is higher-
//numbered than the one corresponding to the supported PDF version, only the CIDs in the latter
//supplement are considered to be standard CIDs.
//The Identity-H and Identity-V CMaps shall not be used with a non-embedded font. Only standardized
//character sets may be used.
//NOTE 4 If a PDF processor producing a PDF file encounters text to be included that uses CIDs from a
//higher-numbered supplement than the one corresponding to the PDF version being generated,
//the application will need to embed the CMap for the higher-numbered supplement rather than
//refer to the predefined CMap.
//The CMap programs that define the predefined CMaps are available through a variety of online sources.
//9.7.5.3 Embedded CMap files
//For character encodings that are not predefined, the PDF file shall contain a stream that defines the
//CMap. In addition to the standard entries for streams (listed in "Table 5 — Entries common to all
//stream dictionaries"), the CMap stream dictionary contains the entries listed in "Table 118 —
//Additional entries in a CMap stream dictionary". The data in the stream defines the mapping from
//character codes to a font number and a character selector. The data shall follow the syntax defined in
//Adobe Technical Note #5014, Adobe CMap and CIDFont Files Specification.
//Table 118 — Additional entries in a CMap stream dictionary
//Key Type Value
//Type name (Required) The type of PDF object that this dictionary describes; shall be
//CMap for a CMap dictionary.
//CMapName name (Required) The name of the CMap. It shall be the same as the value of
//CMapName in the CMap file.
//338 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//CIDSystemInfo dictionary (Required) A dictionary (see 9.7.3, "CIDSystemInfo dictionaries")
//containing entries that define the character collection for the CIDFont or
//CIDFonts associated with the CMap. The value of this entry shall be the
//same as the value of CIDSystemInfo in the CMap file. (However, it does
//not need to match the values of CIDSystemInfo for the Identity-H or
//Identity-V CMaps.)
//WMode integer (Optional) A code that specifies the writing mode for any CIDFont with
//which this CMap is combined. The value shall be 0 for horizontal or 1 for
//vertical. Default value: 0. The value of this entry shall be the same as the
//value of WMode in the CMap file.
//UseCMap name or
//stream
//(Optional) The name of a predefined CMap, or a stream containing a
//CMap. If this entry is present, the referencing CMap shall specify only the
//character mappings that differ from the referenced CMap.
//9.7.5.4 CMap example and operator summary
//Embedded CMap files shall conform to the format documented in Adobe Technical Note #5014, subject
//to these additional constraints:
//a) If the embedded CMap file contains a usecmap reference, the CMap indicated there shall also be
//identified by the UseCMap entry in the CMap stream dictionary.
//b) The usefont operator, if present, shall specify a font number of 0.
//c) The beginbfchar and endbfchar shall not appear in a CMap that is used as the Encoding entry of a Type
//0 font; however, they may appear in the definition of a ToUnicode CMap.
//d) A notdef mapping, defined using beginnotdefchar, endnotdefchar, beginnotdefrange, and
//endnotdefrange shall be used if the normal mapping produces a CID for which no glyph is present in
//the associated CIDFont.
//e) The beginrearrangedfont, endrearrangedfont, beginusematrix, and endusematrix operators shall
//not be used.
//NOTE While often used for mapping 2 byte character codes to CID codes, character codes with just 1
//byte or more than 2 bytes can be used, as long as they can be mapped to CID codes without
//ambiguity.
//EXAMPLE This example shows a sample CMap for a Japanese Shift-JIS encoding. Character codes in this encoding can
//be either 1 or 2 bytes in length. This CMap could be used with a CIDFont that uses the same CID ordering as
//specified in the CIDSystemInfo entry. Note that several of the entries in the stream dictionary are also
//replicated in the stream data.
//22 0 obj
//<</Type /CMap
///CMapName /90ms-RKSJ-H
///CIDSystemInfo <</Registry (Adobe)
///Ordering (Japan1)
///Supplement 2
//>>
///WMode 0
///Length 23 0 R
//>>
//stream
//%!PS-Adobe-3 . 0 Resource-CMap
//© ISO 2020 – All rights reserved 339
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//%%DocumentNeededResources : ProcSet (CIDInit)
//%%IncludeResource : ProcSet (CIDInit)
//%%BeginResource : CMap (90ms-RKSJ-H)
//%%Title : (90ms-RKSJ-H Adobe Japan1 2)
//%%Version : 10 . 001
//%%Copyright : Copyright 1990-2001 Adobe Systems Inc .
//%%Copyright : All Rights Reserved .
//%%EndComments
///CIDInit /ProcSet findresource begin
//12 dict begin begincmap
///CIDSystemInfo
//3 dict dup begin
///Registry (Adobe) def
///Ordering (Japan1) def
///Supplement 2 def
//end def
///CMapName /90ms-RKSJ-H def
///CMapVersion 10 . 001 def
///CMapType 1 def
///UIDOffset 950 def
///XUID [1 10 25343] def
///WMode 0 def
//4 begincodespacerange
//<00> <80>
//<8140> <9FFC>
//<A0> <DF>
//<E040> <FCFC>
//endcodespacerange
//1 beginnotdefrange
//<00> <1F> 231
//endnotdefrange
//100 begincidrange
//<20> <7D> 231
//<7E> <7E> 631
//<8140> <817E> 633
//<8180> <81AC> 696
//<81B8> <81BF> 741
//<81C8> <81CE> 749
//… Additional ranges …
//<FB40> <FB7E> 8518
//<FB80> <FBFC> 8581
//<FC40> <FC4B> 8706
//endcidrange
//endcmap
//CMapName currentdict /CMap defineresource pop
//end
//end
//%%EndResource
//%%EOF
//endstream
//endobj
//9.7.6 Type 0 font dictionaries
//9.7.6.1 General
//A Type 0 font dictionary contains the entries listed in "Table 119 — Entries in a Type 0 font
//dictionary"
//.
//340 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 119 — Entries in a Type 0 font dictionary
//Key Type Value
//Type name (Required) The type of PDF object that this dictionary describes; shall be
//Font for a font dictionary.
//Subtype name (Required) The type of font; shall be Type0 for a Type 0 font.
//BaseFont name (Required) The name of the font. If the descendant is a Type 0 CIDFont, this
//name should be the concatenation of the CIDFont’s BaseFont name, a
//hyphen, and the CMap name given in the Encoding entry (or the
//CMapName entry in the CMap). If the descendant is a Type 2 CIDFont, this
//name should be the same as the CIDFont’s BaseFont name.
//NOTE In principle, this is an arbitrary name, since there is no font program
//associated directly with a Type 0 font dictionary. The conventions
//described here ensure maximum compatibility with existing PDF
//processors.
//Encoding name or
//stream
//(Required) The name of a predefined CMap, or a stream containing a CMap
//that maps character codes to font numbers and CIDs. If the descendant is a
//Type 2 CIDFont whose associated TrueType font program is not embedded
//in the PDF file, the Encoding entry shall be a predefined CMap name (see
//9.7.4.2, "Glyph selection in CIDFonts").
//DescendantFonts array (Required) A one-element array specifying the CIDFont dictionary that is the
//descendant of this Type 0 font.
//ToUnicode stream (Optional) A stream containing a CMap file that maps character codes to
//Unicode values (see 9.9.2, "Font subsets").
//EXAMPLE This code sample shows a Type 0 font.
//14 0 obj
//<</Type /Font
///Subtype /Type0
///BaseFont /HeiseiMin-W5-90ms-RKSJ-H
///Encoding /90ms-RKSJ-H
///DescendantFonts [15 0 R]
//>>
//endobj
//9.7.6.2 CMap mapping
//The Encoding entry of a Type 0 font dictionary specifies a CMap that specifies how text-showing
//operators (such as Tj) shall interpret the bytes in the string to be shown when the current font is the
//Type 0 font. This subclause describes how the characters in the string shall be decoded and mapped
//into character selectors, which in PDF are always CIDs.
//The codespace ranges in the CMap (delimited by begincodespacerange and endcodespacerange)
//specify how many bytes are extracted from the string for each successive character code. A codespace
//range shall be specified by a pair of codes of some particular length giving the lower and upper bounds
//of that range. A code shall be considered to match the range if it is the same length as the bounding
//codes and the value of each of its bytes lies between the corresponding bytes of the lower and upper
//bounds. The code length shall not be greater than 4.
//© ISO 2020 – All rights reserved 341
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//A sequence of one or more bytes shall be extracted from the string and matched against the codespace
//ranges in the CMap. That is, the first byte shall be matched against 1-byte codespace ranges; if no
//match is found, a second byte shall be extracted, and the 2-byte code shall be matched against 2-byte
//codespace ranges. This process continues for successively longer codes until a match is found or all
//codespace ranges have been tested. There will be at most one match because codespace ranges shall
//not overlap.
//The code extracted from the string shall be looked up in the character code mappings for codes of that
//length. (These are the mappings defined by beginbfchar, endbfchar, begincidchar, endcidchar, and
//corresponding operators for ranges.) Failing that, it shall be looked up in the notdef mappings, as
//described in the next subclause.
//The results of the CMap mapping algorithm are a font number and a character selector. The font
//number shall be used as an index into the Type 0 font’s DescendantFonts array to select a CIDFont. In
//PDF, the font number shall be 0 and the character selector shall be a CID; this is the only case described
//here. The CID shall then be used to select a glyph in the CIDFont. If the CIDFont contains no glyph for
//that CID, the notdef mappings shall be consulted, as described in 9.7.6.3, "Handling undefined
//characters"
//.
//9.7.6.3 Handling undefined characters
//A CMap mapping operation can fail to select a glyph for a variety of reasons. This subclause describes
//those reasons and what happens when they occur.
//If a code maps to a CID for which no such glyph exists in the descendant CIDFont, the notdef mappings
//in the CMap shall be consulted to obtain a substitute character selector. These mappings are delimited
//by the operators beginnotdefchar, endnotdefchar, beginnotdefrange, and endnotdefrange within
//an embedded CMap file. They shall always map to a CID. If a matching notdef mapping is found, the CID
//selects a glyph in the associated descendant, which shall be a CIDFont. If no glyph exists for that CID,
//the glyph for CID 0 (which shall be present) shall be substituted.
//NOTE The notdef mappings are similar to the .notdef character mechanism in simple fonts.
//If the CMap does not contain either a character mapping or a notdef mapping for the code, descendant
//0 shall be selected and the glyph for CID 0 shall be substituted from the associated CIDFont.
//If the code is invalid — that is, the bytes extracted from the string to be shown do not match any
//codespace range in the CMap — a substitute glyph is chosen as just described. The character mapping
//algorithm shall be reset to its original position in the string, and a modified mapping algorithm chooses
//the best partially matching codespace range:
//a) If the first byte extracted from the string to be shown does not match the first byte of any codespace
//range, the range having the shortest codes shall be chosen.
//b) Otherwise (that is, if there is a partial match), for each additional byte extracted, the code accumulated so
//far shall be matched against the beginnings of all longer codespace ranges until the longest such partial
//match has been found. If multiple codespace ranges have partial matches of the same length, the one
//having the shortest codes shall be chosen.
//The length of the codes in the chosen codespace range determines the total number of bytes to
//consume from the string for the current mapping operation.
//342 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//For an embedded TrueType font with a CIDtoGIDMap stream, if a (character) code does not have a
//corresponding GID in the CIDtoGIDMap stream, the glyph for CID 0 shall be substituted.
