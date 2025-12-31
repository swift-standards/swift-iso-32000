// ISO 32000-2:2020, 8.9 Images

public import ISO_32000_Shared
public import ISO_32000_7_Syntax
import Synchronization

// MARK: - Section Namespace

extension ISO_32000.`8` {
    /// ISO 32000-2:2020, 8.9 Images
    public enum `9` {}
}

// MARK: - Image XObject

extension ISO_32000.`8`.`9` {
    /// PDF Image XObject (ISO 32000-2:2020, 8.9)
    ///
    /// Represents an image that can be rendered in a PDF content stream
    /// using the Do operator. Images are XObjects stored as streams.
    ///
    /// ## Supported Formats
    ///
    /// - **JPEG**: Passthrough with DCTDecode filter (no decoding needed)
    /// - **PNG**: Decoded to raw pixels, embedded with FlateDecode filter
    ///
    /// ## PDF Structure
    ///
    /// Image XObjects are stream objects with dictionary entries:
    /// - `/Type /XObject`
    /// - `/Subtype /Image`
    /// - `/Width` - pixel width
    /// - `/Height` - pixel height
    /// - `/ColorSpace` - DeviceRGB, DeviceGray, or DeviceCMYK
    /// - `/BitsPerComponent` - typically 8
    /// - `/Filter` - /DCTDecode for JPEG, /FlateDecode for raw pixels
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Create image from JPEG data
    /// let image = try ISO_32000.Image(jpeg: jpegBytes)
    ///
    /// // Draw in content stream
    /// builder.drawImage(image, in: rect)
    /// ```
    public struct Image: Sendable, Hashable {
        // MARK: - Properties

        /// Image width in pixels
        public let pixelWidth: Int

        /// Image height in pixels
        public let pixelHeight: Int

        /// Color space
        public let colorSpace: Color.Space

        /// Bits per component (typically 8)
        public let bitsPerComponent: Int

        /// Image filter (encoding)
        public let filter: Filter

        /// Image stream data
        ///
        /// For JPEG: raw JPEG bytes (DCTDecode passthrough)
        /// For raw pixels: FlateDecode-compressed RGB/Gray data
        public let data: [UInt8]

        /// Unique identifier for resource naming
        public let id: UInt64

        // MARK: - ID Generation

        /// Thread-safe counter for generating unique IDs
        private static let idCounter = Atomic<UInt64>(0)

        /// Generate next unique ID
        private static func nextID() -> UInt64 {
            idCounter.wrappingAdd(1, ordering: .relaxed).newValue
        }

        // MARK: - Initializers

        /// Create an image with explicit parameters
        public init(
            pixelWidth: Int,
            pixelHeight: Int,
            colorSpace: Color.Space,
            bitsPerComponent: Int,
            filter: Filter,
            data: [UInt8]
        ) {
            self.pixelWidth = pixelWidth
            self.pixelHeight = pixelHeight
            self.colorSpace = colorSpace
            self.bitsPerComponent = bitsPerComponent
            self.filter = filter
            self.data = data
            self.id = Self.nextID()
        }

        // MARK: - Hashable

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}

// MARK: - Image Color Space

extension ISO_32000.`8`.`9`.Image {
    /// Image color namespace
    public enum Color {
        /// Image color spaces (ISO 32000-2:2020, 8.6)
        public enum Space: Sendable, Hashable {
            /// DeviceGray - single component grayscale
            case deviceGray

            /// DeviceRGB - three component RGB
            case deviceRGB

            /// DeviceCMYK - four component CMYK
            case deviceCMYK

            /// Number of components for this color space
            public var components: Int {
                switch self {
                case .deviceGray: 1
                case .deviceRGB: 3
                case .deviceCMYK: 4
                }
            }
        }
    }
}

// MARK: - Image Filter

extension ISO_32000.`8`.`9`.Image {
    /// Image compression filters (ISO 32000-2:2020, 7.4)
    public enum Filter: Sendable, Hashable {
        /// DCTDecode - JPEG passthrough (no decoding needed)
        case dctDecode

