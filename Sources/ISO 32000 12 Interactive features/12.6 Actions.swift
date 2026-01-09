// ISO 32000-2:2020, 12.6 Actions
//
// Sections:
//   12.6.1  General
//   12.6.2  Action dictionaries
//   12.6.3  Trigger events
//   12.6.4  Action types

public import ISO_32000_Shared

extension ISO_32000.`12` {
    /// ISO 32000-2:2020, 12.6 Actions
    public enum `6` {}
}

// MARK: - Action Namespace

extension ISO_32000 {
    /// Actions namespace
    ///
    /// Per ISO 32000-2:2020 Section 12.6.1:
    /// > In addition to jumping to a destination in the document, an annotation
    /// > or outline item may specify an action (PDF 1.1) to perform, such as
    /// > launching an application, playing a sound, changing an annotation's
    /// > appearance state.
    public enum Action {}
}

// MARK: - 12.6.4.1 Action Kind (Table 201)

extension ISO_32000.Action {
    /// Action type identifier (Table 201).
    ///
    /// Per ISO 32000-2:2020 Section 12.6.4.1:
    /// > PDF supports the standard action types listed in Table 201 — Action types.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 201 — Action types
    public enum Kind: String, Sendable, Codable, CaseIterable {
        /// Go to a destination in the current document (12.6.4.2)
        case goTo = "GoTo"

        /// Go to a destination in another document (12.6.4.3)
        case goToR = "GoToR"

        /// Go to a destination in an embedded file (PDF 1.6) (12.6.4.4)
        case goToE = "GoToE"

        /// Go to a specified DPart (PDF 2.0) (12.6.4.5)
        case goToDp = "GoToDp"

        /// Launch an application or open a file (12.6.4.6)
        case launch = "Launch"

        /// Begin reading an article thread (12.6.4.7)
        case thread = "Thread"

        /// Resolve a URI (12.6.4.8)
        case uri = "URI"

        /// Play a sound (PDF 1.2; deprecated in PDF 2.0) (12.6.4.9)
        case sound = "Sound"

        /// Play a movie (PDF 1.2; deprecated in PDF 2.0) (12.6.4.10)
        case movie = "Movie"

        /// Set an annotation's Hidden flag (PDF 1.2) (12.6.4.11)
        case hide = "Hide"

        /// Execute a predefined action (PDF 1.2) (12.6.4.12)
        case named = "Named"

        /// Send data to a URL (PDF 1.2) (12.7.6.2)
        case submitForm = "SubmitForm"

        /// Set fields to their default values (PDF 1.2) (12.7.6.3)
        case resetForm = "ResetForm"

        /// Import field values from a file (PDF 1.2) (12.7.6.4)
        case importData = "ImportData"

        /// Set the states of optional content groups (PDF 1.5) (12.6.4.13)
        case setOCGState = "SetOCGState"

        /// Control multimedia playback (PDF 1.5) (12.6.4.14)
        case rendition = "Rendition"

        /// Update display using a transition (PDF 1.5) (12.6.4.15)
        case trans = "Trans"

        /// Set the current view of a 3D annotation (PDF 1.6) (12.6.4.16)
        case goTo3DView = "GoTo3DView"

        /// Execute an ECMAScript script (PDF 1.3) (12.6.4.17)
        case javaScript = "JavaScript"

        /// Send a command to a RichMedia annotation (PDF 2.0) (12.6.4.18)
        case richMediaExecute = "RichMediaExecute"
    }
}

// MARK: - 12.6.4.2 Go-To Action (Table 202)

extension ISO_32000.Action {
    /// A go-to action changes the view to a specified destination.
    ///
    /// Per ISO 32000-2:2020 Section 12.6.4.2:
    /// > A go-to action changes the view to a specified destination (page, location,
    /// > and magnification factor).
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 202 — Additional entries specific to a go-to action
    public struct GoTo: Sendable {
        /// The destination to jump to.
        ///
        /// Per ISO 32000-2 Table 202:
        /// > (Required) The destination to jump to (see 12.3.2, "Destinations").
        public var destination: ISO_32000.Destination

        /// Optional structure destination (PDF 2.0).
        ///
        /// Per ISO 32000-2 Table 202:
        /// > (Optional; PDF 2.0) The structure destination to jump to.
        /// > If present, the structure destination should take precedence
        /// > over destination in the D entry.
        public var structureDestination: [String]?

