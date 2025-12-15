// ISO 32000-2:2020, 12.4 Page-level navigation
//
// Sections:
//   12.4.1  General
//   12.4.2  Page labels
//   12.4.3  Articles
//   12.4.4  Presentations

public import Geometry
public import ISO_32000_8_Graphics
public import ISO_32000_Shared

extension ISO_32000.`12` {
    /// ISO 32000-2:2020, 12.4 Page-level navigation
    public enum `4` {}
}

// MARK: - 12.4.2 Page Labels

extension ISO_32000 {
    /// Page label namespace for visual page numbering.
    public enum PageLabel {}
}

extension ISO_32000.PageLabel {
    /// Page label configuration for visual page numbering.
    ///
    /// Per ISO 32000-2:2020 Section 12.4.2:
    /// > Each page in a PDF document shall be identified by an integer page index.
    /// > In addition, a document may optionally define page labels to identify
    /// > each page visually on the screen or in print.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 161 — Entries in a page label dictionary
    public struct Entry: Sendable, Equatable, Hashable, Codable {
        /// Numbering style for the numeric portion of page labels.
        ///
        /// Per ISO 32000-2 Table 161:
        /// > The numbering style that shall be used for the numeric portion
        /// > of each page label.
        public enum Style: String, Sendable, Codable, CaseIterable {
            /// Decimal Arabic numerals (1, 2, 3, ...)
            case decimal = "D"

            /// Uppercase Roman numerals (I, II, III, ...)
            case romanUpper = "R"

            /// Lowercase Roman numerals (i, ii, iii, ...)
            case romanLower = "r"

            /// Uppercase letters (A, B, C, ... Z, AA, BB, ...)
            case letterUpper = "A"

            /// Lowercase letters (a, b, c, ... z, aa, bb, ...)
            case letterLower = "a"
        }

        /// The numbering style (nil means no numeric portion)
        public var style: Style?

        /// The label prefix for page labels in this range
        public var prefix: String?

        /// The value of the numeric portion for the first page label in the range
        /// (default: 1)
        public var start: Int

        public init(
            style: Style? = nil,
            prefix: String? = nil,
            start: Int = 1
        ) {
            self.style = style
            self.prefix = prefix
            self.start = start
        }
    }
}

// MARK: - 12.4.3 Articles

extension ISO_32000 {
    /// Article namespace for article threads and beads.
    ///
    /// Per ISO 32000-2:2020 Section 12.4.3:
    /// > Some types of documents may contain sequences of content items that
    /// > are logically connected but not physically sequential.
    public enum Article {}
}

extension ISO_32000.Article {
    /// An article thread defining a sequence of content items.
    ///
    /// Per ISO 32000-2:2020 Table 162:
    /// > The sequential flow of an article shall be defined by an article thread;
    /// > the individual content items that make up the article are called beads
    /// > on the thread.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 162 — Entries in a thread dictionary
    public struct Thread: Sendable {
        /// The beads in this thread (in order)
        public var beads: [Bead]

        /// Thread information (title, author, etc.)
        public var info: Info?

        public init(beads: [Bead] = [], info: Info? = nil) {
            self.beads = beads
            self.info = info
        }
    }
}

extension ISO_32000.Article {
    /// Information about an article thread.
    public struct Info: Sendable, Equatable, Hashable, Codable {
        /// The thread title
        public var title: String?

        /// The thread author
        public var author: String?

        /// The thread subject
        public var subject: String?

        /// Keywords for the thread
        public var keywords: String?

        public init(
            title: String? = nil,
            author: String? = nil,
            subject: String? = nil,
            keywords: String? = nil
        ) {
            self.title = title
            self.author = author
            self.subject = subject
            self.keywords = keywords
        }
    }
}

extension ISO_32000.Article {
    /// A bead on an article thread.
    ///
    /// Per ISO 32000-2:2020 Table 163:
    /// > Each individual bead within a thread shall be represented by a bead
    /// > dictionary.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 163 — Entries in a bead dictionary
    public struct Bead: Sendable {
        /// The page index where this bead appears (0-based)
        public var pageIndex: Int

        /// The location of this bead on the page
        public var rect: ISO_32000.UserSpace.Rectangle

        public init(pageIndex: Int, rect: ISO_32000.UserSpace.Rectangle) {
            self.pageIndex = pageIndex
            self.rect = rect
        }
    }
}

// MARK: - 12.4.4 Presentations

