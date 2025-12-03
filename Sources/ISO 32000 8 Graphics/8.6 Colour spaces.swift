// ISO 32000-2:2020, 8.6 Colour spaces
//
// Sections:
//   8.6.1  General
//   8.6.2  Colour values
//   8.6.3  Colour space families
//   8.6.4  Device colour spaces
//   8.6.5  CIE-based colour spaces
//   8.6.6  Special colour spaces

public import ISO_32000_Shared

extension ISO_32000.`8` {
    /// ISO 32000-2:2020, 8.6 Colour spaces
    public enum `6` {}
}

// MARK: - 8.6.4 Device Colour Spaces

extension ISO_32000.`8`.`6` {
    /// ISO 32000-2:2020, 8.6.4 Device colour spaces
    public enum `4` {}
}

extension ISO_32000.`8`.`6`.`4` {
    /// ISO 32000-2:2020, 8.6.4.2 DeviceGray colour space
    public enum `2` {}

    /// ISO 32000-2:2020, 8.6.4.3 DeviceRGB colour space
    public enum `3` {}

    /// ISO 32000-2:2020, 8.6.4.4 DeviceCMYK colour space
    public enum `4` {}
}

// MARK: - Color Type

extension ISO_32000.`8`.`6` {
    /// PDF Color
    ///
    /// Per ISO 32000-2 Section 8.6, PDF supports several device colour spaces.
    /// This type represents colors in DeviceGray, DeviceRGB, and DeviceCMYK
    /// colour spaces.
    ///
    /// Colour component values are in the range 0.0 to 1.0.
    ///
    /// ## Device Colour Spaces
    ///
    /// Per Section 8.6.4:
    /// > Device colour spaces directly specify colours or shades of gray that
    /// > the output device shall produce.
    ///
    /// - **DeviceGray** (8.6.4.2): Single component from black (0) to white (1)
    /// - **DeviceRGB** (8.6.4.3): Three components (red, green, blue)
    /// - **DeviceCMYK** (8.6.4.4): Four components (cyan, magenta, yellow, black)
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.6 — Colour spaces
    public enum Color: Sendable, Hashable {
        /// DeviceGray colour space (0 = black, 1 = white)
        ///
        /// Per ISO 32000-2 Section 8.6.4.2:
        /// > The DeviceGray colour space shall have a single component, called gray,
        /// > in the range 0.0 to 1.0.
        case gray(Double)

        /// DeviceRGB colour space (0-1 range for each component)
        ///
        /// Per ISO 32000-2 Section 8.6.4.3:
        /// > The DeviceRGB colour space shall have three components, called red,
        /// > green, and blue, in the range 0.0 to 1.0.
        case rgb(r: Double, g: Double, b: Double)

        /// DeviceCMYK colour space (0-1 range for each component)
        ///
        /// Per ISO 32000-2 Section 8.6.4.4:
        /// > The DeviceCMYK colour space shall have four components, called cyan,
        /// > magenta, yellow, and black, in the range 0.0 to 1.0.
        case cmyk(c: Double, m: Double, y: Double, k: Double)
    }
}

// MARK: - Common Colors

extension ISO_32000.`8`.`6`.Color {
    /// Black (DeviceGray 0)
    public static let black = Self.gray(0)

    /// White (DeviceGray 1)
    public static let white = Self.gray(1)

    /// Red (DeviceRGB)
    public static let red = Self.rgb(r: 1, g: 0, b: 0)

    /// Green (DeviceRGB)
    public static let green = Self.rgb(r: 0, g: 1, b: 0)

    /// Blue (DeviceRGB)
    public static let blue = Self.rgb(r: 0, g: 0, b: 1)

    /// Cyan (DeviceRGB)
    public static let cyan = Self.rgb(r: 0, g: 1, b: 1)

    /// Magenta (DeviceRGB)
    public static let magenta = Self.rgb(r: 1, g: 0, b: 1)

    /// Yellow (DeviceRGB)
    public static let yellow = Self.rgb(r: 1, g: 1, b: 0)

    /// Dark gray (25%)
    public static let darkGray = Self.gray(0.25)

    /// Gray (50%)
    public static let gray50 = Self.gray(0.5)

    /// Light gray (75%)
    public static let lightGray = Self.gray(0.75)
}

// MARK: - Hex Color

extension ISO_32000.`8`.`6`.Color {
    /// Create color from hex string
    ///
    /// Supports formats: `#RGB`, `#RRGGBB`, `RGB`, `RRGGBB`
    ///
    /// - Parameter hex: Hex color string
    /// - Returns: RGB color or nil if parsing fails
    public init?(hex: String) {
        var hexString = hex
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }

        let scanner = hexString.unicodeScalars
        var value: UInt64 = 0

        for scalar in scanner {
            value *= 16
            switch scalar {
            case "0"..."9":
                value += UInt64(scalar.value - UnicodeScalar("0").value)
            case "a"..."f":
                value += UInt64(scalar.value - UnicodeScalar("a").value + 10)
            case "A"..."F":
                value += UInt64(scalar.value - UnicodeScalar("A").value + 10)
            default:
                return nil
            }
        }

        switch hexString.count {
        case 3:
            // RGB shorthand
            let r = Double((value >> 8) & 0xF) / 15.0
            let g = Double((value >> 4) & 0xF) / 15.0
            let b = Double(value & 0xF) / 15.0
            self = .rgb(r: r, g: g, b: b)
        case 6:
            // RRGGBB
            let r = Double((value >> 16) & 0xFF) / 255.0
            let g = Double((value >> 8) & 0xFF) / 255.0
            let b = Double(value & 0xFF) / 255.0
            self = .rgb(r: r, g: g, b: b)
        default:
            return nil
        }
    }
}

// MARK: - Component Access

extension ISO_32000.`8`.`6`.Color {
    /// Get the color space family name
    public var colorSpaceName: String {
        switch self {
        case .gray:
            return "DeviceGray"
        case .rgb:
            return "DeviceRGB"
        case .cmyk:
            return "DeviceCMYK"
        }
    }

    /// Number of components in this color
    public var componentCount: Int {
        switch self {
        case .gray:
            return 1
        case .rgb:
            return 3
        case .cmyk:
            return 4
        }
    }

    /// Get all components as an array
    public var components: [Double] {
        switch self {
        case .gray(let g):
            return [g]
        case .rgb(let r, let g, let b):
            return [r, g, b]
        case .cmyk(let c, let m, let y, let k):
            return [c, m, y, k]
        }
    }
}

// MARK: - Color Conversion

extension ISO_32000.`8`.`6`.Color {
    /// Convert to DeviceGray (using luminance formula)
    ///
    /// Uses ITU-R BT.709 luminance coefficients: Y = 0.2126*R + 0.7152*G + 0.0722*B
    public var toGray: Self {
        switch self {
        case .gray:
            return self
        case .rgb(let r, let g, let b):
            let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
            return .gray(luminance)
        case .cmyk(let c, let m, let y, let k):
            // Convert CMYK to RGB first, then to gray
            let r = (1 - c) * (1 - k)
            let g = (1 - m) * (1 - k)
            let b = (1 - y) * (1 - k)
            let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
            return .gray(luminance)
        }
    }

    /// Convert to DeviceRGB
    public var toRGB: Self {
        switch self {
        case .gray(let g):
            return .rgb(r: g, g: g, b: g)
        case .rgb:
            return self
        case .cmyk(let c, let m, let y, let k):
            let r = (1 - c) * (1 - k)
            let g = (1 - m) * (1 - k)
            let b = (1 - y) * (1 - k)
            return .rgb(r: r, g: g, b: b)
        }
    }
}
