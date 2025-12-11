// ISO 32000-2:2020, 12.3 Document-level navigation
//
// Sections:
//   12.3.1  General
//   12.3.2  Destinations
//   12.3.3  Document outline
//   12.3.4  Thumbnail images
//   12.3.5  Collections

public import Geometry
public import ISO_32000_Shared
public import ISO_32000_8_Graphics

extension ISO_32000.`12` {
    /// ISO 32000-2:2020, 12.3 Document-level navigation
    public enum `3` {}
}

// MARK: - Outline Namespace

extension ISO_32000 {
    /// Document outline (bookmarks) namespace
    ///
    /// Per ISO 32000-2:2020 Section 12.3.3:
    /// > A PDF document may contain a document outline that the interactive PDF
    /// > processor may display on the screen, allowing the user to navigate
    /// > interactively from one part of the document to another.
    public enum Outline {}
}

// MARK: - 12.3.3 Outline Root (Table 150)

extension ISO_32000.Outline {
    /// The root of a document outline (bookmarks).
    ///
    /// Per ISO 32000-2:2020 Table 150, the outline dictionary is the root of
    /// the document's outline hierarchy and is referenced from the document
    /// catalog's Outlines entry.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 150 — Entries in the outline dictionary
    public struct Root: Sendable {
        /// The outline items at the top level
        public var items: [Item]

        /// Total count of all visible outline items at all levels
        /// (negative if outline is closed by default)
        public var count: Int {
            items.reduce(0) { $0 + $1.visibleDescendantCount }
        }

        public init(items: [Item] = []) {
            self.items = items
        }

        /// Check if the outline has any items
        public var isEmpty: Bool { items.isEmpty }
    }
}

// MARK: - 12.3.3 Outline Item (Table 151)

extension ISO_32000.Outline {
    /// An item in the document outline (bookmark).
    ///
    /// Per ISO 32000-2:2020 Table 151, an outline item dictionary represents
    /// a single entry in the document outline. Items can have children,
    /// forming a tree structure.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 151 — Entries in an outline item dictionary
    public struct Item: Sendable {
        /// The text to be displayed for this item
        public var title: String

        /// The destination to jump to when this item is activated
        public var destination: ISO_32000.Destination

        /// Child items under this item (nil means no children)
        public var children: [Item]

        /// Whether this item is open (children visible) by default
        public var isOpen: Bool

        /// Number of visible descendants (used for PDF Count entry)
        public var visibleDescendantCount: Int {
            guard !children.isEmpty else { return 1 }
            if isOpen {
                return 1 + children.reduce(0) { $0 + $1.visibleDescendantCount }
            } else {
                return 1
            }
        }

        public init(
            title: String,
            destination: ISO_32000.Destination,
            children: [Item] = [],
            isOpen: Bool = true
        ) {
            self.title = title
            self.destination = destination
            self.children = children
            self.isOpen = isOpen
        }
    }
}

// MARK: - 12.3.2 Destination (Table 149)

extension ISO_32000 {
    /// A destination in a PDF document.
    ///
    /// Per ISO 32000-2:2020 Section 12.3.2, a destination defines a particular
    /// view of a document, consisting of a page and the manner of display.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 149 — Destination syntax
    public enum Destination: Sendable, Equatable, Hashable {
        /// Display the page at the given coordinates
        /// - Parameters:
        ///   - page: The page index (0-based)
        ///   - left: Left coordinate, or nil for current value
        ///   - top: Top coordinate, or nil for current value
        ///   - zoom: Zoom factor, or nil for current value
        case xyz(page: Int, left: ISO_32000.UserSpace.Unit?, top: ISO_32000.UserSpace.Unit?, zoom: Double?)

        /// Fit the page to the window
        case fit(page: Int)

        /// Fit the width of the page to the window
        case fitH(page: Int, top: ISO_32000.UserSpace.Unit?)

        /// Fit the height of the page to the window
        case fitV(page: Int, left: ISO_32000.UserSpace.Unit?)

        /// Fit the specified rectangle to the window
        case fitR(page: Int, left: ISO_32000.UserSpace.Unit, bottom: ISO_32000.UserSpace.Unit, right: ISO_32000.UserSpace.Unit, top: ISO_32000.UserSpace.Unit)

        /// Fit the page's bounding box to the window
        case fitB(page: Int)

        /// Fit the width of the page's bounding box to the window
        case fitBH(page: Int, top: ISO_32000.UserSpace.Unit?)

