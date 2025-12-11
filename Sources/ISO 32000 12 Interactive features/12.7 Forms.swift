// ISO 32000-2:2020, 12.7 Forms
//
// Sections:
//   12.7.1  General
//   12.7.2  Interactive forms
//   12.7.3  Interactive form dictionary (Table 224)
//   12.7.4  Field dictionaries (Tables 226-228)
//   12.7.5  Field types
//     12.7.5.1  General
//     12.7.5.2  Button fields (Tables 229-232)
//     12.7.5.3  Text fields (Table 233)
//     12.7.5.4  Choice fields (Tables 234-235)
//     12.7.5.5  Signature fields (Tables 236-237)
//   12.7.6  Form actions (Tables 238-243)
//   12.7.7  Annotation and page appearance characteristics
//   12.7.8  Form data format
//   12.7.9  Non-interactive forms

public import ISO_32000_Shared

extension ISO_32000.`12` {
    /// ISO 32000-2:2020, 12.7 Forms
    public enum `7` {}
}

// MARK: - Form Namespace

extension ISO_32000 {
    /// Interactive forms namespace
    ///
    /// Per ISO 32000-2:2020 Section 12.7.1:
    /// > An interactive form (PDF 1.2) — sometimes referred to as an AcroForm —
    /// > is a collection of fields for gathering information interactively from the user.
    public enum Form {}
}

// MARK: - 12.7.3 Interactive Form Dictionary (Table 224)

extension ISO_32000.Form {
    /// Interactive form dictionary (Table 224)
    ///
    /// The contents and properties of a document's interactive form shall be defined
    /// by an interactive form dictionary referenced from the AcroForm entry in the
    /// document catalog.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 224 — Entries in the interactive form dictionary
    public struct AcroForm: Sendable, Hashable {
        /// Root fields (those with no ancestors in the field hierarchy). Required.
        public var fields: [Int]  // Object references

        /// Whether to construct appearance streams for all widget annotations.
        /// Deprecated in PDF 2.0. Default: false.
        public var needAppearances: Bool

        /// Signature flags (Table 225). Default: none.
        public var sigFlags: SigFlags

        /// Calculation order for fields with calculation actions.
        public var calculationOrder: [Int]?  // Object references

        /// Default resources for form field appearance streams.
        public var defaultResources: Int?  // Object reference to resource dictionary

        /// Document-wide default appearance string for variable text fields.
        public var defaultAppearance: String?

        /// Document-wide default quadding (justification) for variable text fields.
        public var defaultQuadding: Quadding?

        public init(
            fields: [Int],
            needAppearances: Bool = false,
            sigFlags: SigFlags = [],
            calculationOrder: [Int]? = nil,
            defaultResources: Int? = nil,
            defaultAppearance: String? = nil,
            defaultQuadding: Quadding? = nil
        ) {
            self.fields = fields
            self.needAppearances = needAppearances
            self.sigFlags = sigFlags
            self.calculationOrder = calculationOrder
            self.defaultResources = defaultResources
            self.defaultAppearance = defaultAppearance
            self.defaultQuadding = defaultQuadding
        }
    }
}

// MARK: - Form.SigFlags (Table 225)

extension ISO_32000.Form {
    /// Signature flags (Table 225)
    ///
    /// Flags specifying document-level characteristics related to signature fields.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 225 — Signature flags
    public struct SigFlags: OptionSet, Sendable, Hashable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// The document contains at least one signature field.
        public static let signaturesExist = SigFlags(rawValue: 1 << 0)

        /// The document contains signatures that may be invalidated if the file
        /// is saved in a way that alters its previous contents (vs. incremental update).
        public static let appendOnly = SigFlags(rawValue: 1 << 1)
    }
}

// MARK: - Form.Quadding

extension ISO_32000.Form {
    /// Text quadding (justification) for variable text fields
    public enum Quadding: Int, Sendable, Hashable, Codable, CaseIterable {
        /// Left-justified
        case left = 0
        /// Centered
        case center = 1
        /// Right-justified
        case right = 2
    }
}

