// ISO_32000.PDFDocEncoding.swift
// ISO 32000-2:2020 Annex D.3 - PDFDocEncoding character set
//
// Encoding for text strings in a PDF document outside content streams.
// Used for document metadata, annotations, bookmarks, and other text strings.

public import ISO_32000_Shared

extension ISO_32000 {
    /// PDFDocEncoding - Text strings outside content streams
    ///
    /// Per ISO 32000-2 Table D.1:
    /// > Encoding for text strings in a PDF document outside the document's
    /// > content streams. This is one of two encodings (the other being Unicode)
    /// > that may be used to represent text strings; see 7.9.2.2, "Text string type".
    /// > PDF does not have a predefined encoding named PDFDocEncoding; it is not
    /// > customary to use this encoding to show text from fonts.
    ///
    /// ## Key Characteristics
    ///
    /// - Bytes 0-23: Control characters (mostly undefined)
    /// - Bytes 24-31: Diacritical marks (breve, caron, circumflex, etc.)
    /// - Bytes 32-126: Standard ASCII
    /// - Byte 127: Undefined
    /// - Bytes 128-159: Typography (bullet, dagger, quotes, ligatures, etc.)
    /// - Bytes 160-255: Latin supplement with differences from Latin-1
    ///
    /// ## Important Differences from WinAnsiEncoding
    ///
    /// | Byte | PDFDocEncoding | WinAnsiEncoding |
    /// |------|----------------|-----------------|
    /// | 0x80 | U+2022 BULLET  | U+20AC EURO     |
    /// | 0xA0 | U+20AC EURO    | U+00A0 NBSP     |
    /// | 0x18-0x1F | Diacritics | Undefined     |
    /// | 0x93-0x94 | fi/fl ligatures | Smart quotes |
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.3 — PDFDocEncoding character set
    public enum PDFDocEncoding: Encoding {
        /// The encoding name (note: not used as predefined name in PDF)
        public static let name: String = "PDFDocEncoding"

        // MARK: - Decode Table

