// ISO_32000.SymbolEncoding.swift
// ISO 32000-2:2020 Annex D.5 - Symbol set and encoding
//
// The built-in encoding for the Symbol font, containing Greek letters,
// mathematical symbols, and other special characters.

public import ISO_32000_Shared

extension ISO_32000 {
    /// SymbolEncoding - Symbol Font Built-in Encoding
    ///
    /// Per ISO 32000-2 Section D.5:
    /// > D.5, "Symbol set and encoding" and D.6, "ZapfDingbats set and encoding"
    /// > describe the character sets and built-in encodings for the Symbol and
    /// > ZapfDingbats (ITC Zapf Dingbats) font programs, which belong to the
    /// > standard 14 predefined fonts. These fonts have built-in encodings that
    /// > are unique to each font.
    ///
    /// ## Contents
    ///
    /// - Greek uppercase and lowercase letters (Alpha-Omega)
    /// - Mathematical operators and symbols
    /// - Arrows and technical symbols
    /// - Bracket extensions for large delimiters
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.5 — Symbol set and encoding
    public enum SymbolEncoding: Encoding {
        /// The encoding name
        ///
        /// Note: This is a font-specific built-in encoding, not a predefined
        /// encoding name in PDF encoding dictionaries.
        public static let name: String = "SymbolEncoding"

        // MARK: - Decode Table