        /// Create a go-to action.
        ///
        /// - Parameter destination: The destination to jump to
        public init(destination: ISO_32000.Destination) {
            self.destination = destination
            self.structureDestination = nil
        }
    }
}

// MARK: - 12.6.4.3 Remote Go-To Action (Table 203)

extension ISO_32000.Action {
    /// A remote go-to action jumps to a destination in another PDF document.
    ///
    /// Per ISO 32000-2:2020 Section 12.6.4.3:
    /// > A remote go-to action is similar to an ordinary go-to action but jumps
    /// > to a destination in another PDF file instead of the current file.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 203 — Additional entries specific to a remote go-to action
    public struct GoToR: Sendable {
        /// The file containing the destination.
        ///
        /// Per ISO 32000-2 Table 203:
        /// > (Required) The file in which the destination shall be located.
        public var file: String

        /// The destination in the remote document.
        ///
        /// For remote destinations, the first element is a page number (0-indexed)
        /// rather than a page object reference.
        public var destination: ISO_32000.Destination

        /// Whether to open the document in a new window.
        ///
        /// Per ISO 32000-2 Table 203:
        /// > (Optional; PDF 1.2) A flag specifying whether to open the destination
        /// > document in a new window.
        public var newWindow: Bool?

        /// Create a remote go-to action.
        ///
        /// - Parameters:
        ///   - file: The file path or URL of the target document
        ///   - destination: The destination within that document
        ///   - newWindow: Whether to open in a new window
        public init(file: String, destination: ISO_32000.Destination, newWindow: Bool? = nil) {
            self.file = file
            self.destination = destination
            self.newWindow = newWindow
        }
    }
}

// MARK: - 12.6.4.8 URI Action (Table 210)

extension ISO_32000.Action {
    /// A URI action resolves a uniform resource identifier.
    ///
    /// Per ISO 32000-2:2020 Section 12.6.4.8:
    /// > A uniform resource identifier (URI) is a string that identifies (resolves to)
    /// > a resource on the Internet — typically a file that is the destination of a
    /// > hypertext link.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 210 — Additional entries specific to a URI action
    public struct URI: Sendable, Equatable, Hashable, Codable {
        /// The URI to resolve.
        ///
        /// Per ISO 32000-2 Table 210:
        /// > (Required) The uniform resource identifier to resolve, encoded in UTF-8.
        public var uri: String

        /// Whether to track mouse position when the URI is resolved.
        ///
        /// Per ISO 32000-2 Table 210:
        /// > (Optional) A flag specifying whether to track the mouse position when
        /// > the URI is resolved. Default value: false.
        ///
        /// If true, mouse coordinates are appended to the URI as query parameters.
        public var isMap: Bool

        /// Create a URI action.
        ///
        /// - Parameters:
        ///   - uri: The URI to resolve (encoded in UTF-8)
        ///   - isMap: Whether to track mouse position (default: false)
        public init(uri: String, isMap: Bool = false) {
            self.uri = uri
            self.isMap = isMap
        }
    }
}

// MARK: - 12.6.4.11 Hide Action (Table 214)

extension ISO_32000.Action {
    /// A hide action shows or hides annotations.
    ///
    /// Per ISO 32000-2:2020 Section 12.6.4.11:
    /// > A hide action (PDF 1.2) hides or shows one or more annotations on the screen
    /// > by setting or clearing their Hidden flags.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 214 — Additional entries specific to a hide action
    public struct Hide: Sendable, Equatable, Hashable, Codable {
        /// The target specification for annotations to hide/show.
        public enum Target: Sendable, Equatable, Hashable, Codable {
            /// A single annotation reference
            case annotation(Int)

            /// A field name
            case field(String)

            /// Multiple targets
            case multiple([Target])
        }

        /// The annotation(s) to hide or show.
        ///
        /// Per ISO 32000-2 Table 214:
        /// > (Required) The annotation or annotations to be hidden or shown.
        public var target: Target

        /// Whether to hide (true) or show (false) the annotation.
        ///
        /// Per ISO 32000-2 Table 214:
        /// > (Optional) A flag indicating whether to hide the annotation (true)
        /// > or show it (false). Default value: true.
        public var hide: Bool

        /// Create a hide action.
        ///
        /// - Parameters:
        ///   - target: The annotation(s) to affect
        ///   - hide: Whether to hide (true) or show (false)
        public init(target: Target, hide: Bool = true) {
            self.target = target
            self.hide = hide
        }
    }
}

// MARK: - 12.6.4.12 Named Action (Table 215, 216)

