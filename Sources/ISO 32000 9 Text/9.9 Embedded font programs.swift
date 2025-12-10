// ISO 32000-2:2020, 9.9 Embedded font programs

import ISO_32000_Shared

//
// 9.9 Embedded font programs
// 9.9.1 General
// This clause describes how a font program can be embedded in a PDF file as data contained in a PDF
// stream object.
// For text in text rendering mode 3, font programs may be embedded. For text in other text rendering
// modes, font programs should be embedded.
// NOTE 1 Such a stream object is also called a font file by analogy with font programs that are available
// from sources external to PDF processors.
// Font programs are subject to copyright, and the copyright owner may impose conditions under which
// a font program may be used. These permissions are recorded either in the font program or as part of a
// separate license. One of the conditions may be that the font program cannot be embedded, in which
// case it should not be incorporated into a PDF file. A font program may allow embedding for the sole
// purpose of viewing and printing the document but not for creating new or modified text that uses the
// font (in either the same document or other documents). The latter operation would require the user
// performing the operation to have a licensed copy of the font program, not a copy extracted from the
// PDF file. In the absence of explicit information to the contrary, embedded font programs shall be used
// only to view and print the document and not for any other purposes.
// "Table 124 — Embedded font organisation for various font types" summarises the ways in which font
// programs shall be embedded in a PDF file, depending on the representation of the font program. The
// key shall be the name used in the font descriptor to refer to the font file stream; the subtype shall be
// the value of the Subtype key, if present, in the font file stream dictionary.
// © ISO 2020 – All rights reserved 351
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// Table 124 — Embedded font organisation for various font types
// Key Subtype Description
// FontFile — Type 1 font program, in the original (noncompact) format described in
// Adobe Type 1 Font Format. This entry may appear in the font descriptor
// for a Type1 or MMType1 font dictionary.
// The font program provided as the value of this key shall conform to the
// Adobe Type 1 Font Format and/or Adobe Technical Note #5015, Type 1
// Font Format Supplement.
// FontFile2 — (PDF 1.1) TrueType font program, as described in the TrueType Reference
// Manual. This entry may appear in the font descriptor for a TrueType font
// dictionary or (PDF 1.3) for a CIDFontType2 CIDFont dictionary.
// The font program provided as the value of this key shall conform to the
// TrueType Reference Manual. The font program shall include these tables:
// "glyf"
// "head"
// "hhea"
// "hmtx"
// ,
// ,
// ,
// ,
// "loca", and "maxp". The "cvt " (notice the
// trailing SPACE), "fpgm", and "prep" tables shall also be included if they
// are required by the font instructions.
// FontFile3 Type1C (PDF 1.2) Type 1–equivalent font program represented in the Compact
// Font Format (CFF), as described in Adobe Technical Note #5176, The
// Compact Font Format Specification. This entry may appear in the font
// descriptor for a Type1 or MMType1 font dictionary.
// The font program provided as the value of this key shall conform to
// Adobe Technical Note #5176.
// FontFile3 CIDFontType0C (PDF 1.3) Type 0 CIDFont program represented in the Compact Font
// Format (CFF), as described in Adobe Technical Note #5176, The Compact
// Font Format Specification. This entry may appear in the font descriptor
// for a CIDFontType0 CIDFont dictionary.
// The font program provided as the value of this key shall conform to
// Adobe Technical Note #5176.
// 352 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// Key Subtype Description
// FontFile3 OpenType (PDF 1.6) OpenType font program, as described in ISO/IEC 14496-22.
// OpenType is an extension of TrueType that allows inclusion of font
// programs that use the Compact Font Format (CFF).
// • A TrueType font dictionary or a CIDFontType2 CIDFont dictionary, if the
// embedded font program contains a "glyf" table. In addition to the "glyf"
// table, the font program shall include these tables: "head"
// "hhea"
// "hmtx"
// ,
// ,
// ,
// "loca", and "maxp". The "cvt " (notice the trailing SPACE), "fpgm", and
// "prep" tables shall also be included if they are required by the font
// instructions.
// • A CIDFontType0 CIDFont dictionary, if the embedded font program
// contains a "CFF " table (notice the trailing SPACE) with a Top DICT that
// uses CIDFont operators (this is equivalent to subtype CIDFontType0C). In
// addition to the "CFF " table, the font program shall include the "cmap"
// table.
// • A Type1 font dictionary or CIDFontType0 CIDFont dictionary, if the
// embedded font program contains a "CFF " table without CIDFont operators.
// In addition to the "CFF " table, the font program shall include the "cmap"
// table.
// A FontFile3 entry with an OpenType subtype may appear in the font
// descriptor for these types of font dictionaries.
// ISO/IEC 14496-22 describes a set of required tables; however, not all
// tables are required in the font file, as described for each type of font
// dictionary that can include this entry.
// The font program provided as the value of this key shall conform to
// ISO/IEC 14496-22:2019.
// NOTE The absence of some optional tables (such as those used for advanced
// line layout) can prevent editing of text containing the font.
// The stream dictionary for a font file shall contain the normal entries for a stream, such as Length and
// Filter (listed in "Table 5 — Entries common to all stream dictionaries"), plus the additional entries
// listed in "Table 125 — Additional entries in an embedded font stream dictionary"
// .
// Table 125 — Additional entries in an embedded font stream dictionary
// Key Type Value
// Length1 integer (Required for Type 1 and TrueType font programs) The length in bytes of the
// clear-text portion of the Type 1 font program, or the entire TrueType font
// program, after it has been decoded using the filters specified by the stream’s
// Filter entry, if any.
// Length2 integer (Required for Type 1 font programs) The length in bytes of the encrypted
// portion of the Type 1 font program after it has been decoded using the filters
// specified by the stream’s Filter entry.
// Length3 integer (Required for Type 1 font programs) The length in bytes of the fixed-content
// portion of the Type 1 font program after it has been decoded using the filters
// specified by the stream’s Filter entry. If Length3 is 0, it indicates that the
// 512 zeros and cleartomark have not been included in the FontFile font
// program and shall be added by the PDF processor.
// © ISO 2020 – All rights reserved 353
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// Key Type Value
// Subtype name (Required if referenced from FontFile3; PDF 1.2) A name specifying the
// format of the embedded font program. The name shall be Type1C for Type 1
// compact fonts, CIDFontType0C for Type 0 compact CIDFonts, or OpenType
// for OpenType fonts.
// NOTE 2 A standard Type 1 font program, as described in the Adobe Type 1 Font Format specification,
// consists of three parts: a clear-text portion (written using PostScript syntax), an encrypted
// portion, and a fixed-content portion. The fixed-content portion contains 512 ASCII zeros
// followed by a cleartomark operator, and perhaps followed by additional data. Although the
// encrypted portion of a standard Type 1 font can be in binary or ASCII hexadecimal format, PDF
// supports only the binary format. However, the entire font program can be encoded using any
// filters.
// EXAMPLE This code shows the structure of an embedded standard Type 1 font.
// 12 0 obj
// <</Filter /ASCII85Decode
//  Length 41116
//  Length1 2526
//  Length2 32393
//  Length3 570
// >>
// stream
// ,p>`rDKJj'E+LaU0eP.@+AH9dBOu$hFD55nC
// … Omitted data…
// JJQ&Nt')<=^p&mGf(%:%h1%9c//K(/*o=.C>UXkbVGTrr~>
// endstream
// endobj
// As noted in "Table 124 — Embedded font organisation for various font types", a Type 1–equivalent
// font program or a Type 0 CIDFont program may be represented in the Compact Font Format (CFF). The
// Length1, Length2, and Length3 entries are not needed in that case and shall not be present. Although
// CFF enables multiple font or CIDFont programs to be bundled together in a single file, an embedded
// CFF font file in PDF shall consist of exactly one font or CIDFont (as appropriate for the associated font
// dictionary).
// According to the Adobe Type 1 Font Format specification, a Type 1 font program may contain a
// PaintType entry specifying whether the glyphs’ outlines are to be filled or stroked. For fonts
// embedded in a PDF file, this entry shall be ignored; the decision whether to fill or stroke glyph outlines
// is entirely determined by the PDF text rendering mode parameter (see 9.3.6, "Text rendering mode").
// This shall also apply to Type 1 compact fonts and Type 0 compact CIDFonts.
// A TrueType font program may be used as part of either a font or a CIDFont. Although the basic font file
// format is the same in both cases, there are different requirements for what information shall be
// present in the font program. These TrueType tables shall always be present if present in the original
// TrueType font program: "head"
// "hhea"
// "loca"
// ,
// ,
// ,
// "maxp"
// "cvt "
// ,
// ,
// "prep"
// ,
// "glyf"
// ,
// "hmtx", and "fpgm". If used
// with a simple font dictionary, the font program shall additionally contain a "cmap" table defining one
// or more encodings, as discussed in 9.6.5.4, "Encodings for TrueType fonts". If used with a CIDFont
// dictionary, the "cmap" table is not needed and shall not be present, since the mapping from character
// codes to glyph descriptions is provided separately.
// 354 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// The "vhea" and "vmtx" tables that specify vertical metrics shall never be used by a PDF processor. The
// only way to specify vertical metrics in PDF shall be by means of the DW2 and W2 entries in a CIDFont
// dictionary.
// NOTE 3 Beginning with PDF 1.6, font programs can be embedded using the OpenType format, which is an
// extension of the TrueType format that allows inclusion of font programs using the Compact Font
// Format (CFF). It also allows inclusion of data to describe glyph substitutions, kerning, and
// baseline adjustments. In addition to rendering glyphs, PDF processors can use the data in
// OpenType fonts to do advanced line layout, automatically substitute ligatures, provide selections
// of alternative glyphs to users, and handle complex writing scripts.
// The process of finding glyph descriptions in OpenType fonts by a PDF processor shall be the following:
// • For Type 1 fonts using "CFF " tables, the process shall be as described in 9.6.5.2, "Encodings for
// Type 1 fonts"
// .
// • For TrueType fonts using "glyf" tables, the process shall be as described in 9.6.5.4, "Encodings for
// TrueType fonts". Since this process sometimes produces ambiguous results, PDF writers, instead
// of using a simple font, should use a Type 0 font with an Identity-H encoding and use the glyph
// indices as character codes, as described following "Table 116 — Predefined CJK CMap names"
// .
// • For CIDFontType0 fonts using "CFF " tables, the process shall be as described in the discussion of
// embedded Type 0 CIDFonts in 9.7.4.2, "Glyph selection in CIDFonts"
// .
// • For CIDFontType2 fonts using "glyf" tables, the process shall be as described in the discussion of
// embedded Type 2 CIDFonts in 9.7.4.2, "Glyph selection in CIDFonts"
// .
// 9.9.2 Font subsets
// PDF documents may include subsets of PDF fonts whose Subtype is Type1, TrueType or OpenType. The
// font and font descriptor that describe a font subset are slightly different from those of ordinary fonts.
// These differences allow a PDF processor to recognise font subsets and to merge documents containing
// different subsets of the same font. (For more information on font descriptors, see 9.8, "Font
// descriptors".)
// For a font subset, the PostScript name of the font, that is, the value of the font’s BaseFont entry and the
// font descriptor’s FontName entry, shall begin with a tag followed by a plus sign (+) followed by the
// PostScript name of the font from which the subset was created. The tag shall consist of exactly six
// uppercase letters; the choice of letters is arbitrary, but different subsets of the same font in the same
// PDF file shall have different tags. The glyph name .notdef shall be defined in the font subset.
// NOTE It is recommended that PDF processors treat multiple subset fonts as completely independent
// entities, even if they appear to have been created from the same original font.
// EXAMPLE EOODIA+Poetica is the name of a subset of Poetica®, a Type 1 font.
