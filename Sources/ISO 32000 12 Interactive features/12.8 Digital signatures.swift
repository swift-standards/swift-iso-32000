// ISO 32000-2:2020, 12.8 Digital signatures
//
// Sections:
//   12.8.1  General
//   12.8.2  Transform methods
//     12.8.2.1  General
//     12.8.2.2  DocMDP (Table 257)
//     12.8.2.3  UR (Table 258) - deprecated
//     12.8.2.4  FieldMDP (Table 259)
//   12.8.3  Signature interoperability (Table 260)
//   12.8.4  Long term validation of signatures
//     12.8.4.1  General
//     12.8.4.2  Introduction to the DSS
//     12.8.4.3  Document Security Store (Table 261)
//     12.8.4.4  Validation-related information (Table 262)
//     12.8.4.5  Usage of the DSS VRI
//   12.8.5  Document timestamp (DTS) dictionary
//   12.8.6  Permissions (Table 263)
//   12.8.7  Legal content attestations (Table 264)

public import Foundation
public import ISO_32000_Shared

extension ISO_32000.`12` {
    /// ISO 32000-2:2020, 12.8 Digital signatures
    public enum `8` {}
}

// MARK: - Digital Signature Namespace

extension ISO_32000 {
    /// Digital signature namespace
    ///
    /// Per ISO 32000-2:2020 Section 12.8.1:
    /// > A digital signature (PDF 1.3) may be used to verify the integrity of the
    /// > document's contents using verification information related to a signer.
    ///
    /// PDF supports four signature-related activities:
    /// - Adding a digital signature to a document
    /// - Verifying signature validity
    /// - Adding DSS dictionaries and VRI for later verifications
    /// - Adding document timestamp dictionaries (DTS)
    public enum DigitalSignature {}
}

// MARK: - 12.8.1 Signature Dictionary (Table 255)

extension ISO_32000.DigitalSignature {
    /// Signature dictionary (Table 255)
    ///
    /// Contains signature information for certification, approval, or timestamp signatures.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 255 — Entries in a signature dictionary
    public struct SignatureDictionary: Sendable, Hashable {
        /// Dictionary type. Sig for signature, DocTimeStamp for timestamp.
        public var type: DictionaryType

        /// Preferred signature handler name. Required, inheritable.
        public var filter: String

        /// Encoding of signature value and key information. Optional.
        public var subFilter: SubFilter?

        /// The signature value (byte range digest as hex string). Required.
        public var contents: Data

        /// X.509 certificate chain. Required when SubFilter is adbe.x509.rsa_sha1.
        public var cert: CertValue?

        /// Byte ranges for digest calculation. Required for signature fields.
        public var byteRange: [ByteRangePair]?

        /// Signature reference dictionaries for modification detection. Optional.
        public var reference: [SignatureReference]?

        /// Changes since previous signature [pages altered, fields altered, fields filled].
        public var changes: Changes?

        /// Name of person or authority signing. Optional.
        public var name: String?

        /// Time of signing. Optional.
        public var signingTime: Date?

        /// CPU host name or physical location of signing. Optional.
        public var location: String?

        /// Reason for signing. Optional.
        public var reason: String?

        /// Contact information for signature verification. Optional.
        public var contactInfo: String?

        /// Signature handler version. Deprecated in PDF 2.0.
        public var handlerVersion: Int?

        /// Signature dictionary format version. Default: 0.
        public var formatVersion: Int

        /// Build properties dictionary for signing environment. Optional.
        public var propBuild: Int?  // Object reference

        /// Seconds since signer was last authenticated. Optional.
        public var propAuthTime: Int?

        /// Authentication method used. Optional.
        public var propAuthType: AuthType?

        public init(
            type: DictionaryType = .sig,
            filter: String,
            subFilter: SubFilter? = nil,
            contents: Data,
            cert: CertValue? = nil,
            byteRange: [ByteRangePair]? = nil,
            reference: [SignatureReference]? = nil,
            changes: Changes? = nil,
            name: String? = nil,
            signingTime: Date? = nil,
            location: String? = nil,
            reason: String? = nil,
            contactInfo: String? = nil,
            handlerVersion: Int? = nil,
            formatVersion: Int = 0,
            propBuild: Int? = nil,
            propAuthTime: Int? = nil,
            propAuthType: AuthType? = nil
        ) {
            self.type = type
            self.filter = filter
            self.subFilter = subFilter
            self.contents = contents
            self.cert = cert
            self.byteRange = byteRange
            self.reference = reference
            self.changes = changes
            self.name = name
            self.signingTime = signingTime
            self.location = location
            self.reason = reason
            self.contactInfo = contactInfo
            self.handlerVersion = handlerVersion
            self.formatVersion = formatVersion
            self.propBuild = propBuild
            self.propAuthTime = propAuthTime
            self.propAuthType = propAuthType
        }
    }
}