extension ISO_32000.Action {
    /// A named action executes a predefined action.
    ///
    /// Per ISO 32000-2:2020 Section 12.6.4.12:
    /// > Table 215 lists several named actions (PDF 1.2) that interactive PDF processors
    /// > shall support.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 215 — Named actions
    /// ISO 32000-2:2020, Table 216 — Additional entries specific to named actions
    public struct Named: Sendable, Equatable, Hashable, Codable {
        /// Predefined named action types (Table 215).
        public enum Name: String, Sendable, Codable, CaseIterable {
            /// Go to the next page of the document
            case nextPage = "NextPage"

            /// Go to the previous page of the document
            case prevPage = "PrevPage"

            /// Go to the first page of the document
            case firstPage = "FirstPage"

            /// Go to the last page of the document
            case lastPage = "LastPage"
        }

        /// The name of the action to perform.
        ///
        /// Per ISO 32000-2 Table 216:
        /// > (Required) The name of the action that shall be performed.
        public var name: Name

        /// Create a named action.
        ///
        /// - Parameter name: The predefined action to execute
        public init(name: Name) {
            self.name = name
        }
    }
}

// MARK: - 12.6.4.17 JavaScript Action (Table 221)

extension ISO_32000.Action {
    /// A JavaScript action executes an ECMAScript script.
    ///
    /// Per ISO 32000-2:2020 Section 12.6.4.17:
    /// > Upon invocation of an ECMAScript action, a PDF processor shall execute
    /// > a script that is written in the ECMAScript programming language.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 221 — Additional entries specific to an ECMAScript action
    public struct JavaScript: Sendable, Equatable, Hashable, Codable {
        /// The ECMAScript code to execute.
        ///
        /// Per ISO 32000-2 Table 221:
        /// > (Required) A text string or text stream containing the ECMAScript
        /// > script to be executed.
        public var script: String

        /// Create a JavaScript action.
        ///
        /// - Parameter script: The ECMAScript code to execute
        public init(script: String) {
            self.script = script
        }
    }
}

// MARK: - 12.6.4.4 Go-To-Embedded Action (Table 204)

extension ISO_32000.Action {
    /// A go-to-embedded action jumps to a destination in an embedded file.
    ///
    /// Per ISO 32000-2:2020 Section 12.6.4.4:
    /// > A go-to-embedded action (PDF 1.6) is similar to a remote go-to action but
    /// > allows jumping to a destination in a PDF file that is embedded in another
    /// > PDF file.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 204 — Additional entries specific to an embedded go-to action
    public struct GoToE: Sendable, Hashable {
        /// The root document from which to find the target.
        ///
        /// Per ISO 32000-2 Table 204:
        /// > (Optional) The root document of the target relative to the root document
        /// > of the source.
        public var file: String?

        /// The destination in the embedded document.
        ///
        /// Per ISO 32000-2 Table 204:
        /// > (Required) The destination in the target to jump to.
        public var destination: ISO_32000.Destination

        /// A target dictionary specifying path information to the target document.
        ///
        /// Per ISO 32000-2 Table 204:
        /// > (Required if F is not present) A target dictionary specifying path
        /// > information to the target document.
        public var target: Target?

        /// Whether to open the document in a new window.
        ///
        /// Per ISO 32000-2 Table 204:
        /// > (Optional) If true, the destination document shall be opened in a new window;
        /// > if false, the destination document shall replace the current document.
        public var newWindow: Bool?

        /// Target dictionary for embedded go-to action
        public struct Target: Sendable, Hashable {
            /// The relationship between the current document and the target.
            public enum Relation: String, Sendable, Hashable, Codable, CaseIterable {
                /// The target is the parent of the current document.
                case parent = "P"
                /// The target is a child of the current document.
                case child = "C"
            }

            /// The relationship to the target.
            public var relation: Relation

            /// The name of the file in the EmbeddedFiles name tree (for child relation).
            public var name: String?

            /// The page number in a PDF Portfolio (PDF 2.0).
            public var pageNumber: Int?

            /// The annotation index on the page (for child relation).
            public var annotationIndex: Int?

            /// Further target specification for multi-level embedding.
            public var next: Box<Target>?

            public init(
                relation: Relation,
                name: String? = nil,
                pageNumber: Int? = nil,
                annotationIndex: Int? = nil,
                next: Target? = nil
            ) {
                self.relation = relation
                self.name = name
                self.pageNumber = pageNumber
                self.annotationIndex = annotationIndex
                self.next = next.map { Box($0) }
            }
        }