        /// Complete decode table from ISO 32000-2 Table D.3
        ///
        /// Notes column meanings:
        /// - U: Undefined code point in PDFDocEncoding
        /// - SR: Unicode codepoint that may require special representation in XML
        public static let decodeTable: [Unicode.Scalar?] = [
            // 0x00-0x17: Control characters (undefined - marked U in spec)
            nil,  // 0x00 NULL (U)
            nil,  // 0x01 START OF HEADING (U)
            nil,  // 0x02 START OF TEXT (U)
            nil,  // 0x03 END OF TEXT (U)
            nil,  // 0x04 END OF TEXT (U) - note: typo in spec, should be EOT
            nil,  // 0x05 END OF TRANSMISSION (U)
            nil,  // 0x06 ACKNOWLEDGE (U)
            nil,  // 0x07 BELL (U)
            nil,  // 0x08 BACKSPACE (U)
            "\u{0009}",  // 0x09 CHARACTER TABULATION (SR)
            "\u{000A}",  // 0x0A LINE FEED (SR)
            nil,  // 0x0B LINE TABULATION (U)
            nil,  // 0x0C FORM FEED (U)
            "\u{000D}",  // 0x0D CARRIAGE RETURN (SR)
            nil,  // 0x0E SHIFT OUT (U)
            nil,  // 0x0F SHIFT IN (U)
            nil,  // 0x10 DATA LINK ESCAPE (U)
            nil,  // 0x11 DEVICE CONTROL ONE (U)
            nil,  // 0x12 DEVICE CONTROL TWO (U)
            nil,  // 0x13 DEVICE CONTROL THREE (U)
            nil,  // 0x14 DEVICE CONTROL FOUR (U)
            nil,  // 0x15 NEGATIVE ACKNOWLEDGE (U)
            nil,  // 0x16 SYNCHRONOUS IDLE (U)
            nil,  // 0x17 END OF TRANSMISSION BLOCK (U)

            // 0x18-0x1F: Diacritical marks (unique to PDFDocEncoding)
            "\u{02D8}",  // 0x18 BREVE
            "\u{02C7}",  // 0x19 CARON
            "\u{02C6}",  // 0x1A MODIFIER LETTER CIRCUMFLEX ACCENT
            "\u{02D9}",  // 0x1B DOT ABOVE
            "\u{02DD}",  // 0x1C DOUBLE ACUTE ACCENT
            "\u{02DB}",  // 0x1D OGONEK
            "\u{02DA}",  // 0x1E RING ABOVE
            "\u{02DC}",  // 0x1F SMALL TILDE

            // 0x20-0x3F: ASCII punctuation and digits
            "\u{0020}",  // 0x20 SPACE
            "\u{0021}",  // 0x21 EXCLAMATION MARK (SR)
            "\u{0022}",  // 0x22 QUOTATION MARK (SR)
            "\u{0023}",  // 0x23 NUMBER SIGN
            "\u{0024}",  // 0x24 DOLLAR SIGN
            "\u{0025}",  // 0x25 PERCENT SIGN
            "\u{0026}",  // 0x26 AMPERSAND (SR)
            "\u{0027}",  // 0x27 APOSTROPHE (SR)
            "\u{0028}",  // 0x28 LEFT PARENTHESIS
            "\u{0029}",  // 0x29 RIGHT PARENTHESIS
            "\u{002A}",  // 0x2A ASTERISK
            "\u{002B}",  // 0x2B PLUS SIGN
            "\u{002C}",  // 0x2C COMMA
            "\u{002D}",  // 0x2D HYPHEN-MINUS
            "\u{002E}",  // 0x2E FULL STOP
            "\u{002F}",  // 0x2F SOLIDUS
            "\u{0030}",  // 0x30 DIGIT ZERO
            "\u{0031}",  // 0x31 DIGIT ONE
            "\u{0032}",  // 0x32 DIGIT TWO
            "\u{0033}",  // 0x33 DIGIT THREE
            "\u{0034}",  // 0x34 DIGIT FOUR
            "\u{0035}",  // 0x35 DIGIT FIVE
            "\u{0036}",  // 0x36 DIGIT SIX
            "\u{0037}",  // 0x37 DIGIT SEVEN
            "\u{0038}",  // 0x38 DIGIT EIGHT
            "\u{0039}",  // 0x39 DIGIT NINE
            "\u{003A}",  // 0x3A COLON
            "\u{003B}",  // 0x3B SEMICOLON
            "\u{003C}",  // 0x3C LESS-THAN SIGN (SR)
            "\u{003D}",  // 0x3D EQUALS SIGN
            "\u{003E}",  // 0x3E GREATER-THAN SIGN (SR)
            "\u{003F}",  // 0x3F QUESTION MARK

            // 0x40-0x5A: ASCII uppercase letters
            "\u{0040}",  // 0x40 COMMERCIAL AT
            "\u{0041}",  // 0x41 LATIN CAPITAL LETTER A
            "\u{0042}",  // 0x42 LATIN CAPITAL LETTER B
            "\u{0043}",  // 0x43 LATIN CAPITAL LETTER C
            "\u{0044}",  // 0x44 LATIN CAPITAL LETTER D
            "\u{0045}",  // 0x45 LATIN CAPITAL LETTER E
            "\u{0046}",  // 0x46 LATIN CAPITAL LETTER F
            "\u{0047}",  // 0x47 LATIN CAPITAL LETTER G
            "\u{0048}",  // 0x48 LATIN CAPITAL LETTER H
            "\u{0049}",  // 0x49 LATIN CAPITAL LETTER I
            "\u{004A}",  // 0x4A LATIN CAPITAL LETTER J
            "\u{004B}",  // 0x4B LATIN CAPITAL LETTER K
            "\u{004C}",  // 0x4C LATIN CAPITAL LETTER L
            "\u{004D}",  // 0x4D LATIN CAPITAL LETTER M
            "\u{004E}",  // 0x4E LATIN CAPITAL LETTER N
            "\u{004F}",  // 0x4F LATIN CAPITAL LETTER O
            "\u{0050}",  // 0x50 LATIN CAPITAL LETTER P
            "\u{0051}",  // 0x51 LATIN CAPITAL LETTER Q
            "\u{0052}",  // 0x52 LATIN CAPITAL LETTER R
            "\u{0053}",  // 0x53 LATIN CAPITAL LETTER S
            "\u{0054}",  // 0x54 LATIN CAPITAL LETTER T
            "\u{0055}",  // 0x55 LATIN CAPITAL LETTER U
            "\u{0056}",  // 0x56 LATIN CAPITAL LETTER V
            "\u{0057}",  // 0x57 LATIN CAPITAL LETTER W
            "\u{0058}",  // 0x58 LATIN CAPITAL LETTER X
            "\u{0059}",  // 0x59 LATIN CAPITAL LETTER Y
            "\u{005A}",  // 0x5A LATIN CAPITAL LETTER Z
            "\u{005B}",  // 0x5B LEFT SQUARE BRACKET
            "\u{005C}",  // 0x5C REVERSE SOLIDUS
            "\u{005D}",  // 0x5D RIGHT SQUARE BRACKET
            "\u{005E}",  // 0x5E CIRCUMFLEX ACCENT
            "\u{005F}",  // 0x5F LOW LINE

            // 0x60-0x7E: ASCII lowercase letters
            "\u{0060}",  // 0x60 GRAVE ACCENT
            "\u{0061}",  // 0x61 LATIN SMALL LETTER A
            "\u{0062}",  // 0x62 LATIN SMALL LETTER B
            "\u{0063}",  // 0x63 LATIN SMALL LETTER C
            "\u{0064}",  // 0x64 LATIN SMALL LETTER D
            "\u{0065}",  // 0x65 LATIN SMALL LETTER E
            "\u{0066}",  // 0x66 LATIN SMALL LETTER F
            "\u{0067}",  // 0x67 LATIN SMALL LETTER G
            "\u{0068}",  // 0x68 LATIN SMALL LETTER H
            "\u{0069}",  // 0x69 LATIN SMALL LETTER I
            "\u{006A}",  // 0x6A LATIN SMALL LETTER J
            "\u{006B}",  // 0x6B LATIN SMALL LETTER K
            "\u{006C}",  // 0x6C LATIN SMALL LETTER L
            "\u{006D}",  // 0x6D LATIN SMALL LETTER M
            "\u{006E}",  // 0x6E LATIN SMALL LETTER N
            "\u{006F}",  // 0x6F LATIN SMALL LETTER O
            "\u{0070}",  // 0x70 LATIN SMALL LETTER P
            "\u{0071}",  // 0x71 LATIN SMALL LETTER Q
            "\u{0072}",  // 0x72 LATIN SMALL LETTER R
            "\u{0073}",  // 0x73 LATIN SMALL LETTER S
            "\u{0074}",  // 0x74 LATIN SMALL LETTER T
            "\u{0075}",  // 0x75 LATIN SMALL LETTER U
            "\u{0076}",  // 0x76 LATIN SMALL LETTER V
            "\u{0077}",  // 0x77 LATIN SMALL LETTER W
            "\u{0078}",  // 0x78 LATIN SMALL LETTER X
            "\u{0079}",  // 0x79 LATIN SMALL LETTER Y
            "\u{007A}",  // 0x7A LATIN SMALL LETTER Z
            "\u{007B}",  // 0x7B LEFT CURLY BRACKET
            "\u{007C}",  // 0x7C VERTICAL LINE
            "\u{007D}",  // 0x7D RIGHT CURLY BRACKET
            "\u{007E}",  // 0x7E TILDE
            nil,  // 0x7F Undefined

            // 0x80-0x9F: Typography characters
            "\u{2022}",  // 0x80 BULLET (note: differs from WinAnsi which has Euro)
            "\u{2020}",  // 0x81 DAGGER
            "\u{2021}",  // 0x82 DOUBLE DAGGER
            "\u{2026}",  // 0x83 HORIZONTAL ELLIPSIS
            "\u{2014}",  // 0x84 EM DASH
            "\u{2013}",  // 0x85 EN DASH
            "\u{0192}",  // 0x86 LATIN SMALL LETTER F WITH HOOK (florin)
            "\u{2044}",  // 0x87 FRACTION SLASH
            "\u{2039}",  // 0x88 SINGLE LEFT-POINTING ANGLE QUOTATION MARK
            "\u{203A}",  // 0x89 SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
            "\u{2212}",  // 0x8A MINUS SIGN
            "\u{2030}",  // 0x8B PER MILLE SIGN
            "\u{201E}",  // 0x8C DOUBLE LOW-9 QUOTATION MARK
            "\u{201C}",  // 0x8D LEFT DOUBLE QUOTATION MARK
            "\u{201D}",  // 0x8E RIGHT DOUBLE QUOTATION MARK
            "\u{2018}",  // 0x8F LEFT SINGLE QUOTATION MARK
            "\u{2019}",  // 0x90 RIGHT SINGLE QUOTATION MARK
            "\u{201A}",  // 0x91 SINGLE LOW-9 QUOTATION MARK
            "\u{2122}",  // 0x92 TRADE MARK SIGN
            "\u{FB01}",  // 0x93 LATIN SMALL LIGATURE FI
            "\u{FB02}",  // 0x94 LATIN SMALL LIGATURE FL
            "\u{0141}",  // 0x95 LATIN CAPITAL LETTER L WITH STROKE
            "\u{0152}",  // 0x96 LATIN CAPITAL LIGATURE OE
            "\u{0160}",  // 0x97 LATIN CAPITAL LETTER S WITH CARON
            "\u{0178}",  // 0x98 LATIN CAPITAL LETTER Y WITH DIAERESIS
            "\u{017D}",  // 0x99 LATIN CAPITAL LETTER Z WITH CARON
            "\u{0131}",  // 0x9A LATIN SMALL LETTER DOTLESS I
            "\u{0142}",  // 0x9B LATIN SMALL LETTER L WITH STROKE
            "\u{0153}",  // 0x9C LATIN SMALL LIGATURE OE
            "\u{0161}",  // 0x9D LATIN SMALL LETTER S WITH CARON
            "\u{017E}",  // 0x9E LATIN SMALL LETTER Z WITH CARON
            nil,  // 0x9F Undefined

            // 0xA0-0xBF: Latin supplement (with PDFDocEncoding differences)
            "\u{20AC}",  // 0xA0 EURO SIGN (note: differs from Latin-1 which has NBSP)
            "\u{00A1}",  // 0xA1 INVERTED EXCLAMATION MARK
            "\u{00A2}",  // 0xA2 CENT SIGN
            "\u{00A3}",  // 0xA3 POUND SIGN
            "\u{00A4}",  // 0xA4 CURRENCY SIGN
            "\u{00A5}",  // 0xA5 YEN SIGN
            "\u{00A6}",  // 0xA6 BROKEN BAR
            "\u{00A7}",  // 0xA7 SECTION SIGN
            "\u{00A8}",  // 0xA8 DIAERESIS
            "\u{00A9}",  // 0xA9 COPYRIGHT SIGN
            "\u{00AA}",  // 0xAA FEMININE ORDINAL INDICATOR
            "\u{00AB}",  // 0xAB LEFT-POINTING DOUBLE ANGLE QUOTATION MARK
            "\u{00AC}",  // 0xAC NOT SIGN
            nil,  // 0xAD Undefined (note: Latin-1 has SOFT HYPHEN)
            "\u{00AE}",  // 0xAE REGISTERED SIGN
            "\u{00AF}",  // 0xAF MACRON
            "\u{00B0}",  // 0xB0 DEGREE SIGN
            "\u{00B1}",  // 0xB1 PLUS-MINUS SIGN
            "\u{00B2}",  // 0xB2 SUPERSCRIPT TWO
            "\u{00B3}",  // 0xB3 SUPERSCRIPT THREE
            "\u{00B4}",  // 0xB4 ACUTE ACCENT
            "\u{00B5}",  // 0xB5 MICRO SIGN
            "\u{00B6}",  // 0xB6 PILCROW SIGN
            "\u{00B7}",  // 0xB7 MIDDLE DOT
            "\u{00B8}",  // 0xB8 CEDILLA
            "\u{00B9}",  // 0xB9 SUPERSCRIPT ONE
            "\u{00BA}",  // 0xBA MASCULINE ORDINAL INDICATOR
            "\u{00BB}",  // 0xBB RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK
            "\u{00BC}",  // 0xBC VULGAR FRACTION ONE QUARTER
            "\u{00BD}",  // 0xBD VULGAR FRACTION ONE HALF
            "\u{00BE}",  // 0xBE VULGAR FRACTION THREE QUARTERS
            "\u{00BF}",  // 0xBF INVERTED QUESTION MARK

            // 0xC0-0xDF: Latin uppercase accented
            "\u{00C0}",  // 0xC0 LATIN CAPITAL LETTER A WITH GRAVE
            "\u{00C1}",  // 0xC1 LATIN CAPITAL LETTER A WITH ACUTE
            "\u{00C2}",  // 0xC2 LATIN CAPITAL LETTER A WITH CIRCUMFLEX
            "\u{00C3}",  // 0xC3 LATIN CAPITAL LETTER A WITH TILDE
            "\u{00C4}",  // 0xC4 LATIN CAPITAL LETTER A WITH DIAERESIS
            "\u{00C5}",  // 0xC5 LATIN CAPITAL LETTER A WITH RING ABOVE
            "\u{00C6}",  // 0xC6 LATIN CAPITAL LETTER AE
            "\u{00C7}",  // 0xC7 LATIN CAPITAL LETTER C WITH CEDILLA
            "\u{00C8}",  // 0xC8 LATIN CAPITAL LETTER E WITH GRAVE
            "\u{00C9}",  // 0xC9 LATIN CAPITAL LETTER E WITH ACUTE
            "\u{00CA}",  // 0xCA LATIN CAPITAL LETTER E WITH CIRCUMFLEX
            "\u{00CB}",  // 0xCB LATIN CAPITAL LETTER E WITH DIAERESIS
            "\u{00CC}",  // 0xCC LATIN CAPITAL LETTER I WITH GRAVE
            "\u{00CD}",  // 0xCD LATIN CAPITAL LETTER I WITH ACUTE
            "\u{00CE}",  // 0xCE LATIN CAPITAL LETTER I WITH CIRCUMFLEX
            "\u{00CF}",  // 0xCF LATIN CAPITAL LETTER I WITH DIAERESIS
            "\u{00D0}",  // 0xD0 LATIN CAPITAL LETTER ETH
            "\u{00D1}",  // 0xD1 LATIN CAPITAL LETTER N WITH TILDE
            "\u{00D2}",  // 0xD2 LATIN CAPITAL LETTER O WITH GRAVE
            "\u{00D3}",  // 0xD3 LATIN CAPITAL LETTER O WITH ACUTE
            "\u{00D4}",  // 0xD4 LATIN CAPITAL LETTER O WITH CIRCUMFLEX
            "\u{00D5}",  // 0xD5 LATIN CAPITAL LETTER O WITH TILDE
            "\u{00D6}",  // 0xD6 LATIN CAPITAL LETTER O WITH DIAERESIS
            "\u{00D7}",  // 0xD7 MULTIPLICATION SIGN
            "\u{00D8}",  // 0xD8 LATIN CAPITAL LETTER O WITH STROKE
            "\u{00D9}",  // 0xD9 LATIN CAPITAL LETTER U WITH GRAVE
            "\u{00DA}",  // 0xDA LATIN CAPITAL LETTER U WITH ACUTE
            "\u{00DB}",  // 0xDB LATIN CAPITAL LETTER U WITH CIRCUMFLEX
            "\u{00DC}",  // 0xDC LATIN CAPITAL LETTER U WITH DIAERESIS
            "\u{00DD}",  // 0xDD LATIN CAPITAL LETTER Y WITH ACUTE
            "\u{00DE}",  // 0xDE LATIN CAPITAL LETTER THORN
            "\u{00DF}",  // 0xDF LATIN SMALL LETTER SHARP S

            // 0xE0-0xFF: Latin lowercase accented
            "\u{00E0}",  // 0xE0 LATIN SMALL LETTER A WITH GRAVE
            "\u{00E1}",  // 0xE1 LATIN SMALL LETTER A WITH ACUTE
            "\u{00E2}",  // 0xE2 LATIN SMALL LETTER A WITH CIRCUMFLEX
            "\u{00E3}",  // 0xE3 LATIN SMALL LETTER A WITH TILDE
            "\u{00E4}",  // 0xE4 LATIN SMALL LETTER A WITH DIAERESIS
            "\u{00E5}",  // 0xE5 LATIN SMALL LETTER A WITH RING ABOVE
            "\u{00E6}",  // 0xE6 LATIN SMALL LETTER AE
            "\u{00E7}",  // 0xE7 LATIN SMALL LETTER C WITH CEDILLA
            "\u{00E8}",  // 0xE8 LATIN SMALL LETTER E WITH GRAVE
            "\u{00E9}",  // 0xE9 LATIN SMALL LETTER E WITH ACUTE
            "\u{00EA}",  // 0xEA LATIN SMALL LETTER E WITH CIRCUMFLEX
            "\u{00EB}",  // 0xEB LATIN SMALL LETTER E WITH DIAERESIS
            "\u{00EC}",  // 0xEC LATIN SMALL LETTER I WITH GRAVE
            "\u{00ED}",  // 0xED LATIN SMALL LETTER I WITH ACUTE
            "\u{00EE}",  // 0xEE LATIN SMALL LETTER I WITH CIRCUMFLEX
            "\u{00EF}",  // 0xEF LATIN SMALL LETTER I WITH DIAERESIS
            "\u{00F0}",  // 0xF0 LATIN SMALL LETTER ETH
            "\u{00F1}",  // 0xF1 LATIN SMALL LETTER N WITH TILDE
            "\u{00F2}",  // 0xF2 LATIN SMALL LETTER O WITH GRAVE
            "\u{00F3}",  // 0xF3 LATIN SMALL LETTER O WITH ACUTE
            "\u{00F4}",  // 0xF4 LATIN SMALL LETTER O WITH CIRCUMFLEX
            "\u{00F5}",  // 0xF5 LATIN SMALL LETTER O WITH TILDE
            "\u{00F6}",  // 0xF6 LATIN SMALL LETTER O WITH DIAERESIS
            "\u{00F7}",  // 0xF7 DIVISION SIGN
            "\u{00F8}",  // 0xF8 LATIN SMALL LETTER O WITH STROKE
            "\u{00F9}",  // 0xF9 LATIN SMALL LETTER U WITH GRAVE
            "\u{00FA}",  // 0xFA LATIN SMALL LETTER U WITH ACUTE
            "\u{00FB}",  // 0xFB LATIN SMALL LETTER U WITH CIRCUMFLEX
            "\u{00FC}",  // 0xFC LATIN SMALL LETTER U WITH DIAERESIS
            "\u{00FD}",  // 0xFD LATIN SMALL LETTER Y WITH ACUTE
            "\u{00FE}",  // 0xFE LATIN SMALL LETTER THORN
            "\u{00FF}",  // 0xFF LATIN SMALL LETTER Y WITH DIAERESIS
        ]