// MARK: - SignatureDictionary PDF Key Mappings

extension ISO_32000.DigitalSignature.SignatureDictionary {
    /// PDF key mappings for serialization (Table 255 field names)
    ///
    /// Use these keys when serializing to/from PDF format.
    /// Note: Swift property names use descriptive camelCase; PDF uses abbreviated keys.
    public enum PDFKey: String, CodingKey {
        case type = "Type"
        case filter = "Filter"
        case subFilter = "SubFilter"
        case contents = "Contents"
        case cert = "Cert"
        case byteRange = "ByteRange"
        case reference = "Reference"
        case changes = "Changes"
        case name = "Name"
        case signingTime = "M"  // PDF uses "M" for signing time (date Modified)
        case location = "Location"
        case reason = "Reason"
        case contactInfo = "ContactInfo"
        case handlerVersion = "R"  // PDF uses "R" for handler version (Revision)
        case formatVersion = "V"   // PDF uses "V" for format version (Version)
        case propBuild = "Prop_Build"
        case propAuthTime = "Prop_AuthTime"
        case propAuthType = "Prop_AuthType"
    }
}

// MARK: - SignatureDictionary Supporting Types

extension ISO_32000.DigitalSignature.SignatureDictionary {
    /// Dictionary type for signature or timestamp
    public enum DictionaryType: String, Sendable, Hashable, Codable, CaseIterable {
        /// Standard signature dictionary
        case sig = "Sig"
        /// Document timestamp dictionary
        case docTimeStamp = "DocTimeStamp"
    }

    /// SubFilter values specifying signature encoding (Table 260)
    public enum SubFilter: String, Sendable, Hashable, Codable, CaseIterable {
        /// PKCS #1 RSA with SHA-1 digest (deprecated in PDF 2.0)
        case adbeX509RsaSha1 = "adbe.x509.rsa_sha1"
        /// Detached PKCS #7 signature
        case adbePkcs7Detached = "adbe.pkcs7.detached"
        /// PKCS #7 with SHA-1 (deprecated in PDF 2.0)
        case adbePkcs7Sha1 = "adbe.pkcs7.sha1"
        /// CAdES detached signature (PDF 2.0)
        case etsiCadesDetached = "ETSI.CAdES.detached"
        /// RFC 3161 timestamp (PDF 2.0)
        case etsiRfc3161 = "ETSI.RFC3161"
    }

    /// Certificate value (single or chain)
    public enum CertValue: Sendable, Hashable {
        /// Single certificate
        case single(Data)
        /// Certificate chain (signing cert first)
        case chain([Data])
    }

    /// Byte range pair (offset, length)
    public struct ByteRangePair: Sendable, Hashable {
        public var offset: Int
        public var length: Int

        public init(offset: Int, length: Int) {
            self.offset = offset
            self.length = length
        }
    }

    /// Changes made between previous and current signature
    public struct Changes: Sendable, Hashable {
        public var pagesAltered: Int
        public var fieldsAltered: Int
        public var fieldsFilled: Int

        public init(pagesAltered: Int, fieldsAltered: Int, fieldsFilled: Int) {
            self.pagesAltered = pagesAltered
            self.fieldsAltered = fieldsAltered
            self.fieldsFilled = fieldsFilled
        }
    }

    /// Authentication method for signature repudiation claims (Table 255)
    public enum AuthType: String, Sendable, Hashable, Codable, CaseIterable {
        case pin = "PIN"
        case password = "Password"
        case fingerprint = "Fingerprint"
    }
}

// MARK: - 12.8.2 Signature Reference Dictionary (Table 256)

