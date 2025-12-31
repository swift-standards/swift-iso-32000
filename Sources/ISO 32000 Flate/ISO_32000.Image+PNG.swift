// ISO_32000.Image+PNG.swift
// PNG support for ISO_32000.Image using W3C PNG and RFC 1950

public import ISO_32000
public import W3C_PNG
public import RFC_1950

extension ISO_32000.Image {
    /// Create an image from PNG data
    ///
    /// Parses the PNG, decodes to raw pixels, then recompresses with FlateDecode.
    /// The raw pixels are stored in the PDF with `/Filter /FlateDecode`.
    ///
    /// ## Supported Color Types
    ///
    /// - Grayscale (1 channel) → DeviceGray
    /// - RGB (3 channels) → DeviceRGB
    /// - RGBA (4 channels) → Strips alpha, becomes DeviceRGB
    /// - Grayscale+Alpha (2 channels) → Strips alpha, becomes DeviceGray
    /// - Indexed (palette) → Expanded to RGB, becomes DeviceRGB
    ///
    /// - Parameter pngData: Raw PNG file bytes
    /// - Parameter compressionLevel: Flate compression level (default: balanced)
    /// - Throws: `Parse.Error` if the data is not valid PNG
    public init(
        png pngData: [UInt8],
        compressionLevel: RFC_1951.Level = .balanced
    ) throws(Parse.Error) {
        // Parse PNG
        let image: W3C_PNG.Image
        do {
            image = try W3C_PNG.parse(pngData)
        } catch {
            throw .invalidHeader
        }

        // Convert to raw RGB/Gray data (strip alpha if present)
        let (rawPixels, colorSpace) = Self.convertToRawPixels(image)

        // Compress with Flate/zlib
        var compressedData: [UInt8] = []
        RFC_1950.compress(rawPixels, into: &compressedData, level: compressionLevel)

        self.init(
            pixelWidth: image.width,
            pixelHeight: image.height,
            colorSpace: colorSpace,
            bitsPerComponent: 8,  // PNG 16-bit is downsampled to 8-bit
            filter: .flateDecode,
            data: compressedData
        )
    }

    /// Convert PNG image to raw RGB/Gray pixels
    ///
    /// Handles all PNG color types:
    /// - Grayscale: Pass through
    /// - RGB: Pass through
    /// - RGBA: Strip alpha
    /// - GrayscaleAlpha: Strip alpha
    /// - Indexed: Expand palette to RGB
    private static func convertToRawPixels(
        _ image: W3C_PNG.Image
    ) -> (pixels: [UInt8], colorSpace: Color.Space) {
        switch image.colorType {
        case .grayscale:
            // Grayscale: 1 byte per pixel
            return (image.rawPixels, .deviceGray)

        case .rgb:
            // RGB: 3 bytes per pixel
            return (image.rawPixels, .deviceRGB)

        case .rgba:
            // RGBA: 4 bytes per pixel → strip alpha → 3 bytes per pixel
            var rgb: [UInt8] = []
            rgb.reserveCapacity(image.width * image.height * 3)
            for i in stride(from: 0, to: image.rawPixels.count, by: 4) {
                rgb.append(image.rawPixels[i])      // R
                rgb.append(image.rawPixels[i + 1])  // G
                rgb.append(image.rawPixels[i + 2])  // B
                // Skip alpha at i+3
            }
            return (rgb, .deviceRGB)

        case .grayscaleAlpha:
            // Grayscale+Alpha: 2 bytes per pixel → strip alpha → 1 byte per pixel
            var gray: [UInt8] = []
            gray.reserveCapacity(image.width * image.height)
            for i in stride(from: 0, to: image.rawPixels.count, by: 2) {
                gray.append(image.rawPixels[i])  // Gray
                // Skip alpha at i+1
            }
            return (gray, .deviceGray)

        case .indexed:
            // Indexed: 1 byte palette index → expand to RGB using palette
            guard let palette = image.palette else {
                // Should not happen (PNG parser ensures palette exists for indexed)
                return (image.rawPixels, .deviceGray)
            }
            var rgb: [UInt8] = []
            rgb.reserveCapacity(image.width * image.height * 3)
            for index in image.rawPixels {
                let idx = Int(index)
                if idx < palette.count {
                    let entry = palette[idx]
                    rgb.append(entry.r)
                    rgb.append(entry.g)
                    rgb.append(entry.b)
                } else {
                    // Out of range index - use black
                    rgb.append(0)
                    rgb.append(0)
                    rgb.append(0)
                }
            }
            return (rgb, .deviceRGB)
        }
    }
}
