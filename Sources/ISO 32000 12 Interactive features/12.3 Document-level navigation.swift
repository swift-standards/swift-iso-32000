// ISO 32000-2:2020, 12.3 Document-level navigation
//
// Sections:
//   12.3.1  General
//   12.3.2  Destinations
//   12.3.3  Document outline
//   12.3.4  Thumbnail images
//   12.3.5  Collections
//   12.3.6  Navigators

public import Geometry
public import IEC_61966
import ISO_32000_8_Graphics
public import ISO_32000_Shared

extension ISO_32000.`12` {
    /// ISO 32000-2:2020, 12.3 Document-level navigation
    public enum `3` {}
}

// MARK: - 12.3.2 Destinations (Table 149)

extension ISO_32000 {
    /// A destination in a PDF document (Table 149)
    ///
    /// A destination defines a particular view of a document, consisting of:
    /// - The page of the document that shall be displayed
    /// - The location of the document window on that page
    /// - The magnification (zoom) factor
    ///
    /// Destinations may be associated with outline items, annotations, or actions.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 149 — Destination syntax
    public enum Destination: Sendable, Equatable, Hashable {
        /// Display the page at the given coordinates with zoom factor.
        ///
        /// `[page /XYZ left top zoom]`
        ///
        /// A null value for any parameter specifies that the current value
        /// shall be retained unchanged. A zoom value of 0 has the same
        /// meaning as a null value.
        ///
        /// - Parameters:
        ///   - page: The page index (0-based)
        ///   - left: Left coordinate, or nil for current value
        ///   - top: Top coordinate, or nil for current value
        ///   - zoom: Zoom factor, or nil/0 for current value
        case xyz(
            page: Int,
            left: ISO_32000.UserSpace.X?,
            top: ISO_32000.UserSpace.Y?,
            zoom: Double?
        )

        /// Fit the entire page within the window.
        ///
        /// `[page /Fit]`
        ///
        /// If the required horizontal and vertical magnification factors are
        /// different, use the smaller of the two, centring the page within
        /// the window in the other dimension.
        case fit(page: Int)

        /// Fit the width of the page to the window.
        ///
        /// `[page /FitH top]`
        ///
        /// The vertical coordinate top is positioned at the top edge of the window.
        /// A null value for top specifies that the current value shall be retained.
        case fitH(page: Int, top: ISO_32000.UserSpace.Y?)

        /// Fit the height of the page to the window.
        ///
        /// `[page /FitV left]`
        ///
        /// The horizontal coordinate left is positioned at the left edge of the window.
        /// A null value for left specifies that the current value shall be retained.
        case fitV(page: Int, left: ISO_32000.UserSpace.X?)

        /// Fit the specified rectangle to the window.
        ///
        /// `[page /FitR left bottom right top]`
        ///
        /// If the required horizontal and vertical magnification factors are
        /// different, use the smaller of the two, centring the rectangle
        /// within the window in the other dimension.
        case fitR(
            page: Int,
            left: ISO_32000.UserSpace.X,
            bottom: ISO_32000.UserSpace.Y,
            right: ISO_32000.UserSpace.X,
            top: ISO_32000.UserSpace.Y
        )

        /// Fit the page's bounding box to the window. (PDF 1.1)
        ///
        /// `[page /FitB]`
        ///
        /// The bounding box is the smallest rectangle enclosing all page contents.
        case fitB(page: Int)

        /// Fit the width of the page's bounding box to the window. (PDF 1.1)
        ///
        /// `[page /FitBH top]`
        case fitBH(page: Int, top: ISO_32000.UserSpace.Y?)

        /// Fit the height of the page's bounding box to the window. (PDF 1.1)
        ///
        /// `[page /FitBV left]`
        case fitBV(page: Int, left: ISO_32000.UserSpace.X?)

        /// Named destination (resolved at runtime).
        ///
        /// Instead of being defined directly with explicit syntax, a destination
        /// may be referred to indirectly by means of a name object (PDF 1.1) or
        /// a byte string (PDF 1.2).
        case named(String)

        /// The page index for this destination (nil for named destinations).
        public var pageIndex: Int? {
            switch self {
            case .xyz(let page, _, _, _): return page
            case .fit(let page): return page
            case .fitH(let page, _): return page
            case .fitV(let page, _): return page
            case .fitR(let page, _, _, _, _): return page
            case .fitB(let page): return page
            case .fitBH(let page, _): return page
            case .fitBV(let page, _): return page
            case .named: return nil
            }
        }
    }
}

// MARK: - 12.3.3 Document Outline Namespace