        public init(
            destination: ISO_32000.Destination,
            file: String? = nil,
            target: Target? = nil,
            newWindow: Bool? = nil
        ) {
            self.destination = destination
            self.file = file
            self.target = target
            self.newWindow = newWindow
        }
    }

    /// Box type for recursive Target structure
    public final class Box<T: Sendable & Hashable>: @unchecked Sendable, Hashable {
        public let value: T

        public init(_ value: T) {
            self.value = value
        }

        public static func == (lhs: Box<T>, rhs: Box<T>) -> Bool {
            lhs.value == rhs.value
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(value)
        }
    }
}

// MARK: - 12.6.4.5 Go-To-DPart Action (Tables 205, 206)

extension ISO_32000.Action {
    /// A go-to-DPart action jumps to a specific DPart in a PDF document.
    ///
    /// Per ISO 32000-2:2020 Section 12.6.4.5:
    /// > A go-to-DPart action (PDF 2.0) identifies a specific DPart (14.12, "Document
    /// > parts") as the destination. A DPart action may optionally include a go-to
    /// > action whose destination is used if the DPart cannot be located.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Tables 205-206 — Additional entries specific to a go-to-DPart action
    public struct GoToDp: Sendable, Hashable {
        /// The DPart to jump to.
        ///
        /// Per ISO 32000-2 Table 206:
        /// > (Required) An indirect reference to the DPart dictionary representing
        /// > the destination document part.
        public var dpart: Int  // Object reference

        /// Create a go-to-DPart action.
        ///
        /// - Parameter dpart: Object reference to the DPart dictionary
        public init(dpart: Int) {
            self.dpart = dpart
        }
    }
}

// MARK: - 12.6.4.6 Launch Action (Table 207)

extension ISO_32000.Action {
    /// A launch action launches an application or opens a document.
    ///
    /// Per ISO 32000-2:2020 Section 12.6.4.6:
    /// > A launch action launches an application or opens or prints a document.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 207 — Additional entries specific to a launch action
    public struct Launch: Sendable, Hashable {
        /// The application to launch or document to open.
        ///
        /// Per ISO 32000-2 Table 207:
        /// > (Required if none of the entries Win, Mac, or Unix is present)
        /// > The application that shall be launched or the document that shall be
        /// > opened or printed.
        public var file: String?

        /// Windows-specific launch parameters.
        public var win: WindowsLaunch?

        /// Whether to open the document in a new window.
        ///
        /// Per ISO 32000-2 Table 207:
        /// > (Optional; PDF 1.4) If true, the new document shall be opened in a new
        /// > window. Default value: false.
        public var newWindow: Bool?

        /// Windows-specific launch parameters (Table 207)
        public struct WindowsLaunch: Sendable, Hashable {
            /// The file name of the application or document.
            public var file: String

            /// The default directory.
            public var directory: String?

            /// The operation to perform: "open" or "print".
            public var operation: Operation?

            /// The parameter string to pass to the application.
            public var parameters: String?

            /// Windows launch operations
            public enum Operation: String, Sendable, Hashable, Codable, CaseIterable {
                /// Open the document.
                case open
                /// Print the document.
                case print
            }

            public init(
                file: String,
                directory: String? = nil,
                operation: Operation? = nil,
                parameters: String? = nil
            ) {
                self.file = file
                self.directory = directory
                self.operation = operation
                self.parameters = parameters
            }
        }

        public init(
            file: String? = nil,
            win: WindowsLaunch? = nil,
            newWindow: Bool? = nil
        ) {
            self.file = file
            self.win = win
            self.newWindow = newWindow
        }
    }
}

// MARK: - 12.6.4.7 Thread Action (Tables 208, 209)

extension ISO_32000.Action {
    /// A thread action jumps to a bead in an article thread.
    ///
    /// Per ISO 32000-2:2020 Section 12.6.4.7:
    /// > A thread action (PDF 1.1) jumps to a specified bead on an article thread,
    /// > starting at a specific bead or the first bead in the thread.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Tables 208-209 — Additional entries specific to a thread action
    public struct Thread: Sendable, Hashable {
        /// The file containing the thread (if not the current document).
        ///
        /// Per ISO 32000-2 Table 209:
        /// > (Optional) The file containing the thread. If this entry is absent,
        /// > the thread is in the current file.
        public var file: String?