// MARK: - 12.7.4 Field Dictionary (Table 226)

extension ISO_32000.Form {
    /// Field dictionary (Table 226)
    ///
    /// Each field in a document's interactive form shall be defined by a field dictionary.
    /// Fields can be organized hierarchically and can inherit attributes from ancestors.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 226 — Entries common to all field dictionaries
    public struct Field: Sendable, Hashable {
        // MARK: - Field Hierarchy (Table 226)

        /// Reference to the parent field in the field tree. Optional.
        ///
        /// Per ISO 32000-2 Table 226, Parent entry:
        /// > (Required if this field is the child of another in the field hierarchy;
        /// > absent otherwise) An indirect reference to the field dictionary that
        /// > is the immediate parent of this one.
        public var parent: Int?  // Object reference

        /// References to child fields. Optional.
        ///
        /// Per ISO 32000-2 Table 226, Kids entry:
        /// > (Sometimes required) An array of indirect references to the immediate
        /// > children of this field. Terminal fields (those with no children) shall
        /// > not have this entry.
        public var kids: [Int]?  // Object references

        // MARK: - Field Properties

        /// Field type (required for terminal fields; inheritable).
        public var fieldType: FieldType?

        /// The partial field name. Optional.
        public var partialName: String?

        /// An alternate field name for user display. Optional.
        public var alternateName: String?

        /// The mapping name for exporting form data. Optional.
        public var mappingName: String?

        /// Field flags (Table 227). Default: 0.
        public var flags: FieldFlags

        /// The field's value.
        public var value: FieldValue?

        /// The default value to which the field reverts on reset.
        public var defaultValue: FieldValue?

        /// Additional actions dictionary.
        public var additionalActions: Int?  // Object reference

        /// Type-specific data.
        public var content: Content

        public init(
            parent: Int? = nil,
            kids: [Int]? = nil,
            fieldType: FieldType? = nil,
            partialName: String? = nil,
            alternateName: String? = nil,
            mappingName: String? = nil,
            flags: FieldFlags = [],
            value: FieldValue? = nil,
            defaultValue: FieldValue? = nil,
            additionalActions: Int? = nil,
            content: Content
        ) {
            self.parent = parent
            self.kids = kids
            self.fieldType = fieldType
            self.partialName = partialName
            self.alternateName = alternateName
            self.mappingName = mappingName
            self.flags = flags
            self.value = value
            self.defaultValue = defaultValue
            self.additionalActions = additionalActions
            self.content = content
        }
    }
}

// MARK: - Field.FieldType

extension ISO_32000.Form.Field {
    /// Field types (Table 226, FT entry)
    public enum FieldType: String, Sendable, Hashable, Codable, CaseIterable {
        /// Button field (pushbuttons, checkboxes, radio buttons)
        case button = "Btn"
        /// Text field
        case text = "Tx"
        /// Choice field (list boxes, combo boxes)
        case choice = "Ch"
        /// Signature field (PDF 1.3)
        case signature = "Sig"
    }
}

// MARK: - Field.FieldValue

extension ISO_32000.Form.Field {
    /// Field value (V entry)
    public enum FieldValue: Sendable, Hashable {
        /// Text value
        case text(String)
        /// Name value (for buttons)
        case name(String)
        /// Array of selected values (for choice fields)
        case array([String])
        /// Stream value
        case stream(Int)  // Object reference
    }
}

// MARK: - Field.Content (Sum Type)

extension ISO_32000.Form.Field {
    /// Type-specific field content
    public enum Content: Sendable, Hashable {
        /// Button field (Table 229)
        case button(Button)
        /// Text field (Table 233)
        case text(Text)
        /// Choice field (Table 234)
        case choice(Choice)
        /// Signature field (Table 236)
        case signature(Signature)
        /// Non-terminal field (container only)
        case container
    }
}

// MARK: - Field.FieldFlags (Table 227)

