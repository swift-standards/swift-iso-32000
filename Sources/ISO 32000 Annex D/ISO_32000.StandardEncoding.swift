// ISO_32000.StandardEncoding.swift
// ISO 32000-2:2020 Annex D.2 - StandardEncoding
//
// The built-in encoding defined in Type 1 Latin-text font programs.
// This encoding is NOT a predefined encoding name in PDF but serves as
// the base encoding from which differences may be specified.

public import ISO_32000_Shared

extension ISO_32000 {
    /// StandardEncoding - Type 1 Font Built-in Encoding
    ///
    /// Per ISO 32000-2 Table D.1:
    /// > Standard Latin-text encoding. This is the built-in encoding defined
    /// > in Type 1 Latin-text font programs (but generally not in TrueType
    /// > font programs). PDF processors shall not have a predefined encoding
    /// > named StandardEncoding. However, it is necessary to describe this
    /// > encoding, since a font's built-in encoding can be used as the base
    /// > encoding from which differences may be specified in an encoding
    /// > dictionary.
    ///
    /// ## Key Characteristics
    ///
    /// - Based on ASCII for printable characters (0x20-0x7E)
    /// - Does NOT include accented Latin characters
    /// - Includes typographic characters (ligatures, dashes, quotes)
    /// - Many positions are undefined
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.2 — Latin character set and encodings (STD column)
    public enum StandardEncoding: Encoding {
        /// The encoding name
        ///
        /// Note: PDF processors shall NOT have this as a predefined encoding name.
        /// It is used internally by Type 1 fonts.
        public static let name: String = "StandardEncoding"

        // MARK: - Decode Table