extension ISO_32000 {
    /// Presentation transition namespace.
    ///
    /// Per ISO 32000-2:2020 Section 12.4.4:
    /// > Some interactive PDF processors may allow a document to be displayed
    /// > in the form of a presentation or slide show.
    public enum Transition {}
}

extension ISO_32000.Transition {
    /// Transition style for page transitions.
    ///
    /// Per ISO 32000-2:2020 Table 164:
    /// > The transition style that shall be used when moving to this page
    /// > from another during a presentation.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 164 — Entries in a transition dictionary
    public enum Style: String, Sendable, Codable, CaseIterable {
        /// Two lines sweep across the screen, revealing the new page
        case split = "Split"

        /// Multiple lines sweep in the same direction to reveal the new page
        case blinds = "Blinds"

        /// A rectangular box sweeps inward or outward
        case box = "Box"

        /// A single line sweeps across the screen
        case wipe = "Wipe"

        /// The old page dissolves gradually to reveal the new one
        case dissolve = "Dissolve"

        /// Similar to dissolve, but sweeps across the page in a band
        case glitter = "Glitter"

        /// No special transition effect (default)
        case replace = "R"

        /// Changes are flown out or in (PDF 1.5)
        case fly = "Fly"

        /// The old page slides off while the new page slides in (PDF 1.5)
        case push = "Push"

        /// The new page slides on, covering the old page (PDF 1.5)
        case cover = "Cover"

        /// The old page slides off, uncovering the new page (PDF 1.5)
        case uncover = "Uncover"

        /// The new page gradually becomes visible through the old one (PDF 1.5)
        case fade = "Fade"
    }
}

extension ISO_32000.Transition {
    /// Dimension for split/blinds transitions.
    public enum Dimension: String, Sendable, Codable {
        /// Horizontal
        case horizontal = "H"

        /// Vertical
        case vertical = "V"
    }
}

extension ISO_32000.Transition {
    /// Motion direction for split/box/fly transitions.
    public enum Motion: String, Sendable, Codable {
        /// Inward from the edges of the page
        case inward = "I"

        /// Outward from the center of the page
        case outward = "O"
    }
}

extension ISO_32000.Transition {
    /// Direction angle for wipe/glitter/fly/cover/uncover/push transitions.
    public enum Direction: Sendable, Equatable, Hashable, Codable {
        /// Left to right (0°)
        case leftToRight

        /// Bottom to top (90°) - Wipe only
        case bottomToTop

        /// Right to left (180°) - Wipe only
        case rightToLeft

        /// Top to bottom (270°)
        case topToBottom

        /// Top-left to bottom-right (315°) - Glitter only
        case diagonal

        /// No direction (Fly transition only, when scale ≠ 1.0)
        case none

        /// The raw degree value
        public var degrees: Int? {
            switch self {
            case .leftToRight: return 0
            case .bottomToTop: return 90
            case .rightToLeft: return 180
            case .topToBottom: return 270
            case .diagonal: return 315
            case .none: return nil
            }
        }
    }
}

extension ISO_32000.Transition {
    /// A page transition effect.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 164 — Entries in a transition dictionary
    public struct Effect: Sendable {
        /// The transition style
        public var style: Style

        /// Duration of the transition in seconds (default: 1.0)
        public var duration: Double

        /// Dimension (Split and Blinds only)
        public var dimension: Dimension?

        /// Motion direction (Split, Box, and Fly only)
        public var motion: Motion?

        /// Direction angle (Wipe, Glitter, Fly, Cover, Uncover, Push only)
        public var direction: Direction?

        /// Starting/ending scale (Fly only, PDF 1.5)
        public var scale: Double?

        /// Rectangular and opaque fly area (Fly only, PDF 1.5)
        public var opaque: Bool?

        public init(
            style: Style = .replace,
            duration: Double = 1.0,
            dimension: Dimension? = nil,
            motion: Motion? = nil,
            direction: Direction? = nil,
            scale: Double? = nil,
            opaque: Bool? = nil
        ) {
            self.style = style
            self.duration = duration
            self.dimension = dimension
            self.motion = motion
            self.direction = direction
            self.scale = scale
            self.opaque = opaque
        }
    }
}

// MARK: - 12.4.4.2 Sub-page Navigation

extension ISO_32000 {
    /// Navigation namespace for sub-page navigation.
    public enum Navigation {}
}