extension ISO_32000.Form.Field {
    /// Field flags common to all field types (Table 227)
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 227 — Field flags common to all field types
    public struct FieldFlags: OptionSet, Sendable, Hashable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// The user may not change the value of the field.
        public static let readOnly = FieldFlags(rawValue: 1 << 0)

        /// The field shall have a value before the form can be submitted.
        public static let required = FieldFlags(rawValue: 1 << 1)

        /// The field shall not be exported by a submit-form action.
        public static let noExport = FieldFlags(rawValue: 1 << 2)
    }
}

// MARK: - 12.7.5.2 Button Fields (Tables 229-232)

extension ISO_32000.Form.Field {
    /// Button field type-specific entries (Table 229)
    ///
    /// Button fields represent interactive controls to be manipulated with the mouse.
    /// There are three types: pushbuttons, checkboxes, and radio buttons.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Tables 229-232
    public struct Button: Sendable, Hashable {
        /// Button field flags (Table 232).
        public var flags: ButtonFlags

        /// The button's normal caption (for pushbuttons).
        public var normalCaption: String?

        /// The rollover caption.
        public var rolloverCaption: String?

        /// The alternate caption (when pressed).
        public var downCaption: String?

        /// The button's normal icon (form XObject).
        public var normalIcon: Int?  // Object reference

        /// The rollover icon.
        public var rolloverIcon: Int?  // Object reference

        /// The alternate icon.
        public var downIcon: Int?  // Object reference

        /// Icon fit dictionary.
        public var iconFit: IconFit?

        /// How to display the caption relative to the icon.
        public var textPosition: TextPosition

        /// For radio buttons: the export values for each option.
        public var options: [String]?

        public init(
            flags: ButtonFlags = [],
            normalCaption: String? = nil,
            rolloverCaption: String? = nil,
            downCaption: String? = nil,
            normalIcon: Int? = nil,
            rolloverIcon: Int? = nil,
            downIcon: Int? = nil,
            iconFit: IconFit? = nil,
            textPosition: TextPosition = .captionOnly,
            options: [String]? = nil
        ) {
            self.flags = flags
            self.normalCaption = normalCaption
            self.rolloverCaption = rolloverCaption
            self.downCaption = downCaption
            self.normalIcon = normalIcon
            self.rolloverIcon = rolloverIcon
            self.downIcon = downIcon
            self.iconFit = iconFit
            self.textPosition = textPosition
            self.options = options
        }
    }
}

// MARK: - Button.ButtonFlags (Table 232)

extension ISO_32000.Form.Field.Button {
    /// Button field flags (Table 232)
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 232 — Button field flags
    public struct ButtonFlags: OptionSet, Sendable, Hashable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// (Radio buttons only) Exactly one button shall be selected at all times.
        /// Selecting a button automatically deselects others.
        public static let noToggleToOff = ButtonFlags(rawValue: 1 << 14)

        /// The field is a set of radio buttons. If clear and Pushbutton is also clear,
        /// the field is a checkbox.
        public static let radio = ButtonFlags(rawValue: 1 << 15)

        /// The field is a pushbutton that does not retain a permanent value.
        public static let pushbutton = ButtonFlags(rawValue: 1 << 16)

        /// (PDF 1.5) A group of radio buttons within a radio button field that
        /// use the same value for the on state will turn on and off in unison.
        public static let radiosInUnison = ButtonFlags(rawValue: 1 << 25)
    }
}

// MARK: - Button.TextPosition (Table 230)

extension ISO_32000.Form.Field.Button {
    /// Text position relative to icon (Table 230, TP entry)
    public enum TextPosition: Int, Sendable, Hashable, Codable, CaseIterable {
        /// No icon; caption only
        case captionOnly = 0
        /// No caption; icon only
        case iconOnly = 1
        /// Caption below the icon
        case captionBelowIcon = 2
        /// Caption above the icon
        case captionAboveIcon = 3
        /// Caption to the right of the icon
        case captionRightOfIcon = 4
        /// Caption to the left of the icon
        case captionLeftOfIcon = 5
        /// Caption overlaid on the icon
        case captionOverIcon = 6
    }
}

