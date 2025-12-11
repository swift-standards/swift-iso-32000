// ISO 32000-2:2020, 12.5 Annotations
//
// Sections:
//   12.5.1  General
//   12.5.2  Annotation dictionaries (Table 166)
//   12.5.3  Annotation flags (Table 167)
//   12.5.4  Border styles (Tables 168, 169)
//   12.5.5  Appearance streams (Table 170)
//   12.5.6  Annotation types (Table 171)
//     12.5.6.1  General
//     12.5.6.2  Markup annotations (Tables 172, 173)
//     12.5.6.3  Annotation states (Table 174)
//     12.5.6.4  Text annotations (Table 175)
//     12.5.6.5  Link annotations (Table 176)
//     12.5.6.6  Free text annotations (Table 177)
//     12.5.6.7  Line annotations (Tables 178, 179)
//     12.5.6.8  Square and circle annotations (Table 180)
//     12.5.6.9  Polygon and polyline annotations (Table 181)
//     12.5.6.10 Text markup annotations (Table 182)
//     12.5.6.11 Caret annotations (Table 183)
//     12.5.6.12 Rubber stamp annotations (Table 184)
//     12.5.6.13 Ink annotations (Table 185)
//     12.5.6.14 Popup annotations (Table 186)
//     12.5.6.15 File attachment annotations (Table 187)
//     12.5.6.16 Sound annotations (Table 188) - deprecated
//     12.5.6.23 Redaction annotations (Table 195)

public import Geometry
public import ISO_32000_8_Graphics
public import ISO_32000_Shared

extension ISO_32000.`12` {
    /// ISO 32000-2:2020, 12.5 Annotations
    public enum `5` {}
}

// MARK: - 12.5.2 Annotation (Table 166)

extension ISO_32000.`12`.`5` {
    /// Annotation dictionary (Table 166)
    ///
    /// An annotation associates an object such as a note, link or rich media with
    /// a location on a page of a PDF document, or provides a way to interact with
    /// the user by means of the mouse and keyboard.
    ///
    /// ## Algebraic Structure
    ///
    /// ```
    /// Annotation ≅ Common × Content
    /// Content = Link + Text + FreeText + Line + ...  (sum type)
    /// ```
    ///
    /// The common fields (Table 166) are shared by all annotation types.
    /// The `content` enum holds type-specific data indexed by subtype.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 166 — Entries common to all annotation dictionaries
    public struct Annotation: Sendable, Hashable {
        // MARK: - Common Entries (Table 166)

        /// The annotation rectangle in default user space units. Required.
        public var rect: ISO_32000.UserSpace.Rectangle

        /// Text displayed for the annotation or alternative description. Optional.
        public var contents: String?

        /// The annotation name, uniquely identifying it on its page. Optional; PDF 1.4.
        public var name: String?

        /// Date and time when the annotation was most recently modified. Optional; PDF 1.1.
        public var modificationDate: String?

        /// Flags specifying various characteristics. Optional; PDF 1.1.
        public var flags: Flags

        /// Border characteristics. Optional.
        public var border: Border?

        /// Color for background, title bar, or border. Optional; PDF 1.1.
        public var color: Color?

        /// Integer key for structural parent tree. Optional; PDF 1.3.
        public var structParent: Int?

        /// Opacity for nonstroking operations (0.0-1.0). Optional; PDF 2.0.
        public var fillOpacity: Double?

        /// Opacity for stroking operations (0.0-1.0). Optional; PDF 1.4.
        public var strokeOpacity: Double?

        /// Blend mode for painting the annotation. Optional; PDF 2.0.
        ///
        /// Uses the same blend modes as graphics state (Section 11.3.5, Tables 134-135).
        public var blendMode: ISO_32000.`8`.`4`.Graphics.State.Blend.Mode?

        /// Language identifier for the annotation. Optional; PDF 2.0.
        public var language: String?

        // MARK: - Appearance Entries (Table 166)

        /// The annotation's appearance dictionary. Optional.
        ///
        /// Per ISO 32000-2 Table 166, AP entry:
        /// > An appearance dictionary specifying how the annotation shall be
        /// > presented visually on the page.
        public var appearance: ISO_32000.`12`.`5`.Appearance?

        /// The annotation's appearance state. Optional.
        ///
        /// Per ISO 32000-2 Table 166, AS entry:
        /// > The annotation's appearance state, which selects the applicable
        /// > appearance stream from an appearance subdictionary.
        public var appearanceState: String?

        // MARK: - Type-Specific Content

        /// The type-specific content (sum type over all annotation subtypes).
        public var content: Content

        /// The subtype, derived from content.
        public var subtype: Subtype { content.subtype }

        public init(
            rect: ISO_32000.UserSpace.Rectangle,
            content: Content,
            contents: String? = nil,
            name: String? = nil,
            modificationDate: String? = nil,
            flags: Flags = [],
            border: Border? = nil,
            color: Color? = nil,
            structParent: Int? = nil,
            fillOpacity: Double? = nil,
            strokeOpacity: Double? = nil,
            blendMode: ISO_32000.`8`.`4`.Graphics.State.Blend.Mode? = nil,
            language: String? = nil,
            appearance: ISO_32000.`12`.`5`.Appearance? = nil,
            appearanceState: String? = nil
        ) {
            self.rect = rect
            self.content = content
            self.contents = contents
            self.name = name
            self.modificationDate = modificationDate
            self.flags = flags
            self.border = border
            self.color = color
            self.structParent = structParent
            self.fillOpacity = fillOpacity
            self.strokeOpacity = strokeOpacity
            self.blendMode = blendMode
            self.language = language
            self.appearance = appearance
            self.appearanceState = appearanceState
        }
    }
}

// MARK: - Annotation.Content (Sum Type)