        /// Fit the height of the page's bounding box to the window
        case fitBV(page: Int, left: ISO_32000.UserSpace.Unit?)

        /// Named destination (resolved at runtime)
        case named(String)

        /// The page index for this destination
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
    /// Produces a nested outline where H2s are children of H1s, H3s are children of H2s, etc.
    public static func build(
        from headings: [(level: Int, title: String, pageIndex: Int, yPosition: ISO_32000.UserSpace.Y)]
    ) -> Root {
        guard !headings.isEmpty else { return Root() }

        var rootItems: [Item] = []
        // Stack of (level, item) pairs representing the current path from root to deepest item
        var stack: [(level: Int, item: Item)] = []

        for heading in headings {
            let item = Item(
                title: heading.title,
                destination: .xyz(
                    page: heading.pageIndex,
                    left: nil,
                    top: heading.yPosition.value,
                    zoom: nil
                )
            )

            // Pop items from stack that are at same or deeper level
            // These need to be attached to their parent before we can add the new item
            while let last = stack.last, last.level >= heading.level {
                let (_, child) = stack.removeLast()
                if stack.isEmpty {
                    // No parent, add to root
                    rootItems.append(child)
                } else {
                    // Attach to parent's children
                    var (parentLevel, parentItem) = stack.removeLast()
                    parentItem = Item(
                        title: parentItem.title,
                        destination: parentItem.destination,
                        children: parentItem.children + [child],
                        isOpen: parentItem.isOpen
                    )
                    stack.append((parentLevel, parentItem))
                }
            }

            // Push the new item onto the stack
            stack.append((heading.level, item))
        }

        // Flush remaining stack - attach each item to its parent
        while let (_, child) = stack.popLast() {
            if stack.isEmpty {
                rootItems.append(child)
            } else {
                var (parentLevel, parentItem) = stack.removeLast()
                parentItem = Item(
                    title: parentItem.title,
                    destination: parentItem.destination,
                    children: parentItem.children + [child],
                    isOpen: parentItem.isOpen
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
    public typealias Root = ISO_32000.Outline.Root

    /// Outline item (Table 151)
    public typealias Item = ISO_32000.Outline.Item

    /// Destination (Table 149)
    public typealias Destination = ISO_32000.Destination
}

// MARK: - Convenience Typealiases

extension ISO_32000 {
    /// Convenience typealias for outline root
    public typealias OutlineRoot = Outline.Root

    /// Convenience typealias for outline item
    public typealias OutlineItem = Outline.Item
}

// MARK: - Raw Spec Text (for reference)

//12.3 Document-level navigation
//12.3.1 General
//The features described in this subclause allow an interactive PDF processor to present the user with an
//interactive, global overview of a document in either of two forms:
//• As a hierarchical outline showing the document's internal structure
//• As a collection of thumbnail images representing the pages of the document in miniature form

//12.3.2 Destinations
//A destination defines a particular view of a document, consisting of the following items:
//• The page of the document that shall be displayed
//• The location of the document window on that page
//• The magnification (zoom) factor

//Table 149 — Destination syntax
//[page /XYZ left top zoom] - Display at coordinates with zoom
//[page /Fit] - Fit entire page
//[page /FitH top] - Fit width
//[page /FitV left] - Fit height
//[page /FitR left bottom right top] - Fit rectangle
//[page /FitB] - Fit bounding box
//[page /FitBH top] - Fit bounding box width
//[page /FitBV left] - Fit bounding box height

//12.3.3 Document outline
//Table 150 — Entries in the outline dictionary
//Key Type Value
//Type name (Optional) shall be Outlines
//First dictionary (Required if any items) First top-level item
//Last dictionary (Required if any items) Last top-level item
//Count integer (Required if open items) Total visible items

//Table 151 — Entries in an outline item dictionary
//Key Type Value
//Title text string (Required) Display text
//Parent dictionary (Required) Parent item or outline
//Prev dictionary (Required except first) Previous sibling
//Next dictionary (Required except last) Next sibling
//First dictionary (Required if children) First child
//Last dictionary (Required if children) Last child
//Count integer (Required if children) Visible descendants
//Dest name, byte string, or array (Optional) Destination
//A dictionary (Optional; PDF 1.1) Action
//SE dictionary (Optional; PDF 1.3) Structure element
//C array (Optional; PDF 1.4) RGB color
//F integer (Optional; PDF 1.4) Style flags