// MARK: - Button.IconFit (Table 251)

extension ISO_32000.Form.Field.Button {
    /// Icon fit dictionary (Table 251)
    public struct IconFit: Sendable, Hashable {
        /// Scaling mode.
        public var scaleMode: ScaleMode

        /// Whether to scale proportionally.
        public var proportional: Bool

        /// Horizontal alignment (0.0 = left, 0.5 = center, 1.0 = right).
        public var horizontalAlignment: Double

        /// Vertical alignment (0.0 = bottom, 0.5 = center, 1.0 = top).
        public var verticalAlignment: Double

        /// Whether to take border width into account.
        public var fitToBounds: Bool

        /// Scaling modes
        public enum ScaleMode: String, Sendable, Hashable, Codable, CaseIterable {
            /// Always scale
            case always = "A"
            /// Scale only when icon is bigger than annotation rectangle
            case bigger = "B"
            /// Scale only when icon is smaller than annotation rectangle
            case smaller = "S"
            /// Never scale
            case never = "N"
        }

        public init(
            scaleMode: ScaleMode = .always,
            proportional: Bool = true,
            horizontalAlignment: Double = 0.5,
            verticalAlignment: Double = 0.5,
            fitToBounds: Bool = false
        ) {
            self.scaleMode = scaleMode
            self.proportional = proportional
            self.horizontalAlignment = horizontalAlignment
            self.verticalAlignment = verticalAlignment
            self.fitToBounds = fitToBounds
        }
    }
}

// MARK: - 12.7.5.3 Text Fields (Table 233)

extension ISO_32000.Form.Field {
    /// Text field type-specific entries (Table 233)
    ///
    /// A text field is a box or space where the user can enter text from the keyboard.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 233 — Additional entries specific to a text field
    public struct Text: Sendable, Hashable {
        /// Text field flags.
        public var flags: TextFlags

        /// Maximum length of the text string. Optional.
        public var maxLength: Int?

        /// Default appearance string. Required for variable text.
        public var defaultAppearance: String?

        /// Quadding (justification). Default: .left.
        public var quadding: ISO_32000.Form.Quadding

        /// Rich text value (PDF 1.5). Optional.
        public var richText: String?

        /// Default style string (PDF 1.5). Optional.
        public var defaultStyle: String?

        public init(
            flags: TextFlags = [],
            maxLength: Int? = nil,
            defaultAppearance: String? = nil,
            quadding: ISO_32000.Form.Quadding = .left,
            richText: String? = nil,
            defaultStyle: String? = nil
        ) {
            self.flags = flags
            self.maxLength = maxLength
            self.defaultAppearance = defaultAppearance
            self.quadding = quadding
            self.richText = richText
            self.defaultStyle = defaultStyle
        }
    }
}

// MARK: - Text.TextFlags (Table 233)

extension ISO_32000.Form.Field.Text {
    /// Text field flags (bits 13-25 of Ff)
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 233
    public struct TextFlags: OptionSet, Sendable, Hashable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// The field may contain multiple lines of text.
        public static let multiline = TextFlags(rawValue: 1 << 12)

        /// The field is intended for entering a secure password.
        public static let password = TextFlags(rawValue: 1 << 13)

        /// (PDF 1.4) The field is a file-select field.
        public static let fileSelect = TextFlags(rawValue: 1 << 20)

        /// (PDF 1.4) Text entered shall not be spell-checked.
        public static let doNotSpellCheck = TextFlags(rawValue: 1 << 22)

        /// (PDF 1.4) The field shall not scroll if text exceeds boundaries.
        public static let doNotScroll = TextFlags(rawValue: 1 << 23)

        /// (PDF 1.5) The field shall be divided into positions for n characters.
        public static let comb = TextFlags(rawValue: 1 << 24)