extension ISO_32000.`12`.`5`.Annotation {
    /// Type-specific annotation content (sum type)
    ///
    /// ```
    /// Content = Σ_{s : Subtype}. Specific(s)
    /// ```
    ///
    /// Each case carries the type-specific entries for that annotation subtype.
    public enum Content: Sendable, Hashable {
        /// Link annotation (Table 176)
        case link(Link)

        /// Text annotation - sticky note (Table 175)
        case text(Text)

        /// Free text annotation (Table 177)
        case freeText(FreeText)

        /// Line annotation (Table 178)
        case line(Line)

        /// Square or Circle annotation (Table 180)
        case shape(Shape)

        /// Polygon or Polyline annotation (Table 181)
        case poly(Poly)

        /// Text markup annotation (Table 182)
        case textMarkup(TextMarkup)

        /// Caret annotation (Table 183)
        case caret(Caret)

        /// Rubber stamp annotation (Table 184)
        case stamp(Stamp)

        /// Ink annotation (Table 185)
        case ink(Ink)

        /// Popup annotation (Table 186)
        case popup(Popup)

        /// File attachment annotation (Table 187)
        case fileAttachment(FileAttachment)

        /// Redaction annotation (Table 195)
        case redaction(Redaction)

        /// Widget annotation (Table 191) - for interactive forms
        case widget(Widget)

        /// The subtype for this content.
        public var subtype: Subtype {
            switch self {
            case .link: return .link
            case .text: return .text
            case .freeText: return .freeText
            case .line: return .line
            case .shape(let s): return s.kind == .square ? .square : .circle
            case .poly(let p): return p.kind == .polygon ? .polygon : .polyLine
            case .textMarkup(let tm):
                switch tm.kind {
                case .highlight: return .highlight
                case .underline: return .underline
                case .strikeOut: return .strikeOut
                case .squiggly: return .squiggly
                }
            case .caret: return .caret
            case .stamp: return .stamp
            case .ink: return .ink
            case .popup: return .popup
            case .fileAttachment: return .fileAttachment
            case .redaction: return .redact
            case .widget: return .widget
            }
        }
    }
}

// MARK: - Annotation.Subtype (Table 171)

extension ISO_32000.`12`.`5`.Annotation {
    /// Annotation types (Table 171)
    ///
    /// The Subtype entry in an annotation dictionary specifies the type.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 171 — Annotation types
    public enum Subtype: String, Sendable, Hashable, Codable, CaseIterable {
        /// Text annotation (sticky note). Markup annotation.
        case text = "Text"

        /// Link annotation. Not a markup annotation.
        case link = "Link"

        /// Free text annotation (PDF 1.3). Markup annotation.
        case freeText = "FreeText"

        /// Line annotation (PDF 1.3). Markup annotation.
        case line = "Line"

        /// Square annotation (PDF 1.3). Markup annotation.
        case square = "Square"

        /// Circle annotation (PDF 1.3). Markup annotation.
        case circle = "Circle"

        /// Polygon annotation (PDF 1.5). Markup annotation.
        case polygon = "Polygon"

        /// Polyline annotation (PDF 1.5). Markup annotation.
        case polyLine = "PolyLine"

        /// Highlight annotation (PDF 1.3). Text markup annotation.
        case highlight = "Highlight"

        /// Underline annotation (PDF 1.3). Text markup annotation.
        case underline = "Underline"

        /// Squiggly-underline annotation (PDF 1.4). Text markup annotation.
        case squiggly = "Squiggly"

        /// Strikeout annotation (PDF 1.3). Text markup annotation.
        case strikeOut = "StrikeOut"

        /// Caret annotation (PDF 1.5). Markup annotation.
        case caret = "Caret"

        /// Rubber stamp annotation (PDF 1.3). Markup annotation.
        case stamp = "Stamp"

        /// Ink annotation (PDF 1.3). Markup annotation.
        case ink = "Ink"

        /// Popup annotation (PDF 1.3). Not a markup annotation.
        case popup = "Popup"

        /// File attachment annotation (PDF 1.3). Markup annotation.
        case fileAttachment = "FileAttachment"

        /// Sound annotation (PDF 1.2; deprecated in PDF 2.0). Markup annotation.
        case sound = "Sound"

        /// Movie annotation (PDF 1.2; deprecated in PDF 2.0). Not a markup annotation.
        case movie = "Movie"

        /// Screen annotation (PDF 1.5). Not a markup annotation.
        case screen = "Screen"

        /// Widget annotation (PDF 1.2). Not a markup annotation.
        case widget = "Widget"

        /// Printer's mark annotation (PDF 1.4). Not a markup annotation.
        case printerMark = "PrinterMark"

        /// Trap network annotation (PDF 1.3; deprecated in PDF 2.0). Not a markup annotation.
        case trapNet = "TrapNet"

        /// Watermark annotation (PDF 1.6). Not a markup annotation.
        case watermark = "Watermark"

        /// 3D annotation (PDF 1.6). Not a markup annotation.
        case threeD = "3D"

        /// Redact annotation (PDF 1.7). Markup annotation.
        case redact = "Redact"

        /// Projection annotation (PDF 2.0). Markup annotation.
        case projection = "Projection"

        /// RichMedia annotation (PDF 2.0). Not a markup annotation.
        case richMedia = "RichMedia"

        /// Whether this annotation type is a markup annotation.
        public var isMarkup: Bool {
            switch self {
            case .text, .freeText, .line, .square, .circle,
                 .polygon, .polyLine, .highlight, .underline,
                 .squiggly, .strikeOut, .caret, .stamp, .ink,
                 .fileAttachment, .sound, .redact, .projection:
                return true
            case .link, .popup, .movie, .screen, .widget,
                 .printerMark, .trapNet, .watermark, .threeD, .richMedia:
                return false
            }
        }