        /// Complete decode table from ISO 32000-2 Table D.2 (STD column)
        ///
        /// Octal codes from the spec are converted to decimal indices.
        public static let decodeTable: [Unicode.Scalar?] = [
            // 0x00-0x1F: Control characters (undefined)
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,

            // 0x20-0x3F: ASCII punctuation and digits
            "\u{0020}",  // 0x20 (040) space
            "\u{0021}",  // 0x21 (041) exclam
            "\u{0022}",  // 0x22 (042) quotedbl
            "\u{0023}",  // 0x23 (043) numbersign
            "\u{0024}",  // 0x24 (044) dollar
            "\u{0025}",  // 0x25 (045) percent
            "\u{0026}",  // 0x26 (046) ampersand
            "\u{2019}",  // 0x27 (047) quoteright (U+2019, not ASCII apostrophe)
            "\u{0028}",  // 0x28 (050) parenleft
            "\u{0029}",  // 0x29 (051) parenright
            "\u{002A}",  // 0x2A (052) asterisk
            "\u{002B}",  // 0x2B (053) plus
            "\u{002C}",  // 0x2C (054) comma
            "\u{002D}",  // 0x2D (055) hyphen
            "\u{002E}",  // 0x2E (056) period
            "\u{002F}",  // 0x2F (057) slash
            "\u{0030}",  // 0x30 (060) zero
            "\u{0031}",  // 0x31 (061) one
            "\u{0032}",  // 0x32 (062) two
            "\u{0033}",  // 0x33 (063) three
            "\u{0034}",  // 0x34 (064) four
            "\u{0035}",  // 0x35 (065) five
            "\u{0036}",  // 0x36 (066) six
            "\u{0037}",  // 0x37 (067) seven
            "\u{0038}",  // 0x38 (070) eight
            "\u{0039}",  // 0x39 (071) nine
            "\u{003A}",  // 0x3A (072) colon
            "\u{003B}",  // 0x3B (073) semicolon
            "\u{003C}",  // 0x3C (074) less
            "\u{003D}",  // 0x3D (075) equal
            "\u{003E}",  // 0x3E (076) greater
            "\u{003F}",  // 0x3F (077) question

            // 0x40-0x5F: ASCII uppercase letters
            "\u{0040}",  // 0x40 (100) at
            "\u{0041}",  // 0x41 (101) A
            "\u{0042}",  // 0x42 (102) B
            "\u{0043}",  // 0x43 (103) C
            "\u{0044}",  // 0x44 (104) D
            "\u{0045}",  // 0x45 (105) E
            "\u{0046}",  // 0x46 (106) F
            "\u{0047}",  // 0x47 (107) G
            "\u{0048}",  // 0x48 (110) H
            "\u{0049}",  // 0x49 (111) I
            "\u{004A}",  // 0x4A (112) J
            "\u{004B}",  // 0x4B (113) K
            "\u{004C}",  // 0x4C (114) L
            "\u{004D}",  // 0x4D (115) M
            "\u{004E}",  // 0x4E (116) N
            "\u{004F}",  // 0x4F (117) O
            "\u{0050}",  // 0x50 (120) P
            "\u{0051}",  // 0x51 (121) Q
            "\u{0052}",  // 0x52 (122) R
            "\u{0053}",  // 0x53 (123) S
            "\u{0054}",  // 0x54 (124) T
            "\u{0055}",  // 0x55 (125) U
            "\u{0056}",  // 0x56 (126) V
            "\u{0057}",  // 0x57 (127) W
            "\u{0058}",  // 0x58 (130) X
            "\u{0059}",  // 0x59 (131) Y
            "\u{005A}",  // 0x5A (132) Z
            "\u{005B}",  // 0x5B (133) bracketleft
            "\u{005C}",  // 0x5C (134) backslash
            "\u{005D}",  // 0x5D (135) bracketright
            "\u{005E}",  // 0x5E (136) asciicircum
            "\u{005F}",  // 0x5F (137) underscore

            // 0x60-0x7F: ASCII lowercase letters
            "\u{2018}",  // 0x60 (140) quoteleft (U+2018, not ASCII grave)
            "\u{0061}",  // 0x61 (141) a
            "\u{0062}",  // 0x62 (142) b
            "\u{0063}",  // 0x63 (143) c
            "\u{0064}",  // 0x64 (144) d
            "\u{0065}",  // 0x65 (145) e
            "\u{0066}",  // 0x66 (146) f
            "\u{0067}",  // 0x67 (147) g
            "\u{0068}",  // 0x68 (150) h
            "\u{0069}",  // 0x69 (151) i
            "\u{006A}",  // 0x6A (152) j
            "\u{006B}",  // 0x6B (153) k
            "\u{006C}",  // 0x6C (154) l
            "\u{006D}",  // 0x6D (155) m
            "\u{006E}",  // 0x6E (156) n
            "\u{006F}",  // 0x6F (157) o
            "\u{0070}",  // 0x70 (160) p
            "\u{0071}",  // 0x71 (161) q
            "\u{0072}",  // 0x72 (162) r
            "\u{0073}",  // 0x73 (163) s
            "\u{0074}",  // 0x74 (164) t
            "\u{0075}",  // 0x75 (165) u
            "\u{0076}",  // 0x76 (166) v
            "\u{0077}",  // 0x77 (167) w
            "\u{0078}",  // 0x78 (170) x
            "\u{0079}",  // 0x79 (171) y
            "\u{007A}",  // 0x7A (172) z
            "\u{007B}",  // 0x7B (173) braceleft
            "\u{007C}",  // 0x7C (174) bar
            "\u{007D}",  // 0x7D (175) braceright
            "\u{007E}",  // 0x7E (176) asciitilde
            nil,  // 0x7F undefined

            // 0x80-0x9F: Undefined in StandardEncoding
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,

            // 0xA0-0xBF: Extended characters
            nil,  // 0xA0 undefined
            "\u{00A1}",  // 0xA1 (241) exclamdown
            "\u{00A2}",  // 0xA2 (242) cent
            "\u{00A3}",  // 0xA3 (243) sterling
            "\u{2044}",  // 0xA4 (244) fraction (U+2044 FRACTION SLASH)
            "\u{00A5}",  // 0xA5 (245) yen
            "\u{0192}",  // 0xA6 (246) florin
            "\u{00A7}",  // 0xA7 (247) section
            "\u{00A4}",  // 0xA8 (250) currency
            "\u{0027}",  // 0xA9 (251) quotesingle
            "\u{201C}",  // 0xAA (252) quotedblleft
            "\u{00AB}",  // 0xAB (253) guillemotleft
            "\u{2039}",  // 0xAC (254) guilsinglleft
            "\u{203A}",  // 0xAD (255) guilsinglright
            "\u{FB01}",  // 0xAE (256) fi ligature
            "\u{FB02}",  // 0xAF (257) fl ligature

            // 0xB0-0xBF: More extended characters
            nil,  // 0xB0 undefined
            "\u{2013}",  // 0xB1 (261) endash
            "\u{2020}",  // 0xB2 (262) dagger
            "\u{2021}",  // 0xB3 (263) daggerdbl
            "\u{00B7}",  // 0xB4 (264) periodcentered
            nil,  // 0xB5 undefined
            "\u{00B6}",  // 0xB6 (266) paragraph
            "\u{2022}",  // 0xB7 (267) bullet
            "\u{201A}",  // 0xB8 (270) quotesinglbase
            "\u{201E}",  // 0xB9 (271) quotedblbase
            "\u{201D}",  // 0xBA (272) quotedblright
            "\u{00BB}",  // 0xBB (273) guillemotright
            "\u{2026}",  // 0xBC (274) ellipsis
            "\u{2030}",  // 0xBD (275) perthousand
            nil,  // 0xBE undefined
            "\u{00BF}",  // 0xBF (277) questiondown

            // 0xC0-0xCF: Diacritical marks and special
            nil,  // 0xC0 undefined
            "\u{0060}",  // 0xC1 (301) grave
            "\u{00B4}",  // 0xC2 (302) acute
            "\u{02C6}",  // 0xC3 (303) circumflex
            "\u{02DC}",  // 0xC4 (304) tilde
            "\u{00AF}",  // 0xC5 (305) macron
            "\u{02D8}",  // 0xC6 (306) breve
            "\u{02D9}",  // 0xC7 (307) dotaccent
            "\u{00A8}",  // 0xC8 (310) dieresis
            nil,  // 0xC9 undefined
            "\u{02DA}",  // 0xCA (312) ring
            "\u{00B8}",  // 0xCB (313) cedilla
            nil,  // 0xCC undefined
            "\u{02DD}",  // 0xCD (315) hungarumlaut
            "\u{02DB}",  // 0xCE (316) ogonek
            "\u{02C7}",  // 0xCF (317) caron

            // 0xD0-0xDF: Dashes and more
            "\u{2014}",  // 0xD0 (320) emdash
            nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,

            // 0xE0-0xEF: AE, OE, Oslash, etc.
            nil,  // 0xE0 undefined
            "\u{00C6}",  // 0xE1 (341) AE
            nil,  // 0xE2 undefined
            "\u{00AA}",  // 0xE3 (343) ordfeminine
            nil, nil, nil, nil,
            "\u{0141}",  // 0xE8 (350) Lslash
            "\u{00D8}",  // 0xE9 (351) Oslash
            "\u{0152}",  // 0xEA (352) OE
            "\u{00BA}",  // 0xEB (353) ordmasculine
            nil, nil, nil, nil,

            // 0xF0-0xFF: ae, oe, oslash, etc.
            nil,  // 0xF0 undefined
            "\u{00E6}",  // 0xF1 (361) ae
            nil, nil, nil,
            "\u{0131}",  // 0xF5 (365) dotlessi
            nil, nil,
            "\u{0142}",  // 0xF8 (370) lslash
            "\u{00F8}",  // 0xF9 (371) oslash
            "\u{0153}",  // 0xFA (372) oe
            "\u{00DF}",  // 0xFB (373) germandbls
            nil, nil, nil, nil,
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

        /// Encode a Unicode scalar to StandardEncoding byte
        @inlinable
        public static func encode(_ scalar: Unicode.Scalar) -> UInt8? {
            encodeTable[scalar.value]
        }

        /// Decode a StandardEncoding byte to Unicode scalar
        @inlinable
        public static func decode(_ byte: UInt8) -> Unicode.Scalar? {
            decodeTable[Int(byte)]
        }
    }
}