        /// (PDF 1.5) The value shall be a rich text string.
        public static let richText = TextFlags(rawValue: 1 << 25)
    }
}

// MARK: - 12.7.5.4 Choice Fields (Tables 234-235)

extension ISO_32000.Form.Field {
    /// Choice field type-specific entries (Table 234)
    ///
    /// A choice field contains several text items, of which the user may select
    /// one or more. Includes scrollable list boxes and combo boxes.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Tables 234-235 — Additional entries specific to a choice field
    public struct Choice: Sendable, Hashable {
        /// Choice field flags.
        public var flags: ChoiceFlags

        /// Array of options. Each is either a text string or a two-element array
        /// [export_value, display_value].
        public var options: [Option]

        /// For scrollable list boxes: the top index visible.
        public var topIndex: Int?

        /// Default appearance string (for editable combo boxes).
        public var defaultAppearance: String?

        /// Quadding. Default: .left.
        public var quadding: ISO_32000.Form.Quadding

        /// Choice field option
        public struct Option: Sendable, Hashable {
            /// The export value (used when exporting form data).
            public var exportValue: String
            /// The display value (shown to the user).
            public var displayValue: String

            public init(exportValue: String, displayValue: String? = nil) {
                self.exportValue = exportValue
                self.displayValue = displayValue ?? exportValue
            }
        }

        public init(
            flags: ChoiceFlags = [],
            options: [Option] = [],
            topIndex: Int? = nil,
            defaultAppearance: String? = nil,
            quadding: ISO_32000.Form.Quadding = .left
        ) {
            self.flags = flags
            self.options = options
            self.topIndex = topIndex
            self.defaultAppearance = defaultAppearance
            self.quadding = quadding
        }
    }
}

// MARK: - Choice.ChoiceFlags (Table 235)

extension ISO_32000.Form.Field.Choice {
    /// Choice field flags (Table 235)
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 235 — Choice field flags
    public struct ChoiceFlags: OptionSet, Sendable, Hashable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// The field is a combo box; if clear, it's a list box.
        public static let combo = ChoiceFlags(rawValue: 1 << 17)

        /// (Combo boxes only) The combo box includes an editable text box.
        public static let edit = ChoiceFlags(rawValue: 1 << 18)

        /// The field's options shall be sorted alphabetically.
        public static let sort = ChoiceFlags(rawValue: 1 << 19)

        /// (PDF 1.4) More than one item may be selected simultaneously.
        public static let multiSelect = ChoiceFlags(rawValue: 1 << 21)

        /// (PDF 1.4) Text shall not be spell-checked.
        public static let doNotSpellCheck = ChoiceFlags(rawValue: 1 << 22)

        /// (PDF 1.5) New value commits immediately on selection.
        public static let commitOnSelChange = ChoiceFlags(rawValue: 1 << 26)
    }
}

// MARK: - 12.7.5.5 Signature Fields (Tables 236-237)

extension ISO_32000.Form.Field {
    /// Signature field type-specific entries (Table 236)
    ///
    /// A signature field represents a digital signature that may be used to
    /// authenticate the identity of a user, the document's contents, or both.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Tables 236-237 — Additional entries specific to a signature field
    public struct Signature: Sendable, Hashable {
        /// A signature dictionary containing the signature. Optional.
        public var signatureValue: Int?  // Object reference

        /// A seed value dictionary (Table 237). Optional.
        public var seedValue: SeedValue?

        /// A signature field lock dictionary. Optional.
        public var lock: Lock?

        public init(
            signatureValue: Int? = nil,
            seedValue: SeedValue? = nil,
            lock: Lock? = nil
        ) {
            self.signatureValue = signatureValue
            self.seedValue = seedValue
            self.lock = lock
        }
    }
}

// MARK: - Signature.SeedValue (Table 237)

extension ISO_32000.Form.Field.Signature {
    /// Signature field seed value dictionary (Table 237)
    ///
    /// Constrains the properties of a signature applied to this field.
    public struct SeedValue: Sendable, Hashable {
        /// Flags specifying which seed value entries are required.
        public var flags: SeedFlags