        /// Whether this annotation type is a text markup annotation.
        public var isTextMarkup: Bool {
            switch self {
            case .highlight, .underline, .squiggly, .strikeOut:
                return true
            default:
                return false
            }
        }
    }
}

// MARK: - Annotation.Flags (Table 167)

extension ISO_32000.`12`.`5`.Annotation {
    /// Annotation flags (Table 167)
    ///
    /// Flags specifying various characteristics of the annotation.
    /// Bit positions are numbered from 1 (lowest-order bit).
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 167 — Annotation flags
    public struct Flags: OptionSet, Sendable, Hashable, Codable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Bit 1: Do not render unknown annotation types.
        public static let invisible = Flags(rawValue: 1 << 0)

        /// Bit 2: Do not render or allow interaction. (PDF 1.2)
        public static let hidden = Flags(rawValue: 1 << 1)

        /// Bit 3: Print when the page is printed. (PDF 1.2)
        public static let print = Flags(rawValue: 1 << 2)

        /// Bit 4: Do not scale with page magnification. (PDF 1.3)
        public static let noZoom = Flags(rawValue: 1 << 3)

        /// Bit 5: Do not rotate with page rotation. (PDF 1.3)
        public static let noRotate = Flags(rawValue: 1 << 4)

        /// Bit 6: Do not render on screen but may print. (PDF 1.3)
        public static let noView = Flags(rawValue: 1 << 5)

        /// Bit 7: Do not allow user interaction. (PDF 1.3)
        public static let readOnly = Flags(rawValue: 1 << 6)

        /// Bit 8: Do not allow deletion or property modification. (PDF 1.4)
        public static let locked = Flags(rawValue: 1 << 7)

        /// Bit 9: Invert NoView flag for hover and selection. (PDF 1.5)
        public static let toggleNoView = Flags(rawValue: 1 << 8)

        /// Bit 10: Do not allow content modification. (PDF 1.7)
        public static let lockedContents = Flags(rawValue: 1 << 9)
    }
}

// MARK: - Annotation.Color

extension ISO_32000.`12`.`5`.Annotation {
    /// Annotation color (Table 166, C entry)
    ///
    /// The number of components determines the color space.
    public enum Color: Sendable, Hashable {
        /// No color (transparent)
        case transparent

        /// DeviceGray color space
        case gray(Double)

        /// DeviceRGB color space
        case rgb(red: Double, green: Double, blue: Double)

        /// DeviceCMYK color space
        case cmyk(cyan: Double, magenta: Double, yellow: Double, black: Double)

        /// Creates an RGB color.
        public static func rgb(_ red: Double, _ green: Double, _ blue: Double) -> Color {
            .rgb(red: red, green: green, blue: blue)
        }
    }
}

// MARK: - Border (Table 166, Border entry)

extension ISO_32000.`12`.`5` {
    /// Border array (Table 166, Border entry)
    ///
    /// Specifies the characteristics of the annotation's border.
    public struct Border: Sendable, Hashable {
        /// Horizontal corner radius in default user space units.
        public var horizontalRadius: Double

        /// Vertical corner radius in default user space units.
        public var verticalRadius: Double

        /// Border width in default user space units.
        public var width: Double

        /// Optional dash array for dashed borders. (PDF 1.1)
        public var dashArray: [Double]?

        public init(
            horizontalRadius: Double = 0,
            verticalRadius: Double = 0,
            width: Double = 1,
            dashArray: [Double]? = nil
        ) {
            self.horizontalRadius = horizontalRadius
            self.verticalRadius = verticalRadius
            self.width = width
            self.dashArray = dashArray
        }

        /// Default border: solid line, 1 point width, square corners.
        public static let `default` = Border()

        /// No border.
        public static let none = Border(width: 0)
    }
}

// MARK: - Border.Style (Table 168)

extension ISO_32000.`12`.`5`.Border {
    /// Border style dictionary (Table 168)
    ///
    /// Beginning with PDF 1.2, border characteristics may be specified
    /// in a border style dictionary instead of the Border array.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 168 — Entries in a border style dictionary
    public struct Style: Sendable, Hashable {
        /// The border width in points. Default: 1.
        public var width: Double

        /// The border style. Default: `.solid`.
        public var style: Kind

        /// Dash array for dashed borders. Default: [3].
        public var dashArray: [Double]?

        /// Border style kinds (Table 168, S entry)
        public enum Kind: String, Sendable, Hashable, Codable, CaseIterable {
            /// Solid rectangle surrounding the annotation.
            case solid = "S"

            /// Dashed rectangle surrounding the annotation.
            case dashed = "D"

            /// Simulated embossed rectangle (raised appearance).
            case beveled = "B"

            /// Simulated engraved rectangle (recessed appearance).
            case inset = "I"

            /// Single line along the bottom of the annotation rectangle.
            case underline = "U"
        }

        public init(
            width: Double = 1,
            style: Kind = .solid,
            dashArray: [Double]? = nil
        ) {
            self.width = width
            self.style = style
            self.dashArray = dashArray
        }

        /// Default border style.
        public static let `default` = Style()
    }
}

// MARK: - Border.Effect (Table 169)

extension ISO_32000.`12`.`5`.Border {
    /// Border effect dictionary (Table 169)
    ///
    /// Beginning with PDF 1.5, some annotations may have a border effect.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 169 — Entries in a border effect dictionary
    public struct Effect: Sendable, Hashable {
        /// The border effect type. Default: `.none`.
        public var effect: Kind

        /// Effect intensity (0 to 2). Default: 0.
        public var intensity: Double

        /// Border effect kinds (Table 169, S entry)
        public enum Kind: String, Sendable, Hashable, Codable, CaseIterable {
            /// No effect: border as described by BS entry.
            case none = "S"

