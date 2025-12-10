// ISO_32000.MacRomanEncoding.swift
// ISO 32000-2:2020 Annex D.2 - MacRomanEncoding
//
// Mac OS standard encoding for Latin text in Western writing systems.
// Used for cross-platform compatibility with older Mac documents.

public import ISO_32000_Shared

extension ISO_32000 {
    /// MacRomanEncoding - Mac OS Latin Text Encoding
    ///
    /// Per ISO 32000-2 Table D.1:
    /// > Mac OS standard encoding for Latin text in Western writing systems.
    /// > PDF processors shall have a predefined encoding named MacRomanEncoding
    /// > that may be used with both Type 1 and TrueType fonts.
    ///
    /// ## Important Note (ISO 32000-2 Note 1)
    ///
    /// Apple changed the Mac OS Latin-text encoding for code 333 (0xDB) from the
    /// currency character (¤) to the euro character (€). However, this incompatible
    /// change has NOT been reflected in PDF's MacRomanEncoding, which continues to
    /// map code 333 to currency. If the euro character is desired, an encoding
    /// dictionary can be used to specify this single difference from MacRomanEncoding.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.2 — Latin character set and encodings (MAC column)
    public enum MacRomanEncoding: Encoding {
        /// The encoding name as used in PDF
        public static let name: String = "MacRomanEncoding"

        // MARK: - Decode Table