        /// Acceptable signature handlers.
        public var filter: String?

        /// Acceptable signature sub-filters.
        public var subFilter: [String]?

        /// Required signer certificate properties.
        public var certConstraints: CertConstraints?

        /// Acceptable digest methods.
        public var digestMethod: [String]?

        /// Reasons for signing.
        public var reasons: [String]?

        /// Legal attestation strings.
        public var legalAttestation: [String]?

        /// Timestamp server URL (PDF 2.0).
        public var timeStampServer: String?

        /// Seed value flags
        public struct SeedFlags: OptionSet, Sendable, Hashable {
            public let rawValue: Int

            public init(rawValue: Int) {
                self.rawValue = rawValue
            }

            /// Filter is a required constraint.
            public static let filter = SeedFlags(rawValue: 1 << 0)
            /// SubFilter is a required constraint.
            public static let subFilter = SeedFlags(rawValue: 1 << 1)
            /// V (version) is a required constraint.
            public static let version = SeedFlags(rawValue: 1 << 2)
            /// Reasons is a required constraint.
            public static let reasons = SeedFlags(rawValue: 1 << 3)
            /// LegalAttestation is a required constraint.
            public static let legalAttestation = SeedFlags(rawValue: 1 << 4)
            /// AddRevInfo is a required constraint.
            public static let addRevInfo = SeedFlags(rawValue: 1 << 5)
            /// DigestMethod is a required constraint.
            public static let digestMethod = SeedFlags(rawValue: 1 << 6)
        }

        /// Certificate constraints
        public struct CertConstraints: Sendable, Hashable {
            /// Required certificate subject distinguished names.
            public var subject: [String]?
            /// Required certificate issuer distinguished names.
            public var issuer: [String]?
            /// Required certificate OIDs.
            public var oid: [String]?
            /// URL for additional certificate info.
            public var url: String?

            public init(
                subject: [String]? = nil,
                issuer: [String]? = nil,
                oid: [String]? = nil,
                url: String? = nil
            ) {
                self.subject = subject
                self.issuer = issuer
                self.oid = oid
                self.url = url
            }
        }

        public init(
            flags: SeedFlags = [],
            filter: String? = nil,
            subFilter: [String]? = nil,
            certConstraints: CertConstraints? = nil,
            digestMethod: [String]? = nil,
            reasons: [String]? = nil,
            legalAttestation: [String]? = nil,
            timeStampServer: String? = nil
        ) {
            self.flags = flags
            self.filter = filter
            self.subFilter = subFilter
            self.certConstraints = certConstraints
            self.digestMethod = digestMethod
            self.reasons = reasons
            self.legalAttestation = legalAttestation
            self.timeStampServer = timeStampServer
        }
    }
}

// MARK: - Signature.Lock (Table 238)

extension ISO_32000.Form.Field.Signature {
    /// Signature field lock dictionary (Table 238)
    ///
    /// Specifies which fields shall be locked when the signature is applied.
    public struct Lock: Sendable, Hashable {
        /// Which fields to lock.
        public var action: Action

        /// Fields to include or exclude (depending on action).
        public var fields: [String]?

        /// Lock actions
        public enum Action: String, Sendable, Hashable, Codable, CaseIterable {
            /// Lock all fields in the document.
            case all = "All"
            /// Lock only the specified fields.
            case include = "Include"
            /// Lock all fields except the specified ones.
            case exclude = "Exclude"
        }

        public init(action: Action, fields: [String]? = nil) {
            self.action = action
            self.fields = fields
        }
    }
}

// MARK: - 12.7.6 Form Actions

extension ISO_32000.Form {
    /// Submit-form action (Table 239)
    ///
    /// A submit-form action transmits the names and values of selected
    /// form fields to a specified URL.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 239 — Additional entries specific to a submit-form action
    public struct SubmitForm: Sendable, Hashable {
        /// The URL to submit to.
        public var url: String