            /// Cloudy border: drawn as convex curved segments.
            case cloudy = "C"
        }

        public init(effect: Kind = .none, intensity: Double = 0) {
            self.effect = effect
            self.intensity = intensity
        }
    }
}

// MARK: - Appearance (Table 170)

extension ISO_32000.`12`.`5` {
    /// Appearance dictionary (Table 170)
    ///
    /// An annotation may specify up to three separate appearances:
    /// - Normal (N): Used when not interacting with the user; also for printing.
    /// - Rollover (R): Used when cursor enters the annotation's active area.
    /// - Down (D): Used when mouse button is pressed.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 170 — Entries in an appearance dictionary
    public struct Appearance: Sendable, Hashable {
        /// The annotation's normal appearance. Required.
        public var normal: Entry

        /// The annotation's rollover appearance. Optional.
        public var rollover: Entry?

        /// The annotation's down appearance. Optional.
        public var down: Entry?

        public init(
            normal: Entry,
            rollover: Entry? = nil,
            down: Entry? = nil
        ) {
            self.normal = normal
            self.rollover = rollover
            self.down = down
        }
    }
}

// MARK: - Appearance.Entry

extension ISO_32000.`12`.`5`.Appearance {
    /// An appearance entry (stream or subdictionary)
    public enum Entry: Sendable, Hashable {
        /// A single appearance stream (form XObject reference).
        case stream(String)

        /// A subdictionary mapping appearance state names to streams.
        case subdictionary([String: String])
    }
}

// MARK: - TabOrder (12.5.1)

extension ISO_32000.`12`.`5` {
    /// Annotation tab order (Table 31, Tabs entry)
    ///
    /// Specifies the order in which annotations are visited when
    /// navigating using the keyboard.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 12.5.1 — General
    public enum TabOrder: String, Sendable, Hashable, Codable, CaseIterable {
        /// Row order: horizontal rows.
        case row = "R"

        /// Column order: vertical columns.
        case column = "C"

        /// Structure order: structure tree order.
        case structure = "S"

        /// Annotation array order. (PDF 2.0)
        case annotationArray = "A"

        /// Widgets first, then others in row order. (PDF 2.0)
        case widgets = "W"
    }
}

// MARK: - Markup (Table 172)

extension ISO_32000.`12`.`5` {
    /// Additional entries for markup annotations (Table 172)
    ///
    /// Markup annotations are used primarily to mark up PDF documents.
    /// They have text that appears as part of the annotation.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 172 — Additional entries specific to markup annotations
    public struct Markup: Sendable, Hashable {
        /// Text label for popup window title bar. Optional; PDF 1.1.
        public var title: String?

        /// Rich text string for popup window. Optional; PDF 1.5.
        public var richContents: String?

        /// Date and time when the annotation was created. Optional; PDF 1.5.
        public var creationDate: String?

        /// Reference to the annotation this is "in reply to". Optional; PDF 1.5.
        public var inReplyTo: String?

        /// Short description of the subject. Optional; PDF 1.5.
        public var subject: String?

        /// Relationship to the annotation specified by `inReplyTo`. Optional; PDF 1.6.
        public var replyType: ReplyType?

        /// Intent describing the purpose of the annotation. Optional; PDF 1.6.
        public var intent: String?

        public init(
            title: String? = nil,
            richContents: String? = nil,
            creationDate: String? = nil,
            inReplyTo: String? = nil,
            subject: String? = nil,
            replyType: ReplyType? = nil,
            intent: String? = nil
        ) {
            self.title = title
            self.richContents = richContents
            self.creationDate = creationDate
            self.inReplyTo = inReplyTo
            self.subject = subject
            self.replyType = replyType
            self.intent = intent
        }
    }
}

// MARK: - Markup.ReplyType

extension ISO_32000.`12`.`5`.Markup {
    /// Reply type for markup annotations (Table 172, RT entry)
    public enum ReplyType: String, Sendable, Hashable, Codable, CaseIterable {
        /// The annotation is a reply to the annotation specified by IRT.
        case reply = "R"

        /// The annotation shall be grouped with the annotation specified by IRT.
        case group = "Group"
    }
}

// MARK: - Annotation.Link (Table 176)

extension ISO_32000.`12`.`5`.Annotation {
    /// Link annotation type-specific entries (Table 176)
    ///
    /// A link annotation represents either a hypertext link to a destination
    /// elsewhere in the document or an action to be performed.
    ///
    /// Note: Common fields (rect, flags, etc.) are in `Annotation`.
    /// This struct holds only link-specific entries.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 176 — Additional entries specific to a link annotation
    public struct Link: Sendable, Hashable {
        /// The target of the link (A or Dest entry)
        public var target: Target

        /// Highlight mode when the link is activated (H entry). Default: .invert
        public var highlightMode: HighlightMode

        /// Quadrilaterals for the active area (QuadPoints entry). Optional.
        public var quadPoints: [Double]?

        /// The target of the link
        public enum Target: Sendable, Hashable {
            /// URI action for external hyperlinks
            case uri(String)
            /// Internal destination within the document
            case destination(ISO_32000.Destination)
        }

        /// Highlight mode for link annotations (H entry)
        public enum HighlightMode: String, Sendable, Hashable, Codable, CaseIterable {
            /// No highlighting
            case none = "N"
            /// Invert the contents of the annotation rectangle
            case invert = "I"
            /// Invert the annotation's border
            case outline = "O"
            /// Display as if being pushed below the surface
            case push = "P"
        }

        public init(
            target: Target,
            highlightMode: HighlightMode = .invert,
            quadPoints: [Double]? = nil
        ) {
            self.target = target
            self.highlightMode = highlightMode
            self.quadPoints = quadPoints
        }

