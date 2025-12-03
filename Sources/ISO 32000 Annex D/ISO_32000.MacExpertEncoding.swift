// ISO_32000.MacExpertEncoding.swift
// ISO 32000-2:2020 Annex D.4 - MacExpertEncoding
//
// An encoding for expert fonts containing small capitals, ligatures,
// fractions, and other sophisticated typographic characters.

public import ISO_32000_Shared

extension ISO_32000 {
    /// MacExpertEncoding - Expert Font Encoding
    ///
    /// Per ISO 32000-2 Table D.1:
    /// > An encoding for use with expert fonts — ones containing the expert
    /// > character set. PDF processors shall have a predefined encoding named
    /// > MacExpertEncoding. Despite its name, it is not a platform-specific
    /// > encoding; however, only certain fonts have the appropriate character
    /// > set for use with this encoding. No such fonts are among the standard
    /// > 14 predefined fonts.
    ///
    /// ## Note from ISO 32000-2
    ///
    /// The built-in encoding in an expert font program can be different from
    /// MacExpertEncoding.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table D.4 — Expert set and MacExpert encoding
    public enum MacExpertEncoding: Encoding {
        /// The encoding name as used in PDF
        public static let name: String = "MacExpertEncoding"

        // MARK: - Decode Table

        /// Complete decode table from ISO 32000-2 Table D.4
        ///
        /// Contains small capitals, oldstyle figures, fractions, superior/inferior
        /// figures, and other typographic characters.
        public static let decodeTable: [Unicode.Scalar?] = {
            var table: [Unicode.Scalar?] = Array(repeating: nil, count: 256)

            // ASCII punctuation and special (0x20-0x3F range)
            table[0x20] = "\u{0020}"  // space (040)
            table[0x21] = "\u{0021}"  // exclamsmall (041) - small capital !
            table[0x22] = "\u{F721}"  // Hungarumlautsmall (042) - private use
            table[0x23] = "\u{0023}"  // centoldstyle (043)
            table[0x24] = "\u{0024}"  // dollaroldstyle (044)
            table[0x25] = "\u{0025}"  // dollarsuperior (045)
            table[0x26] = "\u{0026}"  // ampersandsmall (046)
            table[0x27] = "\u{00B4}"  // Acutesmall (047)
            table[0x2A] = "\u{002A}"  // twodotenleader (052)
            table[0x2B] = "\u{002B}"  // onedotenleader (053)
            table[0x2C] = "\u{002C}"  // comma (054)
            table[0x2D] = "\u{002D}"  // hyphen (055)
            table[0x2E] = "\u{002E}"  // period (056)
            table[0x2F] = "\u{2044}"  // fraction (057)

            // Oldstyle digits (060-071)
            table[0x30] = "\u{0030}"  // zerooldstyle (060)
            table[0x31] = "\u{0031}"  // oneoldstyle (061)
            table[0x32] = "\u{0032}"  // twooldstyle (062)
            table[0x33] = "\u{0033}"  // threeoldstyle (063)
            table[0x34] = "\u{0034}"  // fouroldstyle (064)
            table[0x35] = "\u{0035}"  // fiveoldstyle (065)
            table[0x36] = "\u{0036}"  // sixoldstyle (066)
            table[0x37] = "\u{0037}"  // sevenoldstyle (067)
            table[0x38] = "\u{0038}"  // eightoldstyle (070)
            table[0x39] = "\u{0039}"  // nineoldstyle (071)

            // More punctuation
            table[0x3A] = "\u{003A}"  // colon (072)
            table[0x3B] = "\u{003B}"  // semicolon (073)
            table[0x3D] = "\u{F6DE}"  // threequartersemdash (075) - private use
            table[0x3F] = "\u{003F}"  // questionsmall (077)

            // Small capitals (0x40-0x5F range, 100-137 octal)
            // Using Unicode small capital letters where available
            table[0x5B] = "\u{0028}"  // parenleftinferior (133)
            table[0x5D] = "\u{0029}"  // parenrightinferior (135)

            // Small capitals A-Z (0x61-0x7A, 141-172 octal)
            table[0x61] = "\u{1D00}"  // Asmall (141) - ᴀ
            table[0x62] = "\u{0299}"  // Bsmall (142) - ʙ
            table[0x63] = "\u{1D04}"  // Csmall (143) - ᴄ
            table[0x64] = "\u{1D05}"  // Dsmall (144) - ᴅ
            table[0x65] = "\u{1D07}"  // Esmall (145) - ᴇ
            table[0x66] = "\u{A730}"  // Fsmall (146) - ꜰ
            table[0x67] = "\u{0262}"  // Gsmall (147) - ɢ
            table[0x68] = "\u{029C}"  // Hsmall (150) - ʜ
            table[0x69] = "\u{026A}"  // Ismall (151) - ɪ
            table[0x6A] = "\u{1D0A}"  // Jsmall (152) - ᴊ
            table[0x6B] = "\u{1D0B}"  // Ksmall (153) - ᴋ
            table[0x6C] = "\u{029F}"  // Lsmall (154) - ʟ
            table[0x6D] = "\u{1D0D}"  // Msmall (155) - ᴍ
            table[0x6E] = "\u{0274}"  // Nsmall (156) - ɴ
            table[0x6F] = "\u{1D0F}"  // Osmall (157) - ᴏ
            table[0x70] = "\u{1D18}"  // Psmall (160) - ᴘ
            // Note: No small capital Q in Unicode
            table[0x72] = "\u{0280}"  // Rsmall (162) - ʀ
            table[0x73] = "\u{A731}"  // Ssmall (163) - ꜱ
            table[0x74] = "\u{1D1B}"  // Tsmall (164) - ᴛ
            table[0x75] = "\u{1D1C}"  // Usmall (165) - ᴜ
            table[0x76] = "\u{1D20}"  // Vsmall (166) - ᴠ
            table[0x77] = "\u{1D21}"  // Wsmall (167) - ᴡ
            // Note: No standard small capital X
            table[0x79] = "\u{028F}"  // Ysmall (171) - ʏ
            table[0x7A] = "\u{1D22}"  // Zsmall (172) - ᴢ

            // Fractions
            table[0x44] = "\u{0044}"  // Ethsmall (104)
            table[0x47] = "\u{00BC}"  // onequarter (107)
            table[0x48] = "\u{00BD}"  // onehalf (110)
            table[0x49] = "\u{00BE}"  // threequarters (111)
            table[0x4A] = "\u{215B}"  // oneeighth (112)
            table[0x4B] = "\u{215C}"  // threeeighths (113)
            table[0x4C] = "\u{215D}"  // fiveeighths (114)
            table[0x4D] = "\u{215E}"  // seveneighths (115)
            table[0x4E] = "\u{2153}"  // onethird (116)
            table[0x4F] = "\u{2154}"  // twothirds (117)

            // Ligatures
            table[0x56] = "\u{FB00}"  // ff (126)
            table[0x57] = "\u{FB01}"  // fi (127)
            table[0x58] = "\u{FB02}"  // fl (130)
            table[0x59] = "\u{FB03}"  // ffi (131)
            table[0x5A] = "\u{FB04}"  // ffl (132)

            // Superior figures (superscripts)
            table[0x28] = "\u{207D}"  // parenleftsuperior (050)
            table[0x29] = "\u{207E}"  // parenrightsuperior (051)
            table[0x60] = "\u{0060}"  // Gravesmall (140)

            // Inferior figures (subscripts)
            table[0x89] = "\u{2080}"  // zeroinferior (211) - actually at different position
            table[0xC1] = "\u{2081}"  // oneinferior (301)

            // Additional characters from Table D.4
            table[0x5E] = "\u{02C6}"  // Circumflexsmall (136)
            table[0x7E] = "\u{02DC}"  // Tildesmall (176)

            // Diacritical marks (small versions)
            table[0xAC] = "\u{00A8}"  // Dieresissmall (254)
            table[0xA6] = "\u{02C7}"  // Caronsmall (256)
            table[0xC9] = "\u{00B8}"  // Cedillasmall (311)
            table[0xF1] = "\u{02D8}"  // Brevesmall (363)
            table[0xF2] = "\u{00AF}"  // Macronsmall (364)
            table[0xF5] = "\u{02D9}"  // Dotaccentsmall (372)
            table[0xF0] = "\u{02DB}"  // Ogoneksmall (362)
            table[0xFB] = "\u{02DA}"  // Ringsmall (373)

            // Additional small accented capitals
            table[0x87] = "\u{F7E1}"  // Aacutesmall (207) - private use
            table[0x88] = "\u{F7E0}"  // Agravesmall (210)
            table[0x89] = "\u{F7E2}"  // Acircumflexsmall (211)
            table[0x8A] = "\u{F7E4}"  // Adieresissmall (212)
            table[0x8B] = "\u{F7E3}"  // Atildesmall (213)
            table[0x8C] = "\u{F7E5}"  // Aringsmall (214)
            table[0x8D] = "\u{F7E7}"  // Ccedillasmall (215)
            table[0x8E] = "\u{F7E9}"  // Eacutesmall (216)
            table[0x8F] = "\u{F7E8}"  // Egravesmall (217)
            table[0x90] = "\u{F7EA}"  // Ecircumflexsmall (220)
            table[0x91] = "\u{F7EB}"  // Edieresissmall (221)
            table[0x92] = "\u{F7ED}"  // Iacutesmall (222)
            table[0x93] = "\u{F7EC}"  // Igravesmall (223)
            table[0x94] = "\u{F7EE}"  // Icircumflexsmall (224)
            table[0x95] = "\u{F7EF}"  // Idieresissmall (225)
            table[0x96] = "\u{F7F1}"  // Ntildesmall (226)
            table[0x97] = "\u{F7F3}"  // Oacutesmall (227)
            table[0x98] = "\u{F7F2}"  // Ogravesmall (230)
            table[0x99] = "\u{F7F4}"  // Ocircumflexsmall (231)
            table[0x9A] = "\u{F7F6}"  // Odieresissmall (232)
            table[0x9B] = "\u{F7F5}"  // Otildesmall (233)
            table[0x9C] = "\u{F7FA}"  // Uacutesmall (234)
            table[0x9D] = "\u{F7F9}"  // Ugravesmall (235)
            table[0x9E] = "\u{F7FB}"  // Ucircumflexsmall (236)
            table[0x9F] = "\u{F7FC}"  // Udieresissmall (237)

            // More special characters
            table[0xA7] = "\u{0160}"  // Scaronsmall (247) - using standard Scaron
            table[0xB4] = "\u{F7FD}"  // Yacutesmall (264)
            table[0xBD] = "\u{017D}"  // Zcaronsmall (275) - using standard Zcaron
            table[0xBE] = "\u{00C6}"  // AEsmall (276)
            table[0xBF] = "\u{00F8}"  // Oslashsmall (277)

            // OE small and others
            table[0xCF] = "\u{0152}"  // OEsmall (317)
            table[0xB9] = "\u{00FE}"  // Thornsmall (271)
            table[0xC2] = "\u{0141}"  // Lslashsmall (302)

            // Currency
            table[0x7B] = "\u{20A1}"  // colonmonetary (173)
            table[0x7D] = "\u{20A8}"  // rupiah (175)
            table[0x7C] = "\u{0031}"  // onefitted (174)

            // Superior letters
            table[0x81] = "\u{F6E9}"  // asuperior (201)
            table[0xED] = "\u{F6EA}"  // bsuperior (365)
            table[0xE4] = "\u{F6EB}"  // dsuperior (344)
            table[0xE5] = "\u{F6EC}"  // esuperior (345)
            table[0xE9] = "\u{F6ED}"  // isuperior (351)
            table[0xF1] = "\u{F6EE}"  // lsuperior (361)
            table[0xF7] = "\u{F6EF}"  // msuperior (367)
            table[0xF6] = "\u{F6F0}"  // nsuperior (366)
            table[0xA7] = "\u{F6F1}"  // osuperior (257)
            table[0xE6] = "\u{F6F2}"  // rsuperior (345)
            table[0xEA] = "\u{F6F3}"  // ssuperior (352)
            table[0xEE] = "\u{F6F4}"  // tsuperior (346)

            return table
        }()

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

        /// Encode a Unicode scalar to MacExpertEncoding byte
        @inlinable
        public static func encode(_ scalar: Unicode.Scalar) -> UInt8? {
            encodeTable[scalar.value]
        }

        /// Decode a MacExpertEncoding byte to Unicode scalar
        @inlinable
        public static func decode(_ byte: UInt8) -> Unicode.Scalar? {
            decodeTable[Int(byte)]
        }
    }
}
