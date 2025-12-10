// ISO_32000.ZapfDingbatsEncoding.swift
// ISO 32000-2:2020 Annex D.6 - ZapfDingbats set and encoding
//
// The built-in encoding for the ZapfDingbats (ITC Zapf Dingbats) font,
// containing decorative symbols, arrows, and ornaments.

public import ISO_32000_Shared

extension ISO_32000 {
    /// ZapfDingbatsEncoding - ZapfDingbats Font Built-in Encoding
    ///
    /// Per ISO 32000-2 Section D.6:
    /// > D.5, "Symbol set and encoding" and D.6, "ZapfDingbats set and encoding"
    /// > describe the character sets and built-in encodings for the Symbol and
    /// > ZapfDingbats (ITC Zapf Dingbats) font programs, which belong to the
    /// > standard 14 predefined fonts. These fonts have built-in encodings that
    /// > are unique to each font. The characters for ZapfDingbats are ordered
    /// > by code instead of by name, since the names in that font are meaningless.
    ///
    /// ## Contents
    ///
    /// - Decorative scissors, telephones, and hands (✁-✎)
    /// - Writing implements and envelopes (✏-✒)
    /// - Checkmarks and crosses (✓-✘)
    /// - Crosses and stars (✙-✯)
    /// - Asterisks and snowflakes (✱-❊)
    /// - Geometric shapes (●-◗)
    /// - Vertical bars and quotes (❘-❞)
    /// - Hearts and playing card suits (❡-♠)
    /// - Circled numbers 1-10 (①-⑩, ❶-❿, ➀-➉, ➊-➓)
    /// - Arrows (➔-➾)
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.6 — ZapfDingbats set and encoding
    public enum ZapfDingbatsEncoding: Encoding {
        /// The encoding name
        ///
        /// Note: This is a font-specific built-in encoding, not a predefined
        /// encoding name in PDF encoding dictionaries.
        public static let name: String = "ZapfDingbatsEncoding"

        // MARK: - Decode Table