        public init(uri: String, highlightMode: HighlightMode = .invert) {
            self.target = .uri(uri)
            self.highlightMode = highlightMode
            self.quadPoints = nil
        }

        public init(destination: ISO_32000.Destination, highlightMode: HighlightMode = .invert) {
            self.target = .destination(destination)
            self.highlightMode = highlightMode
            self.quadPoints = nil
        }
    }
}

// MARK: - Annotation.TextMarkup (Table 182)

extension ISO_32000.`12`.`5`.Annotation {
    /// Text markup annotation type-specific entries (Table 182)
    ///
    /// A text markup annotation highlights, underlines, or strikes out
    /// a span of text in the document.
    ///
    /// Note: Common fields (rect, flags, etc.) are in `Annotation`.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 182 — Additional entries specific to text markup annotations
    public struct TextMarkup: Sendable, Hashable {
        /// The kind of text markup (determines Subtype)
        public var kind: Kind

        /// QuadPoints array defining the region to be marked up. Required.
        ///
        /// An array of 8×n numbers specifying n quadrilaterals.
        public var quadPoints: [Double]

        /// Text markup annotation kinds
        public enum Kind: Sendable, Hashable {
            /// Highlight annotation (PDF 1.3)
            case highlight(Color)
            /// Underline annotation (PDF 1.3)
            case underline
            /// Strikeout annotation (PDF 1.3)
            case strikeOut
            /// Squiggly-underline annotation (PDF 1.4)
            case squiggly
        }

        public init(kind: Kind, quadPoints: [Double]) {
            self.kind = kind
            self.quadPoints = quadPoints
        }
    }
}

// MARK: - 12.5.6.3 Annotation States (Table 174)

extension ISO_32000.`12`.`5`.Annotation {
    /// Annotation state models (Table 174)
    ///
    /// States are grouped into state models.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 174 — Annotation states
    public enum StateModel: String, Sendable, Hashable, Codable, CaseIterable {
        /// Marked state model: Marked/Unmarked
        case marked = "Marked"

        /// Review state model: Accepted/Rejected/Cancelled/Completed/None
        case review = "Review"
    }

    /// Annotation states (Table 174)
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 174 — Annotation states
    public enum State: Sendable, Hashable {
        // MARK: Marked state model

        /// The annotation has been marked by the user.
        case marked

        /// The annotation has not been marked by the user (default for Marked model).
        case unmarked

        // MARK: Review state model

        /// The user agrees with the change.
        case accepted

        /// The user disagrees with the change.
        case rejected

        /// The change has been cancelled.
        case cancelled

        /// The change has been completed.
        case completed

        /// The user has indicated nothing about the change (default for Review model).
        case none

        /// The state model for this state.
        public var stateModel: StateModel {
            switch self {
            case .marked, .unmarked:
                return .marked
            case .accepted, .rejected, .cancelled, .completed, .none:
                return .review
            }
        }

        /// The PDF name value for this state.
        public var rawValue: String {
            switch self {
            case .marked: return "Marked"
            case .unmarked: return "Unmarked"
            case .accepted: return "Accepted"
            case .rejected: return "Rejected"
            case .cancelled: return "Cancelled"
            case .completed: return "Completed"
            case .none: return "None"
            }
        }
    }
}

// MARK: - Line Ending Styles (Table 179)

extension ISO_32000.`12`.`5` {
    /// Line ending styles (Table 179)
    ///
    /// Used for line annotations, free text callouts, and polyline annotations.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 179 — Line ending styles
    public enum LineEnding: String, Sendable, Hashable, Codable, CaseIterable {
        /// A square filled with the annotation's interior colour, if any.
        case square = "Square"

        /// A circle filled with the annotation's interior colour, if any.
        case circle = "Circle"

        /// A diamond shape filled with the annotation's interior colour, if any.
        case diamond = "Diamond"

        /// Two short lines meeting in an acute angle to form an open arrowhead.
        case openArrow = "OpenArrow"

        /// A triangular closed arrowhead filled with the annotation's interior colour.
        case closedArrow = "ClosedArrow"

        /// No line ending.
        case none = "None"

        /// A short line at the endpoint perpendicular to the line itself. (PDF 1.5)
        case butt = "Butt"

        /// Two short lines in the reverse direction from OpenArrow. (PDF 1.5)
        case rOpenArrow = "ROpenArrow"

        /// A triangular closed arrowhead in the reverse direction from ClosedArrow. (PDF 1.5)
        case rClosedArrow = "RClosedArrow"

        /// A short line at the endpoint approximately 30 degrees clockwise from perpendicular. (PDF 1.6)
        case slash = "Slash"
    }
}

// MARK: - Annotation.Text (Table 175)

extension ISO_32000.`12`.`5`.Annotation {
    /// Text annotation type-specific entries (Table 175)
    ///
    /// A text annotation represents a "sticky note" attached to a point in the PDF document.
    /// When closed, the annotation appears as an icon; when open, it displays a popup window.
    ///
    /// Note: Common fields (rect, flags, etc.) are in `Annotation`.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 175 — Additional entries specific to a text annotation
    public struct Text: Sendable, Hashable {
        /// Whether the annotation shall initially be displayed open. Default: false.
        public var isOpen: Bool

        /// The name of an icon to display. Default: `.note`.
        public var iconName: IconName

        /// The state to which the original annotation shall be set. (PDF 1.5)
        public var state: State?

        /// Icon names for text annotations (Table 175)
        public enum IconName: String, Sendable, Hashable, Codable, CaseIterable {
            case comment = "Comment"
            case key = "Key"
            case note = "Note"
            case help = "Help"
            case newParagraph = "NewParagraph"
            case paragraph = "Paragraph"
            case insert = "Insert"
        }

