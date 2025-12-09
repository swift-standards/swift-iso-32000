// ISO_32000.COS.StringValue.swift
// StringValue base is defined in Section 7.3.
// This file adds encoding-aware extensions using Annex D.

import ISO_32000_Annex_D
import ISO_32000_7_Syntax

// MARK: - PDFDocEncoding Support (Annex D)

extension ISO_32000.COS.StringValue {
    /// Check if this string can be encoded in PDFDocEncoding
    ///
    /// Per ISO 32000-2 Section 7.9.2.2, if all characters are encodable
    /// in PDFDocEncoding, that encoding should be used. Otherwise,
    /// UTF-16BE with BOM is required.
    public var canUsePDFDocEncoding: Bool {
        value.unicodeScalars.allSatisfy { ISO_32000.PDFDocEncoding.canEncode($0) }
    }
}

extension ISO_32000.COS.StringValue {
    /// Serialize as literal string: `(Hello)`
    ///
    /// Uses PDFDocEncoding if all characters are encodable, otherwise
    /// falls back to UTF-16BE with BOM per ISO 32000-2 Section 7.9.2.2.
    public func asLiteral() -> [UInt8] {
        var result: [UInt8] = [.ascii.leftParenthesis]

        if canUsePDFDocEncoding {
            // Use PDFDocEncoding - encode each scalar to its PDFDoc byte
            for scalar in value.unicodeScalars {
                if let byte = ISO_32000.PDFDocEncoding.encode(scalar) {
                    if let escaped = ISO_32000.`7`.`3`.Table.`3`.escapeTable[byte] {
                        result.append(contentsOf: escaped)
                    } else {
                        result.append(byte)
                    }
                }
            }
        } else {
            // UTF-16BE with BOM (0xFE 0xFF)
            result.append(0xFE)
            result.append(0xFF)
            for scalar in value.unicodeScalars {
                let codeUnit = UInt16(scalar.value)
                let hi = UInt8((codeUnit >> 8) & 0xFF)
                let lo = UInt8(codeUnit & 0xFF)
                // Escape special bytes
                if let escaped = ISO_32000.`7`.`3`.Table.`3`.escapeTable[hi] {
                    result.append(contentsOf: escaped)
                } else {
                    result.append(hi)
                }
                if let escaped = ISO_32000.`7`.`3`.Table.`3`.escapeTable[lo] {
                    result.append(contentsOf: escaped)
                } else {
                    result.append(lo)
                }
            }
        }

        result.append(.ascii.rightParenthesis)
        return result
    }

    /// Serialize as literal string using WinAnsiEncoding: `(Hello)`
    ///
    /// For use in content streams with Standard 14 fonts, which use
    /// WinAnsiEncoding rather than PDFDocEncoding.
    ///
    /// Characters not in WinAnsiEncoding are replaced with `?`.
    public func asLiteralWinAnsi() -> [UInt8] {
        // Encode string to WinAnsi bytes using Annex D
        let encodedBytes = [UInt8](winAnsi: value, withFallback: true)
        // Serialize as PDF literal string using 7.3 canonical function
        return ISO_32000.`7`.`3`.Table.`3`.literalString(from: encodedBytes)
    }

    /// Serialize as hexadecimal string: `<48656C6C6F>`
    ///
    /// Uses PDFDocEncoding if all characters are encodable, otherwise
    /// falls back to UTF-16BE with BOM per ISO 32000-2 Section 7.9.2.2.
    public func asHexadecimal() -> [UInt8] {
        var result: [UInt8] = [.ascii.lessThan]

        if canUsePDFDocEncoding {
            // Use PDFDocEncoding
            for scalar in value.unicodeScalars {
                if let byte = ISO_32000.PDFDocEncoding.encode(scalar) {
                    result.append(Self.hexChar(byte >> 4))
                    result.append(Self.hexChar(byte & 0x0F))
                }
            }
        } else {
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
    ///
    /// Prefers literal strings unless many bytes need escaping.
    public var preferredFormat: Format {
        // If using UTF-16BE, hex is often cleaner
        guard canUsePDFDocEncoding else {
            return .hexadecimal
        }

        // Count bytes that need escaping in PDFDocEncoding
        var escapeCount = 0
        for scalar in value.unicodeScalars {
            if let byte = ISO_32000.PDFDocEncoding.encode(scalar),
               ISO_32000.`7`.`3`.Table.`3`.escapeTable[byte] != nil {
                escapeCount += 1
            }
        }

        // Use hex if more than 25% would need escaping
        let total = value.unicodeScalars.count
        if total > 0 && Double(escapeCount) / Double(total) > 0.25 {
            return .hexadecimal
        }
        return .literal
    }
}

// MARK: - Parsing

extension ISO_32000.COS.StringValue {
    /// Create a StringValue by parsing raw PDF string bytes
    ///
    /// Automatically detects encoding based on BOM:
    /// - Bytes starting with 0xFE 0xFF are UTF-16BE
    /// - Bytes starting with 0xEF 0xBB 0xBF are UTF-8
    /// - All other bytes are PDFDocEncoding
    ///
    /// - Parameter bytes: Raw bytes from a PDF string object (without delimiters)
    public init<C: Collection>(pdfStringBytes bytes: C) where C.Element == UInt8 {
        switch ISO_32000.PDFDocEncoding.detectEncoding(bytes) {
        case .pdfDocEncoding:
            self.init(String(pdfDoc: bytes, withReplacement: true))
        case .utf16BE:
            // Skip BOM (first 2 bytes) and decode UTF-16BE
            let dataBytes = bytes.dropFirst(2)
            var scalars: [Unicode.Scalar] = []
            var iterator = dataBytes.makeIterator()
            while let hi = iterator.next(), let lo = iterator.next() {
                let codeUnit = UInt16(hi) << 8 | UInt16(lo)
                if let scalar = Unicode.Scalar(codeUnit) {
                    scalars.append(scalar)
                }
            }
            self.init(String(String.UnicodeScalarView(scalars)))
        case .utf8:
            // Skip BOM (first 3 bytes) and decode UTF-8
            let dataBytes = Array(bytes.dropFirst(3))
            self.init(String(decoding: dataBytes, as: UTF8.self))
        }
    }
}