extension ISO_32000 {
    /// Document outline (bookmarks) namespace
    ///
    /// A PDF document may contain a document outline that the interactive
    /// PDF processor may display on the screen, allowing the user to navigate
    /// interactively from one part of the document to another.
    ///
    /// The outline consists of a tree-structured hierarchy of outline items
    /// (sometimes called bookmarks), which serve as a visual table of contents.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 12.3.3 — Document outline
    public enum Outline {}
}

// MARK: - Table 150: Outline Dictionary (Root)

extension ISO_32000.Outline {
    /// The root of a document outline (Table 150)
    ///
    /// The outline dictionary is the root of the document's outline hierarchy
    /// and is referenced from the document catalog's Outlines entry.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 150 — Entries in the outline dictionary
    public struct Root: Sendable {
        /// The outline items at the top level.
        public var items: [Item]

        /// Total count of all visible outline items at all levels.
        ///
        /// Per the spec: "Total number of visible outline items at all levels
        /// of the outline. The value cannot be negative."
        public var count: Int {
            items.reduce(0) { $0 + $1.visibleDescendantCount }
        }

        public init(items: [Item] = []) {
            self.items = items
        }

        /// Check if the outline has any items.
        public var isEmpty: Bool { items.isEmpty }
    }
}

// MARK: - Outline Item Target

extension ISO_32000.Outline {
    /// Target for an outline item activation (Table 151, Dest or A entry)
    ///
    /// Per ISO 32000-2:2020 Table 151:
    /// - **Dest**: The destination that shall be displayed when this item is activated.
    /// - **A**: The action that shall be performed when this item is activated (PDF 1.1).
    ///
    /// These entries are mutually exclusive; only one may be present.
    public enum Target: Sendable {
        /// Navigate to a destination (Dest entry)
        case destination(ISO_32000.Destination)
        /// Perform an action (A entry, PDF 1.1)
        case action(ISO_32000.Action.Kind)
    }
}

// MARK: - Table 151: Outline Item Dictionary

extension ISO_32000.Outline {
    /// An item in the document outline (Table 151)
    ///
    /// An outline item dictionary represents a single entry in the document outline.
    /// Items can have children, forming a tree structure.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 151 — Entries in an outline item dictionary
    public struct Item: Sendable {
        /// The text that shall be displayed on the screen for this item.
        /// (Required)
        public var title: String

        /// The target when this item is activated.
        ///
        /// Per Table 151, either Dest or A may be present, but not both.
        /// If nil, the item has no effect when activated.
        public var target: Target?

        /// Child items under this item.
        public var children: [Item]

        /// Whether this item is open (children visible) by default.
        ///
        /// When an item is open, its immediate children in the hierarchy shall
        /// become visible on the screen. When closed, all descendants shall be hidden.
        public var isOpen: Bool

        /// RGB color for the outline entry's text. (Optional; PDF 1.4)
        ///
        /// Three numbers in the range 0.0 to 1.0, representing the components
        /// in the DeviceRGB colour space. Default: black (0, 0, 0).
        public var color: ISO_32000.DeviceRGB?

        /// Style flags for displaying the outline item's text. (Optional; PDF 1.4)
        ///
        /// See Table 152 — Outline item flags. Default: 0.
        public var flags: ItemFlags

        // MARK: - Computed Properties

        /// Number of visible descendants (used for PDF Count entry).
        ///
        /// If the outline item is open, Count is the sum of the number of visible
        /// descendent outline items at all levels. If closed, Count is negative
        /// and its absolute value is the number of descendants that would be
        /// visible if the outline item were opened.
        public var visibleDescendantCount: Int {
            guard !children.isEmpty else { return 1 }
            if isOpen {
                return 1 + children.reduce(0) { $0 + $1.visibleDescendantCount }
            } else {
                return 1
            }
        }

        // MARK: - Initialization

        public init(
            title: String,
            target: Target? = nil,
            children: [Item] = [],
            isOpen: Bool = true,
            color: ISO_32000.DeviceRGB? = nil,
            flags: ItemFlags = []
        ) {
            self.title = title
            self.target = target
            self.children = children
            self.isOpen = isOpen
            self.color = color
            self.flags = flags
        }

        /// Convenience initializer with a destination.
        public init(
            title: String,
            destination: ISO_32000.Destination,
            children: [Item] = [],
            isOpen: Bool = true,
            color: ISO_32000.DeviceRGB? = nil,
            flags: ItemFlags = []
        ) {
            self.init(
                title: title,
                target: .destination(destination),
                children: children,
                isOpen: isOpen,
                color: color,
                flags: flags
            )
        }