        /// The thread specification.
        ///
        /// Per ISO 32000-2 Table 209:
        /// > (Required) The destination thread, specified as an index into the
        /// > Threads array of the catalog, a byte string representing the thread's
        /// > title, or an indirect reference to a thread dictionary.
        public var thread: ThreadSpec

        /// The bead in the thread.
        ///
        /// Per ISO 32000-2 Table 209:
        /// > (Optional) The bead in the destination thread, specified as an index
        /// > into the thread's B array or an indirect reference to a bead dictionary.
        public var bead: BeadSpec?

        /// Thread specification (index, name, or reference)
        public enum ThreadSpec: Sendable, Hashable {
            /// Index into the Threads array.
            case index(Int)
            /// Thread title.
            case title(String)
            /// Indirect reference to thread dictionary.
            case reference(Int)
        }

        /// Bead specification (index or reference)
        public enum BeadSpec: Sendable, Hashable {
            /// Index into the thread's B array.
            case index(Int)
            /// Indirect reference to bead dictionary.
            case reference(Int)
        }

        public init(
            thread: ThreadSpec,
            file: String? = nil,
            bead: BeadSpec? = nil
        ) {
            self.thread = thread
            self.file = file
            self.bead = bead
        }
    }
}

// MARK: - 12.6.4.13 Set-OCG-State Action (Table 217)

extension ISO_32000.Action {
    /// A set-OCG-state action changes the state of optional content groups.
    ///
    /// Per ISO 32000-2:2020 Section 12.6.4.13:
    /// > A set-OCG-state action (PDF 1.5) sets the state of one or more optional
    /// > content groups.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 217 — Additional entries specific to a set-OCG-state action
    public struct SetOCGState: Sendable, Hashable {
        /// The state changes to apply.
        ///
        /// Per ISO 32000-2 Table 217:
        /// > (Required) An array consisting of any number of sequences, each of which
        /// > begins with a state change command (ON, OFF, or Toggle) followed by one
        /// > or more references to optional content group dictionaries.
        public var state: [StateChange]

        /// Whether to preserve the current RadioButton states.
        ///
        /// Per ISO 32000-2 Table 217:
        /// > (Optional) If true, indicates that the states of radio button groups should
        /// > be preserved when setting states. Default value: true.
        public var preserveRB: Bool

        /// State change command
        public enum Command: String, Sendable, Hashable, Codable, CaseIterable {
            /// Set the OCG to ON.
            case on = "ON"
            /// Set the OCG to OFF.
            case off = "OFF"
            /// Toggle the OCG state.
            case toggle = "Toggle"
        }

        /// A state change entry (command + OCG references)
        public struct StateChange: Sendable, Hashable {
            /// The command to apply.
            public var command: Command
            /// Object references to OCG dictionaries.
            public var ocgs: [Int]

            public init(command: Command, ocgs: [Int]) {
                self.command = command
                self.ocgs = ocgs
            }
        }

        public init(state: [StateChange], preserveRB: Bool = true) {
            self.state = state
            self.preserveRB = preserveRB
        }
    }
}

// MARK: - 12.6.4.14 Rendition Action (Tables 218, 219)

extension ISO_32000.Action {
    /// A rendition action controls multimedia playback.
    ///
    /// Per ISO 32000-2:2020 Section 12.6.4.14:
    /// > A rendition action (PDF 1.5) associates a screen annotation with a rendition
    /// > for the purpose of playing the rendition.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Tables 218-219 — Additional entries specific to a rendition action
    public struct Rendition: Sendable, Hashable {
        /// The operation to perform.
        ///
        /// Per ISO 32000-2 Table 219:
        /// > (Required if JS is not present) The operation to perform.
        public var operation: Operation?

        /// The screen annotation with which this action is associated.
        ///
        /// Per ISO 32000-2 Table 219:
        /// > (Required if OP is 0 or 4; optional otherwise) An indirect reference
        /// > to a screen annotation to which the action is associated.
        public var annotation: Int?  // Object reference

        /// The rendition object.
        ///
        /// Per ISO 32000-2 Table 219:
        /// > (Required if OP is 0; optional otherwise) An indirect reference to a
        /// > rendition object.
        public var rendition: Int?  // Object reference

        /// ECMAScript code to execute.
        ///
        /// Per ISO 32000-2 Table 219:
        /// > (Optional) A text string or stream containing an ECMAScript script.
        public var javaScript: String?

