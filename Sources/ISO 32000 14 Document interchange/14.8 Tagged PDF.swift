// ISO 32000-2:2020, 14.8 Tagged PDF
//
// Sections:
//   14.8.1  General
//   14.8.2  Tagged PDF and page content
//   14.8.3  Tagged PDF and structure tree
//   14.8.4  Standard structure types
//   14.8.5  Standard structure attributes
//   14.8.6  Standard structure namespaces

public import ISO_32000_7_Syntax
public import ISO_32000_Shared
public import Standards

// MARK: - 14.8 Tagged PDF

extension ISO_32000.`14` {
    /// ISO 32000-2:2020, 14.8 Tagged PDF
    public enum `8` {}
}

// MARK: - 14.8.4 Standard structure types

extension ISO_32000.`14`.`8` {
    /// ISO 32000-2:2020, 14.8.4 Standard structure types
    public enum `4` {}
}

// MARK: - 14.8.4.8 Other structure types

extension ISO_32000.`14`.`8`.`4` {
    /// ISO 32000-2:2020, 14.8.4.8 Other structure types
    public enum `8` {}
}

// MARK: - 14.8.4.8.3 Table structure types

extension ISO_32000.`14`.`8`.`4`.`8` {
    /// ISO 32000-2:2020, 14.8.4.8.3 Table structure types
    public enum `3` {}
}

// MARK: - Table 371 — Table standard structure types

extension ISO_32000.`14`.`8`.`4`.`8`.`3` {
    /// Table 371 — Table
    ///
    /// A two-dimensional logical structure of cells, possibly including a complex substructure.
    /// If a Caption is present, it shall be either the first or last child of the Table structure element.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 371 — Table standard structure types
    public struct Table: Sendable, Hashable {
        /// Summary attribute (Table 384) — table's purpose for accessibility
        ///
        /// For use in non-visual rendering such as speech or braille.
        public var summary: String?

        public init(summary: String? = nil) {
            self.summary = summary
        }
    }

    /// Table 371 — TR
    ///
    /// A row of table header cells (TH) or table data cells (TD) in a table.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 371 — Table standard structure types
    public struct TR: Sendable, Hashable {
        public init() {}
    }

    /// Table 371 — TH
    ///
    /// A table header cell containing content describing one or more rows, columns,
    /// or rows and columns of the table.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 371 — Table standard structure types
    public struct TH: Sendable, Hashable {
        /// Row attributes (Table 384)
        public var row: Row
        /// Col attributes (Table 384)
        public var col: Col
        /// Headers (Table 384) — IDs of associated header cells
        public var headers: [String]
        /// Scope (Table 384) — Row, Column, or Both (nil = implicit)
        public var scope: Scope?
        /// Short (Table 384, PDF 2.0) — short form of header content
        public var short: String?

        public init(
            row: Row = Row(),
            col: Col = Col(),
            headers: [String] = [],
            scope: Scope? = nil,
            short: String? = nil
        ) {
            self.row = row
            self.col = col
            self.headers = headers
            self.scope = scope
            self.short = short
        }
    }

    /// Table 371 — TD
    ///
    /// A table cell containing content that is part of the table's content.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 371 — Table standard structure types
    public struct TD: Sendable, Hashable {
        /// Row attributes (Table 384)
        public var row: Row
        /// Col attributes (Table 384)
        public var col: Col
        /// Headers (Table 384) — IDs of associated header cells
        public var headers: [String]

        public init(
            row: Row = Row(),
            col: Col = Col(),
            headers: [String] = []
        ) {
            self.row = row
            self.col = col
            self.headers = headers
        }
    }

    /// Table 371 — THead
    ///
    /// (Optional) A group of TR structure elements that constitute the header of a table.
    /// The THead structure element is optional insofar as when rows of header cells are
    /// present they may, but are not required to be, so enclosed.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 371 — Table standard structure types
    public struct THead: Sendable, Hashable {
        public init() {}
    }

    /// Table 371 — TBody
    ///
    /// (Optional) A group of TR structure elements that constitute the main body portion of a table.
    /// The TBody structure element is optional insofar as when rows of cells are present
    /// they may, but are not required to be, so enclosed.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 371 — Table standard structure types
    public struct TBody: Sendable, Hashable {
        public init() {}
    }

    /// Table 371 — TFoot
    ///
    /// (Optional) A group of TR structure elements that constitute the footer of a table.
    /// The TFoot structure element is optional insofar as when rows of cells belonging
    /// to footer row(s) are present they may, but are not required to be, so enclosed.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 371 — Table standard structure types
    public struct TFoot: Sendable, Hashable {
        public init() {}
    }
}

// MARK: - TH Nested Types

extension ISO_32000.`14`.`8`.`4`.`8`.`3`.TH {
    /// Table 384 — Scope attribute values
    ///
    /// Row, Column, or Both. When absent, scope is determined implicitly
    /// by the algorithm in 14.8.4.8.3.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 384 — Standard table attributes
    public enum Scope: String, Sendable, Codable, Hashable, CaseIterable {
        case row = "Row"
        case column = "Column"
        case both = "Both"
    }

    /// Row attributes for TH (Table 384)
    public struct Row: Sendable, Hashable {
        /// RowSpan — rows spanned (default: 1)
        public var span: Int

        public init(span: Int = 1) {
            self.span = span
        }
    }

    /// Col attributes for TH (Table 384)
    public struct Col: Sendable, Hashable {
        /// ColSpan — columns spanned (default: 1)
        public var span: Int

        public init(span: Int = 1) {
            self.span = span
        }
    }
}

// MARK: - TD Nested Types

extension ISO_32000.`14`.`8`.`4`.`8`.`3`.TD {
    /// Row attributes for TD (Table 384)
    public struct Row: Sendable, Hashable {
        /// RowSpan — rows spanned (default: 1)
        public var span: Int

        public init(span: Int = 1) {
            self.span = span
        }
    }

    /// Col attributes for TD (Table 384)
    public struct Col: Sendable, Hashable {
        /// ColSpan — columns spanned (default: 1)
        public var span: Int

        public init(span: Int = 1) {
            self.span = span
        }
    }
}

// MARK: - 14.8.4.8.4 Caption structure type

extension ISO_32000.`14`.`8`.`4`.`8` {
    /// ISO 32000-2:2020, 14.8.4.8.4 Caption structure type
    public enum `4` {}
}

extension ISO_32000.`14`.`8`.`4`.`8`.`4` {
    /// Table 372 — Caption
    ///
    /// Content serving as a caption for tables, lists, images, formulas, media objects,
    /// or other types of content.
    ///
    /// For lists and tables a Caption structure element may be used as defined for the
    /// L (list) and Table structure elements. A Caption may be used for a structure element
    /// or several structure elements.
    ///
    /// A structure element is understood to be "captioned" when a Caption structure element
    /// exists as an immediate child of that structure element. The Caption shall be the first
    /// or the last structure element inside its parent structure element.
    /// The number of captions cannot exceed 1.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 372 — Standard structure type Caption
    public struct Caption: Sendable, Hashable {
        public init() {}
    }
}

// MARK: - Binary.Serializable Conformance

extension ISO_32000.`14`.`8`.`4`.`8`.`3`.Table: Binary.Serializable {
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ table: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        var dict: ISO_32000.`7`.`3`.COS.Dictionary = [
            .s: .name(.table)
        ]
        if let summary = table.summary {
            dict[.summary] = .string(ISO_32000.`7`.`3`.COS.StringValue(summary))
        }
        ISO_32000.`7`.`3`.COS.Dictionary.serialize(dict, into: &buffer)
    }
}

extension ISO_32000.`14`.`8`.`4`.`8`.`3`.TR: Binary.Serializable {
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ tr: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        let dict: ISO_32000.`7`.`3`.COS.Dictionary = [
            .s: .name(.tr)
        ]
        ISO_32000.`7`.`3`.COS.Dictionary.serialize(dict, into: &buffer)
    }
}

extension ISO_32000.`14`.`8`.`4`.`8`.`3`.TH: Binary.Serializable {
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ th: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        var dict: ISO_32000.`7`.`3`.COS.Dictionary = [
            .s: .name(.th)
        ]
        if th.row.span != 1 {
            dict[.rowSpan] = .integer(Int64(th.row.span))
        }
        if th.col.span != 1 {
            dict[.colSpan] = .integer(Int64(th.col.span))
        }
        if !th.headers.isEmpty {
            dict[.headers] = .array(th.headers.map { .string(ISO_32000.`7`.`3`.COS.StringValue($0)) })
        }
        if let scope = th.scope {
            dict[.scope] = .name(scope.name)
        }
        if let short = th.short {
            dict[.short] = .string(ISO_32000.`7`.`3`.COS.StringValue(short))
        }
        ISO_32000.`7`.`3`.COS.Dictionary.serialize(dict, into: &buffer)
    }
}

extension ISO_32000.`14`.`8`.`4`.`8`.`3`.TH.Scope {
    /// The PDF Name for this scope value
    public var name: ISO_32000.`7`.`3`.`5`.Name {
        switch self {
        case .row: return .row
        case .column: return .column
        case .both: return .both
        }
    }
}

extension ISO_32000.`14`.`8`.`4`.`8`.`3`.TD: Binary.Serializable {
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ td: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        var dict: ISO_32000.`7`.`3`.COS.Dictionary = [
            .s: .name(.td)
        ]
        if td.row.span != 1 {
            dict[.rowSpan] = .integer(Int64(td.row.span))
        }
        if td.col.span != 1 {
            dict[.colSpan] = .integer(Int64(td.col.span))
        }
        if !td.headers.isEmpty {
            dict[.headers] = .array(td.headers.map { .string(ISO_32000.`7`.`3`.COS.StringValue($0)) })
        }
        ISO_32000.`7`.`3`.COS.Dictionary.serialize(dict, into: &buffer)
    }
}

extension ISO_32000.`14`.`8`.`4`.`8`.`3`.THead: Binary.Serializable {
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ thead: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        let dict: ISO_32000.`7`.`3`.COS.Dictionary = [
            .s: .name(.thead)
        ]
        ISO_32000.`7`.`3`.COS.Dictionary.serialize(dict, into: &buffer)
    }
}

extension ISO_32000.`14`.`8`.`4`.`8`.`3`.TBody: Binary.Serializable {
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ tbody: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        let dict: ISO_32000.`7`.`3`.COS.Dictionary = [
            .s: .name(.tbody)
        ]
        ISO_32000.`7`.`3`.COS.Dictionary.serialize(dict, into: &buffer)
    }
}

extension ISO_32000.`14`.`8`.`4`.`8`.`3`.TFoot: Binary.Serializable {
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ tfoot: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        let dict: ISO_32000.`7`.`3`.COS.Dictionary = [
            .s: .name(.tfoot)
        ]
        ISO_32000.`7`.`3`.COS.Dictionary.serialize(dict, into: &buffer)
    }
}

extension ISO_32000.`14`.`8`.`4`.`8`.`4`.Caption: Binary.Serializable {
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ caption: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        let dict: ISO_32000.`7`.`3`.COS.Dictionary = [
            .s: .name(.caption)
        ]
        ISO_32000.`7`.`3`.COS.Dictionary.serialize(dict, into: &buffer)
    }
}