        /// Convenience initializer with an action.
        public init(
            title: String,
            action: ISO_32000.Action.Kind,
            children: [Item] = [],
            isOpen: Bool = true,
            color: ISO_32000.DeviceRGB? = nil,
            flags: ItemFlags = []
        ) {
            self.init(
                title: title,
                target: .action(action),
                children: children,
                isOpen: isOpen,
                color: color,
                flags: flags
            )
        }
    }
}

// MARK: - Table 152: Outline Item Flags

extension ISO_32000.Outline {
    /// Flags specifying style characteristics for displaying outline item text (Table 152)
    ///
    /// Bit positions are numbered from low-order to high-order bits,
    /// with the lowest-order bit numbered 1.
    ///
    /// - Note: PDF 1.4
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 152 — Outline item flags
    public struct ItemFlags: OptionSet, Sendable, Hashable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Bit 1: If set to 1, display the item in italic.
        public static let italic = ItemFlags(rawValue: 1 << 0)

        /// Bit 2: If set to 1, display the item in bold.
        public static let bold = ItemFlags(rawValue: 1 << 1)
    }
}

// MARK: - 12.3.5 Collections (Table 153)

extension ISO_32000.`12`.`3` {
    /// Collection dictionary (Table 153)
    ///
    /// Specifies the viewing and organisational characteristics of portable collections.
    /// If this dictionary is present in a PDF document, the interactive PDF processor
    /// shall present the document as a portable collection.
    ///
    /// - Note: PDF 1.7
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 153 — Entries in a collection dictionary
    public struct Collection: Sendable {
        /// The initial view mode for the collection.
        public var view: CollectionView

        /// A string identifying an entry in the EmbeddedFiles name tree,
        /// determining the document that shall be initially presented.
        public var initialDocument: String?

        /// The collection sort dictionary specifying sort order.
        public var sort: CollectionSort?

        public init(
            view: CollectionView = .details,
            initialDocument: String? = nil,
            sort: CollectionSort? = nil
        ) {
            self.view = view
            self.initialDocument = initialDocument
            self.sort = sort
        }
    }

    /// The initial view mode for a collection (Table 153, View key)
    public enum CollectionView: String, Sendable, Hashable, Codable, CaseIterable {
        /// Details mode: multicolumn format with all schema information.
        case details = "D"

        /// Tile mode: small icons with subset of schema information.
        case tile = "T"

        /// Hidden: collection initially hidden, user can reveal via explicit action.
        case hidden = "H"

        /// Custom navigator (PDF 2.0): use the navigator specified by Navigator entry.
        case custom = "C"
    }

    /// Collection sort dictionary (Table 156)
    ///
    /// Identifies the fields that shall be used to sort items in the collection.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 156 — Entries in a collection sort dictionary
    public struct CollectionSort: Sendable {
        /// The name or names of fields to sort by.
        ///
        /// If multiple fields, each additional field breaks ties.
        public var fields: [String]

        /// Whether to sort in ascending order (true) or descending (false).
        ///
        /// If an array, each element specifies the order for the corresponding field.
        public var ascending: [Bool]

        public init(fields: [String], ascending: [Bool] = [true]) {
            self.fields = fields
            self.ascending = ascending
        }
    }

    /// Collection field subtype (Table 155, Subtype key)
    ///
    /// Identifies the type of data stored in a collection field.
    public enum CollectionFieldSubtype: String, Sendable, Hashable, Codable, CaseIterable {
        // Collection item/subitem field types
        /// Text field (PDF text string)
        case text = "S"
        /// Date field (PDF date string)
        case date = "D"
        /// Number field (PDF number)
        case number = "N"

        // File-related field types
        /// File name from UF or F entry
        case fileName = "F"
        /// Description from Desc entry
        case description = "Desc"
        /// Modification date
        case modificationDate = "ModDate"
        /// Creation date
        case creationDate = "CreationDate"
        /// File size
        case size = "Size"
        /// Compressed size (PDF 2.0)
        case compressedSize = "CompressedSize"
    }
}

// MARK: - 12.3.6 Navigators (Table 160)

extension ISO_32000.`12`.`3` {
    /// Navigator layout types (Table 160)
    ///
    /// Named layouts provide options for presenting collection contents.
    ///
    /// - Note: PDF 2.0
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 160 — Entries in a navigator dictionary
    public enum NavigatorLayout: String, Sendable, Hashable, Codable, CaseIterable {
        /// Details mode (same as View key D)
        case details = "D"

        /// Tile mode (same as View key T)
        case tile = "T"

        /// Hidden mode (same as View key H)
        case hidden = "H"

        /// Film strip: strip of thumbnails with preview of selected attachment.
        case filmStrip = "FilmStrip"

        /// Free form: thumbnails placed randomly in the view.
        case freeForm = "FreeForm"