        /// Rendition operations (Table 218)
        public enum Operation: Int, Sendable, Hashable, Codable, CaseIterable {
            /// Associate rendition with annotation and play.
            case play = 0
            /// Stop any rendition playing in the annotation.
            case stop = 1
            /// Pause any rendition playing in the annotation.
            case pause = 2
            /// Resume any paused rendition.
            case resume = 3
            /// Play the rendition designated by the AN entry.
            case playFromAnnotation = 4
        }

        public init(
            operation: Operation? = nil,
            annotation: Int? = nil,
            rendition: Int? = nil,
            javaScript: String? = nil
        ) {
            self.operation = operation
            self.annotation = annotation
            self.rendition = rendition
            self.javaScript = javaScript
        }
    }
}

// MARK: - 12.6.4.15 Transition Action (Table 220)

extension ISO_32000.Action {
    /// A transition action updates the display with a page transition.
    ///
    /// Per ISO 32000-2:2020 Section 12.6.4.15:
    /// > A trans action (PDF 1.5) provides the ability to update the display
    /// > of a document, using a transition dictionary.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 220 — Additional entries specific to a transition action
    public struct Transition: Sendable, Hashable {
        /// The transition dictionary.
        ///
        /// Per ISO 32000-2 Table 220:
        /// > (Required) A transition dictionary describing the transition effect
        /// > (see 14.11.3, "Transitions").
        public var trans: TransitionDict

        /// Transition dictionary (simplified representation)
        public struct TransitionDict: Sendable, Hashable {
            /// Transition style
            public var style: Style

            /// Duration of the transition in seconds. Default: 1.
            public var duration: Double

            /// Transition styles (Table 363)
            public enum Style: String, Sendable, Hashable, Codable, CaseIterable {
                /// Two lines sweep across the screen, split.
                case split = "Split"
                /// Multiple lines sweep across the screen, blinds.
                case blinds = "Blinds"
                /// The new page reveals from one box to four.
                case box = "Box"
                /// Single line sweeping across the screen.
                case wipe = "Wipe"
                /// Old page dissolves to reveal the new page.
                case dissolve = "Dissolve"
                /// Similar to Dissolve, pixels in two-direction sweep.
                case glitter = "Glitter"
                /// No transition effect.
                case replace = "R"
                /// Changes are flown in (PDF 1.5).
                case fly = "Fly"
                /// Old page pushes new page (PDF 1.5).
                case push = "Push"
                /// New page slides over old (PDF 1.5).
                case cover = "Cover"
                /// Old page slides off (PDF 1.5).
                case uncover = "Uncover"
                /// Old page fades out, new fades in (PDF 1.5).
                case fade = "Fade"
            }

            public init(style: Style = .replace, duration: Double = 1) {
                self.style = style
                self.duration = duration
            }
        }

        public init(trans: TransitionDict) {
            self.trans = trans
        }
    }
}

// MARK: - 12.6.4.18 RichMediaExecute Action (Tables 222, 223)

extension ISO_32000.Action {
    /// A rich media execute action sends a command to a rich media annotation.
    ///
    /// Per ISO 32000-2:2020 Section 12.6.4.18:
    /// > A rich media execute action (PDF 2.0) sends a command to a rich media
    /// > annotation.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Tables 222-223 — Additional entries specific to a rich media execute action
    public struct RichMediaExecute: Sendable, Hashable {
        /// The rich media annotation to target.
        ///
        /// Per ISO 32000-2 Table 223:
        /// > (Required) An indirect reference to a RichMedia annotation.
        public var annotation: Int  // Object reference

        /// The command to execute.
        ///
        /// Per ISO 32000-2 Table 223:
        /// > (Required) An indirect reference to a rich media command dictionary.
        public var command: Command

        /// Rich media command dictionary (Table 222)
        public struct Command: Sendable, Hashable {
            /// The type of command.
            ///
            /// Per ISO 32000-2 Table 222:
            /// > (Required) Specifies the type of command.
            public var type: CommandType

            /// The command name.
            ///
            /// Per ISO 32000-2 Table 222:
            /// > (Optional) The command name.
            public var name: String?

            /// The argument to pass.
            ///
            /// Per ISO 32000-2 Table 222:
            /// > (Optional) The argument to pass to the command.
            public var argument: String?

            /// Command types
            public enum CommandType: String, Sendable, Hashable, Codable, CaseIterable {
                /// Call a JavaScript function in the instance.
                case javaScript = "cycscript"
            }

