// ISO 32000-2:2020, 14.7 Logical structure

import ISO_32000_Shared

//14.7 Logical structure
//14.7.1 General
//PDF’s logical structure facilities (PDF 1.3) shall provide a mechanism for incorporating structural
//information about a document’s content into a PDF file. Such information may include the organisation
//of the document into chapters and sections or the identification of special elements such as figures,
//tables, and footnotes. The logical structure facilities shall be extensible, allowing PDF writers to choose
//what structural information to include and how to represent it, while enabling PDF processors to
//navigate a PDF file without knowing the producer’s structural conventions.
//PDF logical structure shares basic features with standard document markup languages such as HTML
//and XML. A document’s logical structure shall be expressed as a hierarchy of structure elements, each
//represented by a dictionary object. Like their counterparts in other markup languages, PDF structure
//elements may have content and attributes. In PDF, rendered document content takes over the role
//occupied by text in HTML and XML.
//A PDF document’s logical structure shall be stored separately from its visible content, with pointers
//from each to the other. This separation allows the ordering and nesting of logical elements to be
//entirely independent of the order and location of graphics objects on the document’s pages. The
//722 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//MarkInfo entry in the document catalog dictionary (see 7.7.2, "Document catalog dictionary") shall
//specify a mark information dictionary, whose entries are shown in "Table 353 — Entries in the mark
//information dictionary". It provides additional information relevant to specialised uses of structured
//PDF documents.
//Table 353 — Entries in the mark information dictionary
//Key Type Value
//Marked boolean (Optional) A flag indicating whether the document conforms to
//tagged PDF conventions (see 14.8, "Tagged PDF"). Default value:
//false.
//If Suspects is true, the document may not completely conform to
//tagged PDF conventions.
//UserProperties boolean (Optional; PDF 1.6) A flag indicating the presence of structure
//elements that contain user properties attributes (see 14.7.6.4,
//"User properties"). Default value: false.
//Suspects boolean (Optional; PDF 1.6; deprecated in PDF 2.0) A flag indicating the
//presence of tag suspects. Default value: false.
//14.7.2 Structure hierarchy
//The logical structure of a document shall be described by a hierarchy of objects called the structure
//hierarchy or structure tree. At the root of the hierarchy shall be a dictionary object called the structure
//tree root, located by means of the StructTreeRoot entry in the document catalog dictionary (see 7.7.2,
//"Document catalog dictionary"). "Table 354 — Entries in the structure tree root" shows the entries in
//the structure tree root dictionary. The K entry shall specify the immediate children of the structure
//tree root, which shall be structure elements.
//Table 354 — Entries in the structure tree root
//Key Type Value
//Type name (Required) The type of PDF object that this dictionary describes; shall
//be StructTreeRoot for a structure tree root.
//K dictionary or
//array
//(Optional) The immediate child or children of the structure tree root in
//the structure hierarchy. The value may be either a dictionary
//representing a single structure element or an array of such
//dictionaries.
//IDTree name tree (Required if any structure elements have element identifiers) A name
//tree (see 7.9.6,
//"Name trees") that maps element identifiers (see
//"Table 355 — Entries in a structure element dictionary") to the
//structure elements they denote.
//© ISO 2020 – All rights reserved 723
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//ParentTree number tree (Required if any structure element contains content items) A number
//tree (see 7.9.7, "Number trees") used in finding the structure elements
//to which content items belong. Each integer key in the number tree
//shall correspond to a single page of the document or to an individual
//object (such as an annotation or an XObject) that is a content item in
//its own right. The integer key shall be the value of the StructParent or
//StructParents entry in that object (see 14.7.5.4, "Finding structure
//elements from content items"). The form of the associated value shall
//depend on the nature of the object: For an object that is a content item
//in its own right, the value shall be an indirect reference to the object’s
//parent element (the structure element that contains it as a content
//item). For a page object or content stream containing marked-content
//sequences that are content items, the value shall be an array of
//references to the parent elements of those marked-content sequences.
//See 14.7.5.4, "Finding structure elements from content items" for
//further discussion.
//ParentTreeNextKey integer (Optional) An integer greater than any key in the parent tree
//ParentTree and that shall be used as the key for the next entry added
//to the parent tree.
//RoleMap dictionary (Optional) A dictionary that shall map name objects designating names
//of structure types used in the document to a name object designating
//the name of their approximate equivalents in the set of standard
//structure types (see 14.8.4, "Standard structure types").
//ClassMap dictionary (Optional) A dictionary that shall map name objects designating
//attribute classes to the corresponding attribute objects or arrays of
//attribute objects (see 14.7.6.2, "Attribute classes").
//Namespaces array (Required if any structure elements have namespace identifiers; PDF 2.0)
//An array of namespaces used within the document (see 14.7.4.2,
//"Namespace dictionary").
//PronunciationLexicon array of file
//specifications
//(Optional; PDF 2.0) An array containing one or more indirect
//references to file specification dictionaries, where each specified file
//shall be a pronunciation lexicon, which is an XML file conforming to
//the Pronunciation Lexicon Specification (PLS) Version 1.0. These
//pronunciation lexicons may be used as pronunciation hints when the
//document’s content is presented via text-to-speech. Where two or
//more pronunciation lexicons apply to the same text, the first match –
//as defined by the order of entries in the array and the order of entries
//inside the pronunciation lexicon file – should be used.
//See 14.9.6, "Pronunciation hints" for further discussion.
//AF array of
//dictionaries
//(Optional; PDF 2.0) An array of one or more file specification
//dictionaries (7.11.3, "File specification dictionaries") which denote the
//associated files for the entire structure tree. See 14.13, "Associated
//files".
//Structure elements shall be represented by a dictionary, whose entries are shown in "Table 355 —
//Entries in a structure element dictionary". The K entry shall specify the children of the structure
//element, which may be zero or more items of the following kinds:
//724 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//• Other structure elements
//• References to content items, which are either marked-content sequences (see 14.6, "Marked
//content") or complete PDF objects such as XObjects and annotations. These content items
//represent the graphical content, if any, associated with a structure element. Content items are
//discussed in detail in 14.7.5, "Structure content".
//Table 355 — Entries in a structure element dictionary
//Key Type Value
//Type name (Optional) The type of PDF object that this dictionary describes; if present,
//shall be StructElem for a structure element.
//S name (Required) The structure type, a name object identifying the nature of the
//structure element and its role within the document, such as a chapter,
//paragraph, or footnote (see 14.7.3, "Structure types"). Names of structure
//types shall conform to the guidelines described in Annex E, "Extending PDF".
//P dictionary (Required; shall be an indirect reference) The structure element or the
//structure tree root that is the immediate parent of this structure element in
//the structure hierarchy.
//ID byte string (Optional) The element identifier, a byte string designating this structure
//element. The string shall be unique among all elements in the document’s
//structure hierarchy. The IDTree entry in the structure tree root (see "Table
//354 — Entries in the structure tree root") defines the correspondence
//between element identifiers and the structure elements they denote.
//Ref array (Optional; PDF 2.0) An array containing zero, one or more indirect references
//to structure elements. A Ref identifies the structure element or elements to
//which the item of content, contained within this structure element, refers
//(e.g. footnotes, endnotes, sidebars, etc.).
//Pg dictionary (Optional; required if K is an integer object or an array containing integer
//objects; shall be an indirect reference) A page object representing a page on
//which some or all of the content items designated by the K entry shall be
//rendered.
//K (various) (Optional) The children of this structure element. The value of this entry may
//be one of the following objects or an array consisting of one or more of the
//following objects in any combination:
//• A structure element dictionary denoting another structure element
//• An integer marked-content identifier denoting a marked-content sequence
//• A marked-content reference dictionary denoting a marked-content sequence
//(see “Table 357 — Entries in a marked-content reference dictionary")
//• An object reference dictionary denoting a PDF object (see “Table 358 — Entries
//in an object reference dictionary")
//Each of these objects other than the first (structure element dictionary) shall
//be considered to be a content item; see 14.7.5, "Structure content" for further
//discussion of each of these forms of representation.
//If the value of K is a dictionary containing no Type entry, it shall be assumed
//to be a structure element dictionary.
//© ISO 2020 – All rights reserved 725
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type A (various) C name or
//array
//R integer T text string Lang text string Alt text string E text string ActualText text string AF array of
//dictionaries
//NS dictionary 726 Value
//(Optional) A single attribute object or array of attribute objects associated
//with this structure element. Each attribute object shall be either a dictionary
//or a stream. If the value of this entry is an array, each attribute object in the
//array may be followed by an integer representing its revision number (see
//14.7.6, "Structure attributes" and 14.7.6.3, "Attribute revision numbers").
//(Optional) An attribute class name or array of class names associated with
//this structure element. If the value of this entry is an array, each class name
//in the array may be followed by an integer representing its revision number
//(see 14.7.6.2, "Attribute classes" and 14.7.6.3, "Attribute revision numbers").
//If both the A and C entries are present and a given attribute is specified by
//both, the one specified by the A entry shall take precedence.
//(Optional) The current revision number of this structure element (see
//14.7.6.3, "Attribute revision numbers"). The value shall be a non-negative
//integer. Default value: 0.
//(Optional) The title of the structure element, a text string representing it in
//human-readable form. The title should characterise the specific structure
//element, such as Chapter 1, rather than merely a generic element type, such
//as Chapter.
//(Optional; PDF 1.4) A language identifier specifying the natural language for
//all text in the structure element except where overridden by language
//specifications for nested structure elements or marked-content (see 14.9.2,
//"Natural language specification").
//(Optional) An alternative description of the structure element and its
//children in human-readable form, which is useful when extracting the
//document’s contents in support of accessibility to users with disabilities or
//for other purposes (see 14.9.3, "Alternate descriptions").
//(Optional; PDF 1.5) The expanded form of an abbreviation or an acronym.
//(Optional; PDF 1.4) Text that is an exact replacement for the content enclosed
//by the structure element and its children. This replacement text (which
//should apply to as small a piece of content as possible) is useful when
//extracting the document’s contents in support of accessibility to users with
//disabilities or for other purposes (see 14.9.4, "Replacement text").
//(Optional; PDF 2.0) An array of one or more file specification dictionaries
//(7.11.3, "File specification dictionaries") which denote the associated files for
//this entire structure element. See 14.13, "Associated files"
//.
//(Optional; PDF 2.0) An indirect reference to a namespace dictionary defining
//the namespace this element belongs to (see 14.7.4, "Namespaces"). If not
//present, the element shall be considered to be in the default standard
//structure namespace (see 14.8.6, "Standard structure namespaces").
//© ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//PhoneticAlphabet Name (Optional; PDF 2.0) Property for a structure element that indicates the
//phonetic alphabet used by a Phoneme property. Applies to the structure
//element and its children, except where overridden by a child structure
//element.
//Currently defined values are:
//• ipa for the International Phonetic Alphabet by the International Phonetic
//Association
//• x-sampa for Extended Speech Assessment Methods Phonetic Alphabet (X-
//SAMPA)
//• zh-Latn-pinyin for Pinyin Latin romanization (Mandarin)
//• zh-Latn-wadegile for Wade-Giles romanization (Mandarin)
//Other values may be used.
//Default value: ipa.
//See 14.9.6, "Pronunciation hints" for further discussion.
//Phoneme text string (Optional; PDF 2.0) Property for a structure element that may be used as
//pronunciation hint. It is an exact replacement for content enclosed by the
//structure element and its children.
//The value for a Phoneme property is to be interpreted based on the
//PhoneticAlphabet property in effect.
//See 14.9.6, "Pronunciation hints" for further discussion.
//14.7.3 Structure types
//Every structure element shall have a structure type, a name object that identifies the nature of the
//structure element and its role within the document (such as a chapter, paragraph, or footnote). To
//facilitate the interchange of content among PDF processors, PDF defines a set of standard structure
//types; see 14.8.4, "Standard structure types"
//. PDF writers are not required to adopt them, however,
//and may use any names for their structure types.
//Where names other than the standard ones are used, a role map should be provided in the structure
//tree root using the RoleMap entry or, in the case of namespaces, the RoleMapNS entry within an NS
//entry, to map the structure types used in the document to their nearest equivalents in the standard set.
//The RoleMap dictionary shall be comprised of a set of keys representing structure element types
//rolemapped to other structure element types. The corresponding value for each of these keys shall be a
//single name identifying the target structure element type.
//A structure type shall always be mapped to its corresponding name in the role map, if there is one,
//even if the original name is one of the standard types. This shall be done to allow the element, for
//example, to represent a structure type with the same name as a standard role, even though its use
//differs from the standard role.
//NOTE 1 A structure type named Advertising can be mapped to the standard type Part. The equivalence
//need not be exact; the role map merely indicates an approximate analogy between types,
//allowing PDF processors to share nonstandard structure elements in a reasonable way.
//© ISO 2020 – All rights reserved 727
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//NOTE 2 The same structure type can occur as both a key and a value in the role map, and circular chains
//of association are explicitly permitted. Therefore, a single role map can define a bidirectional
//mapping. A PDF processor using the role map needs to follow the chain of associations until it
//either finds a structure type it recognises or returns to one it has already encountered.
//NOTE 3 In PDF versions earlier than 1.5, standard element types were never remapped.
//14.7.4 Namespaces
//14.7.4.1 General
//PDF documents are used to represent many classes of documents as well as many classes of content
//within those documents. The standard structure types (see 14.8.4, "Standard structure types") address
//many classes of documents. The mechanism for providing a role mapping for custom structure types
//allows the inclusion of non-standard, custom, types. However, prior to PDF 2.0, there has been no
//mechanism for identifying and exchanging these custom structure types, other than to use their
//mapping to the standard structure types.
//The concept of namespaces is well understood in the XML world, allowing custom XML tagsets to be
//interchanged and identified. Schemata are often defined for these namespaces using a variety of
//schema languages to allow programmatic exchange of tagsets. Many PDF documents are authored by
//conversion from other formats, many of which have rich structures and content with their own
//structures. PDF 2.0 introduces the namespace mechanism as a component of its logical structure,
//where one or more namespaces may be specified as being used within the document (see 14.7.4.2,
//"Namespace dictionary").
//14.7.4.2 Namespace dictionary
//A namespace dictionary shall be used to define a namespace (see 14.7.4, "Namespaces") within the
//structure tree (see 14.7.2, "Structure hierarchy"). "Table 356 — Entries in a namespace dictionary"
//shows the entries in the namespace dictionary. The NS entry shall specify the namespace name, which
//should take the form of a uniform resource identifier (URI).
//NOTE 1 It is not generally expected that a URI for a namespace name will resolve. It is instead used for
//uniqueness. A URI specified here can correspond to an existing XML namespace (e.g.
//"http://www.w3.org/1998/Math/MathML" for MathML 3.0).
//An optional Schema entry may be provided to identify the schema file for the namespace.
//NOTE 2 There is no requirement that the schema be provided in any specific format (e.g. RelaxNG or
//W3C Schema), though the expectation is that the format would be machine readable.
//A RoleMapNS entry may also be provided to map the entries in the namespace to those of another
//namespace. For a document that is compliant with tagged PDF see 14.8.6, "Standard structure
//namespaces" for namespace requirements.
//NOTE 3 Role mapping to one of the standard structure namespaces can be achieved either directly in the
//provided role map or transitively through one or more namespaces which eventually provide a
//role map to one of the standard structure namespaces.
//728 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 356 — Entries in a namespace dictionary
//Key Type Value
//Type name (Optional; PDF 2.0) The type of PDF object that this dictionary describes. If
//present, shall be Namespace.
//NS text string (Required; PDF 2.0) The string defining the namespace name which this entry
//identifies (conventionally a uniform resource identifier, or URI).
//Schema file
//specification
//(Optional; PDF 2.0) A file specification identifying the schema file, which defines
//this namespace.
//RoleMapNS dictionary (Optional; PDF 2.0) A dictionary that shall, if present, map the names of
//structure types used in the namespace to their approximate equivalents in
//another namespace. The dictionary shall be comprised of a set of keys
//representing structure element types in the namespace defined within this
//namespace dictionary. The corresponding value for each of these keys shall
//either be a single name identifying a structure element type in the default
//standard structure namespace or an array where the first value shall be a
//structure element type name in a target namespace with the second value being
//an indirect reference to the target namespace dictionary.
//When the owner of an attribute object (see Table 360 — Entries common to all attribute object
//dictionaries) is specified by an NS entry, the namespace name shall be considered as identifying the
//owner. For common namespace names which correspond to the values of owner entries defined in
//Table 376 — Standard structure attribute owners, they shall be considered equivalent.
//14.7.5 Structure content
//14.7.5.1 General
//Any structure element may have associated graphical content, consisting of one or more content items.
//Content items shall be graphical objects that exist in the document independently of the structure tree
//but are associated with structure elements as described in the following subclauses.
//14.7.5.1.1 Content items
//Content items are of two kinds:
//• Marked-content sequences within content streams (14.7.5.2, "Marked-content sequences as
//content items")
//• Complete PDF objects such as annotations and XObjects (see 14.7.5.3, "PDF objects as content
//items")
//The K entry in a structure element dictionary (see "Table 355 — Entries in a structure element
//dictionary") specifies the children of the structure element, which may include any number of content
//items, as well as child structure elements that may in turn have content items of their own.
//Content items shall be leaf nodes of the structure tree; that is, they shall not have other content items
//nested within them for purposes of logical structure. The hierarchical relationship among structure
//© ISO 2020 – All rights reserved 729
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//elements shall be represented entirely by the K entries of the structure element dictionaries, not by
//nesting of the associated content items. Therefore, the following restrictions shall apply:
//• A marked-content sequence corresponding to a structure content item shall not have another
//marked-content sequence for a structure content item nested within it though non-structural
//marked-content shall be allowed.
//• A structure content item shall not invoke (with the Do operator) an XObject that is itself a
//structure content item. Logical structure information associated with a page may be ignored
//when importing that page into another document with a reference XObject (see 8.10.4.3 "Special
//considerations").
//14.7.5.2 Marked-content sequences as content items
//A sequence of graphics operators in a content stream may be specified as a content item of a structure
//element in the following way:
//• The operators shall be bracketed as a marked-content sequence between BDC and EMC operators
//(see 14.6, "Marked content"). Although the tag associated with a marked-content sequence is not
//directly related to the document’s logical structure, it should be the same as the structure type of
//the associated structure element.
//• The marked-content sequence shall contain a property list (see 14.6.2, "Property lists")
//containing an MCID entry, which shall be an integer marked-content identifier that uniquely
//identifies the marked-content sequence within its content stream, as shown in the following
//example:
//EXAMPLE 1
//2 0 obj %Page object
//<</Type /Page
///Contents 3 0 R %Content stream
//…
//>>
//endobj
//3 0 obj %Page's content stream
//<</Length …>>
//stream
//…
///P <</MCID 0>> %Start of marked-content sequence
//BDC
//…
//(Here is some text) Tj
//…
//EMC %End of marked-content sequence
//…
//endstream
//endobj
//NOTE This example and the following examples omit required StructParents entries in the objects
//used as content items (see 14.7.5.4, "Finding structure elements from content items").
//A structure element dictionary may include one or more marked-content sequences as content items
//by referring to them in its K entry (see "Table 355 — Entries in a structure element dictionary"). This
//reference may have two forms:
//• A dictionary object called a marked-content reference.
//"Table 357 — Entries in a marked-content
//reference dictionary" shows the contents of this type of dictionary, which shall specify the
//730 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//marked-content identifier, as well as other information identifying the stream in which the
//sequence is contained. Example 2 in this subclause illustrates the use of a marked-content
//reference to the marked-content sequence shown in Example 1.
//• An integer that specifies the marked-content identifier. This may be done in the common case
//where the marked-content sequence is contained in the content stream of the page that is
//specified in the Pg entry of the structure element dictionary. Example 3 shows a structure
//element that has three children: a marked-content sequence specified by a marked-content
//identifier, as well as two other structure elements.
//Table 357 — Entries in a marked-content reference dictionary
//Key Type Value
//Type name (Required) The type of PDF object that this dictionary describes;
//shall be MCR for a marked-content reference.
//Pg dictionary (Optional; shall be an indirect reference) The page object
//representing the page on which the graphics objects in the
//marked-content sequence shall be rendered. This entry overrides
//any Pg entry in the structure element containing the marked-
//content reference; it shall be required if the structure element has
//no such entry.
//Stm stream (Optional; shall be an indirect reference) The content stream
//containing the marked-content sequence. This entry should be
//present only if the marked-content sequence resides in a content
//stream other than the content stream for the page (see 8.10,
//"Form XObjects" and 12.5.5, "Appearance streams").
//If this entry is absent, the marked-content sequence shall be
//contained in the content stream of the page identified by Pg
//(either in the marked-content reference dictionary or in the
//parent structure element).
//StmOwn (any) (Optional; shall be an indirect reference) The indirect reference to
//the PDF object referencing the stream identified by the Stm key.
//NOTE A common use for this would be to identify the annotation
//dictionary owning the appearance stream.
//MCID integer (Required) The marked-content identifier of the marked-content
//sequence within its content stream.
//EXAMPLE 2
//1 0 obj %Structure element
//<</Type /StructElem
///S /P %Structure type
///P … %Parent in structure hierarchy
///K <</Type /MCR
///Pg 2 0 R %Page containing marked-content sequence
///MCID 0 %Marked-content identifier
//>>
//>>
//endobj
//EXAMPLE 3
//1 0 obj %Containing structure element
//© ISO 2020 – All rights reserved 731
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//<</Type /StructElem
///S /MixedContainer %Structure type
///P … %Parent in structure hierarchy
///Pg 2 0 R %Page containing marked-content sequence
///K [4 0 R %Three children: a structure element
//0 %a marked-content identifier
//5 0 R %another structure element
//]
//>>
//endobj
//2 0 obj %Page object
//<</Type /Page
///Contents 3 0 R %Content stream
//…
//>>
//endobj
//3 0 obj %Page's content stream
//<</Length …>>
//stream
//…
///P <</MCID 0>> %Start of marked-content sequence
//BDC
//( Here is some text ) Tj
//…
//EMC %End of marked-content sequence
//…
//endstream
//endobj
//Content streams other than page contents may also contain marked-content sequences that are
//content items of structure elements. The content of form XObjects may be incorporated into structure
//elements in one of the following ways:
//• A Do operator that paints a form XObject may be part of a marked-content sequence that is
//associated with a structure element (see Example 4 in this subclause). In this case, the entire form
//XObject is part of the structure element’s content, as if it were inserted into the marked-content
//sequence at the point of the Do operator. The form XObject shall not, in turn, contain any marked-
//content sequences associated with this or other structure elements.
//• The content stream of a form XObject may contain one or more marked-content sequences that
//are associated with structure elements (see Example 5 in this subclause). The form XObject may
//have arbitrary substructure, containing any number of marked-content sequences associated
//with logical structure elements. However, any Do operator that paints the form XObject shall not
//be part of a logical structure content item.
//A form XObject that is painted with multiple invocations of the Do operator shall be incorporated into
//the document’s logical structure only by the first method, with each invocation of Do individually
//associated with a structure element.
//EXAMPLE 4
//1 0 obj %Structure element
//<</Type /StructElem
///S /P %Structure type
///P … %Parent in structure hierarchy
///Pg 2 0 R %Page containing marked-content sequence
///K 0 %Marked-content identifier
//>>
//endobj
//732 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//2 0 obj %Page object
//<</Type /Page
///Resources <</XObject <</Fm4 4 0 R>> %Resource dictionary
//>> %containing form XObject
///Contents 3 0 R %Content stream
//…
//>>
//endobj
//3 0 obj %Page's content stream
//<</Length …>>
//stream
//…
///P <</MCID 0>> %Start of marked-content sequence
//BDC
///Fm4 Do %Paint form XObject
//EMC %End of marked-content sequence
//…
//endstream
//endobj
//4 0 obj %Form XObject
//<</Type /XObject
///Subtype /Form
///Length …
//>>
//stream
//…
//(Here is some text) Tj
//…
//endstream
//endobj
//EXAMPLE 5
//1 0 obj %Structure element
//<</Type /StructElem
///S /P %Structure type
///P … %Parent in structure hierarchy
///K <</Type /MCR
///Pg 2 0 R %Page containing marked-content sequence
///Stm 4 0 R %Stream containing marked-content sequence
///MCID 0 %Marked-content identifier
//>>
//>>
//endobj
//2 0 obj %Page object
//<</Type /Page
///Resources <</XObject <</Fm4 4 0 R>> %Resource dictionary
//>> %containing form XObject
///Contents 3 0 R %Content stream
//…
//>>
//endobj
//3 0 obj %Page's content stream
//<</Length …>>
//stream
//…
///Fm4 Do %Paint form XObject
//…
//endstream
//endobj
//4 0 obj %Form XObject
//© ISO 2020 – All rights reserved 733
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//<</Type /XObject
///Subtype /Form
///Length …
//>>
//stream
//…
///P <</MCID 0>> %Start of marked-content sequence
//BDC
//…
//(Here is some text) Tj
//…
//EMC %End of marked-content sequence
//…
//endstream
//endobj
//14.7.5.3 PDF objects as content items
//When a structure element’s content consists of an entire PDF object, such as an XObject directly or
//indirectly referenced by a page description or an annotation, the object shall be identified in the
//structure element’s K entry by an object reference dictionary ("Table 358 — Entries in an object
//reference dictionary").
//NOTE 1 This form of reference is used only for entire objects. If the referenced content forms only part of
//the object’s content stream, it is instead handled as a marked-content sequence, as described in
//14.7.5.2,
//"Marked-content sequences as content items"
//.
//Table 358 — Entries in an object reference dictionary
//Key Type Value
//Type name (Required) The type of PDF object that this dictionary describes; shall be OBJR
//for an object reference.
//Pg dictionary (Optional; shall be an indirect reference) The page object of the page on which
//the object shall be rendered. This entry overrides any Pg entry in the structure
//element containing the object reference; it shall be used if the structure element
//has no such entry.
//Obj (any) (Required; shall be an indirect reference) The referenced object.
//NOTE 2 If the referenced object is rendered on multiple pages, each rendering requires a separate object
//reference. However, if it is rendered multiple times on the same page, just a single object
//reference suffices to identify all of them. (If it is important to distinguish between multiple
//renditions of the same XObject on the same page, they need to be accessed by means of marked-
//content sequences enclosing particular invocations of the Do operator rather than through
//object references.)
//14.7.5.4 Finding structure elements from content items
//Because a stream cannot contain object references, there is no way for content items that are marked-
//content sequences to refer directly back to their parent structure elements (the ones to which they
//belong as content items). Instead, a different mechanism, the structural parent tree, shall be provided
//for this purpose. For consistency, content items that are entire PDF objects, such as XObjects, shall also
//use the parent tree to refer to their parent structure elements.
//734 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//The parent tree is a number tree (see 7.9.7, "Number trees"), accessed from the ParentTree entry in a
//document’s structure tree root ("Table 354 — Entries in the structure tree root"). The tree shall
//contain an entry for each object that is a content item of at least one structure element and for each
//content stream containing at least one marked-content sequence that is a content item. The key for
//each entry shall be an integer given as the value of the StructParent or StructParents entry in the
//object (see "Table 359 — Additional dictionary entries for structure element access"). The values of
//these entries shall be as follows:
//• For an object identified as a content item by means of an object reference (see 14.7.5.3, "PDF
//objects as content items"), the value shall be an indirect reference to the parent structure element.
//• For a content stream containing marked-content sequences that are content items, the value shall
//be an array of indirect references to the sequences’ parent structure elements. The array element
//corresponding to each sequence shall be found by using the sequence’s marked-content identifier
//as a zero-based index into the array.
//NOTE Because marked-content identifiers serve as indices into an array in the structural parent tree,
//their assigned values need to be as small as possible to conserve space in the array.
//The ParentTreeNextKey entry in the structure tree root shall hold an integer value greater than any
//that is currently in use as a key in the structural parent tree. Whenever a new entry is added to the
//parent tree, the current value of ParentTreeNextKey shall be used as its key. The value shall be then
//incremented to prepare for the next new entry to be added.
//To locate the relevant parent tree entry, each object or content stream that is represented in the tree
//shall contain a special dictionary entry, StructParent or StructParents (see "Table 359 — Additional
//dictionary entries for structure element access"). Depending on the type of content item, this entry
//may appear in the page object of a page containing marked-content sequences, in the stream dictionary
//of a form or image XObject, or in an annotation dictionary. Its value shall be the integer key under
//which the entry corresponding to the object shall be found in the structural parent tree.
//Table 359 — Additional dictionary entries for structure element access
//Key Type Value
//StructParent integer (Required for all objects that are structural content items; PDF 1.3) The
//integer key of this object’s entry in the structural parent tree.
//StructParents integer (Required for all content streams containing marked-content sequences that
//are structural content items; PDF 1.3) The integer key of this object’s entry
//in the structural parent tree. At most one of these two entries shall be
//present in a given object. An object may be either a content item in its
//entirety or a container for marked-content sequences that are content
//items, but not both.
//For a content item identified by an object reference, the parent structure element may be found by
//using the value of the StructParent entry in the item’s object dictionary as a retrieval key in the
//structural parent tree (found in the ParentTree entry of the structure tree root). The corresponding
//value in the parent tree shall be a reference to the parent structure element (see Example 1).
//EXAMPLE 1
//1 0 obj %Parent structure element
//© ISO 2020 – All rights reserved 735
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//<</Type /StructElem
//…
///K <</Type /OBJR %Object reference
///Pg 2 0 R %Page containing form XObject
///Obj 4 0 R %Reference to form XObject
//>>
//>>
//endobj
//2 0 obj %Page object
//<</Type /Page
///Resources <</XObject <</Fm4 4 0 R>>%Resource dictionary
//>> %containing form XObject
///Contents 3 0 R %Content stream
//…
//>>
//endobj
//3 0 obj %Page's content stream
//<</Length …>>
//stream
//…
///Fm4 Do %Paint form XObject
//…
//endstream
//endobj
//4 0 obj %Form XObject
//<</Type /XObject
///Subtype /Form
///Length …
///StructParent 6 %Parent tree key
//>>
//stream
//…
//endstream
//endobj
//100 0 obj %Parent tree (accessed from structure tree root)
//<</Nums [0 101 0 R
//1 102 0 R
//…
//6 1 0 R %Entry for page object 2; points back
//… %to parent structure element
//]
//>>
//endobj
//For a content item that is a marked-content sequence, the retrieval method is similar but slightly more
//complicated. Because a marked-content sequence is not an object in its own right, its parent tree key
//shall be found in the StructParents entry of the page object or other content stream in which the
//sequence resides. The value retrieved from the parent tree shall not be a reference to the parent
//structure element itself but to an array of such references — one for each marked-content sequence
//contained within that content stream. The parent structure element for the given sequence shall be
//found by using the sequence’s marked-content identifier as an index into this array (see Example 2).
//EXAMPLE 2
//1 0 obj %Parent structure element
//<</Type /StructElem
//…
///Pg 2 0 R %Page containing marked-content sequence
///K 0 %Marked-content identifier
//736 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//>>
//endobj
//2 0 obj %Page object
//<</Type /Page
///Contents 3 0 R %Content stream
///StructParents 6 %Parent tree key
//…
//>>
//endobj
//3 0 obj %Page's content stream
//<</Length …>>
//stream
//…
///P <</MCID 0>> %Start of marked-content sequence
//BDC
//(Here is some text) TJ
//…
//EMC %End of marked-content sequence
//…
//endstream
//endobj
//100 0 obj %Parent tree (accessed from structure tree root)
//<</Nums [0 101 0 R
//1 102 0 R
//…
//6 [1 0 R] %Entry for page object 2; array element at index 0
//… %points back to parent structure element
//]
//>>
//endobj
//14.7.6 Structure attributes
//14.7.6.1 General
//A PDF processor that processes logical structure may attach additional information, called attributes,
//to any structure element. The attribute information shall be held in one or more attribute objects
//associated with the structure element. An attribute object shall be a dictionary or stream that includes
//an O entry (see "Table 360 — Entries common to all attribute object dictionaries") identifying the
//conforming product that owns the attribute information. Other entries, except the NS entry, shall
//represent the attributes: the keys shall be attribute names, and values shall be the corresponding
//attribute values. To facilitate the interchange of content among conforming products, PDF defines a set
//of standard structure attributes identified by specific standard owners; see 14.8.5, "Standard structure
//attributes"
//. In addition, attributes may be used to represent user properties (see 14.7.6.4, "User
//properties").
//NOTE Earlier versions of PDF also provided for the use of streams as attributes.
//© ISO 2020 – All rights reserved 737
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 360 — Entries common to all attribute object dictionaries
//Key Type Value
//O name (Required) The name of the PDF processor creating the attribute data. The value shall
//either be a NSO, UserProperties (see "Table 361 — Additional entries in an attribute
//object dictionary for user properties"), one of the values from 14.8.5,
//"Standard
//structure attributes", or conform to the guidelines described in Annex E, "Extending
//PDF".
//If the value for the O entry is NSO then the NS entry shall be present, and shall identify
//the owner of the attribute object.
//NS dictionary (Required if the value of the O entry is NSO; not permitted otherwise; PDF 2.0) An
//indirect reference to a namespace dictionary defining the namespace that attributes
//with this attribute object dictionary belong to (see 14.7.4, "Namespaces"). If not
//present, the attributes in this attribute object dictionary do not have a namespace.
//NOTE Because the NS entry is now reserved within the attribute object dictionary, attributes
//from existing namespaces with a matching name will not be able to be used.
//Any PDF processor may attach attributes to any structure element, even one created by another PDF
//processor. Multiple PDF processors may attach attributes to the same structure element. The A entry in
//the structure element dictionary (see "Table 355 — Entries in a structure element dictionary") shall
//hold either a single attribute object or an array of at least one object.
//When an array of attribute objects is provided, the value of the O and NS keys may be repeated across
//attribute objects. If a given attribute is specified more than once, the later (in array order) entry shall
//take precedence.
//14.7.6.2 Attribute classes
//If many structure elements share the same set of attribute values, they may be defined as an attribute
//class sharing the identical attribute object. Structure elements shall refer to the class by name. The
//association between class names and attribute objects shall be defined by a dictionary called the class
//map, that shall be kept in the ClassMap entry of the structure tree root (see "Table 354 — Entries in
//the structure tree root"). Each key in the class map shall be a name object denoting the name of a class.
//The corresponding value shall be an attribute object or an array of such objects.
//NOTE PDF attribute classes are unrelated to the concept of a class in object-oriented programming
//languages such as Java and C++. Attribute classes are strictly a mechanism for storing attribute
//information in a more compact form; they have no inheritance properties like those of true
//object-oriented classes.
//The C entry in a structure element dictionary (see "Table 355 — Entries in a structure element
//dictionary") shall contain a class name or an array of class names (typically accompanied by revision
//numbers as well; see 14.7.6.3, "Attribute revision numbers"). For each class named in the C entry, the
//corresponding attribute object or objects shall be considered to be attached to the given structure
//element, along with those identified in the element’s A entry. If both the A and C entries are present
//and a given attribute is specified by both, the one specified by the A entry shall take precedence.
//738 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//14.7.6.3 Attribute revision numbers
//The features described in this subclause are deprecated with PDF 2.0.
//When a PDF processor modifies a structure element or its contents, the change may affect the validity
//of attribute information attached to that structure element by other PDF processors. A system of
//revision numbers shall allow PDF processors to detect such changes and update their own attribute
//information accordingly, as described in this subclause.
//A structure element shall have a revision number, that shall be stored in the R entry in the structure
//element dictionary (see "Table 355 — Entries in a structure element dictionary") or default to 0 if no R
//entry is present. Initially, the revision number shall be 0. When a PDF processor modifies the structure
//element or any of its content items, it may signal the change by incrementing the revision number.
//NOTE 1 The revision number is unrelated to the generation number associated with an indirect object
//(see 7.3.10, "Indirect objects").
//NOTE 2 If there is no R entry and the revision number is to be incremented from the default value of 0 to
//1, an R entry will have to be created in the structure element dictionary in order to record the 1.
//Each attribute object attached to a structure element shall have an associated revision number. The
//revision number shall be stored in the array that associates the attribute object with the structure
//element or if not stored in the array that associates the attribute object with the structure element
//shall default to 0.
//Each attribute object in a structure element’s A array shall be represented by a single or a pair of array
//elements, the first or only element shall contain the attribute object itself and the second (when
//present) shall contain the integer revision number associated with it in this structure element.
//The structure element’s C array shall contain a single or a pair of elements for each attribute class, the
//first or only shall contain the class name and the second (when present) shall contain the associated
//revision number.
//The revision numbers are optional in both the A and C arrays. An attribute object or class name that is
//not followed by an integer array element shall have a revision number of 0 and is represented by a
//single entry in the array.
//NOTE 3 The revision number is not stored directly in the attribute object because a single attribute
//object can be associated with more than one structure element (whose revision numbers can
//differ). Since an attribute object reference is distinct from an integer, that distinction is used to
//determine whether the attribute object is represented in the array by a single or a pair of entries.
//NOTE 4 When an attribute object is created or modified, its revision number is set to the current value of
//the structure element’s R entry. By comparing the attribute object’s revision number with that of
//the structure element, an application can determine whether the contents of the attribute object
//are still current or whether they have been outdated by more recent changes in the underlying
//structure element.
//Changes in an attribute object shall not change the revision number of the associated structure
//element, which shall change only when the structure element itself or any of its content items is
//modified.
//Occasionally, a PDF processor may make extensive changes to a structure element that are likely to
//invalidate all previous attribute information associated with it. In this case, instead of incrementing the
//© ISO 2020 – All rights reserved 739
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//structure element’s revision number, the PDF processor may choose to delete all unknown attribute
//objects from its A and C arrays. These two actions shall be mutually exclusive: the PDF processor
//should either increment the structure element’s revision number or remove its attribute objects, but it
//shall not do both.
//NOTE 5 Any PDF processor creating attribute objects needs to be prepared for the possibility that they
//can be deleted at any time by another PDF processor.
//14.7.6.4 User properties
//Most structure attributes (see 14.8.5, "Standard structure attributes") specify information that is
//reflected in the element’s appearance; for example, BackgroundColor or BorderStyle.
//Some PDF writers, such as CAD applications, may use objects that have a standardized appearance,
//each of which contains non-graphical information that distinguishes the objects from one another. For
//example, several transistors might have the same appearance but different attributes such as type and
//part number.
//User properties (PDF 1.6) may be used to contain such information. Any graphical object that
//corresponds to a structure element may have associated user properties, specified by means of an
//attribute object dictionary that shall have a value of UserProperties for the O entry (see "Table 361 —
//Additional entries in an attribute object dictionary for user properties").
//Table 361 — Additional entries in an attribute object dictionary for user properties
//Key Type Value
//O name (Required) The attribute owner. Shall be UserProperties.
//P array (Required) An array of dictionaries, each of which represents a user property (see
//"Table 362 — Entries in a user property dictionary").
//The P entry shall be an array specifying the user properties. Each element in the array shall be a user
//property dictionary representing an individual property (see "Table 362 — Entries in a user property
//dictionary").
//Table 362 — Entries in a user property dictionary
//Key Type Value
//N text string (Required) The name of the user property.
//V any (Required) The value of the user property.
//While the value of this entry shall be any type of PDF object, PDF writers should use
//only text string, number, and boolean values. PDF processors should display text,
//number and boolean values to users but need not display values of other types;
//however, they should not treat other values as errors.
//F text string (Optional) A formatted representation of the value of V, that shall be used for
//special formatting; for example "($123.45)" for the number -123.45. If this entry is
//absent, PDF processors should use a default format.
//740 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//H boolean (Optional) If true, the attribute shall be hidden; that is, it shall not be shown in any
//user interface element that presents the attributes of an object. Default value: false.
//PDF documents that contain user properties shall provide a UserProperties entry with a value of true
//in the document’s mark information dictionary (see "Table 353 — Entries in the mark information
//dictionary". This entry allows PDF processors to quickly determine whether it is necessary to search
//the structure tree for elements containing user properties.
//EXAMPLE The following example shows a structure element containing user properties called Part Name, Part
//Number, Supplier, and Price.
//100 0 obj
//<</Type /StructElem
///S /Figure %Structure type
///P 50 0 R %Parent in structure tree
///A << /O /UserProperties %Attribute object
///P [ %Array of user properties
//<</N (Part Name) /V (Framostat) >>
//<</N (Part Number) /V 11603 >>
//<</N (Supplier) /V (Just Framostats) /H true >> %Hidden attribute
//<</N (Price) /V -37.99 /F ($37.99) >> %Formatted value
//]
//>>
//>>
//endobj
//14.7.7 Example of logical structure
//The Example shows portions of a PDF file with a simple document structure. The structure tree root
//(object 300) contains elements with structure types Chap (object 301) and Para (object 304). The
//Chap element, titled Chapter 1, contains elements with types Head1 (object 302) and Para (object
//303).
//These elements are mapped to the standard structure types specified in tagged PDF (see 14.8.4,
//"Standard structure types") by means of the role map specified in the structure tree root. Objects 302
//through 304 have attached attributes (see 14.7.6, "Structure attributes" and 14.8.5, "Standard
//structure attributes").
//The example in this subclause also illustrates the structure of a parent tree (object 400) that maps
//content items back to their parent structure elements and an ID tree (object 403) that maps element
//identifiers to the structure elements they denote.
//EXAMPLE
//1 0 obj %Document catalog
//<</Type /Catalog
///Pages 100 0 R %Page tree
///StructTreeRoot 300 0 R %Structure tree root
//>>
//endobj
//100 0 obj %Page tree
//<</Type /Pages
///Kids [101 1 R %First page object
//© ISO 2020 – All rights reserved 741
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//102 0 R %Second page object
//]
///Count 2 %Page count
//>>
//endobj
//101 1 obj %First page object
//<</Type /Page
///Parent 100 0 R %Parent is the page tree
///Resources <</Font <</F1 6 0 R %Font resources
///F12 7 0 R
//>>
//>>
///MediaBox [0 0 612 792] %Media box
///Contents 201 0 R %Content stream
///StructParents 0 %Parent tree key
//>>
//endobj
//201 0 obj %Content stream for first page
//<</Length …>>
//stream
//1 1 1 rg
//0 0 612 792 re f
//BT %Start of text object
///Span <</MCID 0>> %Start of marked-content sequence 0
//BDC
//0 0 0 rg
///F1 1 Tf
//30 0 0 30 18 732 Tm
//(This is a first level heading. Hello world: ) Tj
//1.1333 TL T*
//(goodbye universe.) Tj
//EMC %End of marked-content sequence 0
///Span <</MCID 1>> %Start of marked-content sequence1
//BDC
///F12 1 Tf
//14 0 0 14 18 660.8 Tm
//(This is the first paragraph, which spans pages. It has four fairly short and \
//concise sentences. This is the next to last ) Tj
//EMC %End of marked-content sequence 1
//ET %End of text object
//endstream
//endobj
//102 0 obj %Second page object
//<</Type /Page
///Parent 100 0 R %Parent is the page tree
///Resources <</Font <</F1 6 0 R %Font resources
///F12 7 0 R
//>>
//>>
///MediaBox [0 0 612 792] %Media box
///Contents 202 0 R %Content stream
///StructParents 1 %Parent tree key
//742 >>
//endobj
//202 0 obj %Content stream for second page
//<</Length …>>
//stream
//1 1 1 rg
//0 0 612 792 re f
//BT %Start of text object
///Para <</MCID 0>> %Start of marked-content sequence 0
//© ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//BDC
//0 0 0 rg
///F12 1 Tf
//14 0 0 14 18 732 Tm
//(sentence. This is the very last sentence of the first paragraph.) Tj
//EMC %End of marked-content sequence 0
///Span <</MCID 1>> %Start of marked-content sequence 1
//BDC
///F12 1 Tf
//14 0 0 14 18 570.8 Tm
//( This is the second paragraph. It has four fairly short and concise sentences
//. \ This is the next to last ) Tj
//EMC %End of marked-content sequence 1
///Span <</MCID 2>> %Start of marked-content sequence 2
//BDC
//1.1429 TL
//T*
//(sentence. This is the very last sentence of the second paragraph.) Tj
//EMC %End of marked-content sequence 2
//ET %End of text object
//endstream
//endobj
//300 0 obj %Structure tree root
//<</Type /StructTreeRoot
///K [301 0 R %Two children: a chapter
//304 0 R %and a paragraph
//]
///RoleMap <</Chap /Sect %Mapping to standard structure types
///Head1 /H
///Para /P
//>>
///ClassMap <</Normal 305 0 R>> %Class map containing one attribute class
///ParentTree 400 0 R %Number tree for parent elements
///ParentTreeNextKey 2 %Next key to use in parent tree
///IDTree 403 0 R %Name tree for element identifiers
//>>
//endobj
//301 0 obj %Structure element for a chapter
//<</Type /StructElem
///S /Chap
///ID (Chap1) %Element identifier
///T (Chapter 1) %Human-readable title
///P 300 0 R %Parent is the structure tree root
///K [302 0 R %Two children: a section head
//303 0 R %and a paragraph
//]
//>>
//endobj
//302 0 obj %Structure element for a section head
//<</Type /StructElem
///S /Head1
///ID (Sec1.1) %Element identifier
///T (Section 1.1) %Human-readable title
///P 301 0 R %Parent is the chapter
///Pg 101 1 R %Page containing content items
///A <</O /Layout %Attribute owned by Layout
///SpaceAfter 25
///SpaceBefore 0
//© ISO 2020 – All rights reserved 743
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
///TextIndent 12.5
//>>
///K 0 %Marked-content sequence 0
//>>
//endobj
//303 0 obj %Structure element for a paragraph
//<</Type /StructElem
///S /Para
///ID (Para1) %Element identifier
///P 301 0 R %Parent is the chapter
///Pg 101 1 R %Page containing first content item
///C /Normal %Class containing this element’s attributes
///K [1 %Marked-content sequence 1
//<</Type /MCR %Marked-content reference to 2nd item
///Pg 102 0 R %Page containing second item
///MCID 0 %Marked-content sequence 0
//>>
//]
//>>
//endobj
//304 0 obj %Structure element for another paragraph
//<< /Type /StructElem
///S /Para
///P 300 0 R %Parent is the structure tree root
///Pg 102 0 R %Page containing content items
///C /Normal %Class containing this element’s attributes
///A << /O /Layout
///TextAlign /Justify %Overrides attribute provided by classmap
//>>
///K [1 2] %Marked-content sequences 1 and 2
//>>
//endobj
//305 0 obj %Attribute class
//<< /O /Layout %Owned by Layout
///EndIndent 0
///StartIndent 0
///WritingMode /LrTb
///TextAlign /Start
//>>
//endobj
//400 0 obj %Parent tree (number tree)
//<</Nums [0 401 0 R %Parent elements for first page
//1 402 0 R %Parent elements for second page
//]
//>>
//endobj
//401 0 obj %Array of parent elements for first page
//[302 0 R %Parent of marked-content sequence 0
//303 0 R %Parent of marked-content sequence 1
//]
//endobj
//402 0 obj %Array of parent elements for second page
//[303 0 R %Parent of marked-content sequence 0
//304 0 R %Parent of marked-content sequence 1
//304 0 R %Parent of marked-content sequence 2
//]
//endobj
//403 0 obj %ID tree root node
//<</Kids [404 0 R]>> %Reference to leaf node
//endobj
//744 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//404 0 obj %ID tree leaf node
//<</Limits [(Chap1) (Sec1.3)] %Least and greatest keys in tree
///Names [(Chap1) 301 0 R %Mapping from element identifiers
//(Sec1.1) 302 0 R %to structure elements
//(Sec1.2) 303 0 R
//(Sec1.3) 304 0 R
//]
//>>
//endobj