extension ISO_32000.DigitalSignature {
    /// Signature reference dictionary (Table 256)
    ///
    /// Specifies a transform method for modification detection.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 256 — Entries in a signature reference dictionary
    public struct SignatureReference: Sendable, Hashable {
        /// Transform method for modification analysis. Required.
        public var transformMethod: TransformMethod

        /// Transform parameters specific to the method. Optional.
        public var transformParams: TransformParams?

        /// Object for modification analysis. Required for FieldMDP.
        public var data: Int?  // Indirect object reference

        /// Digest algorithm. Required.
        public var digestMethod: DigestMethod

        public init(
            transformMethod: TransformMethod,
            transformParams: TransformParams? = nil,
            data: Int? = nil,
            digestMethod: DigestMethod
        ) {
            self.transformMethod = transformMethod
            self.transformParams = transformParams
            self.data = data
            self.digestMethod = digestMethod
        }
    }
}

// MARK: - Transform Methods

extension ISO_32000.DigitalSignature.SignatureReference {
    /// Transform methods for modification detection (Table 256)
    public enum TransformMethod: String, Sendable, Hashable, Codable, CaseIterable {
        /// Detect modifications relative to certification signature
        case docMDP = "DocMDP"
        /// Detect modifications invalidating usage rights (deprecated)
        case ur = "UR"
        /// Detect modifications to specified form fields
        case fieldMDP = "FieldMDP"
    }

    /// Transform parameters (union type for all transform methods)
    public enum TransformParams: Sendable, Hashable {
        case docMDP(DocMDPParams)
        case ur(URParams)
        case fieldMDP(FieldMDPParams)
    }

    /// Digest algorithms (Table 256)
    public enum DigestMethod: String, Sendable, Hashable, Codable, CaseIterable {
        /// MD5 (deprecated in PDF 2.0)
        case md5 = "MD5"
        /// SHA-1 (deprecated in PDF 2.0)
        case sha1 = "SHA1"
        /// SHA-256
        case sha256 = "SHA256"
        /// SHA-384
        case sha384 = "SHA384"
        /// SHA-512
        case sha512 = "SHA512"
        /// RIPEMD-160
        case ripemd160 = "RIPEMD160"
    }
}

// MARK: - 12.8.2.2 DocMDP Transform Parameters (Table 257)

extension ISO_32000.DigitalSignature.SignatureReference {
    /// DocMDP transform parameters (Table 257)
    ///
    /// Specifies modification permissions for certification signatures.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 257 — Entries in the DocMDP transform parameters dictionary
    public struct DocMDPParams: Sendable, Hashable {
        /// Access permissions level. Default: 2.
        public var permissions: Permission

        /// Dictionary version. Only valid value is "1.2". Default: "1.2".
        public var version: String

        public init(
            permissions: Permission = .formFillingAndSigning,
            version: String = "1.2"
        ) {
            self.permissions = permissions
            self.version = version
        }
    }
}

extension ISO_32000.DigitalSignature.SignatureReference.DocMDPParams {
    /// DocMDP permission levels (Table 257, P entry)
    public enum Permission: Int, Sendable, Hashable, Codable, CaseIterable {
        /// No changes permitted (document is final)
        case noChanges = 1
        /// Form filling, page templates, signing permitted
        case formFillingAndSigning = 2
        /// Same as formFillingAndSigning plus annotation changes
        case formFillingSigningAndAnnotations = 3
    }
}

// MARK: - 12.8.2.3 UR Transform Parameters (Table 258) - Deprecated

extension ISO_32000.DigitalSignature.SignatureReference {
    /// UR transform parameters (Table 258)
    ///
    /// Specifies additional usage rights. Deprecated in PDF 2.0.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 258 — Entries in the UR transform parameters dictionary
    public struct URParams: Sendable, Hashable {
        /// Document-wide usage rights.
        public var document: DocumentRights

        /// Arbitrary information message.
        public var message: String?

        /// Dictionary version. Value shall be "2.2". Default: "2.2".
        public var version: String

        /// Annotation-related rights.
        public var annots: AnnotRights

        /// Form field-related rights.
        public var form: FormRights

        /// Signature-related rights.
        public var signature: SignatureRights

        /// Embedded file rights (PDF 1.6).
        public var embeddedFiles: EmbeddedFileRights

        /// If false, restrictions may be ignored.
        public var enforceRestrictions: Bool