            public init(type: CommandType, name: String? = nil, argument: String? = nil) {
                self.type = type
                self.name = name
                self.argument = argument
            }
        }

        public init(annotation: Int, command: Command) {
            self.annotation = annotation
            self.command = command
        }
    }
}

// MARK: - 12.6.3 Trigger Events (Tables 197-200)

extension ISO_32000.Action {
    /// Additional actions dictionary for form fields (Table 199)
    ///
    /// Defines actions triggered by various events on form fields.
    /// These are critical for form validation, formatting, and calculation.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 199 — Entries in a form field's additional-actions dictionary
    public struct FormFieldTriggers: Sendable, Hashable {
        /// Action performed when user types a keystroke. Optional.
        ///
        /// Per ISO 32000-2 Table 199, K entry:
        /// > (Optional) An action that shall be performed when the user types a
        /// > keystroke in a text field or combo box, or modifies the selection
        /// > in a scrollable list box.
        public var keystroke: JavaScript?

        /// Action performed before field is formatted for display. Optional.
        ///
        /// Per ISO 32000-2 Table 199, F entry:
        /// > (Optional) An action that shall be performed before the field is
        /// > formatted to display its current value. This action may modify the
        /// > field's value before formatting.
        public var format: JavaScript?

        /// Action performed when field's value is changed. Optional.
        ///
        /// Per ISO 32000-2 Table 199, V entry:
        /// > (Optional) An action that shall be performed when the field's value
        /// > is changed. This action may check the new value for validity.
        public var validate: JavaScript?

        /// Action performed to recalculate field's value. Optional.
        ///
        /// Per ISO 32000-2 Table 199, C entry:
        /// > (Optional) An action that shall be performed in order to recalculate
        /// > the value of this field when that of another field changes.
        public var calculate: JavaScript?

        public init(
            keystroke: JavaScript? = nil,
            format: JavaScript? = nil,
            validate: JavaScript? = nil,
            calculate: JavaScript? = nil
        ) {
            self.keystroke = keystroke
            self.format = format
            self.validate = validate
            self.calculate = calculate
        }
    }

    /// Additional actions dictionary for annotations (Table 198)
    ///
    /// Defines actions triggered by various events on annotations.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 198 — Entries in an annotation's additional-actions dictionary
    public struct AnnotationTriggers: Sendable, Hashable {
        /// Action performed when cursor enters annotation area. Optional.
        public var cursorEnter: JavaScript?

        /// Action performed when cursor exits annotation area. Optional.
        public var cursorExit: JavaScript?

        /// Action performed when mouse button is pressed. Optional.
        public var mouseDown: JavaScript?

        /// Action performed when mouse button is released. Optional.
        public var mouseUp: JavaScript?

        /// Action performed when annotation receives input focus. Optional.
        public var focus: JavaScript?

        /// Action performed when annotation loses input focus. Optional.
        public var blur: JavaScript?

        /// Action performed when page containing annotation is opened. Optional.
        public var pageOpen: JavaScript?

        /// Action performed when page containing annotation is closed. Optional.
        public var pageClose: JavaScript?

        /// Action performed when page containing annotation becomes visible. Optional.
        public var pageVisible: JavaScript?

        /// Action performed when page containing annotation is no longer visible. Optional.
        public var pageInvisible: JavaScript?

        public init(
            cursorEnter: JavaScript? = nil,
            cursorExit: JavaScript? = nil,
            mouseDown: JavaScript? = nil,
            mouseUp: JavaScript? = nil,
            focus: JavaScript? = nil,
            blur: JavaScript? = nil,
            pageOpen: JavaScript? = nil,
            pageClose: JavaScript? = nil,
            pageVisible: JavaScript? = nil,
            pageInvisible: JavaScript? = nil
        ) {
            self.cursorEnter = cursorEnter
            self.cursorExit = cursorExit
            self.mouseDown = mouseDown
            self.mouseUp = mouseUp
            self.focus = focus
            self.blur = blur
            self.pageOpen = pageOpen
            self.pageClose = pageClose
            self.pageVisible = pageVisible
            self.pageInvisible = pageInvisible
        }
    }
}

// MARK: - Section Typealiases

extension ISO_32000.`12`.`6` {
    /// Action kind (Table 201)
    public typealias Kind = ISO_32000.Action.Kind

    /// Go-to action (Table 202)
    public typealias GoTo = ISO_32000.Action.GoTo

    /// Remote go-to action (Table 203)
    public typealias GoToR = ISO_32000.Action.GoToR