        /// FlateDecode - Flate/zlib compressed raw pixels
        case flateDecode
    }
}

// MARK: - Parse Error

extension ISO_32000.`8`.`9`.Image {
    /// Image parsing namespace
    public enum Parse {
        /// Image parsing errors
        public enum Error: Swift.Error, Sendable, Hashable {
            /// Invalid image header (not recognized format)
            case invalidHeader

            /// Unsupported color space / component count
            case unsupportedColorSpace(components: Int)

            /// Image data truncated
            case truncatedData

            /// Missing required marker (e.g., JPEG SOF)
            case missingMarker

            /// Unsupported image format
            case unsupportedFormat
        }
    }
}

// MARK: - JPEG Parsing

extension ISO_32000.`8`.`9`.Image {
    /// Create an image from JPEG data
    ///
    /// Parses the JPEG header to extract dimensions and color space.
    /// The raw JPEG bytes are stored for DCTDecode passthrough - the PDF
    /// reader will decode the JPEG natively.
    ///
    /// - Parameter jpegData: Raw JPEG file bytes
    /// - Throws: `Parse.Error` if the data is not valid JPEG
    public init(jpeg jpegData: [UInt8]) throws(Parse.Error) {
        // Verify JPEG magic bytes: 0xFF 0xD8 (SOI)
        guard jpegData.count >= 2,
              jpegData[0] == 0xFF,
              jpegData[1] == 0xD8 else {
            throw .invalidHeader
        }

        // Parse SOF segment for dimensions and components
        let (width, height, components) = try Self.parseJPEGHeader(jpegData)

        self.pixelWidth = width
        self.pixelHeight = height
        self.bitsPerComponent = 8  // JPEG is always 8-bit
        self.filter = .dctDecode
        self.data = jpegData
        self.id = Self.nextID()

        // Map component count to color space
        switch components {
        case 1:
            self.colorSpace = .deviceGray
        case 3:
            self.colorSpace = .deviceRGB
        case 4:
            self.colorSpace = .deviceCMYK
        default:
            throw .unsupportedColorSpace(components: components)
        }
    }

    /// Parse JPEG header to extract dimensions and component count
    ///
    /// Scans for SOF0 (baseline) or SOF2 (progressive) marker.
    /// SOF format: FF C0/C2 LENGTH(2) PRECISION(1) HEIGHT(2) WIDTH(2) COMPONENTS(1)
    private static func parseJPEGHeader(
        _ data: [UInt8]
    ) throws(Parse.Error) -> (width: Int, height: Int, components: Int) {
        var offset = 2  // Skip SOI marker

        while offset < data.count - 1 {
            guard data[offset] == 0xFF else {
                offset += 1
                continue
            }

            let marker = data[offset + 1]
            offset += 2

            // Skip padding 0xFF bytes
            guard marker != 0xFF && marker != 0x00 else { continue }

            // SOF0 (baseline DCT) or SOF2 (progressive DCT)
            if marker == 0xC0 || marker == 0xC2 {
                guard offset + 7 < data.count else {
                    throw .truncatedData
                }

                // Skip length bytes (2), read precision (1 byte)
                // Height: 2 bytes big-endian at offset+3
                let height = (Int(data[offset + 3]) << 8) | Int(data[offset + 4])
                // Width: 2 bytes big-endian at offset+5
                let width = (Int(data[offset + 5]) << 8) | Int(data[offset + 6])
                // Components: 1 byte at offset+7
                let components = Int(data[offset + 7])

                return (width, height, components)
            }

            // Skip other markers - read length and advance
            // (Markers D0-D9 are standalone, D8=SOI, D9=EOI, 01=TEM)
            if marker >= 0xD0 && marker <= 0xD9 || marker == 0x01 {
                continue
            }

            guard offset + 1 < data.count else {
                throw .truncatedData
            }
            let length = (Int(data[offset]) << 8) | Int(data[offset + 1])
            offset += length
        }

        throw .missingMarker
    }
}

// MARK: - Resource Name

extension ISO_32000.`8`.`9`.Image {
    /// Resource name for this image in the page resources
    ///
    /// Format: "Im1", "Im2", etc. following PDF conventions.
    public var resourceName: ISO_32000.`7`.`3`.COS.Name {
        // "Im" + digits is always a valid PDF name (short alphanumeric, no special chars)
        // swiftlint:disable:next force_try
        try! .init("Im\(id)")
    }
}