        public init(
            isOpen: Bool = false,
            iconName: IconName = .note,
            state: State? = nil
        ) {
            self.isOpen = isOpen
            self.iconName = iconName
            self.state = state
        }
    }
}

// MARK: - Annotation.FreeText (Table 177)

extension ISO_32000.`12`.`5`.Annotation {
    /// Free text annotation type-specific entries (Table 177)
    ///
    /// A free text annotation displays text directly on the page. Unlike a text annotation,
    /// the text is always visible (no open/closed state).
    ///
    /// Note: Common fields (rect, flags, etc.) are in `Annotation`.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 177 — Additional entries specific to a free text annotation
    public struct FreeText: Sendable, Hashable {
        /// The default appearance string for formatting the text. Required.
        public var defaultAppearance: String

        /// Text justification. Default: `.leftJustified`.
        public var quadding: Quadding

        /// The intent of the free text annotation. Default: `.freeText`.
        public var intent: Intent

        /// Callout line coordinates (for FreeTextCallout intent). Optional.
        public var calloutLine: [Double]?

        /// Line ending style for the callout line. Default: `.none`.
        public var lineEnding: ISO_32000.`12`.`5`.LineEnding

        /// Text quadding (justification)
        public enum Quadding: Int, Sendable, Hashable, Codable, CaseIterable {
            /// Left-justified
            case leftJustified = 0
            /// Centered
            case centered = 1
            /// Right-justified
            case rightJustified = 2
        }

        /// Free text annotation intents (Table 177)
        public enum Intent: String, Sendable, Hashable, Codable, CaseIterable {
            /// Plain free-text annotation (text box comment).
            case freeText = "FreeText"
            /// Callout annotation with a line to an area on the page.
            case freeTextCallout = "FreeTextCallout"
            /// Click-to-type or typewriter object, no callout line.
            case freeTextTypeWriter = "FreeTextTypeWriter"
        }

        public init(
            defaultAppearance: String,
            quadding: Quadding = .leftJustified,
            intent: Intent = .freeText,
            calloutLine: [Double]? = nil,
            lineEnding: ISO_32000.`12`.`5`.LineEnding = .none
        ) {
            self.defaultAppearance = defaultAppearance
            self.quadding = quadding
            self.intent = intent
            self.calloutLine = calloutLine
            self.lineEnding = lineEnding
        }
    }
}

// MARK: - Annotation.Line (Table 178)

extension ISO_32000.`12`.`5`.Annotation {
    /// Line annotation type-specific entries (Table 178)
    ///
    /// Displays a single straight line on the page. When opened, displays a popup
    /// window containing the text of the associated note.
    ///
    /// Note: Common fields (rect, flags, etc.) are in `Annotation`.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 178 — Additional entries specific to a line annotation
    public struct Line: Sendable, Hashable {
        /// Starting x coordinate in default user space. Required.
        public var startX: Double

        /// Starting y coordinate in default user space. Required.
        public var startY: Double

        /// Ending x coordinate in default user space. Required.
        public var endX: Double

        /// Ending y coordinate in default user space. Required.
        public var endY: Double

        /// Line ending style for the start point. Default: `.none`.
        public var startLineEnding: ISO_32000.`12`.`5`.LineEnding

        /// Line ending style for the end point. Default: `.none`.
        public var endLineEnding: ISO_32000.`12`.`5`.LineEnding

        /// Interior color for filling line endings. Optional.
        public var interiorColor: Color?

        /// Length of leader lines perpendicular to the line. Default: 0.
        public var leaderLineLength: Double

        /// Length of leader line extensions. Default: 0.
        public var leaderLineExtension: Double

        /// Length of leader line offset (empty space before leader lines). Default: 0. (PDF 1.7)
        public var leaderLineOffset: Double

        /// Whether to display caption text on the line. Default: false. (PDF 1.6)
        public var hasCaption: Bool

        /// Caption positioning. Default: `.inline`. (PDF 1.7)
        public var captionPosition: CaptionPosition

        /// Caption horizontal offset from normal position. Default: 0. (PDF 1.7)
        public var captionOffsetX: Double

        /// Caption vertical offset from normal position. Default: 0. (PDF 1.7)
        public var captionOffsetY: Double

        /// The intent of the line annotation. Optional.
        public var intent: Intent?

        /// Caption positioning (Table 178, CP entry)
        public enum CaptionPosition: String, Sendable, Hashable, Codable, CaseIterable {
            /// Caption centered inside the line.
            case inline = "Inline"
            /// Caption on top of the line.
            case top = "Top"
        }

        /// Line annotation intents (Table 178)
        public enum Intent: String, Sendable, Hashable, Codable, CaseIterable {
            /// The annotation is intended to function as an arrow.
            case lineArrow = "LineArrow"
            /// The annotation is intended to function as a dimension line.
            case lineDimension = "LineDimension"
        }

        public init(
            startX: Double,
            startY: Double,
            endX: Double,
            endY: Double,
            startLineEnding: ISO_32000.`12`.`5`.LineEnding = .none,
            endLineEnding: ISO_32000.`12`.`5`.LineEnding = .none,
            interiorColor: Color? = nil,
            leaderLineLength: Double = 0,
            leaderLineExtension: Double = 0,
            leaderLineOffset: Double = 0,
            hasCaption: Bool = false,
            captionPosition: CaptionPosition = .inline,
            captionOffsetX: Double = 0,
            captionOffsetY: Double = 0,
            intent: Intent? = nil
        ) {
            self.startX = startX
            self.startY = startY
            self.endX = endX
            self.endY = endY
            self.startLineEnding = startLineEnding
            self.endLineEnding = endLineEnding
            self.interiorColor = interiorColor
            self.leaderLineLength = leaderLineLength
            self.leaderLineExtension = leaderLineExtension
            self.leaderLineOffset = leaderLineOffset
            self.hasCaption = hasCaption
            self.captionPosition = captionPosition
            self.captionOffsetX = captionOffsetX
            self.captionOffsetY = captionOffsetY
            self.intent = intent
        }
    }
}

