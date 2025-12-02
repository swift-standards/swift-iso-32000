// ISO_32000.COS.serialize.swift

extension ISO_32000.COS {
    /// Serialize a COS object to PDF syntax
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ object: Object,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        switch object {
        case .null:
            buffer.append(contentsOf: "null".utf8)

        case .boolean(true):
            buffer.append(contentsOf: "true".utf8)

        case .boolean(false):
            buffer.append(contentsOf: "false".utf8)

        case .integer(let value):
            buffer.append(contentsOf: String(value).utf8)

        case .real(let value):
            // Format real number with appropriate precision
            let formatted = formatReal(value)
            buffer.append(contentsOf: formatted.utf8)

        case .name(let name):
            serializeName(name, into: &buffer)

        case .string(let str):
            // Use preferred format based on content
            switch str.preferredFormat {
            case .literal:
                buffer.append(contentsOf: str.asLiteral())
            case .hexadecimal:
                buffer.append(contentsOf: str.asHexadecimal())
            }

        case .array(let elements):
            buffer.append(.ascii.leftBracket)  // [
            for (i, element) in elements.enumerated() {
                if i > 0 {
                    buffer.append(.ascii.space)
                }
                serialize(element, into: &buffer)
            }
            buffer.append(.ascii.rightBracket)  // ]

        case .dictionary(let dict):
            serializeDictionary(dict, into: &buffer)

        case .stream(let stream):
            serializeStream(stream, into: &buffer)

        case .reference(let ref):
            buffer.append(contentsOf: "\(ref.objectNumber) \(ref.generation) R".utf8)
        }
    }

    /// Serialize a name object
    static func serializeName<Buffer: RangeReplaceableCollection>(
        _ name: Name,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        buffer.append(.ascii.solidus)  // /

        // Escape special characters per ISO 32000-1 Section 7.3.5
        for byte in name.rawValue.utf8 {
            if shouldEscapeNameByte(byte) {
                buffer.append(.ascii.numberSign)  // #
                let hi = byte >> 4
                let lo = byte & 0x0F
                buffer.append(hexChar(hi))
                buffer.append(hexChar(lo))
            } else {
                buffer.append(byte)
            }
        }
    }

    /// Check if a byte needs escaping in a name
    private static func shouldEscapeNameByte(_ byte: UInt8) -> Bool {
        // Escape: null, whitespace, delimiters, and #
        // Non-visible ASCII: control chars and DEL
        if !byte.ascii.isVisible { return true }
        // PDF delimiters that must be escaped
        if byte == .ascii.numberSign { return true }  // #
        if byte == .ascii.leftParenthesis || byte == .ascii.rightParenthesis { return true }
        if byte == .ascii.lessThan || byte == .ascii.greaterThan { return true }
        if byte == .ascii.leftBracket || byte == .ascii.rightBracket { return true }
        if byte == .ascii.leftBrace || byte == .ascii.rightBrace { return true }
        if byte == .ascii.solidus { return true }  // /
        if byte == .ascii.percentSign { return true }  // %
        return false
    }

    /// Get hex character for a nibble
    private static func hexChar(_ nibble: UInt8) -> UInt8 {
        nibble < 10 ? .ascii.0 + nibble : .ascii.A + nibble - 10
    }

    /// Serialize a dictionary
    static func serializeDictionary<Buffer: RangeReplaceableCollection>(
        _ dict: Dictionary,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        // << (dictionary open)
        buffer.append(.ascii.lessThan)
        buffer.append(.ascii.lessThan)

        for (key, value) in dict.sortedEntries {
            buffer.append(.ascii.space)
            serializeName(key, into: &buffer)
            buffer.append(.ascii.space)
            serialize(value, into: &buffer)
        }

        // >> (dictionary close)
        buffer.append(.ascii.greaterThan)
        buffer.append(.ascii.greaterThan)
    }

    /// Serialize a stream
    static func serializeStream<Buffer: RangeReplaceableCollection>(
        _ stream: Stream,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        // Stream dictionary (with /Length)
        var dict = stream.dictionary
        dict[.length] = .integer(Int64(stream.data.count))
        serializeDictionary(dict, into: &buffer)

        // Stream content
        buffer.append(contentsOf: "\nstream\n".utf8)
        buffer.append(contentsOf: stream.data)
        buffer.append(contentsOf: "\nendstream".utf8)
    }

    /// Format a real number with appropriate precision
    private static func formatReal(_ value: Double) -> String {
        // Use minimal precision that represents the value accurately
        if value == value.rounded() && abs(value) < 1e10 {
            // Integer value
            return Swift.String(Int64(value))
        }

        // Format with 6 decimal places manually
        let isNegative = value < 0
        let absValue = abs(value)
        let intPart = Int64(absValue)
        let fracPart = absValue - Double(intPart)

        // Get 6 decimal digits
        let fracDigits = Int64((fracPart * 1_000_000).rounded())

        var result = isNegative ? "-" : ""
        result += Swift.String(intPart)

        if fracDigits != 0 {
            result += "."
            var fracStr = Swift.String(fracDigits)
            // Pad with leading zeros if needed
            while fracStr.count < 6 {
                fracStr = "0" + fracStr
            }
            // Remove trailing zeros
            while fracStr.hasSuffix("0") {
                fracStr.removeLast()
            }
            result += fracStr
        }

        return result
    }
}