extension ISO_32000.Navigation {
    /// A navigation node for sub-page navigation (PDF 1.5).
    ///
    /// Per ISO 32000-2:2020 Section 12.4.4.2:
    /// > Sub-page navigation provides the ability to navigate not only between
    /// > pages but also between different states of the same page.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 165 — Entries in a navigation node dictionary
    public struct Node: Sendable {
        /// Action to execute when navigating forward
        public var nextAction: ISO_32000.Action.GoTo?

        /// Action to execute when navigating backward
        public var previousAction: ISO_32000.Action.GoTo?

        /// Maximum seconds before auto-advance (nil = no auto-advance)
        public var duration: Double?

        public init(
            nextAction: ISO_32000.Action.GoTo? = nil,
            previousAction: ISO_32000.Action.GoTo? = nil,
            duration: Double? = nil
        ) {
            self.nextAction = nextAction
            self.previousAction = previousAction
            self.duration = duration
        }
    }
}

// MARK: - Section Typealiases

extension ISO_32000.`12`.`4` {
    /// Page label entry (Table 161)
    public typealias Label = ISO_32000.PageLabel.Entry

    /// Article thread (Table 162)
    public typealias Thread = ISO_32000.Article.Thread

    /// Article bead (Table 163)
    public typealias Bead = ISO_32000.Article.Bead

    /// Transition style (Table 164)
    public typealias TransitionStyle = ISO_32000.Transition.Style

    /// Transition effect (Table 164)
    public typealias TransitionEffect = ISO_32000.Transition.Effect

    /// Navigation node (Table 165)
    public typealias NavigationNode = ISO_32000.Navigation.Node
}

// MARK: - Raw Spec Text (for reference)

// 12.4 Page-level navigation
// 12.4.1 General
// This subclause describes PDF facilities that enable the user to navigate from page to page:
// • Page labels for numbering or otherwise identifying individual pages (12.4.2)
// • Article threads, which chain together logically connected content (12.4.3)
// • Presentations that display the document as a slide show (12.4.4)

// 12.4.2 Page labels
// Table 161 — Entries in a page label dictionary
// Key Type Value
// Type name (Optional) shall be PageLabel
// S name (Optional) Numbering style: D (decimal), R (Roman upper), r (Roman lower),
//       A (letters upper), a (letters lower). No default - omit for no numeric portion.
// P text string (Optional) Label prefix for this range
// St integer (Optional) Starting value for numeric portion. Default: 1

// 12.4.3 Articles
// Table 162 — Entries in a thread dictionary
// Key Type Value
// Type name (Optional) shall be Thread
// F dictionary (Required) First bead in the thread
// I dictionary (Optional) Thread information dictionary

// Table 163 — Entries in a bead dictionary
// Key Type Value
// Type name (Optional) shall be Bead
// T dictionary (Required for first bead) The thread
// N dictionary (Required) Next bead (last bead refers to first)
// V dictionary (Required) Previous bead (first bead refers to last)
// P dictionary (Required) Page object
// R rectangle (Required) Location on page

// 12.4.4 Presentations
// Table 164 — Entries in a transition dictionary
// Key Type Value
// Type name (Optional) shall be Trans
// S name (Optional) Style: Split, Blinds, Box, Wipe, Dissolve, Glitter, R (default),
//       Fly, Push, Cover, Uncover, Fade
// D number (Optional) Duration in seconds. Default: 1
// Dm name (Optional; Split/Blinds) Dimension: H (horizontal), V (vertical). Default: H
// M name (Optional; Split/Box/Fly) Motion: I (inward), O (outward). Default: I
// Di number/name (Optional; Wipe/Glitter/Fly/Cover/Uncover/Push) Direction:
//       0 (left-right), 90 (bottom-top), 180 (right-left), 270 (top-bottom),
//       315 (diagonal, Glitter only), or None (Fly only). Default: 0
// SS number (Optional; Fly, PDF 1.5) Starting/ending scale. Default: 1.0
// B boolean (Optional; Fly, PDF 1.5) Rectangular and opaque. Default: false

// 12.4.4.2 Sub-page navigation
// Table 165 — Entries in a navigation node dictionary
// Key Type Value
// Type name (Optional) shall be NavNode
// NA dictionary (Optional) Action for navigating forward
// PA dictionary (Optional) Action for navigating backward
// Next dictionary (Optional) Next navigation node
// Prev dictionary (Optional) Previous navigation node
// Dur number (Optional) Auto-advance duration in seconds
