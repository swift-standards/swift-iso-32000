// ISO_32000.WinAnsiEncoding.swift
// ISO 32000-2:2020 Annex D.2 - WinAnsiEncoding
//
// Windows Code Page 1252, the standard Windows encoding for Latin text.
// This is the most commonly used encoding for PDF content streams.

public import ISO_32000_Shared

extension ISO_32000 {
    /// WinAnsiEncoding - Windows Code Page 1252
    ///
    /// Per ISO 32000-2 Table D.1:
    /// > Windows Code Page 1252, often called the "Windows ANSI" encoding.
    /// > This is the standard Microsoft Windows specific encoding for Latin text
    /// > in Western writing systems. PDF processors shall have a predefined
    /// > encoding named WinAnsiEncoding that may be used with both Type 1 and
    /// > TrueType fonts.
    ///
    /// ## Key Characteristics
    ///
    /// - Bytes 0x00-0x1F: Control characters (undefined in PDF context)
    /// - Bytes 0x20-0x7F: Standard ASCII
    /// - Bytes 0x80-0x9F: Extended characters (Euro, smart quotes, etc.)
    /// - Bytes 0xA0-0xFF: Latin-1 supplement
    ///
    /// ## Notes from ISO 32000-2
    ///
    /// 1. The Euro character (€) was added in PDF 1.3 at code 200 (0x80)
    /// 2. Zcaron/zcaron were added in PDF 1.3 at codes 216/236 (0x8E/0x9E)
    /// 3. Unused codes > 0x40 map to bullet, but only 225 (0x95) is officially assigned
    /// 4. The hyphen at 0xAD may be soft hyphen; use encoding dictionary to specify
    /// 5. Code 0xA0 maps to space; use encoding dictionary for non-breaking space
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.2 — Latin character set and encodings (WIN column)
    public enum WinAnsiEncoding: Encoding {
        /// The encoding name as used in PDF
        public static let name: String = "WinAnsiEncoding"

        // MARK: - Decode Table