        /// Complete decode table from ISO 32000-2 Table D.6
        ///
        /// Uses Unicode Dingbats block (U+2700-U+27BF) and other related characters.
        public static let decodeTable: [Unicode.Scalar?] = [
            // 0x00-0x1F: Undefined (control characters)
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,

            // 0x20-0x3F: Space and first dingbats
            "\u{0020}",  // 0x20 (040) space
            "\u{2701}",  // 0x21 (041) a1 - ✁ (scissors)
            "\u{2702}",  // 0x22 (042) a2 - ✂
            "\u{2703}",  // 0x23 (043) a202 - ✃
            "\u{2704}",  // 0x24 (044) a3 - ✄
            "\u{260E}",  // 0x25 (045) a4 - ☎ (telephone)
            "\u{2706}",  // 0x26 (046) a5 - ✆
            "\u{2707}",  // 0x27 (047) a119 - ✇
            "\u{2708}",  // 0x28 (050) a118 - ✈ (airplane)
            "\u{2709}",  // 0x29 (051) a117 - ✉ (envelope)
            "\u{261B}",  // 0x2A (052) a11 - ☛ (pointing hand)
            "\u{261E}",  // 0x2B (053) a12 - ☞
            "\u{270C}",  // 0x2C (054) a13 - ✌ (victory hand)
            "\u{270D}",  // 0x2D (055) a14 - ✍ (writing hand)
            "\u{270E}",  // 0x2E (056) a15 - ✎ (pencil)
            "\u{270F}",  // 0x2F (057) a16 - ✏
            "\u{2710}",  // 0x30 (060) a105 - ✐
            "\u{2711}",  // 0x31 (061) a17 - ✑
            "\u{2712}",  // 0x32 (062) a18 - ✒
            "\u{2713}",  // 0x33 (063) a19 - ✓ (checkmark)
            "\u{2714}",  // 0x34 (064) a20 - ✔
            "\u{2715}",  // 0x35 (065) a21 - ✕
            "\u{2716}",  // 0x36 (066) a22 - ✖
            "\u{2717}",  // 0x37 (067) a23 - ✗
            "\u{2718}",  // 0x38 (070) a24 - ✘
            "\u{2719}",  // 0x39 (071) a25 - ✙
            "\u{271A}",  // 0x3A (072) a26 - ✚
            "\u{271B}",  // 0x3B (073) a27 - ✛
            "\u{271C}",  // 0x3C (074) a28 - ✜
            "\u{271D}",  // 0x3D (075) a6 - ✝ (cross)
            "\u{271E}",  // 0x3E (076) a7 - ✞
            "\u{271F}",  // 0x3F (077) a8 - ✟

            // 0x40-0x5F: Crosses and stars
            "\u{2720}",  // 0x40 (100) a9 - ✠
            "\u{2721}",  // 0x41 (101) a10 - ✡ (Star of David)
            "\u{2722}",  // 0x42 (102) a29 - ✢
            "\u{2723}",  // 0x43 (103) a30 - ✣
            "\u{2724}",  // 0x44 (104) a31 - ✤
            "\u{2725}",  // 0x45 (105) a32 - ✥
            "\u{2726}",  // 0x46 (106) a33 - ✦
            "\u{2727}",  // 0x47 (107) a34 - ✧
            "\u{2605}",  // 0x48 (110) a35 - ★ (black star)
            "\u{2729}",  // 0x49 (111) a36 - ✩
            "\u{272A}",  // 0x4A (112) a37 - ✪
            "\u{272B}",  // 0x4B (113) a38 - ✫
            "\u{272C}",  // 0x4C (114) a39 - ✬
            "\u{272D}",  // 0x4D (115) a40 - ✭
            "\u{272E}",  // 0x4E (116) a41 - ✮
            "\u{272F}",  // 0x4F (117) a42 - ✯
            "\u{2730}",  // 0x50 (120) a43 - ✰
            "\u{2731}",  // 0x51 (121) a44 - ✱
            "\u{2732}",  // 0x52 (122) a45 - ✲
            "\u{2733}",  // 0x53 (123) a46 - ✳
            "\u{2734}",  // 0x54 (124) a47 - ✴
            "\u{2735}",  // 0x55 (125) a48 - ✵
            "\u{2736}",  // 0x56 (126) a49 - ✶
            "\u{2737}",  // 0x57 (127) a50 - ✷
            "\u{2738}",  // 0x58 (130) a51 - ✸
            "\u{2739}",  // 0x59 (131) a52 - ✹
            "\u{273A}",  // 0x5A (132) a53 - ✺
            "\u{273B}",  // 0x5B (133) a54 - ✻
            "\u{273C}",  // 0x5C (134) a55 - ✼
            "\u{273D}",  // 0x5D (135) a56 - ✽
            "\u{273E}",  // 0x5E (136) a57 - ✾
            "\u{273F}",  // 0x5F (137) a58 - ✿

            // 0x60-0x7F: More asterisks and snowflakes
            "\u{2740}",  // 0x60 (140) a59 - ❀
            "\u{2741}",  // 0x61 (141) a60 - ❁
            "\u{2742}",  // 0x62 (142) a61 - ❂
            "\u{2743}",  // 0x63 (143) a62 - ❃
            "\u{2744}",  // 0x64 (144) a63 - ❄ (snowflake)
            "\u{2745}",  // 0x65 (145) a64 - ❅
            "\u{2746}",  // 0x66 (146) a65 - ❆
            "\u{2747}",  // 0x67 (147) a66 - ❇
            "\u{2748}",  // 0x68 (150) a67 - ❈
            "\u{2749}",  // 0x69 (151) a68 - ❉
            "\u{274A}",  // 0x6A (152) a69 - ❊
            "\u{274B}",  // 0x6B (153) a70 - ❋
            "\u{25CF}",  // 0x6C (154) a71 - ● (black circle)
            "\u{274D}",  // 0x6D (155) a72 - ❍
            "\u{25A0}",  // 0x6E (156) a73 - ■ (black square)
            "\u{274F}",  // 0x6F (157) a74 - ❏
            "\u{2750}",  // 0x70 (160) a203 - ❐
            "\u{2751}",  // 0x71 (161) a75 - ❑
            "\u{2752}",  // 0x72 (162) a204 - ❒
            "\u{25B2}",  // 0x73 (163) a76 - ▲ (black triangle up)
            "\u{25BC}",  // 0x74 (164) a77 - ▼ (black triangle down)
            "\u{25C6}",  // 0x75 (165) a78 - ◆ (black diamond)
            "\u{2756}",  // 0x76 (166) a79 - ❖
            "\u{25D7}",  // 0x77 (167) a81 - ◗
            "\u{2758}",  // 0x78 (170) a82 - ❘
            "\u{2759}",  // 0x79 (171) a83 - ❙
            "\u{275A}",  // 0x7A (172) a84 - ❚
            "\u{275B}",  // 0x7B (173) a97 - ❛
            "\u{275C}",  // 0x7C (174) a98 - ❜
            "\u{275D}",  // 0x7D (175) a99 - ❝
            "\u{275E}",  // 0x7E (176) a100 - ❞
            nil,  // 0x7F undefined

            // 0x80-0x9F: Undefined
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,
            nil, nil, nil, nil, nil, nil, nil, nil,

            // 0xA0-0xBF: Hearts, arrows, and circled numbers
            nil,  // 0xA0 undefined
            "\u{2761}",  // 0xA1 (241) a101 - ❡
            "\u{2762}",  // 0xA2 (242) a102 - ❢
            "\u{2763}",  // 0xA3 (243) a103 - ❣
            "\u{2764}",  // 0xA4 (244) a104 - ❤ (heart)
            "\u{2765}",  // 0xA5 (245) a106 - ❥
            "\u{2766}",  // 0xA6 (246) a107 - ❦
            "\u{2767}",  // 0xA7 (247) a108 - ❧
            "\u{2663}",  // 0xA8 (250) a112 - ♣ (club)
            "\u{2666}",  // 0xA9 (251) a111 - ♦ (diamond)
            "\u{2665}",  // 0xAA (252) a110 - ♥ (heart)
            "\u{2660}",  // 0xAB (253) a109 - ♠ (spade)
            "\u{2460}",  // 0xAC (254) a120 - ① (circled 1)
            "\u{2461}",  // 0xAD (255) a121 - ②
            "\u{2462}",  // 0xAE (256) a122 - ③
            "\u{2463}",  // 0xAF (257) a123 - ④

            // 0xB0-0xBF: More circled numbers
            "\u{2464}",  // 0xB0 (260) a124 - ⑤
            "\u{2465}",  // 0xB1 (261) a125 - ⑥
            "\u{2466}",  // 0xB2 (262) a126 - ⑦
            "\u{2467}",  // 0xB3 (263) a127 - ⑧
            "\u{2468}",  // 0xB4 (264) a128 - ⑨
            "\u{2469}",  // 0xB5 (265) a129 - ⑩
            "\u{2776}",  // 0xB6 (266) a130 - ❶ (dingbat negative 1)
            "\u{2777}",  // 0xB7 (267) a131 - ❷
            "\u{2778}",  // 0xB8 (270) a132 - ❸
            "\u{2779}",  // 0xB9 (271) a133 - ❹
            "\u{277A}",  // 0xBA (272) a134 - ❺
            "\u{277B}",  // 0xBB (273) a135 - ❻
            "\u{277C}",  // 0xBC (274) a136 - ❼
            "\u{277D}",  // 0xBD (275) a137 - ❽
            "\u{277E}",  // 0xBE (276) a138 - ❾
            "\u{277F}",  // 0xBF (277) a139 - ❿

            // 0xC0-0xCF: Sans-serif circled numbers
            "\u{2780}",  // 0xC0 (300) a140 - ➀
            "\u{2781}",  // 0xC1 (301) a141 - ➁
            "\u{2782}",  // 0xC2 (302) a142 - ➂
            "\u{2783}",  // 0xC3 (303) a143 - ➃
            "\u{2784}",  // 0xC4 (304) a144 - ➄
            "\u{2785}",  // 0xC5 (305) a145 - ➅
            "\u{2786}",  // 0xC6 (306) a146 - ➆
            "\u{2787}",  // 0xC7 (307) a147 - ➇
            "\u{2788}",  // 0xC8 (310) a148 - ➈
            "\u{2789}",  // 0xC9 (311) a149 - ➉
            "\u{278A}",  // 0xCA (312) a150 - ➊
            "\u{278B}",  // 0xCB (313) a151 - ➋
            "\u{278C}",  // 0xCC (314) a152 - ➌
            "\u{278D}",  // 0xCD (315) a153 - ➍
            "\u{278E}",  // 0xCE (316) a154 - ➎
            "\u{278F}",  // 0xCF (317) a155 - ➏

            // 0xD0-0xDF: More numbers and arrows
            "\u{2790}",  // 0xD0 (320) a156 - ➐
            "\u{2791}",  // 0xD1 (321) a157 - ➑
            "\u{2792}",  // 0xD2 (322) a158 - ➒
            "\u{2793}",  // 0xD3 (323) a159 - ➓
            "\u{2794}",  // 0xD4 (324) a160 - ➔ (arrow)
            "\u{2192}",  // 0xD5 (325) a161 - → (rightward arrow)
            "\u{2194}",  // 0xD6 (326) a163 - ↔
            "\u{2195}",  // 0xD7 (327) a164 - ↕
            "\u{2798}",  // 0xD8 (330) a196 - ➘
            "\u{2799}",  // 0xD9 (331) a165 - ➙
            "\u{279A}",  // 0xDA (332) a192 - ➚
            "\u{279B}",  // 0xDB (333) a166 - ➛
            "\u{279C}",  // 0xDC (334) a167 - ➜
            "\u{279D}",  // 0xDD (335) a168 - ➝
            "\u{279E}",  // 0xDE (336) a169 - ➞
            "\u{279F}",  // 0xDF (337) a170 - ➟

            // 0xE0-0xEF: More arrows
            "\u{27A0}",  // 0xE0 (340) a171 - ➠
            "\u{27A1}",  // 0xE1 (341) a172 - ➡
            "\u{27A2}",  // 0xE2 (342) a173 - ➢
            "\u{27A3}",  // 0xE3 (343) a162 - ➣
            "\u{27A4}",  // 0xE4 (344) a174 - ➤
            "\u{27A5}",  // 0xE5 (345) a175 - ➥
            "\u{27A6}",  // 0xE6 (346) a176 - ➦
            "\u{27A7}",  // 0xE7 (347) a177 - ➧
            "\u{27A8}",  // 0xE8 (350) a178 - ➨
            "\u{27A9}",  // 0xE9 (351) a179 - ➩
            "\u{27AA}",  // 0xEA (352) a193 - ➪
            "\u{27AB}",  // 0xEB (353) a180 - ➫
            "\u{27AC}",  // 0xEC (354) a199 - ➬
            "\u{27AD}",  // 0xED (355) a181 - ➭
            "\u{27AE}",  // 0xEE (356) a200 - ➮
            "\u{27AF}",  // 0xEF (357) a182 - ➯

            // 0xF0-0xFF: Final arrows
            nil,  // 0xF0 undefined
            "\u{27B1}",  // 0xF1 (361) a201 - ➱
            "\u{27B2}",  // 0xF2 (362) a183 - ➲
            "\u{27B3}",  // 0xF3 (363) a184 - ➳
            "\u{27B4}",  // 0xF4 (364) a197 - ➴
            "\u{27B5}",  // 0xF5 (365) a185 - ➵
            "\u{27B6}",  // 0xF6 (366) a194 - ➶
            "\u{27B7}",  // 0xF7 (367) a198 - ➷
            "\u{27B8}",  // 0xF8 (370) a186 - ➸
            "\u{27B9}",  // 0xF9 (371) a195 - ➹
            "\u{27BA}",  // 0xFA (372) a187 - ➺
            "\u{27BB}",  // 0xFB (373) a188 - ➻
            "\u{27BC}",  // 0xFC (374) a189 - ➼
            "\u{27BD}",  // 0xFD (375) a190 - ➽
            "\u{27BE}",  // 0xFE (376) a191 - ➾
            nil,  // 0xFF undefined
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

        /// Encode a Unicode scalar to ZapfDingbatsEncoding byte
        @inlinable
        public static func encode(_ scalar: Unicode.Scalar) -> UInt8? {
            encodeTable[scalar.value]
        }

        /// Decode a ZapfDingbatsEncoding byte to Unicode scalar
        @inlinable
        public static func decode(_ byte: UInt8) -> Unicode.Scalar? {
            decodeTable[Int(byte)]
        }
    }
}