        /// Fields to include or exclude.
        public var fields: [String]?

        /// Submit flags.
        public var flags: SubmitFlags

        /// Submit-form flags (Table 240)
        public struct SubmitFlags: OptionSet, Sendable, Hashable {
            public let rawValue: Int

            public init(rawValue: Int) {
                self.rawValue = rawValue
            }

            /// Fields array specifies fields to exclude (not include).
            public static let exclude = SubmitFlags(rawValue: 1 << 0)
            /// Include fields without values.
            public static let includeNoValueFields = SubmitFlags(rawValue: 1 << 1)
            /// Submit as HTML form (application/x-www-form-urlencoded).
            public static let exportFormat = SubmitFlags(rawValue: 1 << 2)
            /// Field names and values submitted as HTTP GET (not POST).
            public static let getMethod = SubmitFlags(rawValue: 1 << 3)
            /// Coordinates of mouse click submitted.
            public static let submitCoordinates = SubmitFlags(rawValue: 1 << 4)
            /// (PDF 1.4) Submit as XFDF.
            public static let xfdf = SubmitFlags(rawValue: 1 << 5)
            /// (PDF 1.4) Include annotations in FDF.
            public static let includeAppendSaves = SubmitFlags(rawValue: 1 << 6)
            /// (PDF 1.4) Include annotations.
            public static let includeAnnotations = SubmitFlags(rawValue: 1 << 7)
            /// (PDF 1.4) Submit as PDF.
            public static let submitPDF = SubmitFlags(rawValue: 1 << 8)
            /// (PDF 1.4) Convert dates to standard format.
            public static let canonicalFormat = SubmitFlags(rawValue: 1 << 9)
            /// (PDF 1.4) Exclude non-user annotations.
            public static let excludeNonUserAnnots = SubmitFlags(rawValue: 1 << 10)
            /// (PDF 1.4) Exclude F entry.
            public static let excludeFKey = SubmitFlags(rawValue: 1 << 11)
            /// (PDF 1.5) Include empty text fields.
            public static let embedForm = SubmitFlags(rawValue: 1 << 13)
        }

        public init(url: String, fields: [String]? = nil, flags: SubmitFlags = []) {
            self.url = url
            self.fields = fields
            self.flags = flags
        }
    }

    /// Reset-form action (Table 241)
    ///
    /// A reset-form action resets selected form fields to their default values.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 241 — Additional entries specific to a reset-form action
    public struct ResetForm: Sendable, Hashable {
        /// Fields to include or exclude.
        public var fields: [String]?

        /// If true, fields array specifies fields to exclude.
        public var exclude: Bool

        public init(fields: [String]? = nil, exclude: Bool = false) {
            self.fields = fields
            self.exclude = exclude
        }
    }

    /// Import-data action (Table 242)
    ///
    /// An import-data action imports FDF data from a specified file.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 242 — Additional entries specific to an import-data action
    public struct ImportData: Sendable, Hashable {
        /// The FDF file from which to import data.
        public var file: String

        public init(file: String) {
            self.file = file
        }
    }
}

// MARK: - 12.5.6.19 Widget Annotation (Tables 191-192)

extension ISO_32000.`12`.`5`.Annotation {
    /// Widget annotation type-specific entries (Tables 191-192)
    ///
    /// Widget annotations are used to display and interact with form fields.
    /// A widget annotation may be merged with the field dictionary for convenience.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Tables 191-192 — Additional entries specific to a widget annotation
    public struct Widget: Sendable, Hashable {
        /// The highlighting mode when activated. Default: .invert.
        public var highlightMode: HighlightMode

        /// Appearance characteristics dictionary.
        public var appearanceCharacteristics: AppearanceCharacteristics?

        /// The annotation's action (A entry).
        public var action: Int?  // Object reference

        /// Additional actions dictionary (AA entry).
        public var additionalActions: Int?  // Object reference

        /// Border style dictionary.
        public var borderStyle: ISO_32000.`12`.`5`.Border.Style?