        /// Complete decode table (256 entries)
        ///
        /// Built from ISO 32000-2 Table D.2, WIN column.
        /// Octal values converted to decimal indices.
        public static let decodeTable: [Unicode.Scalar?] = [
            // 0x00-0x1F: Control characters (undefined in WinAnsi for PDF)
            nil, nil, nil, nil, nil, nil, nil, nil,  // 0x00-0x07
            nil, nil, nil, nil, nil, nil, nil, nil,  // 0x08-0x0F
            nil, nil, nil, nil, nil, nil, nil, nil,  // 0x10-0x17
            nil, nil, nil, nil, nil, nil, nil, nil,  // 0x18-0x1F

            // 0x20-0x3F: ASCII punctuation and digits
            "\u{0020}",  // 0x20 space
            "\u{0021}",  // 0x21 exclam
            "\u{0022}",  // 0x22 quotedbl
            "\u{0023}",  // 0x23 numbersign
            "\u{0024}",  // 0x24 dollar
            "\u{0025}",  // 0x25 percent
            "\u{0026}",  // 0x26 ampersand
            "\u{0027}",  // 0x27 quotesingle
            "\u{0028}",  // 0x28 parenleft
            "\u{0029}",  // 0x29 parenright
            "\u{002A}",  // 0x2A asterisk
            "\u{002B}",  // 0x2B plus
            "\u{002C}",  // 0x2C comma
            "\u{002D}",  // 0x2D hyphen
            "\u{002E}",  // 0x2E period
            "\u{002F}",  // 0x2F slash
            "\u{0030}",  // 0x30 zero
            "\u{0031}",  // 0x31 one
            "\u{0032}",  // 0x32 two
            "\u{0033}",  // 0x33 three
            "\u{0034}",  // 0x34 four
            "\u{0035}",  // 0x35 five
            "\u{0036}",  // 0x36 six
            "\u{0037}",  // 0x37 seven
            "\u{0038}",  // 0x38 eight
            "\u{0039}",  // 0x39 nine
            "\u{003A}",  // 0x3A colon
            "\u{003B}",  // 0x3B semicolon
            "\u{003C}",  // 0x3C less
            "\u{003D}",  // 0x3D equal
            "\u{003E}",  // 0x3E greater
            "\u{003F}",  // 0x3F question

            // 0x40-0x5F: ASCII uppercase letters
            "\u{0040}",  // 0x40 at
            "\u{0041}",  // 0x41 A
            "\u{0042}",  // 0x42 B
            "\u{0043}",  // 0x43 C
            "\u{0044}",  // 0x44 D
            "\u{0045}",  // 0x45 E
            "\u{0046}",  // 0x46 F
            "\u{0047}",  // 0x47 G
            "\u{0048}",  // 0x48 H
            "\u{0049}",  // 0x49 I
            "\u{004A}",  // 0x4A J
            "\u{004B}",  // 0x4B K
            "\u{004C}",  // 0x4C L
            "\u{004D}",  // 0x4D M
            "\u{004E}",  // 0x4E N
            "\u{004F}",  // 0x4F O
            "\u{0050}",  // 0x50 P
            "\u{0051}",  // 0x51 Q
            "\u{0052}",  // 0x52 R
            "\u{0053}",  // 0x53 S
            "\u{0054}",  // 0x54 T
            "\u{0055}",  // 0x55 U
            "\u{0056}",  // 0x56 V
            "\u{0057}",  // 0x57 W
            "\u{0058}",  // 0x58 X
            "\u{0059}",  // 0x59 Y
            "\u{005A}",  // 0x5A Z
            "\u{005B}",  // 0x5B bracketleft
            "\u{005C}",  // 0x5C backslash
            "\u{005D}",  // 0x5D bracketright
            "\u{005E}",  // 0x5E asciicircum
            "\u{005F}",  // 0x5F underscore

            // 0x60-0x7F: ASCII lowercase letters
            "\u{0060}",  // 0x60 grave
            "\u{0061}",  // 0x61 a
            "\u{0062}",  // 0x62 b
            "\u{0063}",  // 0x63 c
            "\u{0064}",  // 0x64 d
            "\u{0065}",  // 0x65 e
            "\u{0066}",  // 0x66 f
            "\u{0067}",  // 0x67 g
            "\u{0068}",  // 0x68 h
            "\u{0069}",  // 0x69 i
            "\u{006A}",  // 0x6A j
            "\u{006B}",  // 0x6B k
            "\u{006C}",  // 0x6C l
            "\u{006D}",  // 0x6D m
            "\u{006E}",  // 0x6E n
            "\u{006F}",  // 0x6F o
            "\u{0070}",  // 0x70 p
            "\u{0071}",  // 0x71 q
            "\u{0072}",  // 0x72 r
            "\u{0073}",  // 0x73 s
            "\u{0074}",  // 0x74 t
            "\u{0075}",  // 0x75 u
            "\u{0076}",  // 0x76 v
            "\u{0077}",  // 0x77 w
            "\u{0078}",  // 0x78 x
            "\u{0079}",  // 0x79 y
            "\u{007A}",  // 0x7A z
            "\u{007B}",  // 0x7B braceleft
            "\u{007C}",  // 0x7C bar
            "\u{007D}",  // 0x7D braceright
            "\u{007E}",  // 0x7E asciitilde
            nil,  // 0x7F undefined

            // 0x80-0x9F: Extended Latin (Windows-specific)
            "\u{20AC}",  // 0x80 Euro (added PDF 1.3)
            nil,  // 0x81 undefined
            "\u{201A}",  // 0x82 quotesinglbase
            "\u{0192}",  // 0x83 florin
            "\u{201E}",  // 0x84 quotedblbase
            "\u{2026}",  // 0x85 ellipsis
            "\u{2020}",  // 0x86 dagger
            "\u{2021}",  // 0x87 daggerdbl
            "\u{02C6}",  // 0x88 circumflex
            "\u{2030}",  // 0x89 perthousand
            "\u{0160}",  // 0x8A Scaron
            "\u{2039}",  // 0x8B guilsinglleft
            "\u{0152}",  // 0x8C OE
            nil,  // 0x8D undefined
            "\u{017D}",  // 0x8E Zcaron (added PDF 1.3)
            nil,  // 0x8F undefined
            nil,  // 0x90 undefined
            "\u{2018}",  // 0x91 quoteleft
            "\u{2019}",  // 0x92 quoteright
            "\u{201C}",  // 0x93 quotedblleft
            "\u{201D}",  // 0x94 quotedblright
            "\u{2022}",  // 0x95 bullet
            "\u{2013}",  // 0x96 endash
            "\u{2014}",  // 0x97 emdash
            "\u{02DC}",  // 0x98 tilde
            "\u{2122}",  // 0x99 trademark
            "\u{0161}",  // 0x9A scaron
            "\u{203A}",  // 0x9B guilsinglright
            "\u{0153}",  // 0x9C oe
            nil,  // 0x9D undefined
            "\u{017E}",  // 0x9E zcaron (added PDF 1.3)
            "\u{0178}",  // 0x9F Ydieresis

            // 0xA0-0xBF: Latin-1 supplement (first part)
            "\u{00A0}",  // 0xA0 space (non-breaking) - see Note 6
            "\u{00A1}",  // 0xA1 exclamdown
            "\u{00A2}",  // 0xA2 cent
            "\u{00A3}",  // 0xA3 sterling
            "\u{00A4}",  // 0xA4 currency
            "\u{00A5}",  // 0xA5 yen
            "\u{00A6}",  // 0xA6 brokenbar
            "\u{00A7}",  // 0xA7 section
            "\u{00A8}",  // 0xA8 dieresis
            "\u{00A9}",  // 0xA9 copyright
            "\u{00AA}",  // 0xAA ordfeminine
            "\u{00AB}",  // 0xAB guillemotleft
            "\u{00AC}",  // 0xAC logicalnot
            "\u{00AD}",  // 0xAD hyphen (soft hyphen) - see Note 5
            "\u{00AE}",  // 0xAE registered
            "\u{00AF}",  // 0xAF macron
            "\u{00B0}",  // 0xB0 degree
            "\u{00B1}",  // 0xB1 plusminus
            "\u{00B2}",  // 0xB2 twosuperior
            "\u{00B3}",  // 0xB3 threesuperior
            "\u{00B4}",  // 0xB4 acute
            "\u{00B5}",  // 0xB5 mu
            "\u{00B6}",  // 0xB6 paragraph
            "\u{00B7}",  // 0xB7 periodcentered
            "\u{00B8}",  // 0xB8 cedilla
            "\u{00B9}",  // 0xB9 onesuperior
            "\u{00BA}",  // 0xBA ordmasculine
            "\u{00BB}",  // 0xBB guillemotright
            "\u{00BC}",  // 0xBC onequarter
            "\u{00BD}",  // 0xBD onehalf
            "\u{00BE}",  // 0xBE threequarters
            "\u{00BF}",  // 0xBF questiondown

            // 0xC0-0xDF: Latin-1 supplement (uppercase accented)
            "\u{00C0}",  // 0xC0 Agrave
            "\u{00C1}",  // 0xC1 Aacute
            "\u{00C2}",  // 0xC2 Acircumflex
            "\u{00C3}",  // 0xC3 Atilde
            "\u{00C4}",  // 0xC4 Adieresis
            "\u{00C5}",  // 0xC5 Aring
            "\u{00C6}",  // 0xC6 AE
            "\u{00C7}",  // 0xC7 Ccedilla
            "\u{00C8}",  // 0xC8 Egrave
            "\u{00C9}",  // 0xC9 Eacute
            "\u{00CA}",  // 0xCA Ecircumflex
            "\u{00CB}",  // 0xCB Edieresis
            "\u{00CC}",  // 0xCC Igrave
            "\u{00CD}",  // 0xCD Iacute
            "\u{00CE}",  // 0xCE Icircumflex
            "\u{00CF}",  // 0xCF Idieresis
            "\u{00D0}",  // 0xD0 Eth
            "\u{00D1}",  // 0xD1 Ntilde
            "\u{00D2}",  // 0xD2 Ograve
            "\u{00D3}",  // 0xD3 Oacute
            "\u{00D4}",  // 0xD4 Ocircumflex
            "\u{00D5}",  // 0xD5 Otilde
            "\u{00D6}",  // 0xD6 Odieresis
            "\u{00D7}",  // 0xD7 multiply
            "\u{00D8}",  // 0xD8 Oslash
            "\u{00D9}",  // 0xD9 Ugrave
            "\u{00DA}",  // 0xDA Uacute
            "\u{00DB}",  // 0xDB Ucircumflex
            "\u{00DC}",  // 0xDC Udieresis
            "\u{00DD}",  // 0xDD Yacute
            "\u{00DE}",  // 0xDE Thorn
            "\u{00DF}",  // 0xDF germandbls

            // 0xE0-0xFF: Latin-1 supplement (lowercase accented)
            "\u{00E0}",  // 0xE0 agrave
            "\u{00E1}",  // 0xE1 aacute
            "\u{00E2}",  // 0xE2 acircumflex
            "\u{00E3}",  // 0xE3 atilde
            "\u{00E4}",  // 0xE4 adieresis
            "\u{00E5}",  // 0xE5 aring
            "\u{00E6}",  // 0xE6 ae
            "\u{00E7}",  // 0xE7 ccedilla
            "\u{00E8}",  // 0xE8 egrave
            "\u{00E9}",  // 0xE9 eacute
            "\u{00EA}",  // 0xEA ecircumflex
            "\u{00EB}",  // 0xEB edieresis
            "\u{00EC}",  // 0xEC igrave
            "\u{00ED}",  // 0xED iacute
            "\u{00EE}",  // 0xEE icircumflex
            "\u{00EF}",  // 0xEF idieresis
            "\u{00F0}",  // 0xF0 eth
            "\u{00F1}",  // 0xF1 ntilde
            "\u{00F2}",  // 0xF2 ograve
            "\u{00F3}",  // 0xF3 oacute
            "\u{00F4}",  // 0xF4 ocircumflex
            "\u{00F5}",  // 0xF5 otilde
            "\u{00F6}",  // 0xF6 odieresis
            "\u{00F7}",  // 0xF7 divide
            "\u{00F8}",  // 0xF8 oslash
            "\u{00F9}",  // 0xF9 ugrave
            "\u{00FA}",  // 0xFA uacute
            "\u{00FB}",  // 0xFB ucircumflex
            "\u{00FC}",  // 0xFC udieresis
            "\u{00FD}",  // 0xFD yacute
            "\u{00FE}",  // 0xFE thorn
            "\u{00FF}",  // 0xFF ydieresis
        ]