        /// Complete decode table from ISO 32000-2 Table D.2 (MAC column)
        ///
        /// Octal codes from the spec are converted to decimal indices.
        public static let decodeTable: [Unicode.Scalar?] = [
            // 0x00-0x1F: Control characters (undefined in PDF context)
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
            "\u{0027}",  // 0x27 (047) quotesingle
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
            "\u{0060}",  // 0x60 (140) grave
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

            // 0x80-0x8F: Extended characters
            "\u{00C4}",  // 0x80 (200) Adieresis
            "\u{00C5}",  // 0x81 (201) Aring
            "\u{00C7}",  // 0x82 (202) Ccedilla
            "\u{00C9}",  // 0x83 (203) Eacute
            "\u{00D1}",  // 0x84 (204) Ntilde
            "\u{00D6}",  // 0x85 (205) Odieresis
            "\u{00DC}",  // 0x86 (206) Udieresis
            "\u{00E1}",  // 0x87 (207) aacute
            "\u{00E0}",  // 0x88 (210) agrave
            "\u{00E2}",  // 0x89 (211) acircumflex
            "\u{00E4}",  // 0x8A (212) adieresis
            "\u{00E3}",  // 0x8B (213) atilde
            "\u{00E5}",  // 0x8C (214) aring
            "\u{00E7}",  // 0x8D (215) ccedilla
            "\u{00E9}",  // 0x8E (216) eacute
            "\u{00E8}",  // 0x8F (217) egrave

            // 0x90-0x9F: More extended
            "\u{00EA}",  // 0x90 (220) ecircumflex
            "\u{00EB}",  // 0x91 (221) edieresis
            "\u{00ED}",  // 0x92 (222) iacute
            "\u{00EC}",  // 0x93 (223) igrave
            "\u{00EE}",  // 0x94 (224) icircumflex
            "\u{00EF}",  // 0x95 (225) idieresis
            "\u{00F1}",  // 0x96 (226) ntilde
            "\u{00F3}",  // 0x97 (227) oacute
            "\u{00F2}",  // 0x98 (230) ograve
            "\u{00F4}",  // 0x99 (231) ocircumflex
            "\u{00F6}",  // 0x9A (232) odieresis
            "\u{00F5}",  // 0x9B (233) otilde
            "\u{00FA}",  // 0x9C (234) uacute
            "\u{00F9}",  // 0x9D (235) ugrave
            "\u{00FB}",  // 0x9E (236) ucircumflex
            "\u{00FC}",  // 0x9F (237) udieresis

            // 0xA0-0xAF: Symbols and special
            "\u{2020}",  // 0xA0 (240) dagger
            "\u{00B0}",  // 0xA1 (241) degree
            "\u{00A2}",  // 0xA2 (242) cent
            "\u{00A3}",  // 0xA3 (243) sterling
            "\u{00A7}",  // 0xA4 (244) section
            "\u{2022}",  // 0xA5 (245) bullet
            "\u{00B6}",  // 0xA6 (246) paragraph
            "\u{00DF}",  // 0xA7 (247) germandbls
            "\u{00AE}",  // 0xA8 (250) registered
            "\u{00A9}",  // 0xA9 (251) copyright
            "\u{2122}",  // 0xAA (252) trademark
            "\u{00B4}",  // 0xAB (253) acute
            "\u{00A8}",  // 0xAC (254) dieresis
            nil,  // 0xAD undefined
            "\u{00C6}",  // 0xAE (256) AE
            "\u{00D8}",  // 0xAF (257) Oslash

            // 0xB0-0xBF: More symbols
            nil,  // 0xB0 undefined
            "\u{00B1}",  // 0xB1 (261) plusminus
            nil,  // 0xB2 undefined
            nil,  // 0xB3 undefined
            "\u{00A5}",  // 0xB4 (264) yen
            "\u{00B5}",  // 0xB5 (265) mu
            nil,  // 0xB6 undefined
            nil,  // 0xB7 undefined
            nil,  // 0xB8 undefined
            nil,  // 0xB9 undefined
            nil,  // 0xBA undefined
            "\u{00AA}",  // 0xBB (273) ordfeminine
            "\u{00BA}",  // 0xBC (274) ordmasculine
            nil,  // 0xBD undefined
            "\u{00E6}",  // 0xBE (276) ae
            "\u{00F8}",  // 0xBF (277) oslash

            // 0xC0-0xCF: Special characters
            "\u{00BF}",  // 0xC0 (300) questiondown
            "\u{00A1}",  // 0xC1 (301) exclamdown
            "\u{00AC}",  // 0xC2 (302) logicalnot
            nil,  // 0xC3 undefined
            "\u{0192}",  // 0xC4 (304) florin
            nil,  // 0xC5 undefined
            nil,  // 0xC6 undefined
            "\u{00AB}",  // 0xC7 (307) guillemotleft
            "\u{00BB}",  // 0xC8 (310) guillemotright
            "\u{2026}",  // 0xC9 (311) ellipsis
            "\u{00A0}",  // 0xCA (312) space (non-breaking) - see Note 6
            "\u{00C0}",  // 0xCB (313) Agrave
            "\u{00C3}",  // 0xCC (314) Atilde
            "\u{00D5}",  // 0xCD (315) Otilde
            "\u{0152}",  // 0xCE (316) OE
            "\u{0153}",  // 0xCF (317) oe

            // 0xD0-0xDF: Dashes, quotes, and accented
            "\u{2013}",  // 0xD0 (320) endash
            "\u{2014}",  // 0xD1 (321) emdash
            "\u{201C}",  // 0xD2 (322) quotedblleft
            "\u{201D}",  // 0xD3 (323) quotedblright
            "\u{2018}",  // 0xD4 (324) quoteleft
            "\u{2019}",  // 0xD5 (325) quoteright
            "\u{00F7}",  // 0xD6 (326) divide
            nil,  // 0xD7 undefined
            "\u{00FF}",  // 0xD8 (330) ydieresis
            "\u{0178}",  // 0xD9 (331) Ydieresis
            "\u{2044}",  // 0xDA (332) fraction
            "\u{00A4}",  // 0xDB (333) currency (NOT Euro - see Note 1)
            "\u{2039}",  // 0xDC (334) guilsinglleft
            "\u{203A}",  // 0xDD (335) guilsinglright
            "\u{FB01}",  // 0xDE (336) fi
            "\u{FB02}",  // 0xDF (337) fl

            // 0xE0-0xEF: More special characters
            "\u{2021}",  // 0xE0 (340) daggerdbl
            "\u{00B7}",  // 0xE1 (341) periodcentered
            "\u{201A}",  // 0xE2 (342) quotesinglbase
            "\u{201E}",  // 0xE3 (343) quotedblbase
            "\u{2030}",  // 0xE4 (344) perthousand
            "\u{00C2}",  // 0xE5 (345) Acircumflex
            "\u{00CA}",  // 0xE6 (346) Ecircumflex
            "\u{00C1}",  // 0xE7 (347) Aacute
            "\u{00CB}",  // 0xE8 (350) Edieresis
            "\u{00C8}",  // 0xE9 (351) Egrave
            "\u{00CD}",  // 0xEA (352) Iacute
            "\u{00CE}",  // 0xEB (353) Icircumflex
            "\u{00CF}",  // 0xEC (354) Idieresis
            "\u{00CC}",  // 0xED (355) Igrave
            "\u{00D3}",  // 0xEE (356) Oacute
            "\u{00D4}",  // 0xEF (357) Ocircumflex

            // 0xF0-0xFF: Final characters
            nil,  // 0xF0 undefined
            "\u{00D2}",  // 0xF1 (361) Ograve
            "\u{00DA}",  // 0xF2 (362) Uacute
            "\u{00DB}",  // 0xF3 (363) Ucircumflex
            "\u{00D9}",  // 0xF4 (364) Ugrave
            "\u{0131}",  // 0xF5 (365) dotlessi
            "\u{02C6}",  // 0xF6 (366) circumflex
            "\u{02DC}",  // 0xF7 (367) tilde
            "\u{00AF}",  // 0xF8 (370) macron
            "\u{02D8}",  // 0xF9 (371) breve
            "\u{02D9}",  // 0xFA (372) dotaccent
            "\u{02DA}",  // 0xFB (373) ring
            "\u{00B8}",  // 0xFC (374) cedilla
            "\u{02DD}",  // 0xFD (375) hungarumlaut
            "\u{02DB}",  // 0xFE (376) ogonek
            "\u{02C7}",  // 0xFF (377) caron
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

        /// Encode a Unicode scalar to MacRomanEncoding byte
        @inlinable
        public static func encode(_ scalar: Unicode.Scalar) -> UInt8? {
            encodeTable[scalar.value]
        }

        /// Decode a MacRomanEncoding byte to Unicode scalar
        @inlinable
        public static func decode(_ byte: UInt8) -> Unicode.Scalar? {
            decodeTable[Int(byte)]
        }
    }
}