    /// Embedded go-to action (Table 204)
    public typealias GoToE = ISO_32000.Action.GoToE

    /// Go-to-DPart action (Tables 205-206)
    public typealias GoToDp = ISO_32000.Action.GoToDp

    /// Launch action (Table 207)
    public typealias Launch = ISO_32000.Action.Launch

    /// Thread action (Tables 208-209)
    public typealias Thread = ISO_32000.Action.Thread

    /// URI action (Table 210)
    public typealias URI = ISO_32000.Action.URI

    /// Hide action (Table 214)
    public typealias Hide = ISO_32000.Action.Hide

    /// Named action (Table 216)
    public typealias Named = ISO_32000.Action.Named

    /// Set-OCG-State action (Table 217)
    public typealias SetOCGState = ISO_32000.Action.SetOCGState

    /// Rendition action (Tables 218-219)
    public typealias Rendition = ISO_32000.Action.Rendition

    /// Transition action (Table 220)
    public typealias Transition = ISO_32000.Action.Transition

    /// JavaScript action (Table 221)
    public typealias JavaScript = ISO_32000.Action.JavaScript

    /// RichMediaExecute action (Tables 222-223)
    public typealias RichMediaExecute = ISO_32000.Action.RichMediaExecute

    /// Form field triggers (Table 199)
    public typealias FormFieldTriggers = ISO_32000.Action.FormFieldTriggers

    /// Annotation triggers (Table 198)
    public typealias AnnotationTriggers = ISO_32000.Action.AnnotationTriggers
}

// MARK: - Raw Spec Text (for reference)

// 12.6 Actions
// 12.6.1 General
// In addition to jumping to a destination in the document, an annotation or outline item may specify an
// action (PDF 1.1) to perform, such as launching an application, playing a sound, changing an
// annotation's appearance state.

// Table 196 — Entries common to all action dictionaries
// Key Type Value
// Type name (Optional) The type of PDF object that this dictionary describes;
// if present, shall be Action for an action dictionary.
// S name (Required) The type of action that this dictionary describes; see
// "Table 201 — Action types" for specific values.
// Next dictionary or array (Optional; PDF 1.2) The next action or sequence of actions.

// Table 201 — Action types
// GoTo Go to a destination in the current document. 12.6.4.2
// GoToR Go to a destination in another document. 12.6.4.3
// GoToE Go to a destination in an embedded file. 12.6.4.4
// GoToDp Go to a specified DPart. 12.6.4.5
// Launch Launch an application. 12.6.4.6
// Thread Begin reading an article thread. 12.6.4.7
// URI Resolve a URI. 12.6.4.8
// Sound Play a sound. 12.6.4.9
// Movie Play a movie. 12.6.4.10
// Hide Set an annotation's Hidden flag. 12.6.4.11
// Named Execute a predefined action. 12.6.4.12
// SubmitForm Send data to a URL. 12.7.6.2
// ResetForm Set fields to their default values. 12.7.6.3
// ImportData Import field values from a file. 12.7.6.4
// SetOCGState Set the states of optional content groups. 12.6.4.13
// Rendition Controls multimedia playback. 12.6.4.14
// Trans Updates display using a transition. 12.6.4.15
// GoTo3DView Set the view of a 3D annotation. 12.6.4.16
// JavaScript Execute an ECMAScript script. 12.6.4.17
// RichMediaExecute Send a command to a RichMedia annotation. 12.6.4.18

// Table 202 — Additional entries specific to a go-to action
// S name (Required) shall be GoTo
// D name, byte string, or array (Required) The destination to jump to
// SD array (Optional; PDF 2.0) The structure destination

// Table 210 — Additional entries specific to a URI action
// S name (Required) shall be URI
// URI ASCII string (Required) The URI to resolve, encoded in UTF-8
// IsMap boolean (Optional) Track mouse position. Default: false

// Table 214 — Additional entries specific to a hide action
// S name (Required) shall be Hide
// T dictionary, text string, or array (Required) The annotations to hide/show
// H boolean (Optional) Hide (true) or show (false). Default: true

// Table 215 — Named actions
// NextPage, PrevPage, FirstPage, LastPage

// Table 216 — Additional entries specific to named actions
// S name (Required) shall be Named
// N name (Required) The action name

// Table 221 — Additional entries specific to an ECMAScript action
// S name (Required) shall be JavaScript
// JS text string or stream (Required) The script to execute