// MARK: - Annotation.Shape (Table 180)

extension ISO_32000.`12`.`5`.Annotation {
    /// Square or Circle annotation type-specific entries (Table 180)
    ///
    /// Displays a rectangle or ellipse on the page. When opened, displays a popup
    /// window containing the text of the associated note.
    ///
    /// Note: Common fields (rect, flags, etc.) are in `Annotation`.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 180 — Additional entries specific to a square or circle annotation
    public struct Shape: Sendable, Hashable {
        /// The shape type (Square or Circle).
        public var kind: Kind

        /// Interior color for filling the shape. Optional.
        public var interiorColor: Color?

        /// Rectangle differences between Rect and actual shape. Optional.
        public var rectangleDifferences: RectangleDifferences?

        /// Shape kinds
        public enum Kind: String, Sendable, Hashable, Codable, CaseIterable {
            case square = "Square"
            case circle = "Circle"
        }

        /// Rectangle differences (RD entry)
        public struct RectangleDifferences: Sendable, Hashable {
            public var left: Double
            public var top: Double
            public var right: Double
            public var bottom: Double

            public init(left: Double, top: Double, right: Double, bottom: Double) {
                self.left = left
                self.top = top
                self.right = right
                self.bottom = bottom
            }
        }

        public init(
            kind: Kind,
            interiorColor: Color? = nil,
            rectangleDifferences: RectangleDifferences? = nil
        ) {
            self.kind = kind
            self.interiorColor = interiorColor
            self.rectangleDifferences = rectangleDifferences
        }
    }
}

// MARK: - Annotation.Poly (Table 181)

extension ISO_32000.`12`.`5`.Annotation {
    /// Polygon or Polyline annotation type-specific entries (Table 181)
    ///
    /// Polygon annotations display closed polygons; polyline annotations display
    /// similar shapes but the first and last vertices are not connected.
    ///
    /// Note: Common fields (rect, flags, etc.) are in `Annotation`.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 181 — Additional entries specific to a polygon or polyline annotation
    public struct Poly: Sendable, Hashable {
        /// The shape type (Polygon or PolyLine).
        public var kind: Kind

        /// Vertices as alternating x, y coordinates in default user space. Required.
        public var vertices: [Double]

        /// Line ending style for the start point (for polyline only). Default: `.none`.
        public var startLineEnding: ISO_32000.`12`.`5`.LineEnding?

        /// Line ending style for the end point (for polyline only). Default: `.none`.
        public var endLineEnding: ISO_32000.`12`.`5`.LineEnding?

        /// Interior color for filling. For polylines, fills only line endings; for polygons, fills entire shape.
        public var interiorColor: Color?

        /// The intent of the annotation. Optional.
        public var intent: Intent?

        /// Shape kinds
        public enum Kind: String, Sendable, Hashable, Codable, CaseIterable {
            case polygon = "Polygon"
            case polyLine = "PolyLine"
        }

        /// Polygon/Polyline annotation intents (Table 181)
        public enum Intent: String, Sendable, Hashable, Codable, CaseIterable {
            /// Polygon annotation intended to function as a cloud object.
            case polygonCloud = "PolygonCloud"
            /// Polyline annotation intended to function as a dimension. (PDF 1.7)
            case polyLineDimension = "PolyLineDimension"
            /// Polygon annotation intended to function as a dimension. (PDF 1.7)
            case polygonDimension = "PolygonDimension"
        }

        public init(
            kind: Kind,
            vertices: [Double],
            startLineEnding: ISO_32000.`12`.`5`.LineEnding? = nil,
            endLineEnding: ISO_32000.`12`.`5`.LineEnding? = nil,
            interiorColor: Color? = nil,
            intent: Intent? = nil
        ) {
            self.kind = kind
            self.vertices = vertices
            self.startLineEnding = startLineEnding
            self.endLineEnding = endLineEnding
            self.interiorColor = interiorColor
            self.intent = intent
        }
    }
}

// MARK: - Annotation.Caret (Table 183)

extension ISO_32000.`12`.`5`.Annotation {
    /// Caret annotation type-specific entries (Table 183)
    ///
    /// A visual symbol that indicates the presence of text edits.
    ///
    /// Note: Common fields (rect, flags, etc.) are in `Annotation`.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 183 — Additional entries specific to a caret annotation
    public struct Caret: Sendable, Hashable {
        /// Rectangle differences between Rect and actual caret boundaries. Optional.
        public var rectangleDifferences: Shape.RectangleDifferences?

        /// Symbol associated with the caret. Default: `.none`.
        public var symbol: Symbol

        /// Caret symbols (Table 183)
        public enum Symbol: String, Sendable, Hashable, Codable, CaseIterable {
            /// A new paragraph symbol (¶) shall be associated with the caret.
            case paragraph = "P"
            /// No symbol shall be associated with the caret.
            case none = "None"
        }

        public init(
            rectangleDifferences: Shape.RectangleDifferences? = nil,
            symbol: Symbol = .none
        ) {
            self.rectangleDifferences = rectangleDifferences
            self.symbol = symbol
        }
    }
}

// MARK: - Annotation.Stamp (Table 184)

extension ISO_32000.`12`.`5`.Annotation {
    /// Rubber stamp annotation type-specific entries (Table 184)
    ///
    /// Displays text or graphics intended to look as if stamped on the page with a rubber stamp.
    ///
    /// Note: Common fields (rect, flags, etc.) are in `Annotation`.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 184 — Additional entries specific to a rubber stamp annotation
    public struct Stamp: Sendable, Hashable {
        /// The name of the stamp icon. Default: `.draft`.
        public var iconName: IconName