        // MARK: - Encode Table

        /// Unicode to byte mapping
        @usableFromInline
        static let encodeTable: [UInt32: UInt8] = {
            var table: [UInt32: UInt8] = [:]
            for (byte, scalar) in decodeTable.enumerated() {
                if let scalar = scalar {
                    table[scalar.value] = UInt8(byte)
                }
            }
            return table
        }()

        // MARK: - Protocol Implementation

        /// Encode a Unicode scalar to a PDFDocEncoding byte
        @inlinable
        public static func encode(_ scalar: Unicode.Scalar) -> UInt8? {
            encodeTable[scalar.value]
        }

        /// Decode a PDFDocEncoding byte to Unicode scalar
        @inlinable
        public static func decode(_ byte: UInt8) -> Unicode.Scalar? {
            decodeTable[Int(byte)]
        }
    }
}

// MARK: - Text String Detection

extension ISO_32000.PDFDocEncoding {
    /// Detect if bytes represent a PDFDocEncoding string vs Unicode (UTF-16BE)
    ///
    /// Per ISO 32000-2 Section 7.9.2.2:
    /// - If bytes start with UTF-16BE BOM (0xFE 0xFF), treat as UTF-16BE
    /// - If bytes start with UTF-8 BOM (0xEF 0xBB 0xBF), treat as UTF-8
    /// - Otherwise, treat as PDFDocEncoding
    ///
    /// - Parameter bytes: The raw bytes from a PDF text string
    /// - Returns: The encoding type detected
    public static func detectEncoding<C: Collection>(_ bytes: C) -> TextStringEncoding
    where C.Element == UInt8 {
        var iterator = bytes.makeIterator()

        guard let first = iterator.next() else {
            return .pdfDocEncoding
        }

        guard let second = iterator.next() else {
            return .pdfDocEncoding
        }

        // Check for UTF-16BE BOM
        if first == 0xFE && second == 0xFF {
            return .utf16BE
        }

        // Check for UTF-8 BOM
        if first == 0xEF && second == 0xBB {
            if let third = iterator.next(), third == 0xBF {
                return .utf8
            }
        }

        return .pdfDocEncoding
    }

    /// Text string encoding types in PDF
    public enum TextStringEncoding: Sendable {
        /// PDFDocEncoding (single-byte, no BOM)
        case pdfDocEncoding
        /// UTF-16BE with BOM (0xFE 0xFF)
        case utf16BE
        /// UTF-8 with BOM (0xEF 0xBB 0xBF)
        case utf8
    }
}