        /// Complete decode table from ISO 32000-2 Table D.5
        public static let decodeTable: [Unicode.Scalar?] = [
            // 0x00-0x1F: Undefined (control characters)
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,

            // 0x20-0x3F: Space, punctuation, digits
            "\u{0020}",  // 0x20 (040) space
            "\u{0021}",  // 0x21 (041) exclam
            "\u{2200}",  // 0x22 (042) universal (∀)
            "\u{0023}",  // 0x23 (043) numbersign
            "\u{2203}",  // 0x24 (044) existential (∃)
            "\u{0025}",  // 0x25 (045) percent
            "\u{0026}",  // 0x26 (046) ampersand
            "\u{220B}",  // 0x27 (047) suchthat (∋)
            "\u{0028}",  // 0x28 (050) parenleft
            "\u{0029}",  // 0x29 (051) parenright
            "\u{2217}",  // 0x2A (052) asteriskmath (∗)
            "\u{002B}",  // 0x2B (053) plus
            "\u{002C}",  // 0x2C (054) comma
            "\u{2212}",  // 0x2D (055) minus (−)
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

            // 0x40-0x5F: Congruent and Greek uppercase
            "\u{2245}",  // 0x40 (100) congruent (≅)
            "\u{0391}",  // 0x41 (101) Alpha
            "\u{0392}",  // 0x42 (102) Beta
            "\u{03A7}",  // 0x43 (103) Chi
            "\u{0394}",  // 0x44 (104) Delta (Δ)
            "\u{0395}",  // 0x45 (105) Epsilon
            "\u{03A6}",  // 0x46 (106) Phi
            "\u{0393}",  // 0x47 (107) Gamma
            "\u{0397}",  // 0x48 (110) Eta
            "\u{0399}",  // 0x49 (111) Iota
            "\u{03D1}",  // 0x4A (112) theta1 (ϑ variant)
            "\u{039A}",  // 0x4B (113) Kappa
            "\u{039B}",  // 0x4C (114) Lambda
            "\u{039C}",  // 0x4D (115) Mu
            "\u{039D}",  // 0x4E (116) Nu
            "\u{039F}",  // 0x4F (117) Omicron
            "\u{03A0}",  // 0x50 (120) Pi
            "\u{0398}",  // 0x51 (121) Theta
            "\u{03A1}",  // 0x52 (122) Rho
            "\u{03A3}",  // 0x53 (123) Sigma
            "\u{03A4}",  // 0x54 (124) Tau
            "\u{03A5}",  // 0x55 (125) Upsilon
            "\u{03C2}",  // 0x56 (126) sigma1 (ς final)
            "\u{03A9}",  // 0x57 (127) Omega
            "\u{039E}",  // 0x58 (130) Xi
            "\u{03A8}",  // 0x59 (131) Psi
            "\u{0396}",  // 0x5A (132) Zeta
            "\u{005B}",  // 0x5B (133) bracketleft
            "\u{2234}",  // 0x5C (134) therefore (∴)
            "\u{005D}",  // 0x5D (135) bracketright
            "\u{22A5}",  // 0x5E (136) perpendicular (⊥)
            "\u{005F}",  // 0x5F (137) underscore

            // 0x60-0x7F: Radicalex and Greek lowercase
            "\u{F8E5}",  // 0x60 (140) radicalex (private use for radical extender)
            "\u{03B1}",  // 0x61 (141) alpha
            "\u{03B2}",  // 0x62 (142) beta
            "\u{03C7}",  // 0x63 (143) chi
            "\u{03B4}",  // 0x64 (144) delta
            "\u{03B5}",  // 0x65 (145) epsilon
            "\u{03C6}",  // 0x66 (146) phi
            "\u{03B3}",  // 0x67 (147) gamma
            "\u{03B7}",  // 0x68 (150) eta
            "\u{03B9}",  // 0x69 (151) iota
            "\u{03D5}",  // 0x6A (152) phi1 (ϕ variant)
            "\u{03BA}",  // 0x6B (153) kappa
            "\u{03BB}",  // 0x6C (154) lambda
            "\u{03BC}",  // 0x6D (155) mu
            "\u{03BD}",  // 0x6E (156) nu
            "\u{03BF}",  // 0x6F (157) omicron
            "\u{03C0}",  // 0x70 (160) pi
            "\u{03B8}",  // 0x71 (161) theta
            "\u{03C1}",  // 0x72 (162) rho
            "\u{03C3}",  // 0x73 (163) sigma
            "\u{03C4}",  // 0x74 (164) tau
            "\u{03C5}",  // 0x75 (165) upsilon
            "\u{03D6}",  // 0x76 (166) omega1 (ϖ variant)
            "\u{03C9}",  // 0x77 (167) omega
            "\u{03BE}",  // 0x78 (170) xi
            "\u{03C8}",  // 0x79 (171) psi
            "\u{03B6}",  // 0x7A (172) zeta
            "\u{007B}",  // 0x7B (173) braceleft
            "\u{007C}",  // 0x7C (174) bar
            "\u{007D}",  // 0x7D (175) braceright
            "\u{223C}",  // 0x7E (176) similar (~)
            nil,         // 0x7F undefined

            // 0x80-0x9F: Undefined
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,

            // 0xA0-0xBF: Special symbols
            "\u{20AC}",  // 0xA0 (240) Euro (€)
            "\u{03D2}",  // 0xA1 (241) Upsilon1 (ϒ variant)
            "\u{2032}",  // 0xA2 (242) minute (′)
            "\u{2264}",  // 0xA3 (243) lessequal (≤)
            "\u{2044}",  // 0xA4 (244) fraction (⁄)
            "\u{221E}",  // 0xA5 (245) infinity (∞)
            "\u{0192}",  // 0xA6 (246) florin
            "\u{2663}",  // 0xA7 (247) club (♣)
            "\u{2666}",  // 0xA8 (250) diamond (♦)
            "\u{2665}",  // 0xA9 (251) heart (♥)
            "\u{2660}",  // 0xAA (252) spade (♠)
            "\u{2194}",  // 0xAB (253) arrowboth (↔)
            "\u{2190}",  // 0xAC (254) arrowleft (←)
            "\u{2191}",  // 0xAD (255) arrowup (↑)
            "\u{2192}",  // 0xAE (256) arrowright (→)
            "\u{2193}",  // 0xAF (257) arrowdown (↓)

            // 0xB0-0xBF: More symbols
            "\u{00B0}",  // 0xB0 (260) degree
            "\u{00B1}",  // 0xB1 (261) plusminus
            "\u{2033}",  // 0xB2 (262) second (″)
            "\u{2265}",  // 0xB3 (263) greaterequal (≥)
            "\u{00D7}",  // 0xB4 (264) multiply
            "\u{221D}",  // 0xB5 (265) proportional (∝)
            "\u{2202}",  // 0xB6 (266) partialdiff (∂)
            "\u{2022}",  // 0xB7 (267) bullet
            "\u{00F7}",  // 0xB8 (270) divide
            "\u{2260}",  // 0xB9 (271) notequal (≠)
            "\u{2261}",  // 0xBA (272) equivalence (≡)
            "\u{2248}",  // 0xBB (273) approxequal (≈)
            "\u{2026}",  // 0xBC (274) ellipsis
            "\u{F8E6}",  // 0xBD (275) arrowvertex (private use)
            "\u{F8E7}",  // 0xBE (276) arrowhorizex (private use)
            "\u{21B5}",  // 0xBF (277) carriagereturn (↵)

            // 0xC0-0xCF: Set theory and logic
            "\u{2135}",  // 0xC0 (300) aleph (ℵ)
            "\u{2111}",  // 0xC1 (301) Ifraktur (ℑ)
            "\u{211C}",  // 0xC2 (302) Rfraktur (ℜ)
            "\u{2118}",  // 0xC3 (303) weierstrass (℘)
            "\u{2297}",  // 0xC4 (304) circlemultiply (⊗)
            "\u{2295}",  // 0xC5 (305) circleplus (⊕)
            "\u{2205}",  // 0xC6 (306) emptyset (∅)
            "\u{2229}",  // 0xC7 (307) intersection (∩)
            "\u{222A}",  // 0xC8 (310) union (∪)
            "\u{2283}",  // 0xC9 (311) propersuperset (⊃)
            "\u{2287}",  // 0xCA (312) reflexsuperset (⊇)
            "\u{2284}",  // 0xCB (313) notsubset (⊄)
            "\u{2282}",  // 0xCC (314) propersubset (⊂)
            "\u{2286}",  // 0xCD (315) reflexsubset (⊆)
            "\u{2208}",  // 0xCE (316) element (∈)
            "\u{2209}",  // 0xCF (317) notelement (∉)

            // 0xD0-0xDF: Angle, gradient, etc.
            "\u{2220}",  // 0xD0 (320) angle (∠)
            "\u{2207}",  // 0xD1 (321) gradient (∇)
            "\u{F6DA}",  // 0xD2 (322) registerserif (private use)
            "\u{F6D9}",  // 0xD3 (323) copyrightserif (private use)
            "\u{F6DB}",  // 0xD4 (324) trademarkserif (private use)
            "\u{220F}",  // 0xD5 (325) product (∏)
            "\u{221A}",  // 0xD6 (326) radical (√)
            "\u{22C5}",  // 0xD7 (327) dotmath (⋅)
            "\u{00AC}",  // 0xD8 (330) logicalnot
            "\u{2227}",  // 0xD9 (331) logicaland (∧)
            "\u{2228}",  // 0xDA (332) logicalor (∨)
            "\u{21D4}",  // 0xDB (333) arrowdblboth (⇔)
            "\u{21D0}",  // 0xDC (334) arrowdblleft (⇐)
            "\u{21D1}",  // 0xDD (335) arrowdblup (⇑)
            "\u{21D2}",  // 0xDE (336) arrowdblright (⇒)
            "\u{21D3}",  // 0xDF (337) arrowdbldown (⇓)

            // 0xE0-0xEF: Lozenge, angles, summation
            "\u{25CA}",  // 0xE0 (340) lozenge (◊)
            "\u{2329}",  // 0xE1 (341) angleleft (〈)
            "\u{F8E8}",  // 0xE2 (342) registersans (private use)
            "\u{F8E9}",  // 0xE3 (343) copyrightsans (private use)
            "\u{F8EA}",  // 0xE4 (344) trademarksans (private use)
            "\u{2211}",  // 0xE5 (345) summation (∑)
            "\u{239B}",  // 0xE6 (346) parenlefttp
            "\u{239C}",  // 0xE7 (347) parenleftex
            "\u{239D}",  // 0xE8 (350) parenleftbt
            "\u{23A1}",  // 0xE9 (351) bracketlefttp
            "\u{23A2}",  // 0xEA (352) bracketleftex
            "\u{23A3}",  // 0xEB (353) bracketleftbt
            "\u{23A7}",  // 0xEC (354) bracelefttp
            "\u{23A8}",  // 0xED (355) braceleftmid
            "\u{23A9}",  // 0xEE (356) braceleftbt
            "\u{23AA}",  // 0xEF (357) braceex

            // 0xF0-0xFF: Integral, angle right, etc.
            nil,         // 0xF0 undefined
            "\u{232A}",  // 0xF1 (361) angleright (〉)
            "\u{222B}",  // 0xF2 (362) integral (∫)
            "\u{2320}",  // 0xF3 (363) integraltp (⌠)
            "\u{23AE}",  // 0xF4 (364) integralex
            "\u{2321}",  // 0xF5 (365) integralbt (⌡)
            "\u{239E}",  // 0xF6 (366) parenrighttp
            "\u{239F}",  // 0xF7 (367) parenrightex
            "\u{23A0}",  // 0xF8 (370) parenrightbt
            "\u{23A4}",  // 0xF9 (371) bracketrighttp
            "\u{23A5}",  // 0xFA (372) bracketrightex
            "\u{23A6}",  // 0xFB (373) bracketrightbt
            "\u{23AB}",  // 0xFC (374) bracerighttp
            "\u{23AC}",  // 0xFD (375) bracerightmid
            "\u{23AD}",  // 0xFE (376) bracerightbt
            nil,         // 0xFF undefined
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

        /// Encode a Unicode scalar to SymbolEncoding byte
        @inlinable
        public static func encode(_ scalar: Unicode.Scalar) -> UInt8? {
            encodeTable[scalar.value]
        }

        /// Decode a SymbolEncoding byte to Unicode scalar
        @inlinable
        public static func decode(_ byte: UInt8) -> Unicode.Scalar? {
            decodeTable[Int(byte)]
        }
    }
}
