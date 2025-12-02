// ISO_32000_Flate.swift

public import ISO_32000
public import RFC_1950

extension ISO_32000.StreamCompression {
    /// ZLIB/FlateDecode compression
    ///
    /// Uses RFC 1950 (ZLIB) compression which wraps RFC 1951 (DEFLATE).
    /// This is the standard compression format used in PDF files.
    public static let flate = ISO_32000.StreamCompression { input, output in
        RFC_1950.compress(input, into: &output)
    }

    /// ZLIB/FlateDecode compression with custom level
    public static func flate(level: RFC_1951.Level) -> ISO_32000.StreamCompression {
        ISO_32000.StreamCompression { input, output in
            RFC_1950.compress(input, into: &output, level: level)
        }
    }
}

extension ISO_32000.Writer {
    /// Create a writer with FlateDecode compression
    ///
    /// ## Example
    ///
    /// ```swift
    /// var writer = ISO_32000.Writer.flate()
    /// let pdf = writer.write(document)
    /// ```
    public static func flate(level: RFC_1951.Level = .balanced) -> ISO_32000.Writer {
        ISO_32000.Writer(compression: .flate(level: level))
    }
}