        // MARK: - Encode Table

        /// Unicode to byte mapping for non-ASCII characters
        ///
        /// Only contains mappings for characters outside 0x20-0x7E range.
        /// ASCII characters are handled directly.
        @usableFromInline
        static let encodeTable: [UInt32: UInt8] = [
            // Extended Latin (0x80-0x9F)
            0x20AC: 0x80,  // Euro
            0x201A: 0x82,  // quotesinglbase
            0x0192: 0x83,  // florin
            0x201E: 0x84,  // quotedblbase
            0x2026: 0x85,  // ellipsis
            0x2020: 0x86,  // dagger
            0x2021: 0x87,  // daggerdbl
            0x02C6: 0x88,  // circumflex
            0x2030: 0x89,  // perthousand
            0x0160: 0x8A,  // Scaron
            0x2039: 0x8B,  // guilsinglleft
            0x0152: 0x8C,  // OE
            0x017D: 0x8E,  // Zcaron
            0x2018: 0x91,  // quoteleft
            0x2019: 0x92,  // quoteright
            0x201C: 0x93,  // quotedblleft
            0x201D: 0x94,  // quotedblright
            0x2022: 0x95,  // bullet
            0x2013: 0x96,  // endash
            0x2014: 0x97,  // emdash
            0x02DC: 0x98,  // tilde
            0x2122: 0x99,  // trademark
            0x0161: 0x9A,  // scaron
            0x203A: 0x9B,  // guilsinglright
            0x0153: 0x9C,  // oe
            0x017E: 0x9E,  // zcaron
            0x0178: 0x9F,  // Ydieresis

            // Latin-1 supplement (0xA0-0xFF)
            0x00A0: 0xA0,  // space (non-breaking)
            0x00A1: 0xA1,  // exclamdown
            0x00A2: 0xA2,  // cent
            0x00A3: 0xA3,  // sterling
            0x00A4: 0xA4,  // currency
            0x00A5: 0xA5,  // yen
            0x00A6: 0xA6,  // brokenbar
            0x00A7: 0xA7,  // section
            0x00A8: 0xA8,  // dieresis
            0x00A9: 0xA9,  // copyright
            0x00AA: 0xAA,  // ordfeminine
            0x00AB: 0xAB,  // guillemotleft
            0x00AC: 0xAC,  // logicalnot
            0x00AD: 0xAD,  // soft hyphen
            0x00AE: 0xAE,  // registered
            0x00AF: 0xAF,  // macron
            0x00B0: 0xB0,  // degree
            0x00B1: 0xB1,  // plusminus
            0x00B2: 0xB2,  // twosuperior
            0x00B3: 0xB3,  // threesuperior
            0x00B4: 0xB4,  // acute
            0x00B5: 0xB5,  // mu
            0x00B6: 0xB6,  // paragraph
            0x00B7: 0xB7,  // periodcentered
            0x00B8: 0xB8,  // cedilla
            0x00B9: 0xB9,  // onesuperior
            0x00BA: 0xBA,  // ordmasculine
            0x00BB: 0xBB,  // guillemotright
            0x00BC: 0xBC,  // onequarter
            0x00BD: 0xBD,  // onehalf
            0x00BE: 0xBE,  // threequarters
            0x00BF: 0xBF,  // questiondown
            0x00C0: 0xC0,  // Agrave
            0x00C1: 0xC1,  // Aacute
            0x00C2: 0xC2,  // Acircumflex
            0x00C3: 0xC3,  // Atilde
            0x00C4: 0xC4,  // Adieresis
            0x00C5: 0xC5,  // Aring
            0x00C6: 0xC6,  // AE
            0x00C7: 0xC7,  // Ccedilla
            0x00C8: 0xC8,  // Egrave
            0x00C9: 0xC9,  // Eacute
            0x00CA: 0xCA,  // Ecircumflex
            0x00CB: 0xCB,  // Edieresis
            0x00CC: 0xCC,  // Igrave
            0x00CD: 0xCD,  // Iacute
            0x00CE: 0xCE,  // Icircumflex
            0x00CF: 0xCF,  // Idieresis
            0x00D0: 0xD0,  // Eth
            0x00D1: 0xD1,  // Ntilde
            0x00D2: 0xD2,  // Ograve
            0x00D3: 0xD3,  // Oacute
            0x00D4: 0xD4,  // Ocircumflex
            0x00D5: 0xD5,  // Otilde
            0x00D6: 0xD6,  // Odieresis
            0x00D7: 0xD7,  // multiply
            0x00D8: 0xD8,  // Oslash
            0x00D9: 0xD9,  // Ugrave
            0x00DA: 0xDA,  // Uacute
            0x00DB: 0xDB,  // Ucircumflex
            0x00DC: 0xDC,  // Udieresis
            0x00DD: 0xDD,  // Yacute
            0x00DE: 0xDE,  // Thorn
            0x00DF: 0xDF,  // germandbls
            0x00E0: 0xE0,  // agrave
            0x00E1: 0xE1,  // aacute
            0x00E2: 0xE2,  // acircumflex
            0x00E3: 0xE3,  // atilde
            0x00E4: 0xE4,  // adieresis
            0x00E5: 0xE5,  // aring
            0x00E6: 0xE6,  // ae
            0x00E7: 0xE7,  // ccedilla
            0x00E8: 0xE8,  // egrave
            0x00E9: 0xE9,  // eacute
            0x00EA: 0xEA,  // ecircumflex
            0x00EB: 0xEB,  // edieresis
            0x00EC: 0xEC,  // igrave
            0x00ED: 0xED,  // iacute
            0x00EE: 0xEE,  // icircumflex
            0x00EF: 0xEF,  // idieresis
            0x00F0: 0xF0,  // eth
            0x00F1: 0xF1,  // ntilde
            0x00F2: 0xF2,  // ograve
            0x00F3: 0xF3,  // oacute
            0x00F4: 0xF4,  // ocircumflex
            0x00F5: 0xF5,  // otilde
            0x00F6: 0xF6,  // odieresis
            0x00F7: 0xF7,  // divide
            0x00F8: 0xF8,  // oslash
            0x00F9: 0xF9,  // ugrave
            0x00FA: 0xFA,  // uacute
            0x00FB: 0xFB,  // ucircumflex
            0x00FC: 0xFC,  // udieresis
            0x00FD: 0xFD,  // yacute
            0x00FE: 0xFE,  // thorn
            0x00FF: 0xFF,  // ydieresis
        ]

        // MARK: - Protocol Implementation

        /// Encode a Unicode scalar to a WinAnsi byte
        @inlinable
        public static func encode(_ scalar: Unicode.Scalar) -> UInt8? {
            let value = scalar.value

            // ASCII printable range (0x20-0x7E) maps directly
            if value >= 0x20 && value <= 0x7E {
                return UInt8(value)
            }

            // Look up in encode table
            return encodeTable[value]
        }

        /// Decode a WinAnsi byte to Unicode scalar
        @inlinable
        public static func decode(_ byte: UInt8) -> Unicode.Scalar? {
            decodeTable[Int(byte)]
        }
    }
}