//14.8 Tagged PDF
//14.8.1 General
//Tagged PDF (PDF 1.4) is a stylised use of PDF that builds on the logical structure framework described
//in 14.7, "Logical structure". It defines a set of standard structure types and attributes that allow page
//content (text, graphics and images, as well as annotations and form fields) to be extracted and reused
//for other purposes.
//A tagged PDF document is one that conforms to all rules described in all of the subclauses in 14.8,
//"Tagged PDF"
//.
//A tagged PDF document shall contain a mark information dictionary (see "Table 353 — Entries in the
//mark information dictionary") with a value of true for the Marked entry.
//NOTE Tagged PDF is intended for use by tools that perform operations such as:
//• Extraction of text and graphics for pasting into other applications
//• Automatic reflow of page contents – text as well as associated graphics and images or
//annotations and form fields – to fit a display area of a different size than was assumed for
//the original layout
//• Processing of content for such purposes as searching, indexing, and spell-checking
//• Conversion to other common file formats (such as HTML, XML, and RTF) with document
//structure preserved
//• Making content accessible to users with disabilities
//14.8.2 Tagged PDF and page content
//14.8.2.1 General
//Like all PDF documents, a tagged PDF document consists of a sequence of self-contained pages, each of
//which is described by one or more page content streams (including any subsidiary streams such as
//form XObjects), annotations and form fields. Tagged PDF defines some further rules for organising and
//marking content streams so that additional information may be derived from them:
//• Distinguishing between the author’s original content and artifacts of the layout process (see
//14.8.2.2, "Real content and Artifacts").
//• Specifying the content order as intended by the content author to guide the layout process if the
//PDF processor repurposes the page content (see 14.8.2.5, "Page content order and logical content
//order").
//• Guaranteeing that the logical order of content can be deterministically derived from a
//© ISO 2020 – All rights reserved 745
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//combination of logical structure and page content (see 14.8.2.5, "Page content order and logical
//content order").
//• Representing text in a form from which a Unicode representation may be unambiguously derived
//(see 14.8.2.6, "Unicode mapping in tagged PDF").
//• Representing word breaks unambiguously (see 14.8.2.6.2, "Identifying word breaks").
//• Marking all content with information for making it accessible to users with visual impairments or
//other disabilities (see 14.9, "Repurposing and accessibility support").
//14.8.2.2 Real content and Artifacts
//14.8.2.2.1 General
//The content in a document may be divided into two classes:
//• The real content of a document comprises graphics objects, annotations and form fields
//representing material intentionally introduced by the document’s author and necessary to
//understand the content of the document.
//• All other content is considered to be artifacts, whether generated by the PDF writer in the course
//of pagination, layout, or other mechanical processes or introduced by the document author for
//decoration or other purposes that are not relevant for understanding the content of the
//document.
//The document’s logical structure encompasses all real content and describes how real content objects
//relate to one another. Where artifacts are to be included in the structure tree, they shall be included
//through the Artifact structure element type, and shall not be considered real content.
//A document’s real content may include graphics objects in the page content stream and subsidiary
//XObjects and annotations, including widget annotations.
//NOTE 1 The above paragraph was clarified in this document (2020).
//To support PDF processors in providing accessibility to users with disabilities, tagged PDF documents
//should use the natural language specification (Lang), alternate description (Alt), replacement text
//(ActualText), and abbreviation expansion text (E) facilities as described in 14.9, "Repurposing and
//accessibility support"
//.
//NOTE 2 ISO 14289 (PDF/UA) specifies the use of tagged PDF to accommodate the needs of users with
//disabilities.
//Tagged PDF processors may make various choices about what page content to consider relevant in a
//tagged PDF document. A text-to-speech engine, for instance, may decide not to speak running heads or
//page numbers when the page is turned. In general, PDF processors may do any of the following:
//• Disregard elements of page content (for example, skip Link annotations) that are not of interest
//• Treat some page elements as terminals that are not to be examined further (for example, to treat
//an illustration as a unit for repurposing)
//• Substitute an element with its alternative description (see 14.9.3, "Alternate descriptions")
//NOTE 3 Depending on their goals, different PDF processors can make different decisions in this regard.
//The purpose of tagged PDF is not to prescribe what the PDF processor does, but to provide
//sufficient declarative and descriptive information to allow it to make appropriate choices about
//how to process the content.
//746 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//14.8.2.2.2 Specification of Artifacts
//For tagged PDF files, an artifact should be explicitly distinguished from real content through either of
//the following methods:
//• By enclosing it in a marked-content sequence with the tag Artifact:
//EXAMPLE 1
///Artifact BMC
//EMC
//EXAMPLE 2 (marked-content sequence Artifact with a property list entry)
///Artifact <<propertyList>> BDC
//EMC
//• By inclusion in the logical structure tree through the use of the Artifact structure element type
//(see "Table 375 — standard structure type Artifact").
//NOTE 1 The purpose of the Artifact structure element type is to accommodate artifact content in cases
//that have positional context relative to real content within the structure tree. An example of such
//content is line numbers.
//For artifacts defined using the marked-content sequence method, the form indicated in EXAMPLE 1
//shall be used to identify a generic artifact; the form indicated in EXAMPLE 2 shall be used for those
//artifacts that have an associated property list. "Table 363 — Property list entries for artifacts" shows
//the properties that may be included in such a property list.
//Any content that is not included in the structure tree is an artifact even when not enclosed in a marked-
//content sequence using the tag Artifact.
//NOTE 2 The phrase “any content” above refers to all page content as well as annotations.
//Table 363 — Property list entries for artifacts
//Key Type Value
//Type name (Optional) The type of artifact that this property list describes; if present, shall be
//one of the names Pagination, Layout, Page or Background.
//• Pagination artifacts are ancillary page features such as running heads, folios (page
//numbers) or Bates Numbering.
//• Layout artifacts are purely cosmetic typographical or design elements such as
//footnote rules or decorative ornaments.
//• Page artifacts are production aids extraneous to the document itself, such as cut
//marks and colour bars.
//• Background artifacts can occur from document templates that are often repeated
//unchanged across many pages and include images, patterns or coloured blocks that
//either run the entire length and/or width of the page or the entire dimensions of a
//structural element.
//BBox rectangle (Optional) An array of four numbers in default user space units giving the
//coordinates of the left, bottom, right, and top edges, respectively, of the artifact’s
//bounding box (the rectangle that completely encloses its visible extent).
//© ISO 2020 – All rights reserved 747
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//Attached array (Optional; pagination and full-page background artifacts only) An
//array of name objects containing one to four of the names Top,
//Bottom, Left, and Right, specifying the edges of the page, if any, to
//which the artifact is logically attached. Page edges shall be defined
//by the page’s crop box (see 14.11.2, "Page boundaries"). The
//ordering of names within the array is immaterial. Including both
//Left and Right or both Top and Bottom indicates a full-width or full
//height artifact, respectively.
//Use of this entry for background artifacts shall be limited to full-
//page artifacts. Background artifacts that are not full-page take their
//dimensions from their parent structural element.
//NOTE (2020) The Attached key was accidently omitted from
//the earlier PDF 2.0 specification and was reinstated in
//this document.
//Subtype name (Optional; PDF 1.7) The subtype of the artifact. This entry should appear only
//when the Type entry has a value of Pagination. Valid values are Header, Footer,
//Watermark, PageNum (PDF 2.0), LineNum (PDF 2.0), Redaction (PDF 2.0) and
//Bates (PDF 2.0). Additional values may be specified for this entry, provided they
//comply with the naming conventions described in Annex E, "Extending PDF".
//Some properties defined elsewhere may also be used as entries in the property list of an artifact,
//including Alt (see 14.9.3, "Alternate descriptions"), ActualText (see 14.9.4, "Replacement text"), E (see
//14.9.5, "Expansion of abbreviations and acronyms") or Lang (see 14.9.2, "Natural language
//specification").
//Where it is necessary to represent the content of an artifact as text, the property ActualText can be
//used, for instance, to contain the page number for an artifact with a Subtype of PageNum or the Bates
//number for an artifact of subtype Bates.
//NOTE 3 Bates numbering is used in the legal, medical, and business fields in some countries to place
//identifying numbers and/or date/time-marks on images and documents. For example, it is added
//during the discovery stage of preparations for trial or when identifying business receipts. This
//process provides identification, protection, and automatic consecutive numbering.
//14.8.2.3 Soft hyphens
//In tagged PDF, the visible hyphen that is introduced through the incidental division of a word at the
//end of a line but which would not be present otherwise, may be represented as a soft hyphen, mapped
//to the Unicode value U+00AD, in one of the ways described in 14.8.2.6, "Unicode mapping in tagged
//PDF"
//.
//NOTE 1 The soft hyphen character represented by the Unicode value U+00AD is distinct from an
//ordinary hard hyphen, whose Unicode value is U+002D.
//The writer of a tagged PDF document shall distinguish explicitly between soft and hard hyphens so that
//a PDF processor can unambiguously determine which type a given character represents.
//748 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//NOTE 2 In some languages, the situation is more complicated: there can be multiple characters affected
//by hyphenation, and hyphenation can change the spelling of words. See the Example in 14.9.4,
//"Replacement text"
//.
//14.8.2.4 Hidden or invisible page content
//For a variety of reasons, elements of a document’s real content can be invisible on the page: they can be
//clipped; their colour can match the background; or they can be obscured by other, overlapping objects.
//For the purposes of tagged PDF, page content shall be considered to include all graphics objects in their
//entirety, regardless of whether they are visible when the document is displayed or printed.
//NOTE For example, invisible elements can become visible when content is repurposed, or a text-to-
//speech engine could choose to speak invisible text.
//14.8.2.5 Page content order and logical content order
//14.8.2.5.1 General
//Page content order shall be defined by the sequencing of graphics objects within a page’s content
//stream.
//Logical content order – the ordering for semantic purposes – shall be defined by a depth-first traversal
//of the document’s logical structure hierarchy.
//The page content order in a tagged PDF should coincide with the logical content order.
//NOTE 1 Page content order is constrained by the need to render objects in an order that produces the
//desired visual appearance. Logical content order is constrained by the need to reflect the order
//of the content as intended by its author. For example, the running text of a page, as encoded in
//the page’s content stream, can contain places where it is not possible to make the order in which
//the text progresses match the logical content order.
//Content within a single marked-content sequence (see 14.6,
//"Marked content") shall be in logical
//content order for that item of content.
//NOTE 2 Both in terms of how page content is encoded in a tagged PDF as well as in terms of how a PDF
//processor can process that content, efficiency can be impacted if the page content order and
//logical content order sequences do not coincide. In some cases it is not feasible to make the
//sequences coincide:
//• Regarding the sequence of page objects within a given page, page objects can visually
//overlap in a way that requires reverse ordering.
//• A logical object can extend over more than one PDF page, such as in the case of a headline
//spanning two pages in a facing pages layout.
//• A page can contain the beginnings of two separate articles, each of which is continued onto
//a later page of the document. In logical content order terms, the last words of the first
//article appearing on the page are not followed by the first words of the second article on the
//same page, but rather by the continuation of the first article on a different page.
//NOTE 3 Artifacts not contained within an Artifact structure element are not considered part of the
//logical content order because only structure elements are part of the logical content order.
//© ISO 2020 – All rights reserved 749
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//14.8.2.5.2 Sequencing of annotations
//Annotations associated with a page are not interleaved within the page’s content stream but are listed
//in the Annots array in its page object (see 7.7.3.3,
//"Page objects"). The position of an annotation in the
//logical content order is determined from the document’s logical structure.
//Both page content (marked-content sequences) and annotations may be treated as content items that
//are referenced from structure elements (see 14.7.5, "Structure content"). Structure elements of type
//Annot, Link, or Form (see 14.8.4.7, "Inline level structure types") explicitly specify the association
//between a marked-content sequence and a corresponding annotation through an object reference
//dictionary as described in 14.7.5.3, "PDF objects as content items"
//.
//14.8.2.5.3 Reverse-order show strings
//The marked-content tag ReversedChars informs the PDF processor that show strings within a
//marked-content sequence contain characters in reverse order. In order for such text to be extracted or
//read out aloud, the sequence of the characters as found in the show string operator shall be reversed
//before using them. If the sequence encompasses multiple show strings, only the individual characters
//within each string shall be reversed.
//NOTE 1 In writing systems that are read from right to left (such as Arabic or Hebrew), one expects that
//the glyphs in a font would have their origins at the lower right and their widths (rightward
//horizontal displacements) specified as negative. For various technical and historical reasons,
//however, many such fonts follow the same conventions as those designed for Western writing
//systems, with glyph origins at the lower left and positive widths, as shown in "Figure 54 — Glyph
//metrics". Consequently, showing text in such right-to-left writing systems requires either
//positioning each glyph individually (which is tedious and costly) or representing text with show
//strings (see 9.2, "Organisation and use of fonts") whose character codes are given in reverse
//order.
//The show strings in a ReversedChars block may have a SPACE (U+0020) character or other white-
//space characters at the beginning or end to indicate a word break (see 14.8.2.6.2, "Identifying word
//breaks") but shall not contain interior SPACE characters or other white-space characters.
//NOTE 2 This limitation is not serious, since a SPACE or other white-space character typically provides an
//opportunity to realign the typography without visible effect, and it serves the valuable purpose
//of limiting the scope of reversals for word-processing interactive PDF processors.
//EXAMPLE The sequence
///ReversedChars
//BMC
//( olleH) Tj
//-200 0 Td
//( .dlrow) Tj
//EMC
//represents the text
//Hello world.
//750 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//14.8.2.6 Unicode mapping in tagged PDF
//14.8.2.6.1 General
//PDF documents conforming with 14.8,
//"Tagged PDF" should map every character code in any of the
//content streams or appearance streams of a document to a corresponding Unicode value. Every
//character code that belongs to a structure element in the structure tree shall map to Unicode, except
//where an associated Alt or ActualText entry applies to the content to which the character code
//belongs.
//NOTE 1 These Unicode values can then be used for such operations as copy-and-paste, searching, text-to-
//speech conversion, and exporting to other applications or file formats.
//NOTE 2 Unicode defines scalar values for most of the characters used in the world’s languages and
//writing systems, as well as providing a private use area for application-specific characters.
//Information about Unicode can be found in the Unicode Standard.
//The methods for mapping a character code to a Unicode value are described in 9.10.2, "Mapping
//character codes to Unicode values"
//.
//Private Use Area Unicode values should only be used if no other Unicode value is available, as no pre-
//defined meaning is associated with the Unicode values in the Private Use Area.
//NOTE 3 An Alt, ActualText, or E entry specified in a structure element dictionary or a marked-content
//property list (see 14.9.3, "Alternate descriptions" 14.9.4, "Replacement text" and 14.9.5,
//"Expansion of abbreviations and acronyms") can affect the character stream used by PDF
//processors. For example, some PDF processors could choose to use the Alt or ActualText entry
//and ignore all text and other content associated with the structure element and its descendants.
//In some cases a required character may not be available in a given font, for example the soft hyphen
//character. Such a character may be represented either by adding it to the font’s encoding or CMap and
//using ToUnicode to map it to the appropriate Unicode value, or by using an ActualText entry in the
//associated structure element to provide substitute characters.
//14.8.2.6.2 Identifying word breaks
//A document’s text content defines not only the characters in a page’s text but also the words. Unlike a
//character, which is defined unambiguously, a word is defined by script and context. A repurposing tool
//needs to determine where it can break the running text into lines; a text-to-speech engine needs to
//identify the words to be vocalised; spelling checkers and other applications have varying definitions
//for what constitutes a word. It is not important for a tagged PDF document to identify the words within
//the text stream according to a single, unambiguous definition that satisfies all of these clients. What is
//important is that there be enough information available for each client to make that determination for
//itself.
//A PDF processor of a tagged PDF document may find words by sequentially examining the Unicode
//character stream, as augmented by replacement text specified with ActualText (see 14.9.4,
//"Replacement text").
//For this purpose any white-space characters that would be present to separate words in a pure text
//representation shall be present in the tagged PDF representation of the text.
//© ISO 2020 – All rights reserved 751
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//NOTE 1 As a consequence, the PDF processor can determine word breaks without having to rely on
//heuristics based on information such as glyph positioning on the page, font changes, or glyph
//sizes.
//The identification of what constitutes a word shall be unrelated to how the text happens to be grouped
//into show strings. The division into show strings shall have no semantic significance. In particular, a
//SPACE (U+0020) or other word-breaking character shall be present in a character stream even if a
//word break happens to fall at the end of a show string.
//NOTE 2 Some PDF processors identify words by simply separating them at every SPACE character.
//Others can be slightly more sophisticated and treat punctuation marks such as hyphens or Em
//dashes as word separators as well. Still others can identify line-break opportunities by using an
//algorithm similar to the one in Unicode Standard Annex #29, Unicode Text Segmentation.
//14.8.3 Basic layout model
//14.8.3.1 General
//Tagged PDF’s standard structure types and attributes can be interpreted in the context of a basic
//layout model that describes the arrangement of structure elements on the page. This model is designed
//to capture the general intent of the document’s underlying structure and does not necessarily
//correspond to the one actually used for page layout by the application creating the document (the PDF
//content stream specifies the exact appearance).
//NOTE 1 The goal is to provide sufficient information for PDF processors to make their own layout
//decisions while preserving the authoring application’s intent as closely as their own layout
//models allow.
//NOTE 2 The tagged PDF layout model resembles the ones used in markup languages such as HTML, XML,
//and RTF, but does not correspond exactly to any of them. The model is deliberately defined
//loosely to allow reasonable latitude in the interpretation of structure elements and attributes
//when converting to other document formats. Some degree of variation in the resulting layout
//from one format to another is to be expected.
//14.8.3.2 Reference area
//The basic layout model begins with the notion of a reference area. This is a rectangular region used as a
//frame or guide in which to place the document’s content. Some of the standard structure attributes,
//such as StartIndent and EndIndent (see 14.8.5.4.3, "Layout Attributes for BLSEs"), shall be measured
//from the boundaries of the reference area. Reference areas are not specified explicitly but are inferred
//from context. Those of interest are generally the column area or areas in a general text layout, the
//outer bounding box of a table and those of its component cells, and the bounding box of a Figure, Form
//or Formula, or other floating element.
//The standard structure types can be divided into four main categories according to the roles they play
//in page layout:
//• Grouping elements (see 14.8.4.4, "Grouping level structure types") group other elements into
//sequences or hierarchies but hold no content directly and have no direct effect on layout.
//• Block-level structure elements (BLSEs) (see 14.8.4.5, "Block level structure types") describe the
//overall layout of content on the page, proceeding in the block-progression direction.
//• Inline-level structure elements (ILSEs) (see 14.8.4.7, "Inline level structure types") describe the
//layout of content within a BLSE, proceeding in the inline-progression direction.
//752 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//• Some elements can be grouping elements, BLSEs or ILSEs, depending on context or usage. For
//example, a Figure structure element can be treated as either a grouping element, a BLSE or an
//ILSE.
//14.8.3.3 Progression direction
//The meaning of the terms block-progression direction and inline-progression direction depends on the
//writing system in use, as specified by the standard attribute WritingMode (see 14.8.5.4.2, "General
//Layout Attributes"). In Western writing systems, the block direction is from top to bottom and the
//inline direction is from left to right. Other writing systems use different directions for laying out
//content.
//Because the progression directions can vary depending on the writing system, edges of areas and
//directions on the page are identified by terms that are neutral with respect to the progression order
//rather than by familiar terms such as up, down, left, and right. Block layout proceeds from before to
//after, inline from start to end. Thus, for example, in Western writing systems, the before and after
//edges of a reference area are at the top and bottom, respectively, and the start and end edges are at the
//left and right. Another term, shift direction (the direction of shift for a superscript), refers to the
//direction opposite that for block progression — that is, from after to before (in Western writing
//systems, from bottom to top).
//BLSEs shall be stacked within a reference area in block-progression order. In general, the first BLSE
//shall be placed against the before edge of the reference area. Subsequent BLSEs shall be stacked
//against preceding ones, progressing toward the after edge, until no more BLSEs fit in the reference
//area. If the overflowing BLSE allows itself to be split — such as a paragraph that can be split between
//lines of text — a portion of it may be included in the current reference area and the remainder carried
//over to a subsequent reference area (either elsewhere on the same page or on another page of the
//document). Once the amount of content that fits in a reference area is determined, the placements of
//the individual BLSEs may be adjusted to bias the placement toward the before edge, the middle, or the
//after edge of the reference area, or the spacing within or between BLSEs may be adjusted to fill the full
//extent of the reference area.
//BLSEs may be nested, with child BLSEs stacked within a parent BLSE in the same manner as BLSEs
//within a reference area. Except in a few instances noted (the BlockAlign and InlineAlign elements),
//such nesting of BLSEs does not result in the nesting of reference areas; a single reference area prevails
//for all levels of nested BLSEs.
//Within a BLSE, child ILSEs shall be packed into lines. Direct content items — those that are immediate
//children of a BLSE rather than contained within a child ILSE — shall be implicitly treated as ILSEs for
//packing purposes. Each line shall be treated as a synthesized BLSE and shall be stacked within the
//parent BLSE. Lines may be intermingled with other BLSEs within the parent area. This line-building
//process is analogous to the stacking of BLSEs within a reference area, except that it proceeds in the
//inline-progression rather than the block-progression direction: a line shall be packed with ILSEs
//beginning at the start edge of the containing BLSE and continuing until the end edge shall be reached
//and the line is full. The overflowing ILSE may allow itself to be broken at linguistically determined or
//explicitly marked break points (such as hyphenation points within a word), and the remaining
//fragment shall be carried over to the next line.
//© ISO 2020 – All rights reserved 753
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Certain values of an element’s Placement attribute remove the element from the normal stacking or
//packing process and allow it instead to float to a specified edge of the enclosing reference area or
//parent BLSE; see "General Layout Attributes" in 14.8.5.4, "Layout Attributes" for further discussion.
//Two enclosing rectangles shall be associated with each BLSE and ILSE (including direct content items
//that are treated implicitly as ILSEs):
//• The content rectangle shall be derived from the shape of the enclosed content and defines the
//bounds used for the layout of any included child elements.
//• The allocation rectangle includes any additional borders or spacing surrounding the element,
//affecting how it shall be positioned with respect to adjacent elements and the enclosing content
//rectangle or reference area.
//The definitions of these rectangles shall be determined by layout attributes associated with the
//structure element; see 14.8.5.4.5, "Content and Allocation Rectangles" for further discussion.
//14.8.4 Standard structure types
//14.8.4.1 General
//Standard structure types are divided into categories:
//• "Document level structure types" identify a whole document or a fragment of a document. In most
//cases a tagged PDF will contain exactly one document, but in some other cases a tagged PDF
//contains several documents that have been merged together into one PDF file, or the tagged PDF
//is a document containing document fragments which have been inserted into the document.
//• "Grouping level structure types" make it possible to organise the overall structure of content in a
//tagged PDF. For example, a book typically consists of chapters, or a newspaper page consists of
//several parts called articles, and a scientific publication typically contains sections and several
//levels of sub-sections.
//• "Block level structure types" are structure types that enclose actual content, like a heading or
//paragraph.
//• "Inline level structure types" are structure types that enable structural organisation of content
//inside block level elements and inside specialised structure elements used as block level elements.
//Some structure types — for example Table or Figure — may be used as block level types or as inline
//types, whereas others (e.g., H1) may only be used as block level types. Whenever a provision in clause
//14.8, "Tagged PDF", refers to block level types, all structure elements used as block level elements shall
//be included. Whenever a provision in clause 14.8, "Tagged PDF"
//, refers to inline level types, all
//structure elements used as inline level elements shall be included.
//To determine the category that is applicable to a structure element that may either be a block level
//structure element or an inline level structure element, the following applies:
//• If the structure element is used inside a block level element, it is an inline level structure element
//• In all other cases it is a block level structure element.
//All structure elements occurring within a tagged PDF document shall have a type matching one of
//those defined as a Standard Structure Type, or a role map providing a mapping from the non-standard
//type to a Standard Structure Type.
//754 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//14.8.4.2 Nesting of standard structure elements
//Annex L,
//"Parent-child relationships between the standard structure elements in the standard
//structure namespace for PDF 2.0" defines the nesting rules for standard structure elements. In
//addition, supplemental rules apply for some standard structure elements. These supplemental rules
//are defined in the subclauses specific to each of the standard structure types.
//Structure elements other than the standard structure elements identified in clause 14.8.4 "Standard
//structure types" or in the standard structure namespaces (see 14.8.6.2,
//"Role maps and namespaces")
//shall nest in relation to standard structure elements according to the requirements of the structure
//elements to which they are role mapped.
//NOTE The nesting rules detailed in Annex L,
//"Parent-child relationships between the standard
//structure elements in the standard structure namespace for PDF 2.0" address in detail the
//following system model:
//o Structure elements can be empty.
//o If a structure element contains neither structure elements nor real content it is
//empty.
//o Unless specifically constrained in 14.8, "Tagged PDF", any number of structure
//elements can exist in any order inside a parent structure element.
//o Real content is contained inside block level or inline level structure elements.
//o Document level structure elements that are not empty contain other document
//level, grouping or block level elements, and cannot contain inline level structure
//elements or content.
//o Grouping structure elements that are not empty contain other document level,
//grouping or block level elements, and cannot contain inline level structure elements
//or content.
//o Inline level elements can contain other inline level structure elements but cannot
//contain any other type of structure element.
//14.8.4.3 Document level structure types
//In a tagged PDF file a logical document is a portion of content typically perceived as a semantically self
//contained document of any granularity. Examples range from short memos to articles, presentations or
//fillable forms to comprehensive publications like magazines or books.
//A logical document fragment is a portion of content that constitutes – or is intended or perceived as –
//just a part of a logical document, regardless of whether it was extracted from a logical document or
//originated as a document fragment. A tagged PDF file may consist of one or more logical documents or
//logical document fragments as described in "Table 364 — Document level structure types"
//.
//© ISO 2020 – All rights reserved 755
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 364 — Document level structure types
//Structure Type Category Description
//Document Document Encloses a logical document.
//EXAMPLE 1 A mail merge PDF typically contains a number of
//letters to different recipients. This implies that the
//PDF at the top level is one document, containing
//multiple documents at its child level where each such
//document is a letter to a recipient.
//EXAMPLE 2 A Proceedings PDF generally includes individual
//papers given at a conference. This implies that the
//PDF at the top level is one document containing
//several documents.
//DocumentFragment Document (PDF 2.0) Encloses a logical document fragment.
//A document fragment is typically created by extracting it as a
//part from an original complete document. As a consequence the
//structure of the fragment may be incomplete, and content may
//start at an arbitrary point within the original logical content
//structure.
//EXAMPLE 3 The following are just two possible types of
//document fragments:
//• an extract from an original document is inserted
//into a new containing document
//• extracts from original documents are
//concatenated into a new document
//NOTE 1 A logical document can contain any number of DocumentFragment elements, including nested
//logical document fragments.
//Each logical document fragment shall define its own logical structure. The logical structure of a logical
//document fragment may start in the middle of what was the parent document’s logical structure. For
//example, it could start at an arbitrary paragraph or at a heading level 2 or 3 instead of heading level 1
//or even in the middle of a list.
//NOTE 2 DocumentFragments are especially useful when hierarchical aspects of logical structure from
//the original document are to be maintained but are incomplete and thus would be difficult to
//understand or process.
//Within each Document or DocumentFragment structure element, all heading structure elements
//shall either be Hn or H. See "Table 366 — Block level structure types" for more information on heading
//structure elements.
//An XMP metadata stream (see 14.3.2, "Metadata streams") in a Document or DocumentFragment
//structure element may be used to include document metadata for a logical document nested inside a
//tagged PDF.
//756 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//14.8.4.4 Grouping level structure types
//This subclause describes structure types for grouping elements, as detailed in "Table 365 — Grouping
//level structure types", that are used to organise the overall structure of content in a tagged PDF.
//Table 365 — Grouping level structure types
//Structure
//Type
//Category Description
//Part Grouping Encloses a grouping of structure elements without consideration for their
//hierarchy.
//NOTE 1 Part is the semantic equivalent of Div.
//A structure element with the type of Part shall inherit the containment
//requirements and limitations of its parent element. Where the parent
//element is itself a structure element of type Part, then the inheritance shall
//recurse to the first parent element whose type is not Part.
//EXAMPLE 1 The following are just a few of the possible types of content that
//could be marked as Part:
//• frontmatter or backmatter in a book
//• a table of contents or bibliography section in a document
//• main body of content in a document
//• advertising section in a magazine
//• a group of pages (for example, a spread in a magazine)
//• a group of form fields
//• a group of Figure standard structure elements
//• a publisher’s indicia
//Sect Grouping Encloses a grouping of structure elements with consideration for their
//hierarchy.
//EXAMPLE 2 The following are just a few of the possible types of content that
//could be marked as Sect:
//• clauses in a technical document
//• components of an article in a newspaper or magazine
//• Elements of a recipe (e.g., “name”, “instructions”,
//“ingredients”, etc.)
//© ISO 2020 – All rights reserved 757
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Structure
//Type
//Category Description
//Div Grouping Encloses content structured in fashion that is orthogonal to the semantic
//structure. It can be used as a role mapping target for custom tags for which
//no suitable standard structure element is available, or where attributes are
//applied in a non-semantic fashion.
//NOTE 2 Nesting Div structure elements allows content to be subdivided.
//A structure element with the type of Div shall inherit the containment
//requirements and limitations of its parent element. Where the parent
//element is itself a structure element of type Div, then the inheritance shall
//recurse to the first parent element whose type is not Div.
//NOTE 3 Div does not change the semantic level of the structure hierarchy.
//EXAMPLE 3 The following is just one of the possible types of content that
//could be marked as Div:
//• associating a language attribute to group of content items
//without implying any semantic aspects
//Aside Grouping NonStruct Grouping (PDF 2.0) Encloses content that is distinct from other content within its
//parent structure element.
//EXAMPLE 4 The following are just a few of the possible types of content that
//could be marked as Aside:
//• Callout elements
//• Sidebar elements
//• Commentary accompanying an article
//• Background information for a section in a text book
//(Non-structural element) A grouping element having no inherent
//structural significance; it serves solely for grouping purposes. This type of
//element differs from a division (structure type Div) in that it should not be
//interpreted or exported to other document formats. Its descendants shall
//be processed normally.
//A structure element with the type of NonStruct shall inherit the
//containment requirements and limitations of its parent element. Where the
//parent element is itself a structure element of type NonStruct, then the
//inheritance shall recurse to the first parent element whose type is not
//NonStruct.
//NOTE (2020) This document updated the definition of Part and returned Sect and NonStruct to the
//above table with revised definitions.
//14.8.4.5 Block level structure types
//This subclause describes structure types for paragraph-like elements, as detailed in "Table 366 —
//Block level structure types"
//, that consist of running text and other content laid out in the form of
//conventional paragraphs (as opposed to more specialised types of content such as lists and tables).
//758 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 366 — Block level structure types
//Structure
//Type
//Category Description
//P Block (Paragraph) A low-level division of content. Although in many cases it will
//be used for paragraphs it may enclose any low-level division of content.
//EXAMPLE The following is just one of the possible types of content that
//could be marked as P:
//• A paragraph in a newspaper article or a paragraph in the
//chapter of a novel.
//Hn Block (With n being a sequence of digits representing an unsigned integer greater
//than or equal to 1) Encloses a low-level division of content usually referred
//to as a heading.
//NOTE 1 Low-level content would typically be perceived as a sub-section of a
//document, whether a section heading, chapter or any other identifiable
//subdivision of content within a logical document. See the Title element
//regarding high-level division of content.
//Any such heading structure element shall always consist of the uppercase
//letter "H" and one or more digits, representing an unsigned integer greater
//than or equal to 1, without leading zeroes or any other prefix or postfix.
//The heading level is indicated through the chosen structure element type,
//for example H1 indicates a heading at the topmost level within a document,
//H2 a heading at the second level, and so forth.
//NOTE 2 This implies that H7 can be used to indicate a heading on the seventh
//level, whereas h7, H07, H-7 or H_7 cannot be used as heading structure
//elements.
//The heading level indicated by a heading should reflect the heading level of
//the tagged content.
//NOTE 3 The Lbl structure element can be used to enclose section enumeration
//content or its functional equivalent present inside the heading.
//EXAMPLE A section heading in a text book or newspaper article is one
//example where a heading level would be indicated.
//© ISO 2020 – All rights reserved 759
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Structure
//Type
//Category H Block Title Grouping
//or Block
//FENote Grouping,
//Block or
//Inline
//760 Description
//Encloses a low-level division of content usually referred to as a heading. The
//heading level is not indicated through this structure element, but instead is
//derived from the nesting of the logical structure within a given Document
//or DocumentFragment structure element. The H heading structure
//elements should always be the first structure element within its parent
//structure element. The H heading structure element shall always be the
//only heading structure element within its parent structure element.
//NOTE 1 This implies that within a given logical document it is not acceptable that
//an H heading structure element is used if a H1, H2, H3 etc. heading
//structure element is also used inside the same DocumentFragment
//structure element.
//NOTE 2 The Lbl structure element can be used to enclose a section number or
//similar present inside the heading.
//EXAMPLE 1 As the use of the H heading structure element requires strict
//document structuring it is typically used only for machine
//generated documents, documents created from a well structured
//content data set or documents whose creation is fully controlled
//by a program such that its structure is strictly guaranteed.
//EXAMPLE 2 Scientific publications and technical specifications often follow
//very strict structuring rules and thus are suitable candidates for
//use of the H heading structure element.
//(PDF 2.0) Encloses content that is usually referred to as the title of a
//document or high-level division of content.
//NOTE 3 High-level content would typically be perceived as the title of an article,
//section, chapter or any other identifiable top-level subdivision of content
//within a logical document. See the Hn and H elements regarding low-level
//division of content.
//It should occur only once inside the parent grouping structure element, and
//it should occur at or near the beginning of the content inside that grouping
//structure element.
//EXAMPLE 3 The title of a book, brochure or leaflet are some types of content
//that can be marked with the Title structure element.
//(PDF 2.0) Used to markup footnotes and endnotes. Footnotes and endnotes
//are content that is not normally read as part of the enclosing content from
//which it is referenced, but rather consulted at the reading person’s
//discretion. In order for text to be considered a footnote or endnote, there
//should be a reference from the enclosing content to the footnote or
//endnote. Such reference may be achieved by means of a Link structure
//element through a structure destination in its link annotation (see "Table
//368 — General inline level structure types"), or use of Ref in structure
//elements (see "Table 355 — Entries in a structure element dictionary").
//NOTE 4 Text that is labelled as a note – like this paragraph –but is intended to be
//normally read together with the enclosing content is not a footnote or
//endnote.
//© ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//14.8.4.6 Sub-block level structure type
//"Table 367 — Sub-block level structure type" defines a structure type similar to block level types but
//intended for use in an inline context. An example of this usage is provided in H.8.4, "Example of Sub
//standard structure type"
//.
//Table 367 — Sub-block level structure type
//Structure
//Type
//Category Description
//Sub Inline (PDF 2.0) (Sub-division of a block level element) Encloses content typically
//perceived as a sub-division inside a block level structure element.
//A Lbl structure element may be used inside a Sub structure element to
//enclose a line number, verse number or similar, if present.
//If a Sub structure element is used, all other content inside the same block
//level element that is the parent of the Sub structure element, should also
//be enclosed in Sub structure elements.
//Examples:
//• a verse in a poem or sacred scripture
//• a line-numbered document
//• a line of source code
//• a line in a postal address
//14.8.4.7 Inline level structure types
//14.8.4.7.1 General
//Unless otherwise noted in 14.8.4.2, “Nesting of standard structure elements”, any inline structure
//element is optional. It may occur once or more than once inside its parent structure element. The other
//children of its parent structure element, if any are present, may be other inline structure elements or
//actual content. Inline structure elements and portions of actual content inside a parent structure
//element may occur in any combination and in any order.
//Unless restricted by their type, structure elements and portions of actual content inside a parent
//structure element may occur in any combination and in any order.
//14.8.4.7.2 General inline level structure types
//"Table 368 — General inline level structure types" defines standard structure types for inline level
//structure types.
//© ISO 2020 – All rights reserved 761
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 368 — General inline level structure types
//Structure
//Type
//Category Description
//Lbl Inline (Label) Encloses content that distinguishes it from other content inside the same
//parent element.
//In a list item (see 14.8.4, "Standard structure types") the Lbl structure element
//may enclose the bullet for list items in unordered lists or digits and characters
//used for numbering of list items in ordered lists. For headings it may be the
//number of the chapter. For a definition list it may enclose the term to be defined.
//For key value pairs it may enclose the key for which a value is provided. For an
//entry in a table of contents there may be two Lbl structure elements, one for a
//chapter number, and one for the page number at which the chapter starts, whereas
//the actual text for the chapter heading is the remaining portion of the table of
//contents list item.
//EXAMPLE 1 The following are just a few of the possible types of content that could be
//marked as Lbl:
//• bullets for list items in an unordered list
//• digits or characters used for numbering list items in an ordered list
//• the number in the Caption for a Figure or Table
//• in a form, the label of a form field
//• in footnotes, the number or symbol matching the reference from the
//text
//• in headings, the enumeration of the headings
//• in a dictionary, the word for which a translation is provided
//• in a definition list, the term for which a definition is provided
//• in key value pairs, the key for which a value is provided
//• in a question and answer sequence in an interview, visual cues for
//designating questions and answer
//Span Inline A generic inline portion of content having no particular inherent characteristics. It
//can be used, for example, to delimit a range of text with certain attributes.
//EXAMPLE 4 A word inside a sentence is in a different language than the surrounding
//text, and is contained in a Span with a Lang attribute indicating the
//applicable language.
//EXAMPLE 5 A custom set of structure element types defines custom inline structure
//elements which are mapped to the Span structure element in the
//RoleMap to enable a PDF processor unaware of the custom set of
//structure element types to essentially ignore the structure element.
//762 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Structure
//Type
//Category Description
//Em Inline (PDF 2.0) (Emphasis) Encloses content for the purpose of emphasis. The level of
//stress that a particular piece of content has is given by its number of ancestor Em
//structure elements.
//The placement of stress emphasis changes the meaning of the sentence. The
//element thus forms an integral part of the content. The precise way in which stress
//is used in this way depends on the language.
//EXAMPLE 2 These examples show how changing the stress emphasis changes the
//meaning. First, a general statement of fact, with no stress:
//<P>Cats are cute animals.</P>
//By emphasizing the first word, the statement implies that the kind
//of animal under discussion is in question (maybe someone is
//asserting that dogs are cute):
//<P><Em>Cats</Em> are cute animals.</P>
//By moving it to the adjective, the exact nature of the cats is
//reasserted (maybe someone suggested cats were mean animals):
//<P>Cats are <Em>cute</Em> animals.</P>
//Strong Inline (PDF 2.0) Encloses content for the purpose of strong importance, seriousness or
//urgency for its contents.
//EXAMPLE 3 In this example the Strong element is used to denote the content that the
//user is intended to read first:
//<P>Your tasks for today:</P>
//<L>
//<LI><LBody><Strong>Turn off the oven.</Strong></LBody>
//</LI>
//<LI><LBody>Put out the trash.</LBody></LI>
//<LI><LBody>Do the laundry.</LBody></LI>
//</L>
//Link Grouping,
//Block or
//Inline
//An association between content enclosed by the Link structure element and a
//corresponding link annotation (see 12.5.6.5, "Link annotations").
//© ISO 2020 – All rights reserved 763
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Structure
//Type
//Category Description
//Annot Grouping,
//Block or
//Inline
//Either an association between the content enclosed by the Annot structure
//element and one or more corresponding PDF annotations (see 12.5,
//"Annotations"), or a mechanism to include one or more PDF annotations in the
//structure tree.
//If more than one annotation is referenced in an Annot structure element, they
//shall be of the same annotation type.
//Annot shall not be used for link annotations (see the Link structure element) or
//widget annotations (see the Form structure element). All other annotation types
//may be referenced by this structure element.
//EXAMPLE 6 The following are just a couple of the possible types of content that could
//be marked as Annot:
//• Markup annotations indicating change requests like requests for
//deletions, modifications or insertions.
//• Highlighting of certain content.
//Form Grouping,
//Block or
//Inline
//Either an association between content enclosed by the Form structure element and
//a corresponding widget annotation or a mechanism to include a widget annotation
//in the structure tree.
//In a tagged PDF, Form shall be used for each PDF widget annotation that belongs
//to the real content of the document.
//NOTE Form structure elements often include Lbl structure elements to mark up
//a form field’s label (if any).
//EXAMPLE 7 The following are the possible types of content that could be marked as
//Form:
//• Form fields in a PDF containing a fillable form would be marked as
//Form structure element.
//• Non-interactive forms, that is, content enclosed in a structure element
//with the PrintField attribute, would be marked with Form structure
//elements.
//NOTE 1 (2020) This document redefined available categories for Link and Annot structure elements
//types.
//Tagged PDF link elements (standard structure type Link) use PDF’s logical structure facilities to
//establish the association between content items and link annotations, providing functionality
//comparable to HTML hypertext links. The following items may be children of a link element:
//• One or more content items or other ILSEs (except other links) if A, Dest and PA keys of all of them
//have identical values
//• One object reference (see 14.7.5.3, "PDF objects as content items") to one link annotation
//associated with the content
//NOTE 2 An SD entry in the GoTo or GoToR action in a Link annotation facilitates linking directly to a
//target structure element as opposed to just targeting an area on a page.
//Goto errata
//764 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//14.8.4.7.3 Ruby and warichu elements
//Ruby text is a side note, written in a smaller text size and placed adjacent to the base text to which it
//refers. It is used in Japanese and Chinese to describe the pronunciation of unusual words or to describe
//such items as abbreviations and logos.
//Warichu text is a comment or annotation, written in a smaller text size and formatted onto two smaller
//lines within the height of the containing text line and placed following (inline) the base text to which it
//refers. It is used in Japanese for descriptive comments and for ruby annotation text that is too long to
//be aesthetically formatted as a ruby.
//"Table 369 — Ruby and Warichu structure types" defines standard structure types for Ruby and
//warichu text.
//Table 369 — Ruby and Warichu structure types
//Structure
//Type
//Category Description
//Ruby Inline Structure element that wraps around an entire ruby assembly.
//It shall contain one RB element followed by either an RT element or a
//three-element sequence consisting of RP, RT, and RP.
//Ruby structure elements and their content elements shall not break
//across multiple lines.
//RB Inline (Ruby base text) The full-size text to which the ruby annotation is applied.
//RB may contain text, other inline elements, or a mixture of both.
//It may have the RubyAlign attribute.
//RT Inline (Ruby annotation text) The smaller-size text that shall be placed adjacent
//to the ruby base text. It may contain text, other inline elements, or a
//mixture of both. It may have the RubyAlign and RubyPosition attributes.
//RP Inline (Ruby punctuation) Punctuation surrounding the ruby annotation text. It
//is used only when a ruby annotation cannot be properly formatted in a
//ruby style and instead is formatted as a normal comment, or when it is
//formatted as a warichu. It contains text (usually a single LEFT
//PARENTHESIS or RIGHT PARENTHESIS or similar bracketing character).
//Warichu Inline (Warichu) The wrapper around the entire warichu assembly. It shall
//contain a three-element sequence consisting of WP, WT, and WP.
//Warichu structure elements (and their child structure elements) may
//wrap across multiple lines, according to the warichu breaking rules
//described in the Japanese Industrial Standard (JIS) X 4051-2004.
//WT Inline (Warichu text) The smaller-size text of a warichu comment that is
//formatted into two lines and placed between surrounding WP elements.
//WP Inline (Warichu punctuation) The punctuation that surrounds the content in the
//WT structure element. It typically contains text (usually a single LEFT
//PARENTHESIS or RIGHT PARENTHESIS or similar bracketing character).
//According to JIS X 4051-2004, the parentheses surrounding a warichu
//may be converted to a SPACE (nominally 1/4 EM in width) at the
//discretion of the formatter.
//© ISO 2020 – All rights reserved 765
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//14.8.4.8 Other structure types
//14.8.4.8.1 General
//There are a number of other structure types that have a distinct internal structure on their own, or that
//may be used as grouping level structure elements, as block level structure elements or as inline level
//structure elements, depending on the context in which they are used.
//14.8.4.8.2 Standard structure types for lists
//This clause describes structure types for organising the content of lists. H.8.3, "Hierarchical lists"
//provides an example of hierarchical list entries. "Table 370 — List standard structure types" defines
//standard structure types for lists.
//Table 370 — List standard structure types
//Structure
//Type
//Category Description
//L Block or Inline (List) Encloses content consisting of a sequence of items that are
//semantically related with each other.
//If a Caption is present, it shall be either the first or last child in the L
//(list) structure element.
//The ListNumbering attribute (see 14.8.5.5, "List attribute") may be
//used to indicate the type of ordered or unordered list.
//The ContinuedList and ContinuedFrom attributes (see 14.8.5.5,
//"List attributes") may be used to indicate relationships with other L
//(list) structure elements.
//EXAMPLE 1 Bulleted lists, numbered lists, tables of contents, indexes,
//dictionaries, and lists of key value pairs are all examples of
//content that would use the L structure element.
//LI Internal to L
//(List) structure
//elements
//(List Item) Encloses content for an individual member of a list.
//Children (see Annex L,
//"Parent-child relationships between the
//standard structure elements in the standard structure namespace for
//PDF 2.0") of the list item may occur in any order or combination.
//NOTE LI structure elements often include Lbl structure elements
//(see Table 368 — General inline level structure types) to
//mark up a list item's label (if any).
//LBody Internal to LI
//(List item)
//structure
//elements
//(List Item Body) Encloses the actual content of a list item.
//EXAMPLE 2 In a dictionary list the list item body contains the
//translation or definition of the term.
//To represent hierarchical lists, the child L (list) structure elements shall be a direct child of its parent L
//(list) structure element or contained within a Div structure element belonging to the parent L (list).
//766 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//NOTE Lists can occur within the content of an LBody structure element. Such lists are not considered
//part of the hierarchy.
//14.8.4.8.3 Table structure types
//"Table 371 — Table standard structure types" defines standard structure types for tables.
//Table 371 — Table standard structure types
//Structure
//Type
//Category Description
//Table Block A two-dimensional logical structure of cells, possibly including a complex
//substructure.
//If a Caption is present, it shall be either the first or last child of the Table
//structure element.
//TR Internal to a
//Table
//structure
//A row of table header cells (TH) or table data cells (TD) in a table.
//TH Internal to a
//Table
//structure
//A table header cell containing content describing one or more rows,
//columns or rows and columns of the table.
//The following attributes can be used with the TH structure element:
//• RowSpan
//• ColSpan
//• Headers
//• Scope
//• Short
//TD Internal to a
//Table
//structure
//A table cell containing content that is part of the table’s content.
//The following attributes can be used with the TD structure element:
//• RowSpan
//• ColSpan
//• Headers
//THead Internal to a
//Table
//structure
//(Optional) A group of TR structure elements that constitute the header of
//a table.
//The THead structure element is optional insofar as when rows of header
//cells are present they may, but are not required to be, so enclosed.
//TBody Internal to a
//Table
//structure
//(Optional) A group of TR structure elements that constitute the main body
//portion of a table.
//The TBody structure element is optional insofar as when rows of cells are
//present they may, but are not required to be, so enclosed.
//TFoot Internal to a
//Table
//structure
//(Optional) A group of TR structure elements that constitute the footer of a
//table.
//The TFoot structure element is optional insofar as when rows of cells
//belonging to footer row(s) are present they may, but are not required to
//be, so enclosed.
//© ISO 2020 – All rights reserved 767
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//If the Headers attribute (see 14.8.5, "Standard structure attributes") is not specified, any cell in a table
//may have multiple headers associated with it. These headers are defined either explicitly by the
//Headers attribute, or implicitly, by the following algorithm:
//To find headers for any data or header cell, begin from the current cell position and use the current
//value of WritingMode to search towards the first cell in the appropriate horizontal/vertical direction.
//The search terminates when any of these conditions is reached:
//• the edge of the table is reached
//• a data cell is found after a header cell
//• a header cell has the Headers attribute set — the headers that are specified are appended to the
//row/ column list that is being built
//When a header cell is found in the search and the (implicit or explicit) Scope attribute of the header
//cell is either Both or Row/Column, the header cell is appended to the end of the list of row/column
//headers, resulting in a list of headers ordered from most specific to most general.
//NOTE This algorithm works for languages with different intrinsic directionality of the script (such as
//right-to-left) because the structure always reflects the logical content order of the table.
//14.8.4.8.4 Caption structure type
//The standard structure type Caption, defined in "Table 372 — Standard structure type Caption"
//,
//encloses content that serves as a caption for tables, lists, images, formulas, media objects or other types
//of content.
//Table 372 — Standard structure type Caption
//Structure
//Type
//Category Description
//Caption Grouping or
//Block
//For lists and tables a Caption structure element may be used as defined
//for the L (list) and Table structure elements. In addition a Caption may
//be used for a structure element or several structure elements.
//A structure element is understood to be "captioned" when a Caption
//structure element exists as an immediate child of that structure element.
//The Caption shall be the first or the last structure element inside its
//parent structure element. The number of captions cannot exceed 1.
//While captions are often used with figures or formulas, they may be
//associated with any type of content.
//NOTE In principle, captions can appear in a nested fashion. For example,
//several smaller images belonging to a group of images can each be
//accompanied by a caption, and the group of these images as a whole is
//accompanied by a caption as well.
//EXAMPLE The following are just a few of the possible types of content
//that could be marked as Caption:
//• Caption for an image, list, table, or formula
//• Caption for a group of images or a sequence of graphics
//• Group of images with a caption, plus a caption for each of
//the images inside the group of images
//768 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//14.8.4.8.5 Figure structure type
//"Table 373 — Standard structure type Figure" defines the Figure standard structure type.
//The standard structure type Figure encloses content that represents one or more complete graphics
//objects. It shall not appear between the BT and ET operators delimiting a text object (see 9.4, "Text
//objects").
//A Figure element may have logical substructure, including other Figure elements. For repurposing
//purposes it may be treated as visually static, without examining its internal contents. It should have a
//BBox attribute (see 14.8.5, "Standard structure attributes").
//For repurposing and accessibility purposes, a Figure element should have either an Alt entry or an
//ActualText entry in its structure element dictionary (see 14.9.3, "Alternate descriptions" and 14.9.4,
//"Replacement text").
//NOTE Alt is a description of the graphics objects enclosed by the Figure element, whereas ActualText
//gives the exact text equivalent of a graphical illustration that has the appearance of text.
//Table 373 — Standard structure type Figure
//Structure
//Type
//Category Description
//Figure Grouping,
//Block or
//Inline
//Encloses graphical content.
//The BBox attribute (see 14.8.5, "Standard structure attributes") should
//be present for a figure appearing in its entirety on a single page to
//indicate the area of the figure on the page.
//EXAMPLE 1 Some examples of content that would be marked as Figure
//include:
//• an image
//• a drawing
//• a chart, including the text that denotes values on each axis
//14.8.4.8.6 Formula structure type
//"Table 374 — Standard structure type Formula" defines the Formula standard structure type.
//The standard structure type Formula shall not appear between the BT and ET operators delimiting a
//text object (see 9.4, "Text objects").
//A Formula element may have logical substructure, including other Formula elements. For
//repurposing purposes it may be treated as visually static, without examining its internal contents. It
//should have a BBox attribute (see 14.8.5, "Standard structure attributes").
//For repurposing and accessibility purposes, a Formula element should have either an Alt entry or an
//ActualText entry in its structure element dictionary (see 14.9.3, "Alternate descriptions" and 14.9.4,
//"Replacement text").
//© ISO 2020 – All rights reserved 769
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//NOTE Alt is a description of the content enclosed by the Formula element, whereas ActualText gives
//the exact text equivalent of a formula has the appearance of text.
//Table 374 — Standard structure type Formula
//Structure
//Type
//Category Description
//Formula Grouping,
//Block or
//Inline
//Encloses a formula.
//The BBox attribute ("see 14.8.5, "Standard structure attributes") should
//be present for a formula appearing in its entirety on a single page to
//indicate the area of the formula on the page.
//EXAMPLE Some examples of content that would be marked as Formula
//include:
//• a mathematical equation or a part thereof
//• a chemical formula
//• a mathematical proof
//14.8.4.8.7 Artifact structure type
//"Table 375 — standard structure type Artifact" defines the Artifact standard structure type.
//Table 375 — standard structure type Artifact
//Structure
//Type
//Category Description
//Artifact Grouping,
//Block or
//Inline
//(PDF 2.0) Encloses content for which semantics require a reference in the
//structure tree even when such content is not part of the document’s real
//content.
//The Artifact structure type may be used to enclose content that would not
//otherwise be tagged based on the rules of tagged PDF.
//A processor of tagged PDF should normally ignore any content items and
//structure elements that are direct or indirect descendants of an Artifact
//structure element.
//EXAMPLE Some documents include pages with line numbers. Whereas for
//tagged PDF such line numbers would typically be considered
//artifacts, the Artifact structure element allows authors to
//ensure context is maintained by making it possible to place the
//line numbers in the logical structure without forcing end users
//to consume them as part of the logical content order.
//770 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//14.8.5 Standard structure attributes
//14.8.5.1 General
//In addition to the standard structure types, PDF defines standard structure attributes for standard
//structure elements in addition to those attributes in a structure element dictionary that are already
//defined in "Table 355 — Entries in a structure element dictionary"
//.
//The example in 14.7.7, "Example of logical structure" illustrates the use of standard structure
//attributes.
//As discussed in 14.7.6, "Structure attributes" attributes shall be defined in attribute objects, which are
//dictionaries or streams attached to a structure element in either of two ways:
//The A entry in the structure element dictionary identifies an attribute object or an array of such
//objects.
//The C entry in the structure element dictionary gives the name of an attribute class or an array of such
//names. The class name is in turn looked up in the class map, a dictionary identified by the ClassMap
//entry in the structure tree root, yielding an attribute object or array of objects corresponding to the
//class.
//In addition to the standard structure attributes described in 14.8.5.2, "Standard Attribute Owners"
//there are several other optional entries – Lang, Alt, ActualText, and E – that are described in 14.9,
//"Repurposing and accessibility support" but are useful to other PDF consumers as well. They appear in
//the following places in a PDF file (rather than in attribute dictionaries):
//• As entries in the structure element dictionary (see "Table 355 — Entries in a structure element
//dictionary");
//• As entries in property lists attached to marked-content sequences with the tag Span (see 14.6,
//"Marked content").
//14.8.5.2 Standard attribute owners
//Each attribute object has an owner, specified by the object’s O entry, or, if the value of O is NSO, by the
//object’s NS entry, which determines the interpretation of the attributes defined in the object’s
//dictionary. Multiple owners may define like-named attributes with different value types or
//interpretations. Tagged PDF defines a set of standard attribute owners as shown in "Table 376 —
//Standard structure attribute owners"
//.
//Table 376 — Standard structure attribute owners
//Owner value for
//the attribute
//object’s O entry
//Description
//Layout Attributes governing the layout of content
//List Attributes governing the numbering of lists
//PrintField Attributes governing Form structure elements for non-interactive form fields
//© ISO 2020 – All rights reserved 771
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Owner value for
//the attribute
//object’s O entry
//Description
//Table Attributes governing the organisation of cells in tables
//Artifact Attributes governing Artifact structure elements
//XML-1.00 Additional attributes governing translation to XML, version 1.00
//HTML-3.20 Additional attributes governing translation to HTML, version 3.20
//HTML-4.01 Additional attributes governing translation to HTML, version 4.0
//HTML-5.00 Additional attributes governing translation to HTML, version 5.0
//OEB-1.00 Additional attributes governing translation to OEB (Open eBook), version 1.0
//RTF-1.05 Additional attributes governing translation to Microsoft Rich Text Format, version 1.05
//CSS-1 Additional attributes governing translation to a format using CSS, version 1
//CSS-2 Additional attributes governing translation to a format using CSS, version 2.1
//CSS-3 Additional attributes governing translation to a format using CSS, version 3
//RDFa-1.10 Additional attributes governing translation to a format using RDFa version 1.1
//ARIA-1.1 Additional attributes governing translation to a format using WAI-ARIA version 1.1
//NOTE (2020) The three owner values for CSS were changed in the above table to better reflect CSS
//numbering.
//An attribute object owned by a specific export format, such as XML-1.00, shall be applied only when
//processing PDF content based on that format. Such format-specific attributes shall override any
//corresponding attributes owned by Layout, List, PrintField, Table or Artifact. There may also be
//additional format-specific attributes; the set of possible attributes is open-ended and is not explicitly
//specified or limited by tagged PDF.
//14.8.5.3 Attribute values and inheritance
//Some attributes are defined as inheritable. Inheritable attributes propagate down the structure tree;
//that is, an attribute that is specified for an element shall apply to all the descendants of the element in
//the structure tree unless a descendent element specifies an explicit value for the attribute.
//NOTE 1 The description of each of the standard attributes in this subclause specifies whether their
//values are inheritable.
//An inheritable attribute may be specified for an element for the purpose of propagating its value to
//child elements, even if the attribute is not meaningful for the parent element. Non-inheritable
//attributes may be specified only for elements on which they would be meaningful.
//The following list shows the priority for determining attribute values. A PDF processor determines an
//attribute’s value to be the first item in the following list that applies:
//772 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//• The value of the attribute specified in the element’s A entry, owned by an owner as specified by
//the O entry, or, if the value of the O entry is NSO, the NS entry, excluding Layout, PrintField,
//Table, List and Artifact, if present, and if processing based on the format indicated by the owner
//value
//• The value of the attribute specified in the element’s A entry, owned by Layout, PrintField, Table,
//List or Artifact, if present
//• The value of the attribute specified in a class map associated with the element’s C entry, if there is
//one
//• The resolved value of the parent structure element, if the attribute is inheritable
//• The default value for the attribute, if there is one
//NOTE 2 The properties Lang, Alt, ActualText, and E do not appear in attribute dictionaries. The rules
//governing their application are discussed in 14.9, "Repurposing and accessibility support"
//.
//There is no semantic distinction between attributes that are specified explicitly and ones that are
//inherited. Logically, the structure tree has attributes fully bound to each element, even though some
//may be inherited from an ancestor element. This is consistent with the behaviour of properties (such
//as font characteristics) that are not specified by structure attributes but shall be derived from the
//content.
//14.8.5.4 Layout attributes
//14.8.5.4.1 General
//Layout attributes specify parameters of the layout process used to produce the appearance described
//by a document’s PDF content. Attributes in this category shall be defined in attribute objects whose O
//(owner) entry has the value Layout or whose owner is any other owner excluding List, Table,
//PrintField and Artifact.
//NOTE 1 The intent is that these parameters can be used to repurpose the content or export it to some
//other document format with at least basic styling preserved.
//"Table 377 — Standard layout attributes" summarizes the standard layout attributes and the structure
//elements to which they apply.
//As described in 14.8.5.3, "Attribute Values and Inheritance" an inheritable attribute may be specified
//for any element to propagate it to descendants, regardless of whether it is meaningful for that element.
//Table 377 — Standard layout attributes
//Goto errata
//Structure Elements Attributes Inheritable
//Any structure element Placement No
//WritingMode Yes
//BackgroundColor No
//BorderColor Yes
//BorderStyle No
//© ISO 2020 – All rights reserved 773
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Structure Elements Attributes Inheritable
//BorderThickness Yes
//Color Yes
//Padding No
//Any BLSE;
//ILSEs with Placement other than
//Inline
//SpaceBefore No
//SpaceAfter No
//StartIndent Yes
//EndIndent Yes
//BLSEs containing text TextIndent Yes
//TextAlign Yes
//Figure, Form, Formula and Table
//elements
//BBox No
//Width No
//Height No
//TH (Table header); TD (Table
//data)
//Width No
//Height No
//BlockAlign Yes
//InlineAlign Yes
//TBorderStyle Yes
//TPadding Yes
//Any ILSE;
//BLSEs containing ILSEs or
//containing direct or nested
//content items
//LineHeight Yes
//BaselineShift No
//TextDecorationType Yes, only for directly nested ILSEs
//TextPosition Yes
//TextDecorationColor Yes
//TextDecorationThickness Yes
//Grouping elements ColumnCount No
//ColumnWidths No
//ColumnGap No
//Vertical text GlyphOrientationVertical Yes
//774 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Structure Elements Attributes Inheritable
//Ruby text RubyAlign Yes
//RubyPosition Yes
//NOTE 2 TextPosition was corrected in the above table (2020).
//14.8.5.4.2 General layout attributes
//The layout attributes described in "Table 378 — Standard layout attributes common to all standard
//structure types" may apply to structure elements of any of the standard at the block level (BLSEs) or
//the inline level (ILSEs).
//© ISO 2020 – All rights reserved 775
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 378 — Standard layout attributes common to all standard structure types
//Key Type Value
//Placement name (Optional; not inheritable) The positioning of the element with respect
//to the enclosing reference area and other content. The value shall be
//one of the following:
//Block Stacked in the block-progression direction within an enclosing
//reference area or parent BLSE.
//Inline Packed in the inline-progression direction within an enclosing
//BLSE.
//Before Placed so that the before edge of the element’s allocation
//rectangle (see 14.8.5.4.5, "Content and Allocation Rectangles")
//coincides with that of the nearest enclosing reference area.
//The element may float, if necessary, to achieve the specified
//placement. The element shall be treated as a block occupying
//the full extent of the enclosing reference area in the inline
//direction. Other content shall be stacked so as to begin at the
//after edge of the element’s allocation rectangle.
//Start Placed so that the start edge of the element’s allocation
//rectangle (see 14.8.5.4.5, "Content and Allocation Rectangles")
//coincides with that of the nearest enclosing reference area.
//The element may float, if necessary, to achieve the specified
//placement. Other content that would intrude into the
//element’s allocation rectangle shall be laid out as a runaround.
//End Placed so that the end edge of the element’s allocation
//rectangle (see 14.8.5.4.5, "Content and Allocation Rectangles")
//coincides with that of the nearest enclosing reference area.
//The element may float, if necessary, to achieve the specified
//placement. Other content that would intrude into the
//element’s allocation rectangle shall be laid out as a runaround.
//When applied to an ILSE, any value except Inline shall cause the
//element to be treated as a BLSE instead.
//Default value: Block for BLSEs, Inline for ILSEs.
//Elements with Placement values of Before, Start, or End shall be
//removed from the normal stacking or packing process and allowed to
//float to the specified edge of the enclosing reference area or parent
//BLSE. Multiple such floating elements may be positioned adjacent to
//one another against the specified edge of the reference area or placed
//serially against the edge, in the order encountered. Complex cases such
//as floating elements that interfere with each other or do not fit on the
//same page may be handled differently by different PDF processors.
//Tagged PDF merely identifies the elements as floating and indicates
//their desired placement.
//776 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//WritingMode name (Optional; inheritable) Indicates the directions of layout progression
//inside Block Level Structure Elements (BLSEs) (inline progression)
//and regarding the sequence of BLSEs (block progression).
//WritingMode may be used as an attribute for any structure element.
//The value shall be one of the following:
//LrTb Inline progression from left to right; block progression from
//top to bottom. This is the typical writing mode for Western
//writing systems.
//RlTb Inline progression from right to left; block progression from
//top to bottom. This is the typical writing mode for Arabic and
//Hebrew writing systems.
//TbRl Inline progression from top to bottom; block progression from
//right to left. This is the typical writing mode for Chinese and
//Japanese writing systems.
//TbLr Inline progression from top to bottom; block progression from
//left to right. This is the typical writing mode for writing
//systems like classical Mongolian.
//LrBt Inline progression from left to right; block progression from
//bottom to top. There is currently no known writing system to
//which this writing mode applies.
//RlBt Inline progression from right to left; block progression from
//bottom to top. There is currently no known writing system to
//which this writing mode applies.
//BtRl Inline progression from bottom to top; block progression from
//right to left. This is the typical writing mode for the Ancient
//Berber writing system.
//BtLr Inline progression from bottom to top; block progression from
//left to right. This is the typical writing mode for the Batak
//writing system.
//The specified layout directions shall apply to the given structure
//element and all of its descendants.
//Default value: LrTb.
//For elements that are represented in multiple columns, the writing
//mode defines the direction of column progression within the reference
//area: the inline direction determines the stacking direction for columns
//and the default flow order of text from column to column.
//For tables, the writing mode controls the layout of rows and columns:
//table rows (structure type TR) shall be stacked in the block direction,
//cells within a row (structure types TH and TD) in the inline direction.
//The inline-progression direction specified by the writing mode is
//subject to local override within the text being laid out, as described in
//Unicode Standard Annex #9, Unicode Bidirectional Algorithm, available
//from the Unicode Consortium.
//BackgroundColor array (Optional; not inheritable; PDF 1.5) The colour to be used to fill the
//background of a table cell or any element’s content rectangle (possibly
//adjusted by the Padding attribute). The value shall be an array of three
//numbers in the range 0.0 to 1.0, representing the red, green, and blue
//values, respectively, of an RGB colour space. If this attribute is not
//specified, the element shall be treated as if its background were
//transparent.
//© ISO 2020 – All rights reserved 777
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type BorderColor array BorderStyle name or
//array
//778 Value
//(Optional; inheritable; PDF 1.5) The colour of the border drawn on the
//edges of a table cell or any element’s content rectangle (possibly
//adjusted by the Padding attribute). The value of each edge shall be an
//array of three numbers in the range 0.0 to 1.0, representing the red,
//green, and blue values, respectively, of an RGB colour space. There are
//two forms:
//• A single array of three numbers representing the RGB values to apply to
//all four edges.
//• An array of four arrays, each specifying the RGB values for one edge of
//the border, in the order of the before, after, start, and end edges. A value
//of null for any of the edges means that it shall not be drawn.
//If this attribute is not specified, the border colour for this element shall
//be the current text fill colour in effect at the start of its associated
//content.
//(Optional; not inheritable; PDF 1.5) The style of an element’s border.
//Specifies the stroke pattern of each edge of a table cell or any element’s
//content rectangle (possibly adjusted by the Padding attribute). There
//are two forms:
//• An array of four entries, each entry specifying the style for one edge of
//the border in the order of the before, after, start, and end edges. A value
//of null for any of the edges means that it shall not be drawn.
//• A name from the list below representing the border style to apply to all
//four edges.
//Valid values are:
//None No border. Forces the computed value of BorderThickness to
//be 0.
//Hidden Same as None, except in terms of border conflict resolution for
//table elements.
//Dotted The border is a series of dots.
//Dashed The border is a series of short line segments.
//Solid The border is a single line segment.
//Double The border is two solid lines. The sum of the two lines and the
//space between them equals the value of BorderThickness.
//Groove The border looks as though it were carved into the canvas.
//Ridge The border looks as though it were coming out of the canvas
//(the opposite of Groove).
//Inset The border makes the entire box look as though it were
//embedded in the canvas.
//Outset The border makes the entire box look as though it were
//coming out of the canvas (the opposite of Inset).
//Default value: None
//All borders shall be drawn on top of the box’s background. The colour
//of borders drawn for values of Groove, Ridge, Inset, and Outset shall
//depend on the structure element’s BorderColor attribute and the
//colour of the background over which the border is being drawn.
//NOTE Conforming HTML applications may interpret Dotted, Dashed,
//Double, Groove, Ridge, Inset, and Outset to be Solid.
//© ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//BorderThickness number
//or array
//(Optional; inheritable; PDF 1.5) The thickness of the border drawn on
//the edges of a table cell or any element’s content rectangle (possibly
//adjusted by the Padding attribute). The value of each edge shall be a
//positive number in default user space units representing the border’s
//thickness (a value of 0 indicates that the border shall not be drawn).
//There are two forms:
//• A number representing the border thickness for all four edges.
//• An array of four entries, each entry specifying the thickness for one edge
//of the border, in the order of the before, after, start, and end edges. A
//value of null for any of the edges means that it shall not be drawn.
//Default value: 0.
//Padding number
//or array
//(Optional; not inheritable; PDF 1.5) Specifies an offset to account for the
//separation between the element’s content rectangle and the
//surrounding border (see 14.8.5.4.5, "Content and Allocation
//Rectangles"). A positive value enlarges the background area; a negative
//value trims it, possibly allowing the border to overlap the element’s
//text or graphic.
//There are two forms:
//• A number representing the width of the padding for all four edges.
//• An array of four entries, each entry specifying the width of the padding
//for one edge, in the order of the before, after, start and end edges.
//Default value: 0.
//Color array (Optional; inheritable; PDF 1.5) The colour to be used for drawing text
//and the default value for the colour of table borders and text
//decorations. The value shall be an array of three numbers in the range
//0.0 to 1.0, representing the red, green, and blue values, respectively, of
//an RGB colour space. If this attribute is not specified, the border colour
//for this element shall be the current text fill colour in effect at the start
//of its associated content.
//14.8.5.4.3 Layout Attributes for BLSEs
//"Table 379 — Additional standard layout attributes specific to block-level structure elements"
//describes layout attributes that shall apply only to block-level structure elements (BLSEs).
//© ISO 2020 – All rights reserved 779
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 379 — Additional standard layout attributes specific to block-level structure elements
//Key Type Value
//SpaceBefore number (Optional; not inheritable) The amount of extra space preceding the before
//edge of the BLSE, measured in default user space units in the block-
//progression direction. This value shall be added to any adjustments induced
//by the LineHeight attributes of ILSEs within the first line of the BLSE (see
//14.8.5.4.4, "Layout Attributes for ILSEs"). If the preceding BLSE has a
//SpaceAfter attribute, the greater of the two attribute values shall be used.
//Default value: 0.
//This attribute shall be disregarded for the first BLSE placed in a given
//reference area.
//SpaceAfter number (Optional; not inheritable) The amount of extra space following the after
//edge of the BLSE, measured in default user space units in the block-
//progression direction. This value shall be added to any adjustments induced
//by the LineHeight attributes of ILSEs within the last line of the BLSE (see
//14.8.5.4, "Layout Attributes"). If the following BLSE has a SpaceBefore
//attribute, the greater of the two attribute values shall be used.
//Default value: 0.
//This attribute shall be disregarded for the last BLSE placed in a given
//reference area.
//StartIndent number (Optional; inheritable) The distance from the start edge of the reference
//area to that of the BLSE, measured in default user space units in the inline-
//progression direction. This attribute shall apply only to structure elements
//with a Placement attribute of Block or Start (see 14.8.5.4.2, "General
//Layout Attributes"). The attribute shall be disregarded for elements with
//other Placement values.
//Default value: 0.
//A negative value for this attribute places the start edge of the BLSE outside
//that of the reference area. The results are implementation-dependent and
//may not be supported by all conforming products that process tagged PDF
//or by particular export formats.
//If a structure element with a StartIndent attribute is placed adjacent to a
//floating element with a Placement attribute of Start, the actual value used
//for the element’s starting indent shall be its own StartIndent attribute or
//the inline extent of the adjacent floating element, whichever is greater. This
//value may be further adjusted by the element’s TextIndent attribute, if any.
//EndIndent number (Optional; inheritable) The distance from the end edge of the BLSE to that of
//the reference area, measured in default user space units in the inline-
//progression direction. This attribute shall apply only to structure elements
//with a Placement attribute of Block or End (see 14.8.5.4.2, "General Layout
//Attributes"). The attribute shall be disregarded for elements with other
//Placement values.
//Default value: 0.
//A negative value for this attribute places the end edge of the BLSE outside
//that of the reference area. The results are implementation-dependent and
//may not be supported by all conforming products that process tagged PDF
//or by particular export formats.
//If a structure element with an EndIndent attribute is placed adjacent to a
//floating element with a Placement attribute of End, the actual value used
//for the element’s ending indent shall be its own EndIndent attribute or the
//inline extent of the adjacent floating element, whichever is greater.
//780 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//TextIndent number (Optional; inheritable; applies only to some BLSEs) The additional distance,
//measured in default user space units in the inline-progression direction,
//from the start edge of the BLSE, as specified by StartIndent, to that of the
//first line of text. A negative value shall indicate a hanging indent.
//Default value: 0.
//This attribute shall apply only to paragraphlike BLSEs and those of
//structure types LI (List item), TH (Table header), and TD (Table data),
//provided that they contain content other than nested BLSEs.
//TextAlign name (Optional; inheritable; applies only to BLSEs containing text) The alignment,
//in the inline-progression direction, of text and other content within lines of
//the BLSE. Valid values are:
//Start Aligned with the start edge.
//Center Centred between the start and end edges.
//End Aligned with the end edge.
//Justify Aligned with both the start and end edges, with internal spacing
//within each line expanded, if necessary, to achieve such alignment.
//The last (or only) line shall be aligned with the start edge only.
//Default value: Start.
//BBox rectangle (Optional; not inheritable) An array of four numbers in default user space
//units that shall give the coordinates of the left, bottom, right, and top edges,
//respectively, of the structure element’s bounding box (the rectangle that
//completely encloses its visible content).
//The BBox attribute should be present for structure elements whose content
//does not lend itself to reflow or any other visual rearrangement of the
//content inside it.
//NOTE 1 Examples of types of structure elements that do not lend themselves to
//reflow include Figure and Formula structure elements.
//NOTE 2 The semantics of the visual presentation of charts, illustrations consisting
//of more than one graphics object, or formulas can suffer if the objects
//inside them are rearranged, as is typical for content reflow.
//A structure element with a BBox attribute may contain other structure
//elements inside it.
//NOTE 3 A formula, for example, can lose its meaning if the parts in the formula are
//visually rearranged. At the same time, the parts inside the formula could
//be individually tagged, for example with inline level structure elements.
//EXAMPLE Formulas, graphic art, vector drawings, images are types of
//structure elements for which a BBox attribute is appropriate.
//© ISO 2020 – All rights reserved 781
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Width number
//or name
//Height number
//or name
//BlockAlign name 782 Value
//(Optional; not inheritable; illustrations, tables, and table cells only; should be
//used for table cells; sometimes required for Figure, Form or Formula
//elements with Placement attribute) The width of the element’s content
//rectangle (see 14.8.5.4.5, "Content and Allocation Rectangles"), measured in
//default user space units in the inline-progression direction. This attribute
//shall apply only to elements of structure type Figure, Formula, Table, TH
//(Table header), or TD (Table data).
//The name Auto in place of a numeric value shall indicate that no specific
//width constraint is to be imposed; the element’s width is determined by the
//intrinsic width of its content.
//Default value: Auto.
//(Optional; not inheritable; illustrations, tables, table headers, and table cells
//only; sometimes required for Figure, Form or Formula elements with
//Placement attribute) The height of the element’s content rectangle (see
//14.8.5.4.5, "Content and Allocation Rectangles"), measured in default user
//space units in the block-progression direction. This attribute shall apply
//only to elements of structure type Figure, Formula, Table, TH (Table
//header), or TD (Table data).
//The name Auto in place of a numeric value shall indicate that no specific
//height constraint is to be imposed; the element’s height is determined by
//the intrinsic height of its content.
//Default value: Auto.
//(Optional; inheritable; table cells only) The alignment, in the block-
//progression direction, of content within the table cell. Valid values are:
//Before Before edge of the first child’s allocation rectangle aligned with that
//of the table cell’s content rectangle.
//Middle Children centred within the table cell. The distance between the
//before edge of the first child’s allocation rectangle and that of the
//table cell’s content rectangle shall be the same as the distance
//between the after edge of the last child’s allocation rectangle and
//that of the table cell’s content rectangle.
//After After edge of the last child’s allocation rectangle aligned with that
//of the table cell’s content rectangle.
//Justify Children aligned with both the before and after edges of the table
//cell’s content rectangle. The first child shall be placed as described
//for Before and the last child as described for After, with equal
//spacing between the children. If there is only one child, it shall be
//aligned with the before edge only, as for Before.
//This attribute shall apply only to elements of structure type TH (Table
//header) or TD (Table data) and shall control the placement of all BLSEs that
//are children of the given element. The table cell’s content rectangle (see
//14.8.5.4.5, "Content and Allocation Rectangles") shall become the reference
//area for all of its descendants.
//Default value: Before.
//© ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//InlineAlign name (Optional; inheritable; table cells only) The alignment, in the inline-
//progression direction, of content within the table cell. Valid values are:
//Start Start edge of each child’s allocation rectangle aligned with that of
//the table cell’s content rectangle.
//Center Each child centred within the table cell. The distance between the
//start edges of the child’s allocation rectangle and the table cell’s
//content rectangle shall be the same as the distance between their
//end edges.
//End End edge of each child’s allocation rectangle aligned with that of
//the table cell’s content rectangle.
//This attribute shall apply only to elements of structure type TH (Table
//header) or TD (Table data) and controls the placement of all ILSEs that are
//children of the given element. The table cell’s content rectangle (see
//14.8.5.4.5, "Content and Allocation Rectangles") shall become the reference
//area for all of its descendants.
//Default value: Start.
//TBorderStyle name or
//array
//(Optional; inheritable; PDF 1.5) The style of the border drawn on each edge
//of a table cell. Allowed values shall be the same as those specified for
//BorderStyle (see "Table 379 — Additional standard layout attributes
//specific to block-level structure elements"). If both TBorderStyle and
//BorderStyle apply to a given table cell, BorderStyle shall supersede
//TBorderStyle.
//Default value: None.
//TPadding integer
//or array
//(Optional; inheritable; PDF 1.5) Specifies an offset to account for the
//separation between the table cell’s content rectangle and the surrounding
//border (see 14.8.5.4.5, "Content and Allocation Rectangles"). If both
//TPadding and Padding apply to a given table cell, Padding shall supersede
//TPadding. A positive value shall enlarge the background area; a negative
//value shall trim it, and the border may overlap the element’s text or graphic.
//The value shall be either a single number representing the width of the
//padding, in default user space units, that applies to all four edges of the
//table cell, or a 4-entry array representing the padding width for the before
//edge, after edge, start edge, and end edge, respectively, of the content
//rectangle.
//Default value: 0.
//14.8.5.4.4 Layout Attributes for ILSEs
//The attributes described in "Table 380 — Standard layout attributes specific to inline-level structure
//elements" apply to inline-level structure elements (ILSEs). They may also be specified for a block-level
//element (BLSE) and may apply to any content items that are its immediate children.
//© ISO 2020 – All rights reserved 783
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 380 — Standard layout attributes specific to inline-level structure elements
//Key Type Value
//BaselineShift number (Optional; not inheritable) The distance, in default user space units,
//by which the element’s baseline shall be shifted relative to that of its
//parent element. The shift direction shall be the opposite of the
//block-progression direction specified by the prevailing
//WritingMode attribute (see "General Layout Attributes" in 14.8.5.4,
//"Layout Attributes"). Thus, positive values shall shift the baseline
//toward the before edge and negative values toward the after edge of
//the reference area (upward and downward, respectively, in
//Western writing systems).
//Default value: 0.
//The shifted element may be a superscript, a subscript, or an inline
//graphic. The shift shall apply to the element, its content, and all of
//its descendants. Any further baseline shift applied to a child of this
//element shall be measured relative to the shifted baseline of this
//(parent) element.
//LineHeight number
//or name
//(Optional; inheritable) The element’s preferred height, measured in
//default user space units in the block-progression direction. The
//height of a line of text is determined by the largest LineHeight
//value for any complete or partial ILSE that it contains.
//The name Normal or Auto in place of a numeric value shall indicate
//that no specific height constraint is to be imposed. The element’s
//height shall be set to a reasonable value based on the content’s font
//size:
//Normal Adjust the line height to include any non-zero value
//specified for BaselineShift.
//Auto Adjustment for the value of BaselineShift shall not be
//made.
//Default value: Normal.
//The meaning of the term "reasonable value" is left to the PDF
//processor to determine. It should be approximately 1.2 times the
//font size, but this value may vary depending on the export format.
//This attribute applies to all ILSEs (including implicit ones) that are
//children of this element or of its nested ILSEs, if any. It shall not
//apply to nested BLSEs.
//When translating to a specific export format, the values Normal and
//Auto, if specified, shall be used directly if they are available in the
//target format.
//NOTE 1 In the absence of a numeric value for LineHeight or an explicit
//value for the font size, a reasonable method of calculating the line
//height from the information in a tagged PDF file is to find the
//difference between the associated font’s Ascent and Descent
//values (see 9.8, "Font descriptors"), map it from glyph space to
//default user space (see 9.4.4, "Text space details"), and use the
//maximum resulting value for any character in the line.
//784 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//TextPosition name (Optional; inheritable; PDF 2.0) The position of the element relative
//the immediately surrounding content. Valid values are:
//Sup Position is elevated, like for superscript.
//Sub Position is lowered, like for subscript
//Normal Position is neither elevated nor lowered.
//Default value: Normal
//TextPosition does not imply any specific semantic.
//NOTE 2 As a consequence, it cannot be determined whether text with a
//TextPosition attribute of Sup is a footnote number, an exponent,
//an index or some other use of the text. For mathematical
//expressions, MathML structure elements provide a richer
//semantic for superscripted or subscripted content.
//TextDecorationColor array (Optional; inheritable; PDF 1.5) The colour to be used for drawing
//text decorations. The value shall be an array of three numbers in the
//range 0.0 to 1.0, representing the red, green, and blue values,
//respectively, of an RGB colour space. If this attribute is not specified,
//the text decoration colour for this element shall be the current fill
//colour in effect at the start of its associated content.
//TextDecorationThickness number (Optional; inheritable; PDF 1.5) The thickness of each line drawn as
//part of the text decoration. The value shall be a non-negative
//number in default user space units representing the thickness (0 is
//interpreted as the thinnest possible line). If this attribute is not
//specified, it shall be derived from the current stroke thickness in
//effect at the start of the element’s associated content, transformed
//into default user space units.
//TextDecorationType name (Optional; inheritable only for directly nested ILSEs) The text
//decoration, if any, to be applied to the element’s text. Valid values
//are:
//None  No text decoration
//Underline  A line below the text
//Overline A line above the text
//LineThrough A line through the middle of the text
//Default value: None.
//This attribute shall apply to all text content items that are children
//of this element or of its nested ILSEs, if any. The attribute shall not
//apply to nested BLSEs or to content items other than text.
//The colour, position, and thickness of the decoration shall be
//uniform across all children, regardless of changes in colour, font
//size, or other variations in the content’s text characteristics.
//© ISO 2020 – All rights reserved 785
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//RubyAlign name (Optional; inheritable; PDF 1.5) The justification of the lines within a
//ruby assembly. Valid values are:
//Start The content shall be aligned on the start edge in the
//inline-progression direction.
//Center The content shall be centred in the inline-progression
//direction.
//End The content shall be aligned on the end edge in the
//inline-progression direction.
//Justify The content shall be expanded to fill the available
//width in the inline-progression direction.
//Distribute The content shall be expanded to fill the available
//width in the inline-progression direction. However,
//space shall also be inserted at the start edge and end
//edge of the text. The spacing shall be distributed using
//a 1:2:1 (start:infix:end) ratio. It shall be changed to a
//0:1:1 ratio if the ruby appears at the start of a text line
//or to a 1:1:0 ratio if the ruby appears at the end of the
//text line.
//Default value: Distribute.
//This attribute may be specified on the RB and RT elements. When a
//ruby is formatted, the attribute shall be applied to the shorter line of
//these two elements. For example, if the RT element has a shorter
//width than the RB element, the RT element shall be aligned as
//specified in its RubyAlign attribute.
//RubyPosition name (Optional; inheritable; PDF 1.5) The placement of the RT structure
//element relative to the RB element in a ruby assembly. Valid values
//are:
//Before The RT content shall be aligned along the before edge of the
//element.
//After The RT content shall be aligned along the after edge of the
//element.
//WarichuThe RT and associated RP elements shall be formatted as a
//warichu, following the RB element.
//Inline The RT and associated RP elements shall be formatted as a
//parenthesis comment, following the RB element.
//Default value: Before.
//786 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//GlyphOrientationVertical number
//or name
//(Optional; inheritable; PDF 1.5) Specifies the orientation of glyphs
//when the inline-progression direction is top to bottom or bottom to
//top. Valid values are:
//angle A number representing the clockwise rotation in degrees of
//the top of the glyphs relative to the top of the reference
//area. Shall be a multiple of 90 degrees between -180 and
//+360.
//Auto Specifies a default orientation for text, depending on
//whether it is fullwidth (as wide as it is high). Fullwidth
//Latin and fullwidth ideographic text (excluding ideographic
//punctuation) shall be set with an angle of 0. Ideographic
//punctuation and other ideographic characters having
//alternate horizontal and vertical forms shall use the vertical
//form of the glyph. Non-fullwidth text shall be set with an
//angle of 90.
//Default value: Auto.
//NOTE 3 This attribute is used most commonly to differentiate between
//the preferred orientation of alphabetic (non-ideographic) text in
//vertically written Japanese documents (Auto or 90) and the
//orientation of the ideographic characters and/or alphabetic (non-
//ideographic) text in western signage and advertising (90).
//This attribute shall affect both the alignment and width of the
//glyphs. If a glyph is perpendicular to the vertical baseline, its
//horizontal alignment point shall be aligned with the alignment
//baseline for the script to which the glyph belongs. The width of the
//glyph area shall be determined from the horizontal width font
//characteristic for the glyph.
//14.8.5.4.5 Content and allocation rectangles
//As defined in 14.8.3, "Basic Layout Model" an element’s content rectangle is an enclosing rectangle
//derived from the shape of the element’s content, which shall define the bounds used for the layout of
//any included child elements. The allocation rectangle includes any additional borders or spacing
//surrounding the element, affecting how it shall be positioned with respect to adjacent elements and the
//enclosing content rectangle or reference area.
//The exact definition of the content rectangle shall depend on the element’s structure type:
//• For a table cell (structure type TH or TD), the content rectangle is determined from the bounding
//box of all graphics objects in the cell’s content, taking into account any explicit bounding boxes
//(such as the BBox entry in a form XObject). This implied size may be explicitly overridden by the
//cell’s Width and Height attributes. The cell’s height shall be adjusted to equal the maximum
//height of any cell in its row; its width shall be adjusted to the maximum width of any cell in its
//column.
//• For any other BLSE other than TH and TD, the height of the content rectangle shall be the sum of
//the heights of all BLSEs it contains, plus any additional spacing adjustments between these
//elements.
//• For an ILSE that contains text, the height of the content rectangle shall be set by the LineHeight
//attribute. The width shall be determined by summing the widths of the contained characters,
//adjusted for any indents, letter spacing, word spacing, or line-end conditions.
//© ISO 2020 – All rights reserved 787
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//• For an ILSE that contains an illustration or table, the content rectangle shall be determined from
//the bounding box of all graphics objects in the content, and shall take into account any explicit
//bounding boxes (such as the BBox entry in a form XObject). This implied size may be explicitly
//overridden by the element’s Width and Height attributes.
//• For an ILSE that contains a mixture of elements, the height of the content rectangle shall be
//determined by aligning the child objects relative to one another based on their text baseline (for
//text ILSEs) or end edge (for non-text ILSEs), along with any applicable BaselineShift attribute
//(for all ILSEs), and finding the extreme top and bottom for all elements.
//NOTE PDF processors can apply this process to all elements within the block or apply it on a line-by-
//line basis.
//The allocation rectangle shall be derived from the content rectangle in a way that also depends on the
//structure type:
//• For a BLSE, the allocation rectangle shall be equal to the content rectangle with its before and
//after edges adjusted by the element’s SpaceBefore and SpaceAfter attributes, if any, but with no
//changes to the start and end edges.
//• For an ILSE, the allocation rectangle is the same as the content rectangle.
//14.8.5.4.6 Figure, Form and Formula attributes
//Particular uses of Figure, Form or Formula elements shall have additional restrictions:
//• When a Figure, Form or Formula element has a Placement attribute of Block, it shall have a
//Height attribute with an explicitly specified numerical value (not Auto). This value shall be the
//sole source of information about the element’s extent in the block-progression direction.
//• When a Figure, Form or Formula element has a Placement attribute of Inline, it shall have a
//Width attribute with an explicitly specified numerical value (not Auto). This value shall be the
//sole source of information about the element’s extent in the inline-progression direction.
//• When a Figure, Form or Formula element has a Placement attribute of Inline, Start, or End, the
//value of its BaselineShift attribute shall be used to determine the position of its after edge
//relative to the text baseline; BaselineShift shall be ignored for all other values of Placement. (A
//Figure, Form or Formula element with a Placement value of Start may be used to create a
//dropped capital; one with a Placement value of Inline may be used to create a raised capital.)
//14.8.5.4.7 Column attributes
//The attributes described in "Table 381 — Standard layout attributes specific to standard column
//attributes" shall be present for the grouping elements (see 14.8.4.4, "Grouping level structure types") if
//the content in the grouping element is divided into columns.
//Table 381 — Standard layout attributes specific to standard column attributes
//Key Type Value
//ColumnCount integer (Optional; not inheritable; PDF 1.6) The number of columns in the
//content of the grouping element.
//Default value: 1.
//788 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//ColumnGap number or
//array
//(Optional; not inheritable; PDF 1.6) The desired space between
//adjacent columns, measured in default user space units in the
//inline-progression direction. If the value is a number, it specifies
//the space between all columns. If the value is an array, it should
//contain numbers, the first element specifying the space between
//the first and second columns, the second specifying the space
//between the second and third columns, and so on. If there are
//fewer than ColumnCount - 1 numbers, the last element shall
//specify all remaining spaces; if there are more than ColumnCount
//- 1 numbers, the excess array elements shall be ignored.
//ColumnWidths number or
//array
//(Optional; not inheritable; PDF 1.6) The desired width of the
//columns, measured in default user space units in the inline-
//progression direction. If the value is a number, it specifies the
//width of all columns. If the value is an array, it shall contain
//numbers, representing the width of each column, in order. If there
//are fewer than ColumnCount numbers, the last element shall
//specify all remaining widths; if there are more than ColumnCount
//numbers, the excess array elements shall be ignored.
//14.8.5.5 List attributes
//If present, the List attributes described in "Table 382 — Standard list attributes" shall appear in an L
//(List) element. These attributes control the interpretation of the Lbl (Label) elements (see “Table 368
//— General inline level structure types” within the list’s LI (List Item) elements (see 14.8.4.8.2,
//"Standard structure types for Lists"). These attributes may only be defined in attribute objects whose O
//(owner) entry has the value List or whose owner is any other owner excluding Layout, Table,
//PrintField and Artifact.
//The ContinuedList and the ContinuedFrom attributes described in "Table 382 — Standard list
//attributes" control the interpretation of the L element as it relates to other L elements that are not its
//immediate parent.
//© ISO 2020 – All rights reserved 789
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 382 — Standard list attributes
//Key Type Value
//ListNumbering name (Optional; inheritable) The numbering system used to generate the content
//of the Lbl (Label) elements in a numbered list, or the type of symbol in the
//content of the Lbl (Label) elements used to identify list items in an
//unnumbered list (see "Table 368 — General inline level structure types").
//The value of the ListNumbering shall be one of the following, and shall be
//applied as described here.
//None No numbering system; Lbl elements (if present) contain
//arbitrary text not subject to any numbering scheme
//Unordered (PDF 2.0) Unordered list with unspecified bullets
//Description (PDF 2.0) A list of terms for corresponding definitions
//NOTE The Description value was added in this document (2020).
//Disc Solid circular bullet
//Circle Open circular bullet
//Square Solid square
//Ordered (PDF 2.0) Ordered lists with unspecified numbering
//Decimal Decimal Arabic numerals (1–9, 10–99, … )
//UpperRoman Uppercase Roman numerals (I, II, III, IV, … )
//LowerRoman Lowercase Roman numerals (i, ii, iii, iv, … )
//UpperAlpha Uppercase letters (A, B, C, .. )
//LowerAlpha Lowercase letters (a, b, c, … )
//Default value: None.
//A list is an unordered list unless the ListNumbering attribute is present
//with one of the following values: Ordered, Decimal, UpperRoman,
//LowerRoman, UpperAlpha or LowerAlpha, in which case the list is an
//ordered list.
//The alphabet used for UpperAlpha and LowerAlpha is determined by the
//prevailing Lang entry (see 14.9.2, "Natural language specification").
//ContinuedList boolean (Optional; PDF 2.0) A flag specifying whether the list is a continuation of a
//previous list in the structure tree (true), or not (false). Default value: false.
//If the ContinuedFrom attribute is not present, the continuation is from the
//preceding list at the same level in the structure hierarchy.
//ContinuedFrom ID (byte
//string)
//(Optional; PDF 2.0) The ID (see “Table 355 — Entries in a structure
//element dictionary") of the list for which this list is a continuation.
//NOTE The ListNumbering attribute allows a content extraction tool to autonumber a list. However, the
//list’s Lbl structure elements can contain the resulting numbers explicitly, so that the document
//can be reused without autonumbering.
//14.8.5.6 PrintField attributes
//The attributes described in the next table define the accessibility mechanism for non-interactive PDF
//forms (see 12.7.9, "Non-interactive forms"). Such forms may have originally contained interactive
//fields such as text fields and radio buttons but were then converted into non-interactive PDF files, or
//they may have been designed to be printed out and filled in manually. Since the form’s fields cannot be
//determined from interactive elements, form field roles and values in a non-interactive form field are
//defined using a PrintField attribute on respective Form elements (see "Table 383 — PrintField
//790 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//attributes") enclosing each set of content representing a non-interactive form field. This attribute may
//only be defined in attribute objects whose O (owner) entry has the value PrintField or whose owner is
//any other owner excluding Layout, List, Table and Artifact.
//Table 383 — PrintField attributes
//Key Type Value
//Role name (Optional; not inheritable; PDF 1.7) The type of form field represented. The
//value of Role shall be one of the following:
//rb Radio button
//cb Check box
//pb Push button
//tv Text-value field
//lb Listbox field
//The tv role shall be used for non-interactive fields with textual values. The
//text that is the value of the field shall be the content of the Form structure
//element (see "Table 368 — General inline level structure types").
//NOTE 1 Examples include text edit fields, numeric fields, password fields, digital
//signature fields and combo box fields.
//Semantic groupings of non-interactive form fields and associated content
//(for example, a set of radio button fields associated with a label) should be
//enclosed within a Part structure element.
//Default value: None specified.
//Checked,
//checked
//name (Optional; not inheritable; PDF 1.7; lower case form is deprecated in PDF 2.0)
//The state of a radio button or check box field. The value shall be one of: on,
//off, or neutral.
//NOTE 2 In earlier versions of PDF the case (capitalization) used for this key did
//not conform to the same conventions used elsewhere in this standard.
//Default value: off.
//Desc text string (Optional; not inheritable; PDF 1.7) The alternate name of the field.
//NOTE 3 Similar to the value supplied in the TU entry of the field dictionary for
//interactive fields (see "Table 226 — Entries common to all field
//dictionaries").
//14.8.5.7 Table attributes
//The table attributes, as described in "Table 384 — Standard table attributes"
//, may only be defined in
//attribute objects whose O (owner) entry has the value Table or whose owner is any other owner
//excluding Layout, List, PrintField and Artifact.
//© ISO 2020 – All rights reserved 791
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Table 384 — Standard table attributes
//Key Type Value
//RowSpan integer (Optional; not inheritable) The number of rows in the enclosing table that shall
//be spanned by the cell.
//The cell shall expand by adding rows in the block-progression direction specified
//by the table’s WritingMode attribute.
//Default value: 1.
//This entry shall only have an effect for structure elements of type of TH or TD.
//ColSpan integer (Optional; not inheritable) The number of columns in the enclosing table that
//shall be spanned by the cell.
//The cell shall expand by adding columns in the inline-progression direction
//specified by the table’s WritingMode attribute.
//Default value: 1.
//This entry shall only have an effect for structure elements of type of TH or TD.
//Headers array (Optional; not inheritable) An array of byte strings, where each string shall be the
//element identifier (see the ID entry in "Table 355 — Entries in a structure
//element dictionary") for a TH structure element that shall be used as a header
//associated with this cell.
//This entry shall only have an effect for structure elements of type of TH or TD.
//The order in which the entries in the Headers array are listed shall be row IDs
//followed by column IDs. The row and column IDs shall be ordered from most
//specific to most general.
//If the scope for any cells with an ID listed in the Headers attribute of a cell
//cannot be determined by the default algorithm defined in 14.8.4.8.3, "Table
//structure types", those header cells shall specify a Scope so that the header can
//be determined to be either a row header, a column header or both.
//This attribute may apply to header cells (TH) as well as data cells (TD).
//Therefore, the headers associated with any cell shall be those in its Headers
//array plus those in the Headers array of any TH cells in that array, and so on
//recursively.
//Scope name (Optional; not inheritable; PDF 1.5) A name whose value shall be one of the
//following: Row, Column, or Both.
//This entry shall only have an effect for structure elements of type of TH.
//If a Scope is not specified for a TH structure element, then the assumed value for
//the Scope shall be determined as follows, taking into account the current value
//for WritingMode:
//• if it is in the first row and column, the Scope is assumed to be Both;
//• otherwise, if it is in the first row, the Scope is assumed to be Column.
//• otherwise, if it is in the first column, the Scope is assumed to be Row.
//• otherwise, the Scope is assumed to be Both.
//These assumptions are used by the algorithm following "Table 371 — Table
//standard structure types" for determining which headers are associated with a
//cell.
//792 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//Summary text
//string
//(Optional; not inheritable; PDF 1.7) A summary of the table’s purpose and
//structure. This entry shall only be used within Table structure elements (see
//Table 371 — Table standard structure types”
//.
//NOTE For use in non-visual rendering such as speech or braille. The Summary key
//was restored in this document (2020).
//Short text
//string
//(Optional; not inheritable; PDF 2.0) Contains a short form of the content of a TH
//structure element’s content.
//This entry shall only have an effect for structure elements of type of TH.
//EXAMPLE When accessed by means of a screen reader, for each table cell the
//applicable header cells are read to the user in order to allow that user
//to understand the content of the table cell. It can become cumbersome
//for a user to repeatedly have to listen to the full contents of a TH
//structure element. An option to have the short form of the content of
//the TH structure element read out aloud is sometimes preferred.
//14.8.5.8 Artifact attributes
//The artifact attributes described in "Table 385 — Standard artifact attributes" may only be defined in
//attribute objects whose O (owner) entry has the value Artifact or whose owner is any other owner
//excluding Layout, List, PrintField and Table.
//Table 385 — Standard artifact attributes
//Key Type Value
//Type Name (Optional) The type of artifact that this attribute describes; if present, shall
//be one of the names Pagination, Layout, Page or Inline (PDF 2.0).
//• Pagination artifacts are ancillary page features such as running heads or
//folios (page numbers)
//• Layout artifacts are purely cosmetic typographical or design elements such as
//footnote rules or decorative ornaments
//• Page artifacts are production aids extraneous to the document itself, such as
//cut marks and print control patches
//• Inline artifacts enclose artifact content that has context in the document’s
//logical structure, typically, artifacts of subtype LineNum or Redaction
//NOTE Inline artifacts can be used to provide context in the logical structure to
//any artifact. This is similar to an inline structure element.
//BBox rectangle (Optional) An array of four numbers in default user space units giving the
//coordinates of the left, bottom, right, and top edges, respectively, of
//the artifact’s bounding box (the rectangle that completely encloses its
//visible extent).
//© ISO 2020 – All rights reserved 793
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Key Type Value
//Subtype Name (Optional; PDF 1.7) The subtype of the artifact. This entry should appear
//only when the Type entry has a value of Pagination or Inline. Valid values
//are Header, Footer, Watermark, PageNum (PDF 2.0), Bates (PDF 2.0),
//LineNum (PDF 2.0) and Redaction (PDF 2.0). Additional values may be
//specified for this entry, provided they comply with the naming conventions
//described in Annex E, "Extending PDF".
//14.8.6 Standard structure namespaces
//14.8.6.1 Namespaces for standard structure types and attributes
//The namespace mechanism defined as part of logical structure (see 14.7.4, "Namespaces") in PDF 2.0
//defines a more robust means of interchanging tagsets than was previously possible. The standard
//structure types and attributes defined within the previous clauses (see 14.8.4, "Standard structure
//types" and 14.8.5, "Standard structure attributes") effectively define a schema for a tagset in PDF. This
//schema is called the standard structure namespace for PDF 2.0, which shall be defined by the
//namespace name:
//"http://iso.org/pdf2/ssn"
//ISO 32000-1:2008, Clause 14.8, "Tagged PDF" describes the schema for the standard structure types
//and attributes that were defined prior to PDF 2.0 and the rules for processing documents tagged using
//them. This schema shall be known as the standard structure namespace for PDF 1.7, and shall be
//defined by the namespace name:
//"http://iso.org/pdf/ssn"
//To facilitate conversion of documents created against versions of the PDF standard earlier than PDF
//2.0, the default standard structure namespace shall be "http://iso.org/pdf/ssn"
//. When a namespace is
//not explicitly specified for a given structure element or attribute, it shall be assumed to be within this
//default standard structure namespace.
//NOTE Annex M,
//"Differences between the standard structure namespaces" lists the standard structure
//types defined in the default (PDF 1.7) namespace.
//The term standard structure namespaces refers to either of the two namespaces defined above.
//14.8.6.2 Role maps and namespaces
//Role maps prior to the introduction of namespaces identify a given structure element and map it to
//another structure element. This can be applied transitively to allow a structure element to be mapped
//through multiple steps to a final structure element. Tagged PDF requires that all structure elements be
//role mapped to a standard structure type except where explicitly stated in this subclause.
//The introduction of namespaces adds complexity here, since there may be multiple structure element
//dictionaries specifying the same structure type name (see "Table 355 — Entries in a structure element
//dictionary"), but from a different namespace, which require different mappings. To enable support for
//this, a namespace dictionary (see 14.7.4.2, "Namespace dictionary") can define a role map specific to it.
//794 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//When processing a structure element dictionary within a tagged PDF document, if the structure
//element does not explicitly identify its namespace using an NS entry, it should use the RoleMap entry
//in the Structure Tree Root dictionary (see "Table 354 — Entries in the structure tree root") to
//determine its role mapping, if any. If the structure element is in an explicit namespace, then that
//namespace shall be identified in the structure tree root dictionary’s Namespaces array entry and the
//RoleMapNS entry within that namespace dictionary shall provide the role mapping, if any.
//In a tagged PDF, all structure elements shall be in at least one of the standard structure namespaces or
//in a namespace identified in 14.8.6.3, “Other namespaces”. An element shall be considered to be in one
//of these namespaces if:
//• they directly identify one of these namespaces through their NS entry;
//• they are in the default standard structure namespace;
//• they are role mapped into the namespace, either directly or transitively.
//NOTE 1 This provision facilitates interoperability by allowing a structure element to be in multiple
//namespaces, including the standard structure namespace for PDF 1.7 and the standard structure
//namespace for PDF 2.0.
//NOTE 2 The above paragraph and bullets were rewritten in this document (2020).
//14.8.6.3 Other namespaces
//The standard structure types (see 14.8.4, "Standard structure types") address many of the structural
//elements that commonly exist within general documents. However, the ILSEs defined do not provide
//sufficient structure to support domain specific languages. An example of such a language is
//mathematics, which is common to many classes of documents. This subclause identifies any domain
//specific languages that are common within broad ranges of documents types. Namespaces identified in
//this subclause do not require a RoleMapNS entry in their respective namespace dictionary.
//MathML 3.0 defines a domain specific schema for representing mathematics. The namespace name
//(see 14.7.4.2, "Namespace dictionary"), as would be identified by the NS entry in a namespace
//dictionary, shall have the value:
//“http://www.w3.org/1998/Math/MathML”
//NOTE 1 MathML is the only domain-specific namespace defined in PDF 2.0.
//When including mathematics structured as MathML 3.0, the math structure element type as defined in
//MathML 3.0 shall be used, and shall have its namespace explicitly defined (see 14.7.4.2, "Namespace
//dictionary").
//NOTE 2 The math structure element type is all lowercase to match the MathML 3.0 specification.
//Any other namespaces can be specified within a PDF document, but shall meet the requirements of role
//mapping described in 14.8.6.2, "Role maps and namespaces"
//.
//© ISO 2020 – All rights reserved 795
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)

