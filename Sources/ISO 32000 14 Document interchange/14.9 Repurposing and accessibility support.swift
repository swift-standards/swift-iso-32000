// ISO 32000-2:2020, 14.9 Repurposing and accessibility support

import ISO_32000_Shared

// 14.9 Repurposing and accessibility support
// 14.9.1 General
// PDF includes several facilities in support of accessibility of documents to users with disabilities. In
// particular, many computer users with visual impairments use screen readers to read documents aloud.
// To enable proper vocalisation, either through a screen reader or by some more direct invocation of a
// text-to-speech engine, PDF supports the following features:
// • Specifying the natural language used for text in a PDF document — for example, as English or
// Spanish (see 14.9.2, "Natural language specification")
// • Providing textual descriptions for images or other items that do not translate naturally into text
// (14.9.3, "Alternate descriptions"), or replacement text for content that does translate into text but
// is represented in a nonstandard way (such as with a ligature or illuminated character; see 14.9.4,
// "Replacement text")
// • Specifying the expansion of abbreviations or acronyms (14.9.5, "Expansion of abbreviations and
// acronyms")
// • Specifying pronunciation (14.9.6,
// "Pronunciation hints")
// 14.9.2 Natural language specification
// 14.9.2.1 General
// Natural language may be specified for content in a document.
// The natural language used for content in a document shall be determined in a hierarchical fashion,
// based on whether an optional Lang entry (PDF 1.4) is present in any of several possible locations. At
// the highest level, the document’s default language (which applies to both text strings and text within
// content streams) may be specified by a Lang entry in the document catalog dictionary (see 7.7.2,
// "Document catalog dictionary"). This applies to both content within content streams and any text
// strings, including text strings not included in the structure hierarchy such as, for example, entries in
// metadata, outline entries and names for optional content groups. Below this, the language may be
// specified for the following items:
// • Structure elements of any type (see 14.7.2, "Structure hierarchy"), through a Lang entry in the
// structure element dictionary. The language specified by a Lang entry shall apply to any content
// within content streams enclosed or referenced by the respective structure elements, to any
// ActualText, Alt, or E properties of the respective structure elements.
// • Marked-content sequences that are not in the structure hierarchy (see 14.6, "Marked content"),
// through a Lang entry in a property list attached to the marked-content sequence with a Span tag.
// NOTE 1 Although Span is also a standard structure type, as described under 14.8.4.7, "Inline level
// structure types"
// , a marked-content sequence whose tag is Span is entirely independent of logical
// structure.
// • Text strings encoded in Unicode may include an escape sequence using a language tag indicating
// the language of the text and overriding the prevailing Lang entry (see 7.9.2.2.2 "Text string
// language escape sequences").
// NOTE 2 The natural language used for optional content allows content to be hidden or revealed based on
// the Lang entry (PDF 1.5) in the Language dictionary of an optional content usage dictionary (see
// "Table 100 — Entries in an optional content usage dictionary").
// 796 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// 14.9.2.2 Language identifiers
// Certain language-related dictionary entries are text strings that specify language identifiers. Such text
// strings may appear as Lang entries in the following structures or dictionaries:
// • Document catalog dictionary, structure element dictionary, or property list.
// • In the optional content usage dictionary’s Language dictionary, the hierarchical issues described
// in 14.9.2.3, "Language specification hierarchy" shall not apply to this entry.
// • Font Descriptors for CIDFonts can have a Lang key (see "Table 122 — Additional font descriptor
// entries for CIDFonts").
// UTF-16BE or UTF-8 text strings can also have language escape sequences (see 7.9.2.2.2 "Text string
// language escape sequences").
// A language identifier shall either be the empty text string, to indicate that the language is unknown, or
// a Language-Tag as defined in BCP 47.
// Although language codes are commonly represented using lowercase letters and country codes are
// commonly represented using uppercase letters, all language tags shall be treated as case-insensitive.
// Non-linguistic content should be marked with language code "
// zxx
// " (as defined in BCP 47).
// 14.9.2.3 Language specification hierarchy
// The Lang entry in the document catalog dictionary shall specify the default natural language for all text
// in the document. Language specifications may appear within structure elements, and they may appear
// within marked-content sequences that are not in the structure hierarchy. If present, such language
// specifications override the default.
// Language specifications within the structure hierarchy apply in this order:
// • A structure element’s language specification. If a structure element does not have a Lang entry,
// the element shall inherit its language from any parent element that has one.
// • Within a structure element, a language specification for a nested structure element or marked-
// content sequence
// If only part of the page content is contained in the structure hierarchy, and the structured content is
// nested within non-structured content for which a different language specification applies, the structure
// element’s language specification shall take precedence.
// A language identifier attached to a marked-content sequence with the Span tag specifies the language
// for all text in the sequence except for nested marked-content that is contained in the structure
// hierarchy (in which case the structure element’s language applies) and except where overridden by
// language specifications for other nested marked-content.
// NOTE Examples in this subclause illustrate the hierarchical manner in which the language for text in a
// document is determined.
// EXAMPLE 1 This example shows how a language specified for the document as a whole could be overridden by one
// specified for a marked-content sequence within a page’s content stream, independent of any logical
// structure. In this case, the Lang entry in the document catalog dictionary (not shown) has the value en-US,
// meaning U.S. English, and it is overridden by the Lang property attached (with the Span tag) to the marked-
// content sequence “Hasta la vista”. The Lang property identifies the language for this marked-content
// © ISO 2020 – All rights reserved 797
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// sequence with the value es-MX, meaning Mexican Spanish.
// 2 0 obj %Page object
// <</Type /Page
/// Contents 3 0 R %Content stream
// …
// >>
// endobj
// 3 0 obj %Page's content stream
// <</Length …>>
// stream
// BT
// (See you later, or as Arnold would say, ) Tj
/// Span <</Lang (es-MX)>> %Start of marked-content sequence
// BDC
// ("Hasta la vista.
// ") Tj
// EMC %End of marked-content sequence
// ET
// endstream
// endobj
// EXAMPLE 2 In the following example, the Lang entry in the structure element dictionary (specifying English) applies to
// the marked-content sequence having an MCID (marked-content identifier) value of 0 within the indicated
// page’s content stream. However, nested within that marked-content sequence is another one in which the
// Lang property attached with the Span tag (specifying Spanish) overrides the structure element’s language
// specification.
// This example omits required StructParents entries in the objects used as content items (see 14.7.5.4,
// "Finding structure elements from content items").
// 1 0 obj %Structure element
// <</Type /StructElem
/// S /P %Structure type
/// P … %Parent in structure hierarchy
/// K <</Type /MCR
/// Pg 2 0 R %Page containing marked-content sequence
/// MCID 0 %Marked-content identifier
// >>
/// Lang (en-US) %Language specification for this element
// >>
// endobj
// 2 0 obj %Page object
// <</Type /Page
/// Contents 3 0 R %Content stream
// …
// >>
// endobj
// 3 0 obj %Page's content stream
// <</Length …>>
// stream
// BT
/// P <</MCID 0 …>> %Start of marked-content sequence
// BDC
// (See you later, or in Spanish you would say, ) Tj
/// Span <</Lang (es-MX)>> %Start of nested marked-content sequence
// BDC
// (Hasta la vista.) Tj
// EMC %End of nested marked-content sequence
// EMC %End of marked-content sequence
// ET
// endstream
// endobj
// 798 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// EXAMPLE 3 The page’s content stream consists of a marked-content sequence that specifies Spanish as its language by
// means of the Span tag with a Lang property. Nested within it is content that is part of a structure element
// (indicated by the MCID entry in that property list), and the language specification that applies to the latter
// content is that of the structure element, English.
// This example omits required StructParents entries in the objects used as content items (see 14.7.5.4,
// "Finding structure elements from content items").
// 1 0 obj %Structure element
// <</Type /StructElem
/// S /P %Structure type
/// P … %Parent in structure hierarchy
/// K <</Type /MCR
/// Pg 2 0 R %Page containing marked-content sequence
/// MCID 0 %Marked-content identifier
// >>
/// Lang (en-US) %Language specification for this element
// >>
// endobj
// 2 0 obj %Page object
// <</Type /Page
/// Contents 3 0 R %Content stream
// …
// >>
// endobj
// 3 0 obj %Page's content stream
// <</Length …>>
// stream
/// Span <</Lang (es-MX)>> %Start of marked-content sequence
// BDC
// (Hasta la vista, ) Tj
/// P <</MCID 0 …>> %Start of structured marked-content
// sequence,
// applies
// BDC %to which structure element's language
// (as Arnold would say.) Tj
// EMC %End of structured marked-content
// sequence
// endstream
// endobj
// 14.9.2.4 Multi-language text arrays
// EMC %End of marked-content sequence
// A multi-language text array (PDF 1.5) allows multiple text strings to be specified, each in association
// with a language identifier (see the Alt entry in "Table 285 — Additional entries in a media clip data
// dictionary" and "Table 288 — Additional entries in a media clip section dictionary").
// A multi-language text array shall contain pairs of strings. The first string in each pair shall be a
// language identifier 14.9.2.2,
// "Language identifiers"). A language identifier shall not appear more than
// once in the array; any unrecognised language identifier shall be ignored. An empty string specifies
// default text that may be used when no suitable language identifier is found in the array. The second
// string is text associated with the language.
// EXAMPLE [(en-US) (My vacation) (fr) (mes vacances) () (default text)]
// When a PDF processor searches a multi-language text array to find text for a given language, it shall
// look for an exact (though case-insensitive) match between the given language’s identifier and the
// language identifiers in the array. If no exact match is found, prefix matching shall be attempted in
// © ISO 2020 – All rights reserved 799
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// increasing array order: a match shall be declared if the given identifier is a leading, case-insensitive,
// substring of an identifier in the array, and the first post-substring character in the array identifier is a
// hyphen. For example, given identifier en matches array identifier en-US, but given identifier en-US
// matches neither en nor en-GB. If no exact or prefix match can be found, the default text (if any) should
// be used.
// 14.9.3 Alternate descriptions
// PDF documents may be enhanced by providing alternate descriptions for images, formulas, or other
// items that do not translate naturally into text.
// NOTE Alternate descriptions are human-readable text that could, for example, be vocalised by a text-to-
// speech engine for the benefit of users with visual impairments.
// An alternate description may be specified for the following items:
// • A structure element (see 14.7.2, "Structure hierarchy"), through an Alt entry in the structure
// element dictionary
// • (PDF 1.5) A marked-content sequence (see 14.6, "Marked content"), through an Alt entry in a
// property list attached to the marked-content sequence with a Span tag.
// • Any type of annotation (see 12.5, "Annotations") that does not already have a text representation,
// through a Contents entry in the annotation dictionary
// For annotation types that normally display text, the Contents entry of the annotation dictionary shall
// be used as the source for an alternate description. For annotation types that do not display text, a
// Contents entry may be included to specify an alternate description.
// An alternative name may be specified for an interactive form field (see 12.7, "Forms") which, if present,
// shall be used in place of the actual field name when an interactive PDF processor identifies the field in
// a user-interface. This alternative name, if provided, shall be specified using the TU entry of the field
// dictionary.
// When applied to structure elements, the alternate description text (see 7.9.2.2, "Text string type") is a
// complete (or whole) word or phrase substitution for the current element. If each of two (or more)
// elements in a sequence have an Alt entry in their dictionaries, they shall be treated as if a word break is
// present between them. The same applies to consecutive marked-content sequences.
// The Alt entry in property lists may be combined with other entries.
// EXAMPLE This example shows the Alt entry combined with a Lang entry.
/// Span <</Lang (en-us) /Alt (six-point star)>> BDC (A) Tj EMC
// 14.9.4 Replacement text
// Replacement text may be specified for the following items:
// • A structure element (see 14.7.2, "Structure hierarchy"), by means of the optional ActualText
// entry (PDF 1.4) of the structure element dictionary.
// • (PDF 1.5) A marked-content sequence (see 14.6, "Marked content"), through an ActualText entry
// in a property list attached to the marked-content sequence with a Span tag.
// 800 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// NOTE 1 Just as alternate descriptions can be provided for images and other items that do not translate
// naturally into text (as described in 14.9.3, “Alternate descriptions”), replacement text can be
// specified for content that does translate into text but is represented in a nonstandard way. These
// nonstandard representations can include, for example, glyphs for ligatures or custom characters,
// or inline graphics corresponding to letters in an illuminated manuscript.
// The ActualText value shall be used as a replacement, not a description, for the content, providing text
// that is equivalent to what a person would see when viewing the content. The value of ActualText is a
// character substitution for the content enclosed by the structure element or marked-content sequence.
// If each of two (or more) consecutive structure or marked-content sequences has an ActualText entry,
// they shall be treated as if no word break is present between them.
// NOTE 2 The treatment of ActualText as a character replacement is different from the treatment of Alt,
// which is treated as a whole word or phrase substitution.
// EXAMPLE This example shows the use of replacement text to indicate the correct character content in a case where
// hyphenation changes the spelling of a word (in German, up until spelling reforms, the word "Drucker" when
// hyphenated was rendered as "Druk-
// " and "ker").
// (Dru) Tj
/// Span
// <</Actual Text (c)>>
// BDC
// (k-) Tj
// EMC
// (ker) '
// Like alternate descriptions (and other text strings), replacement text, if encoded in Unicode, may
// include an escape sequence for indicating the language of the text. Such a sequence shall override the
// prevailing Lang entry (see 7.9.2.2, "Text string type").
// 14.9.5 Expansion of abbreviations and acronyms
// The expansion of an abbreviation or acronym may be specified for the following items:
// • Marked-content sequences, through an E property in a property list attached to the marked-
// content sequence with a Span tag.
// • Structure elements, through an E entry in the structure element dictionary. (See "Table 355 —
// Entries in a structure element dictionary".)
// NOTE 1 Abbreviations and acronyms can pose a problem for text-to-speech engines. Sometimes the full
// pronunciation for an abbreviation can be divined without aid. For example, a dictionary search
// will probably reveal that "Blvd." is pronounced "boulevard" and that "Ave." is pronounced
// "avenue." However, some abbreviations are difficult to resolve, as in the sentence "Dr. Healwell
// works at 123 Industrial Dr."
// .
// EXAMPLE
// BT
/// Span <</E (Doctor)>>
// BDC
// (Dr.) Tj
// EMC
// (Healwell works at 123 Industrial ) Tj
/// Span <</E (Drive)>>
// BDC
// (Dr.) Tj
// EMC
// ET
// © ISO 2020 – All rights reserved 801
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// The E value (a text string) is a word or phrase substitution for the tagged text and therefore shall be
// treated as if a word break separates it from any surrounding text. The expansion text, if encoded in
// Unicode, may include an escape sequence for indicating the language of the text (see 7.9.2.2, "Text
// string type"). Such a sequence shall override the prevailing Lang entry.
// NOTE 2 Some abbreviations or acronyms are conventionally not expanded into words. For the text "XYZ"
// ,
// for example, either no expansion would be supplied (leaving its pronunciation up to the text-to-
// speech engine) or, to be safe, the expansion "X Y Z" would be specified.
// 14.9.6 Pronunciation hints
// Content in a tagged PDF may be accompanied by hints for its correct pronunciation, for example for
// use by a text to speech function. Such pronunciation hints may be provided through the structure
// element entries PhoneticAlphabet and Phoneme (see "Table 355 — Entries in a structure element
// dictionary") and the structure tree root entry PronunciationLexicons (see "Table 354 — Entries in
// the structure tree root"). A PDF processor is not required to process pronunciation hints.
// NOTE Usually text-to-speech functions support pronunciation reasonably well based on text provided
// in Unicode encoding combined with an indication of the language that applies to that text. For
// uncommon words or special cases though it can be useful, to provide explicit instructions for the
// pronunciation of a given text.