        /// The intent of the stamp annotation. Default: `.stamp`. (PDF 2.0)
        public var intent: Intent

        /// Standard stamp icon names (Table 184)
        public enum IconName: String, Sendable, Hashable, Codable, CaseIterable {
            case approved = "Approved"
            case experimental = "Experimental"
            case notApproved = "NotApproved"
            case asIs = "AsIs"
            case expired = "Expired"
            case notForPublicRelease = "NotForPublicRelease"
            case confidential = "Confidential"
            case final = "Final"
            case sold = "Sold"
            case departmental = "Departmental"
            case forComment = "ForComment"
            case topSecret = "TopSecret"
            case draft = "Draft"
            case forPublicRelease = "ForPublicRelease"
        }

        /// Stamp annotation intents (Table 184, PDF 2.0)
        public enum Intent: String, Sendable, Hashable, Codable, CaseIterable {
            /// Appearance taken from preexisting PDF content.
            case stampSnapshot = "StampSnapshot"
            /// Appearance is an image.
            case stampImage = "StampImage"
            /// Appearance is a rubber stamp.
            case stamp = "Stamp"
        }

        public init(
            iconName: IconName = .draft,
            intent: Intent = .stamp
        ) {
            self.iconName = iconName
            self.intent = intent
        }
    }
}

// MARK: - Annotation.Ink (Table 185)

extension ISO_32000.`12`.`5`.Annotation {
    /// Ink annotation type-specific entries (Table 185)
    ///
    /// Represents a freehand "scribble" composed of one or more disjoint paths.
    ///
    /// Note: Common fields (rect, flags, etc.) are in `Annotation`.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 185 — Additional entries specific to an ink annotation
    public struct Ink: Sendable, Hashable {
        /// An array of stroked paths, each as alternating x, y coordinates. Required.
        public var inkList: [[Double]]

        public init(inkList: [[Double]]) {
            self.inkList = inkList
        }
    }
}

// MARK: - Annotation.Popup (Table 186)

extension ISO_32000.`12`.`5`.Annotation {
    /// Popup annotation type-specific entries (Table 186)
    ///
    /// Displays text in a popup window for entry and editing. It is associated
    /// with a parent markup annotation and used for editing the parent's text.
    ///
    /// Note: Common fields (rect, flags, etc.) are in `Annotation`.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 186 — Additional entries specific to a popup annotation
    public struct Popup: Sendable, Hashable {
        /// Whether the popup annotation shall initially be displayed open. Default: false.
        public var isOpen: Bool

        public init(isOpen: Bool = false) {
            self.isOpen = isOpen
        }
    }
}

// MARK: - Annotation.FileAttachment (Table 187)

extension ISO_32000.`12`.`5`.Annotation {
    /// File attachment annotation type-specific entries (Table 187)
    ///
    /// Contains a reference to a file, typically embedded in the PDF file.
    ///
    /// Note: Common fields (rect, flags, etc.) are in `Annotation`.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 187 — Additional entries specific to a file attachment annotation
    public struct FileAttachment: Sendable, Hashable {
        /// The name of the icon to display. Default: `.pushPin`.
        public var iconName: IconName

        /// Standard file attachment icon names (Table 187)
        public enum IconName: String, Sendable, Hashable, Codable, CaseIterable {
            case graph = "Graph"
            case pushPin = "PushPin"
            case paperclip = "Paperclip"
            case tag = "Tag"
        }

        public init(iconName: IconName = .pushPin) {
            self.iconName = iconName
        }
    }
}

// MARK: - Annotation.Redaction (Table 195)

extension ISO_32000.`12`.`5`.Annotation {
    /// Redaction annotation type-specific entries (Table 195)
    ///
    /// Identifies content intended to be removed from the document.
    /// The redaction process has two phases: content identification and content removal.
    ///
    /// Note: Common fields (rect, flags, etc.) are in `Annotation`.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 195 — Additional entries specific to a redaction annotation
    public struct Redaction: Sendable, Hashable {
        /// Quadrilaterals specifying the content region to be removed. Optional.
        public var quadPoints: [Double]?

        /// Interior color (RGB) for the redacted region after removal. Optional.
        public var interiorColor: Color?

        /// Overlay text to draw over the redacted region. Optional.
        public var overlayText: String?

        /// Whether overlay text should repeat to fill the region. Default: false.
        public var repeatText: Bool

        /// Text justification for overlay text. Default: `.leftJustified`.
        public var quadding: FreeText.Quadding

        public init(
            quadPoints: [Double]? = nil,
            interiorColor: Color? = nil,
            overlayText: String? = nil,
            repeatText: Bool = false,
            quadding: FreeText.Quadding = .leftJustified
        ) {
            self.quadPoints = quadPoints
            self.interiorColor = interiorColor
            self.overlayText = overlayText
            self.repeatText = repeatText
            self.quadding = quadding
        }
    }
}

// MARK: - Convenience Typealiases

extension ISO_32000 {
    /// Annotation (Table 166) - the algebraic sum: Common × Content
    public typealias Annotation = ISO_32000.`12`.`5`.Annotation

    /// Border (Table 166)
    public typealias Border = ISO_32000.`12`.`5`.Border

    /// Appearance dictionary (Table 170)
    public typealias Appearance = ISO_32000.`12`.`5`.Appearance

    /// Markup annotation entries (Table 172)
    public typealias Markup = ISO_32000.`12`.`5`.Markup

    /// Line ending styles (Table 179)
    public typealias LineEnding = ISO_32000.`12`.`5`.LineEnding
}