        public init(
            document: DocumentRights = [],
            message: String? = nil,
            version: String = "2.2",
            annots: AnnotRights = [],
            form: FormRights = [],
            signature: SignatureRights = [],
            embeddedFiles: EmbeddedFileRights = [],
            enforceRestrictions: Bool = false
        ) {
            self.document = document
            self.message = message
            self.version = version
            self.annots = annots
            self.form = form
            self.signature = signature
            self.embeddedFiles = embeddedFiles
            self.enforceRestrictions = enforceRestrictions
        }
    }
}

extension ISO_32000.DigitalSignature.SignatureReference.URParams {
    /// Document-wide rights (Table 258, Document entry)
    public struct DocumentRights: OptionSet, Sendable, Hashable {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }

        /// Permit saving with modified form/annotation data
        public static let fullSave = DocumentRights(rawValue: 1 << 0)
    }

    /// Annotation rights (Table 258, Annots entry)
    public struct AnnotRights: OptionSet, Sendable, Hashable {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }

        public static let create = AnnotRights(rawValue: 1 << 0)
        public static let delete = AnnotRights(rawValue: 1 << 1)
        public static let modify = AnnotRights(rawValue: 1 << 2)
        public static let copy = AnnotRights(rawValue: 1 << 3)
        public static let `import` = AnnotRights(rawValue: 1 << 4)
        public static let export = AnnotRights(rawValue: 1 << 5)
        /// PDF 1.6: Online commenting
        public static let online = AnnotRights(rawValue: 1 << 6)
        /// PDF 1.6: Summary view
        public static let summaryView = AnnotRights(rawValue: 1 << 7)
    }

    /// Form rights (Table 258, Form entry)
    public struct FormRights: OptionSet, Sendable, Hashable {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }

        public static let add = FormRights(rawValue: 1 << 0)
        public static let delete = FormRights(rawValue: 1 << 1)
        public static let fillIn = FormRights(rawValue: 1 << 2)
        public static let `import` = FormRights(rawValue: 1 << 3)
        public static let export = FormRights(rawValue: 1 << 4)
        public static let submitStandalone = FormRights(rawValue: 1 << 5)
        public static let spawnTemplate = FormRights(rawValue: 1 << 6)
        /// PDF 1.6
        public static let barcodePlaintext = FormRights(rawValue: 1 << 7)
        /// PDF 1.6
        public static let online = FormRights(rawValue: 1 << 8)
    }

    /// Signature rights (Table 258, Signature entry)
    public struct SignatureRights: OptionSet, Sendable, Hashable {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }

        /// Permit applying/clearing digital signatures
        public static let modify = SignatureRights(rawValue: 1 << 0)
    }

    /// Embedded file rights (Table 258, EF entry)
    public struct EmbeddedFileRights: OptionSet, Sendable, Hashable {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }

        public static let create = EmbeddedFileRights(rawValue: 1 << 0)
        public static let delete = EmbeddedFileRights(rawValue: 1 << 1)
        public static let modify = EmbeddedFileRights(rawValue: 1 << 2)
        public static let `import` = EmbeddedFileRights(rawValue: 1 << 3)
    }
}

// MARK: - 12.8.2.4 FieldMDP Transform Parameters (Table 259)

extension ISO_32000.DigitalSignature.SignatureReference {
    /// FieldMDP transform parameters (Table 259)
    ///
    /// Specifies form fields that cannot change after signing.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 259 — Entries in the FieldMDP transform parameters dictionary
    public struct FieldMDPParams: Sendable, Hashable {
        /// Action determining which fields are locked. Required.
        public var action: Action

        /// Field names. Required if action is Include or Exclude.
        public var fields: [String]?

        /// Dictionary version. Value shall be "1.2". Default: "1.2".
        public var version: String

        public init(
            action: Action,
            fields: [String]? = nil,
            version: String = "1.2"
        ) {
            self.action = action
            self.fields = fields
            self.version = version
        }
    }
}

extension ISO_32000.DigitalSignature.SignatureReference.FieldMDPParams {
    /// Field action type (Table 259, Action entry)
    public enum Action: String, Sendable, Hashable, Codable, CaseIterable {
        /// All form fields locked
        case all = "All"
        /// Only specified fields locked
        case include = "Include"
        /// All except specified fields locked
        case exclude = "Exclude"
    }
}

// MARK: - 12.8.4.3 Document Security Store (Table 261)

