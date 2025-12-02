// ISO_32000.COS.StringValue.swift

extension ISO_32000.COS {
    /// PDF String object
    ///
    /// Per ISO 32000-1 Section 7.3.4, strings can be:
    /// - Literal strings: `(Hello World)`
    /// - Hexadecimal strings: `<48656C6C6F>`
    ///
    /// ## Encoding
    ///
    /// PDF supports two text encodings:
    /// - PDFDocEncoding: Single-byte encoding (Latin-1 subset)
    /// - UTF-16BE with BOM: For Unicode text
    ///
    /// This type always stores the logical string value; the encoding
    /// is determined at serialization time.
    public struct StringValue: Sendable, Hashable, Codable {
        /// The string content
        public let value: String

        /// Create a string value
        public init(_ value: String) {
            self.value = value
        }

        /// Escape table for literal strings (ISO 32000-1 Table 3)
        private static let escapeTable: [UInt8: [UInt8]] = [
            .ascii.lf: [.ascii.backslash, .ascii.n],     // \n
            .ascii.cr: [.ascii.backslash, .ascii.r],     // \r
            .ascii.htab: [.ascii.backslash, .ascii.t],   // \t
            .ascii.bs: [.ascii.backslash, .ascii.b],     // \b
            .ascii.ff: [.ascii.backslash, .ascii.f],     // \f
            .ascii.leftParenthesis: [.ascii.backslash, .ascii.leftParenthesis],   // \(
            .ascii.rightParenthesis: [.ascii.backslash, .ascii.rightParenthesis], // \)
            .ascii.backslash: [.ascii.backslash, .ascii.backslash],               // \\
        ]

        /// Serialize as literal string: `(Hello)`
        public func asLiteral() -> [UInt8] {
            var result: [UInt8] = [.ascii.leftParenthesis]

            // Check if we need UTF-16BE (any non-ASCII)
            let needsUnicode = value.unicodeScalars.contains { $0.value > 0x7F }

            if needsUnicode {
                // UTF-16BE with BOM (0xFE 0xFF - not ASCII, keep as hex)
                result.append(0xFE)
                result.append(0xFF)
                for scalar in value.unicodeScalars {
                    let codeUnit = UInt16(scalar.value)
                    let hi = UInt8((codeUnit >> 8) & 0xFF)
                    let lo = UInt8(codeUnit & 0xFF)
                    // Escape special bytes
                    if let escaped = Self.escapeTable[hi] {
                        result.append(contentsOf: escaped)
                    } else {
                        result.append(hi)
                    }
                    if let escaped = Self.escapeTable[lo] {
                        result.append(contentsOf: escaped)
                    } else {
                        result.append(lo)
                    }
                }
            } else {
                // PDFDocEncoding (ASCII subset)
                for byte in value.utf8 {
                    if let escaped = Self.escapeTable[byte] {
                        result.append(contentsOf: escaped)
                    } else {
                        result.append(byte)
                    }
                }
            }

            result.append(.ascii.rightParenthesis)
            return result
        }

        /// Serialize as hexadecimal string: `<48656C6C6F>`
        public func asHexadecimal() -> [UInt8] {
            var result: [UInt8] = [.ascii.lessThan]

            // Check if we need UTF-16BE
            let needsUnicode = value.unicodeScalars.contains { $0.value > 0x7F }

            if needsUnicode {
                // UTF-16BE with BOM: FEFF
                result.append(.ascii.F)
                result.append(.ascii.E)
                result.append(.ascii.F)
                result.append(.ascii.F)

                for scalar in value.unicodeScalars {
                    let codeUnit = UInt16(scalar.value)
                    let hi = UInt8((codeUnit >> 8) & 0xFF)
                    let lo = UInt8(codeUnit & 0xFF)
                    result.append(Self.hexChar(hi >> 4))
                    result.append(Self.hexChar(hi & 0x0F))
                    result.append(Self.hexChar(lo >> 4))
                    result.append(Self.hexChar(lo & 0x0F))
                }
            } else {
                for byte in value.utf8 {
                    result.append(Self.hexChar(byte >> 4))
                    result.append(Self.hexChar(byte & 0x0F))
                }
            }

            result.append(.ascii.greaterThan)
            return result
        }

        /// Get hex character for a nibble
        private static func hexChar(_ nibble: UInt8) -> UInt8 {
            nibble < 10 ? .ascii.0 + nibble : .ascii.A + nibble - 10
        }

        /// Preferred serialization format based on content
        public enum Format: Sendable {
            case literal
            case hexadecimal
        }

        /// Determine preferred format based on content
        public var preferredFormat: Format {
            var escapeCount = 0
            for byte in value.utf8 {
                if Self.escapeTable[byte] != nil {
                    escapeCount += 1
                }
            }

            // Use hex if more than 25% would need escaping
            let total = value.utf8.count
            if total > 0 && Double(escapeCount) / Double(total) > 0.25 {
                return .hexadecimal
            }
            return .literal
        }
    }
}

// MARK: - CustomStringConvertible

extension ISO_32000.COS.StringValue: CustomStringConvertible {
    public var description: String {
        "(\(value))"
    }
}

// MARK: - ExpressibleByStringLiteral

extension ISO_32000.COS.StringValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.value = value
    }
}