        /// Linear: large preview with metadata displayed alongside.
        case linear = "Linear"

        /// Tree: folder structure with files as leaf nodes.
        case tree = "Tree"
    }
}

// MARK: - Outline Builder

extension ISO_32000.Outline {
    /// Builds a hierarchical outline from a flat list of headings.
    ///
    /// This is a convenience method for creating bookmarks from document headings.
    /// Headings are organized into a tree based on their level (H1 > H2 > H3, etc.).
    ///
    /// Example:
    /// ```
    /// H1 "Chapter 1"
    ///   H2 "Section 1.1"
    ///   H2 "Section 1.2"
    ///     H3 "Subsection 1.2.1"
    /// H1 "Chapter 2"
    /// ```
    /// Build an outline from a flat list of headings.
    ///
    /// - Parameters:
    ///   - headings: Flat list of headings with level, title, page index, and Y position
    ///   - openToLevel: Maximum heading level to expand by default (1 = only H1 expanded, 2 = H1 and H2, etc.)
    ///                  Default is 1 (H1 expanded, H2+ collapsed)
    ///   - color: RGB color for all outline items (nil uses viewer default, typically black)
    ///   - flags: Style flags (bold/italic) for all outline items
    public static func build(
        from headings: [(
            level: Int,
            title: String,
            pageIndex: Int,
            yPosition: ISO_32000.UserSpace.Y
        )],
        openToLevel: Int = 1,
        color: ISO_32000.DeviceRGB? = nil,
        flags: ItemFlags = []
    ) -> Root {
        guard !headings.isEmpty else { return Root() }

        var rootItems: [Item] = []
        var stack: [(level: Int, item: Item)] = []

        for heading in headings {
            let destination = ISO_32000.Destination.xyz(
                page: heading.pageIndex,
                left: nil,
                top: heading.yPosition,
                zoom: nil
            )
            // Items at or below openToLevel are expanded, others collapsed
            let item = Item(
                title: heading.title,
                target: .destination(destination),
                children: [],
                isOpen: heading.level <= openToLevel,
                color: color,
                flags: flags
            )

            while let last = stack.last, last.level >= heading.level {
                let (_, child) = stack.removeLast()
                if stack.isEmpty {
                    rootItems.append(child)
                } else {
                    var (parentLevel, parentItem) = stack.removeLast()
                    parentItem = Item(
                        title: parentItem.title,
                        target: parentItem.target,
                        children: parentItem.children + [child],
                        isOpen: parentItem.isOpen,
                        color: parentItem.color,
                        flags: parentItem.flags
                    )
                    stack.append((parentLevel, parentItem))
                }
            }

            stack.append((heading.level, item))
        }

        while let (_, child) = stack.popLast() {
            if stack.isEmpty {
                rootItems.append(child)
            } else {
                var (parentLevel, parentItem) = stack.removeLast()
                parentItem = Item(
                    title: parentItem.title,
                    target: parentItem.target,
                    children: parentItem.children + [child],
                    isOpen: parentItem.isOpen,
                    color: parentItem.color,
                    flags: parentItem.flags
                )
                stack.append((parentLevel, parentItem))
            }
        }

        return Root(items: rootItems)
    }
}

// MARK: - Section Typealiases

extension ISO_32000.`12`.`3` {
    /// Outline root (Table 150)
    public typealias OutlineRoot = ISO_32000.Outline.Root

    /// Outline item (Table 151)
    public typealias OutlineItem = ISO_32000.Outline.Item

    /// Outline item target (Table 151, Dest/A entries)
    public typealias OutlineItemTarget = ISO_32000.Outline.Target

    /// Outline item flags (Table 152)
    public typealias OutlineItemFlags = ISO_32000.Outline.ItemFlags

    /// Destination (Table 149)
    public typealias Destination = ISO_32000.Destination
}

// MARK: - Convenience Typealiases

extension ISO_32000 {
    /// Device-dependent RGB color space.
    ///
    /// Per ISO 32000-2:2020, DeviceRGB colors are three components in the range 0.0 to 1.0.
    /// This typealias uses sRGB (IEC 61966-2-1) for convenience, as most PDF viewers
    /// interpret DeviceRGB values as sRGB in practice.
    public typealias DeviceRGB = IEC_61966.sRGB

    /// Convenience typealias for outline root
    public typealias OutlineRoot = Outline.Root

    /// Convenience typealias for outline item
    public typealias OutlineItem = Outline.Item

    /// Convenience typealias for outline item target
    public typealias OutlineItemTarget = Outline.Target

    /// Convenience typealias for outline item flags
    public typealias OutlineItemFlags = Outline.ItemFlags
}