extension ISO_32000.DigitalSignature {
    /// Document Security Store (Table 261)
    ///
    /// Contains validation information for long-term signature verification.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 261 — Entries in the document security store (DSS) dictionary
    public struct DSS: Sendable, Hashable {
        /// VRI dictionaries keyed by SHA-1 hash of signature. Optional.
        public var vri: [String: VRI]?

        /// Array of certificate streams (DER-encoded X.509). Optional.
        public var certs: [Int]?  // Indirect references to streams

        /// Array of OCSP response streams. Optional.
        public var ocsps: [Int]?  // Indirect references to streams

        /// Array of CRL streams (DER-encoded). Optional.
        public var crls: [Int]?  // Indirect references to streams

        public init(
            vri: [String: VRI]? = nil,
            certs: [Int]? = nil,
            ocsps: [Int]? = nil,
            crls: [Int]? = nil
        ) {
            self.vri = vri
            self.certs = certs
            self.ocsps = ocsps
            self.crls = crls
        }
    }
}

// MARK: - 12.8.4.4 Validation-Related Information (Table 262)

extension ISO_32000.DigitalSignature {
    /// Validation-Related Information dictionary (Table 262)
    ///
    /// Contains validation data for a specific signature.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 262 — Entries in the signature validation-related information (VRI) dictionary
    public struct VRI: Sendable, Hashable {
        /// PDF key mappings for serialization (Table 262 field names)
        ///
        /// Use these keys when serializing to/from PDF format.
        public enum PDFKey: String, CodingKey {
            case cert = "Cert"
            case crl = "CRL"
            case ocsp = "OCSP"
            case createdTime = "TU"  // PDF uses "TU" for creation time (TimeStamp Unix)
            case timestamp = "TS"    // PDF uses "TS" for timestamp stream
        }

        /// Certificate streams used for validation. Optional.
        public var cert: [Int]?  // Indirect references to streams

        /// CRL streams used for validation. Required if CRL present.
        public var crl: [Int]?  // Indirect references to streams

        /// OCSP response streams used for validation. Required if OCSP present.
        public var ocsp: [Int]?  // Indirect references to streams

        /// Time at which this VRI was created. Optional.
        public var createdTime: Date?

        /// Timestamp stream (DER-encoded RFC 3161). Optional.
        public var timestamp: Int?  // Indirect reference to stream

        public init(
            cert: [Int]? = nil,
            crl: [Int]? = nil,
            ocsp: [Int]? = nil,
            createdTime: Date? = nil,
            timestamp: Int? = nil
        ) {
            self.cert = cert
            self.crl = crl
            self.ocsp = ocsp
            self.createdTime = createdTime
            self.timestamp = timestamp
        }
    }
}

// MARK: - 12.8.6 Permissions Dictionary (Table 263)

extension ISO_32000.DigitalSignature {
    /// Permissions dictionary (Table 263)
    ///
    /// Specifies permission handlers controlling document access.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 263 — Entries in a permissions dictionary
    public struct Permissions: Sendable, Hashable {
        /// Reference to certification signature with DocMDP transform. Optional.
        public var docMDP: Int?  // Indirect reference to signature dictionary

        /// Reference to usage rights signature (deprecated in PDF 2.0). Optional.
        public var ur3: Int?  // Indirect reference to signature dictionary

        public init(
            docMDP: Int? = nil,
            ur3: Int? = nil
        ) {
            self.docMDP = docMDP
            self.ur3 = ur3
        }
    }
}

// MARK: - 12.8.7 Legal Content Attestations (Table 264)

extension ISO_32000.DigitalSignature {
    /// Legal attestation dictionary (Table 264)
    ///
    /// Specifies content that may affect the legal integrity of a signed document.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 264 — Entries in a legal attestation dictionary
    public struct LegalAttestation: Sendable, Hashable {
        /// Number of ECMAScript actions found. Optional.
        public var javaScriptActions: Int?

        /// Number of launch actions found. Optional.
        public var launchActions: Int?

        /// Number of URI actions found. Optional.
        public var uriActions: Int?

        /// Number of movie actions found (deprecated in PDF 2.0). Optional.
        public var movieActions: Int?

        /// Number of sound actions found (deprecated in PDF 2.0). Optional.
        public var soundActions: Int?

