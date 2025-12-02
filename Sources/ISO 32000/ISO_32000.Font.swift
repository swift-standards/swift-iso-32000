// ISO_32000.Font.swift

extension ISO_32000 {
    /// PDF Font
    ///
    /// For MVP, we support the Standard 14 fonts which are guaranteed to be
    /// available in every PDF reader.
    public struct Font: Sendable, Hashable {
        /// The Standard 14 font
        public let standard14: Standard14

        /// Create a font from a Standard 14 font
        public init(_ standard14: Standard14) {
            self.standard14 = standard14
        }

        /// The PDF name for this font
        public var baseFontName: COS.Name {
            standard14.baseFontName
        }

        /// Resource name for this font (e.g., /F1)
        public var resourceName: COS.Name {
            // Use a simple naming scheme based on the font
            // These are all valid name strings so try! is safe
            switch standard14 {
            case .helvetica: return try! COS.Name("F1")
            case .helveticaBold: return try! COS.Name("F2")
            case .helveticaOblique: return try! COS.Name("F3")
            case .helveticaBoldOblique: return try! COS.Name("F4")
            case .timesRoman: return try! COS.Name("F5")
            case .timesBold: return try! COS.Name("F6")
            case .timesItalic: return try! COS.Name("F7")
            case .timesBoldItalic: return try! COS.Name("F8")
            case .courier: return try! COS.Name("F9")
            case .courierBold: return try! COS.Name("F10")
            case .courierOblique: return try! COS.Name("F11")
            case .courierBoldOblique: return try! COS.Name("F12")
            case .symbol: return try! COS.Name("F13")
            case .zapfDingbats: return try! COS.Name("F14")
            }
        }
    }
}

// MARK: - Standard 14 Fonts

extension ISO_32000.Font {
    /// The Standard 14 fonts guaranteed to be available in every PDF reader
    ///
    /// Per ISO 32000-1 Section 9.6.2.2, these fonts are pre-defined and
    /// require no embedding.
    public enum Standard14: String, Sendable, Hashable, CaseIterable {
        case helvetica = "Helvetica"
        case helveticaBold = "Helvetica-Bold"
        case helveticaOblique = "Helvetica-Oblique"
        case helveticaBoldOblique = "Helvetica-BoldOblique"
        case timesRoman = "Times-Roman"
        case timesBold = "Times-Bold"
        case timesItalic = "Times-Italic"
        case timesBoldItalic = "Times-BoldItalic"
        case courier = "Courier"
        case courierBold = "Courier-Bold"
        case courierOblique = "Courier-Oblique"
        case courierBoldOblique = "Courier-BoldOblique"
        case symbol = "Symbol"
        case zapfDingbats = "ZapfDingbats"

        /// The PDF base font name
        public var baseFontName: ISO_32000.COS.Name {
            switch self {
            case .helvetica: return .helvetica
            case .helveticaBold: return .helveticaBold
            case .helveticaOblique: return .helveticaOblique
            case .helveticaBoldOblique: return .helveticaBoldOblique
            case .timesRoman: return .timesRoman
            case .timesBold: return .timesBold
            case .timesItalic: return .timesItalic
            case .timesBoldItalic: return .timesBoldItalic
            case .courier: return .courier
            case .courierBold: return .courierBold
            case .courierOblique: return .courierOblique
            case .courierBoldOblique: return .courierBoldOblique
            case .symbol: return .symbol
            case .zapfDingbats: return .zapfDingbats
            }
        }

        /// Whether this is a fixed-width font
        public var isMonospaced: Bool {
            switch self {
            case .courier, .courierBold, .courierOblique, .courierBoldOblique:
                return true
            default:
                return false
            }
        }
    }
}