        /// Widget highlighting modes
        public enum HighlightMode: String, Sendable, Hashable, Codable, CaseIterable {
            /// No highlighting
            case none = "N"
            /// Invert the annotation
            case invert = "I"
            /// Invert the border
            case outline = "O"
            /// Push effect
            case push = "P"
            /// Toggle highlighting (used with T in appearance dictionary)
            case toggle = "T"
        }

        public init(
            highlightMode: HighlightMode = .invert,
            appearanceCharacteristics: AppearanceCharacteristics? = nil,
            action: Int? = nil,
            additionalActions: Int? = nil,
            borderStyle: ISO_32000.`12`.`5`.Border.Style? = nil
        ) {
            self.highlightMode = highlightMode
            self.appearanceCharacteristics = appearanceCharacteristics
            self.action = action
            self.additionalActions = additionalActions
            self.borderStyle = borderStyle
        }
    }
}

// MARK: - Widget.AppearanceCharacteristics (Table 192)

extension ISO_32000.`12`.`5`.Annotation.Widget {
    /// Appearance characteristics dictionary (Table 192)
    ///
    /// Specifies visual characteristics for widget annotations.
    public struct AppearanceCharacteristics: Sendable, Hashable {
        /// Rotation angle in degrees (0, 90, 180, 270).
        public var rotation: Int

        /// Border color.
        public var borderColor: ISO_32000.`12`.`5`.Annotation.Color?

        /// Background color.
        public var backgroundColor: ISO_32000.`12`.`5`.Annotation.Color?

        /// Normal caption (buttons).
        public var normalCaption: String?

        /// Rollover caption.
        public var rolloverCaption: String?

        /// Alternate (down) caption.
        public var alternateCaption: String?

        /// Normal icon (form XObject reference).
        public var normalIcon: Int?

        /// Rollover icon.
        public var rolloverIcon: Int?

        /// Alternate icon.
        public var alternateIcon: Int?

        /// Icon fit dictionary.
        public var iconFit: ISO_32000.Form.Field.Button.IconFit?

        /// Text position relative to icon.
        public var textPosition: ISO_32000.Form.Field.Button.TextPosition

        public init(
            rotation: Int = 0,
            borderColor: ISO_32000.`12`.`5`.Annotation.Color? = nil,
            backgroundColor: ISO_32000.`12`.`5`.Annotation.Color? = nil,
            normalCaption: String? = nil,
            rolloverCaption: String? = nil,
            alternateCaption: String? = nil,
            normalIcon: Int? = nil,
            rolloverIcon: Int? = nil,
            alternateIcon: Int? = nil,
            iconFit: ISO_32000.Form.Field.Button.IconFit? = nil,
            textPosition: ISO_32000.Form.Field.Button.TextPosition = .captionOnly
        ) {
            self.rotation = rotation
            self.borderColor = borderColor
            self.backgroundColor = backgroundColor
            self.normalCaption = normalCaption
            self.rolloverCaption = rolloverCaption
            self.alternateCaption = alternateCaption
            self.normalIcon = normalIcon
            self.rolloverIcon = rolloverIcon
            self.alternateIcon = alternateIcon
            self.iconFit = iconFit
            self.textPosition = textPosition
        }
    }
}

// MARK: - Section Typealiases

extension ISO_32000.`12`.`7` {
    /// Interactive form dictionary (Table 224)
    public typealias AcroForm = ISO_32000.Form.AcroForm

    /// Signature flags (Table 225)
    public typealias SigFlags = ISO_32000.Form.SigFlags

    /// Field dictionary (Table 226)
    public typealias Field = ISO_32000.Form.Field

    /// Submit-form action (Table 239)
    public typealias SubmitForm = ISO_32000.Form.SubmitForm

    /// Reset-form action (Table 241)
    public typealias ResetForm = ISO_32000.Form.ResetForm

    /// Import-data action (Table 242)
    public typealias ImportData = ISO_32000.Form.ImportData
}