        /// Number of hide actions found. Optional.
        public var hideAnnotationActions: Int?

        /// Number of remote go-to actions found. Optional.
        public var goToRemoteActions: Int?

        /// Number of alternate images found. Optional.
        public var alternateImages: Int?

        /// Number of external streams found. Optional.
        public var externalStreams: Int?

        /// Number of TrueType fonts found. Optional.
        public var trueTypeFonts: Int?

        /// Number of reference XObjects found. Optional.
        public var externalRefXobjects: Int?

        /// Number of OPI dictionaries found (deprecated in PDF 2.0). Optional.
        public var externalOPIdicts: Int?

        /// Number of non-embedded fonts found. Optional.
        public var nonEmbeddedFonts: Int?

        /// Number of OP graphics state parameter references. Optional.
        public var devDepGS_OP: Int?

        /// Number of HT graphics state parameter references. Optional.
        public var devDepGS_HT: Int?

        /// Number of TR graphics state parameter references. Optional.
        public var devDepGS_TR: Int?

        /// Number of UCR graphics state parameter references. Optional.
        public var devDepGS_UCR: Int?

        /// Number of BG graphics state parameter references. Optional.
        public var devDepGS_BG: Int?

        /// Number of FL graphics state parameter references. Optional.
        public var devDepGS_FL: Int?

        /// Number of annotations found. Optional.
        public var annotations: Int?

        /// Whether optional content is found. Optional.
        public var optionalContent: Bool?

        /// Author's explanation of document contents. Optional.
        public var attestation: String?

        public init(
            javaScriptActions: Int? = nil,
            launchActions: Int? = nil,
            uriActions: Int? = nil,
            movieActions: Int? = nil,
            soundActions: Int? = nil,
            hideAnnotationActions: Int? = nil,
            goToRemoteActions: Int? = nil,
            alternateImages: Int? = nil,
            externalStreams: Int? = nil,
            trueTypeFonts: Int? = nil,
            externalRefXobjects: Int? = nil,
            externalOPIdicts: Int? = nil,
            nonEmbeddedFonts: Int? = nil,
            devDepGS_OP: Int? = nil,
            devDepGS_HT: Int? = nil,
            devDepGS_TR: Int? = nil,
            devDepGS_UCR: Int? = nil,
            devDepGS_BG: Int? = nil,
            devDepGS_FL: Int? = nil,
            annotations: Int? = nil,
            optionalContent: Bool? = nil,
            attestation: String? = nil
        ) {
            self.javaScriptActions = javaScriptActions
            self.launchActions = launchActions
            self.uriActions = uriActions
            self.movieActions = movieActions
            self.soundActions = soundActions
            self.hideAnnotationActions = hideAnnotationActions
            self.goToRemoteActions = goToRemoteActions
            self.alternateImages = alternateImages
            self.externalStreams = externalStreams
            self.trueTypeFonts = trueTypeFonts
            self.externalRefXobjects = externalRefXobjects
            self.externalOPIdicts = externalOPIdicts
            self.nonEmbeddedFonts = nonEmbeddedFonts
            self.devDepGS_OP = devDepGS_OP
            self.devDepGS_HT = devDepGS_HT
            self.devDepGS_TR = devDepGS_TR
            self.devDepGS_UCR = devDepGS_UCR
            self.devDepGS_BG = devDepGS_BG
            self.devDepGS_FL = devDepGS_FL
            self.annotations = annotations
            self.optionalContent = optionalContent
            self.attestation = attestation
        }
    }
}

// MARK: - Section Typealiases

extension ISO_32000.`12`.`8` {
    /// Signature dictionary (Table 255)
    public typealias SignatureDictionary = ISO_32000.DigitalSignature.SignatureDictionary

    /// Signature reference dictionary (Table 256)
    public typealias SignatureReference = ISO_32000.DigitalSignature.SignatureReference

    /// Document Security Store (Table 261)
    public typealias DSS = ISO_32000.DigitalSignature.DSS

    /// Validation-Related Information (Table 262)
    public typealias VRI = ISO_32000.DigitalSignature.VRI

    /// Permissions dictionary (Table 263)
    public typealias Permissions = ISO_32000.DigitalSignature.Permissions

    /// Legal attestation dictionary (Table 264)
    public typealias LegalAttestation = ISO_32000.DigitalSignature.LegalAttestation
}
