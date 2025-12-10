// ISO 32000-2:2020, 9.5 Introduction to font data structures

import ISO_32000_Shared

// 9.5 Introduction to font data structures
// A font shall be represented in PDF as a dictionary specifying the type of font, its PostScript language
// name, its encoding, and information that can be used to provide a substitute when the font program is
// not available. Optionally, the font program (more commonly known as font files) may be embedded as
// a stream object in the PDF file.
// NOTE 1 See 9.2, "Organisation and use of fonts" for more introductory information.
// "Table 108 — Font types" lists the types of fonts that are supported in ISO 32000 along with the value
// that shall be used for the Subtype key in the font dictionary that represents the font. No values for
// Subtype other than those listed in the table are valid. Type 0 fonts are called composite fonts; other
// types of fonts are called simple fonts. In addition to fonts, PDF supports two classes of font-related
// objects, called CIDFonts and CMaps, described in 9.7.2, "CID-Keyed fonts overview". CIDFonts are listed
// in "Table 108 — Font types" because, like fonts, they are collections of glyphs; however, a CIDFont
// shall not be used directly but only as a component of a Type 0 font.
// © ISO 2020 – All rights reserved 311
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// Table 108 — Font types
// Type Subtype Value Description
// Type 0 Type0 (PDF 1.2) A composite font — a font composed of glyphs
// from a descendant CIDFont (see 9.7, "Composite fonts")
// Type 1 Type1 A font that defines glyph shapes using Type 1 font
// technology (see 9.6.2, "Type 1 fonts").
// MMType1 A multiple master font — an extension of the Type 1 font
// that allows the generation of a wide variety of typeface
// styles from a single font (see 9.6.2.3, "Multiple master fonts")
// Type 3 Type3 A font that defines glyphs with streams of PDF graphics
// operators (see 9.6.4, "Type 3 fonts")
// TrueType TrueType A font based on the TrueType font format (see 9.6.3,
// "TrueType fonts") and with glyph descriptions based on
// TrueType glyph technology.
// CIDFont CIDFontType0 (PDF 1.2) A CIDFont whose glyph descriptions are based on
// CFF font technology (see 9.7.4, "CIDFonts")
// CIDFontType2 (PDF 1.2) A CIDFont whose glyph descriptions are based on
// TrueType glyph technology (see 9.7.4, "CIDFonts")
// NOTE 2 Embedding of OpenType font programs (files) in PDF is described in "Table 124 — Embedded
// font organisation for various font types" when the value of the FontFile3 key is OpenType. The
// font dictionary that refers to it can have a Subtype of TrueType, Type1, CIDFontType0, or
// CIDFontType2, depending upon the glyph technology used in the OpenType font and other
// details provided in that table.
// For all font types, the term font dictionary refers to a PDF dictionary containing information about the
// font; likewise, a CIDFont dictionary contains information about a CIDFont. Except for Type 3, this
// dictionary is distinct from the font program that defines the font’s glyphs. That font program may be
// embedded in the PDF file as a stream object or be obtained from some external source.
// NOTE 3 This terminology differs from that used in the PostScript language. In PostScript, a font
// dictionary is a PostScript data structure that is created as a direct result of interpreting a font
// program. In PDF, a font program is always treated as if it were a separate file, even when its
// content is embedded in the PDF file. The font program is interpreted by a specialised font
// interpreter when necessary; its contents never materialize as PDF objects.
// NOTE 4 Most font programs (and related programs, such as CIDFonts and CMaps) conform to external
// specifications, such as the Adobe Type 1 Font Format. This document does not include those
// specifications. See 2, "Normative references" for more information about the specifications
// mentioned in this clause.
// NOTE 5 The most predictable and dependable results are produced when all font programs used to show
// text are embedded in the PDF file. See 9.9, "Embedded font programs" for the precise description
// of how to do so. If a PDF file refers to font programs that are not embedded, the results depend
// on the availability of fonts in the PDF processor’s environment. See 9.8, "Font descriptors" for
// some conventions for referring to external font programs. However, some details of font naming,
// font substitution, and glyph selection are implementation-dependent and can vary among
// different PDF processors and operating system environments.
// 312 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// 9.6 Simple fonts
