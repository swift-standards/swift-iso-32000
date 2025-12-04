// Color+sRGB.swift
// ISO 32000 Color ↔ IEC 61966-2-1 sRGB conversions
//
// Per ISO 32000-2 Section 8.6.4.3, DeviceRGB is defined as "red, green, and blue"
// with components in the range 0.0 to 1.0. While ISO 32000 doesn't mandate sRGB,
// sRGB (IEC 61966-2-1) is the de facto standard for RGB color encoding.

public import IEC_61966
public import ISO_32000_Shared

// MARK: - ISO 32000 Color from sRGB

extension ISO_32000.`8`.`6`.Color {
    /// Create PDF Color from IEC 61966-2-1 sRGB
    ///
    /// Converts an sRGB color to PDF DeviceRGB color space.
    ///
    /// - Parameter srgb: An sRGB color
    ///
    /// ## Reference
    ///
    /// - ISO 32000-2:2020, Section 8.6.4.3 — DeviceRGB colour space
    /// - IEC 61966-2-1:1999 — sRGB standard
    public init(_ srgb: IEC_61966.`2`.`1`.sRGB) {
        self = .rgb(r: srgb.r, g: srgb.g, b: srgb.b)
    }

    /// Create PDF Color from HSL using IEC 61966 validated types
    ///
    /// - Parameters:
    ///   - hue: Hue angle (auto-normalizes to 0-360°)
    ///   - saturation: Saturation component (0-1, validated)
    ///   - lightness: Lightness component (0-1, validated)
    public init(
        hue: IEC_61966.`2`.`1`.Hue,
        saturation: IEC_61966.`2`.`1`.Saturation,
        lightness: IEC_61966.`2`.`1`.Lightness
    ) {
        let srgb = IEC_61966.`2`.`1`.sRGB(
            hue: hue,
            saturation: saturation,
            lightness: lightness
        )
        self.init(srgb)
    }

    /// Create PDF Color from HWB using IEC 61966 validated types
    ///
    /// - Parameters:
    ///   - hue: Hue angle (auto-normalizes to 0-360°)
    ///   - whiteness: Whiteness component (0-1, validated)
    ///   - blackness: Blackness component (0-1, validated)
    public init(
        hue: IEC_61966.`2`.`1`.Hue,
        whiteness: IEC_61966.`2`.`1`.Whiteness,
        blackness: IEC_61966.`2`.`1`.Blackness
    ) {
        let srgb = IEC_61966.`2`.`1`.sRGB(
            hue: hue,
            whiteness: whiteness,
            blackness: blackness
        )
        self.init(srgb)
    }
}

// MARK: - sRGB from ISO 32000 Color

extension IEC_61966.`2`.`1`.sRGB {
    /// Create sRGB from PDF Color
    ///
    /// Converts a PDF DeviceRGB color to IEC 61966-2-1 sRGB.
    /// DeviceGray is converted by replicating the gray value to all channels.
    /// DeviceCMYK is converted via standard CMYK→RGB formula.
    ///
    /// - Parameter color: A PDF color
    public init(_ color: ISO_32000.`8`.`6`.Color) {
        switch color {
        case .gray(let g):
            self.init(gray: g)

        case .rgb(let r, let g, let b):
            self.init(r: r, g: g, b: b)

        case .cmyk(let c, let m, let y, let k):
            // Standard CMYK to RGB conversion
            let r = (1 - c) * (1 - k)
            let g = (1 - m) * (1 - k)
            let b = (1 - y) * (1 - k)
            self.init(r: r, g: g, b: b)
        }
    }
}

// MARK: - Convenience Type Alias

extension ISO_32000.`8`.`6`.Color {
    /// sRGB type from IEC 61966-2-1
    public typealias sRGB = IEC_61966.`2`.`1`.sRGB

    /// Hue type from IEC 61966-2-1
    public typealias Hue = IEC_61966.`2`.`1`.Hue

    /// Saturation type from IEC 61966-2-1
    public typealias Saturation = IEC_61966.`2`.`1`.Saturation

    /// Lightness type from IEC 61966-2-1
    public typealias Lightness = IEC_61966.`2`.`1`.Lightness

    /// Whiteness type from IEC 61966-2-1
    public typealias Whiteness = IEC_61966.`2`.`1`.Whiteness

    /// Blackness type from IEC 61966-2-1
    public typealias Blackness = IEC_61966.`2`.`1`.Blackness
}
