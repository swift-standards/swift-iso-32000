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

// MARK: - Section Typealiases

extension ISO_32000.`12`.`6` {
    /// Action kind (Table 201)
    public typealias Kind = ISO_32000.Action.Kind

    /// Go-to action (Table 202)
    public typealias GoTo = ISO_32000.Action.GoTo

    /// Remote go-to action (Table 203)
    public typealias GoToR = ISO_32000.Action.GoToR

    /// URI action (Table 210)
    public typealias URI = ISO_32000.Action.URI

    /// Hide action (Table 214)
    public typealias Hide = ISO_32000.Action.Hide

    /// Named action (Table 216)
    public typealias Named = ISO_32000.Action.Named

    /// JavaScript action (Table 221)
    public typealias JavaScript = ISO_32000.Action.JavaScript
}

// MARK: - Raw Spec Text (for reference)

//12.6 Actions
//12.6.1 General
//In addition to jumping to a destination in the document, an annotation or outline item may specify an
//action (PDF 1.1) to perform, such as launching an application, playing a sound, changing an
//annotation's appearance state.

//Table 196 — Entries common to all action dictionaries
//Key Type Value
//Type name (Optional) The type of PDF object that this dictionary describes;
//if present, shall be Action for an action dictionary.
//S name (Required) The type of action that this dictionary describes; see
//"Table 201 — Action types" for specific values.
//Next dictionary or array (Optional; PDF 1.2) The next action or sequence of actions.

//Table 201 — Action types
//GoTo Go to a destination in the current document. 12.6.4.2
//GoToR Go to a destination in another document. 12.6.4.3
//GoToE Go to a destination in an embedded file. 12.6.4.4
//GoToDp Go to a specified DPart. 12.6.4.5
//Launch Launch an application. 12.6.4.6
//Thread Begin reading an article thread. 12.6.4.7
//URI Resolve a URI. 12.6.4.8
//Sound Play a sound. 12.6.4.9
//Movie Play a movie. 12.6.4.10
//Hide Set an annotation's Hidden flag. 12.6.4.11
//Named Execute a predefined action. 12.6.4.12
//SubmitForm Send data to a URL. 12.7.6.2
//ResetForm Set fields to their default values. 12.7.6.3
//ImportData Import field values from a file. 12.7.6.4
//SetOCGState Set the states of optional content groups. 12.6.4.13
//Rendition Controls multimedia playback. 12.6.4.14
//Trans Updates display using a transition. 12.6.4.15
//GoTo3DView Set the view of a 3D annotation. 12.6.4.16
//JavaScript Execute an ECMAScript script. 12.6.4.17
//RichMediaExecute Send a command to a RichMedia annotation. 12.6.4.18

//Table 202 — Additional entries specific to a go-to action
//S name (Required) shall be GoTo
//D name, byte string, or array (Required) The destination to jump to
//SD array (Optional; PDF 2.0) The structure destination

//Table 210 — Additional entries specific to a URI action
//S name (Required) shall be URI
//URI ASCII string (Required) The URI to resolve, encoded in UTF-8
//IsMap boolean (Optional) Track mouse position. Default: false

//Table 214 — Additional entries specific to a hide action
//S name (Required) shall be Hide
//T dictionary, text string, or array (Required) The annotations to hide/show
//H boolean (Optional) Hide (true) or show (false). Default: true

//Table 215 — Named actions
//NextPage, PrevPage, FirstPage, LastPage

//Table 216 — Additional entries specific to named actions
//S name (Required) shall be Named
//N name (Required) The action name

//Table 221 — Additional entries specific to an ECMAScript action
//S name (Required) shall be JavaScript
//JS text string or stream (Required) The script to execute
