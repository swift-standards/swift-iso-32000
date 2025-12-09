// ISO_32000.Encoding Tests.swift
// Unit tests for ISO 32000-2:2020 Annex D - Character sets and encodings

import Foundation
import Testing
import ISO_32000_Shared
@testable import ISO_32000_Annex_D

@Suite
struct `ISO_32000.Encoding Tests` {

    // MARK: - WinAnsiEncoding Tests (Table D.2 WIN column)

    @Suite
    struct WinAnsiEncodingTests {

        @Test
        func `Euro sign at 0x80`() {
            // PDF 1.3+ maps 0x80 to Euro sign
            #expect(ISO_32000.WinAnsiEncoding.encode("\u{20AC}") == 0x80)
            #expect(ISO_32000.WinAnsiEncoding.decode(0x80) == "\u{20AC}")
        }

        @Test
        func `Zcaron at 0x8E (PDF 1.3)`() {
            #expect(ISO_32000.WinAnsiEncoding.encode("\u{017D}") == 0x8E)
            #expect(ISO_32000.WinAnsiEncoding.decode(0x8E) == "\u{017D}")
        }

        @Test
        func `zcaron at 0x9E (PDF 1.3)`() {
            #expect(ISO_32000.WinAnsiEncoding.encode("\u{017E}") == 0x9E)
            #expect(ISO_32000.WinAnsiEncoding.decode(0x9E) == "\u{017E}")
        }

        @Test
        func `Bullet at 0x95`() {
            // Note: PDF spec maps to BULLET, not MIDDLE DOT
            #expect(ISO_32000.WinAnsiEncoding.encode("\u{2022}") == 0x95)
            #expect(ISO_32000.WinAnsiEncoding.decode(0x95) == "\u{2022}")
        }

        @Test
        func `ASCII range preserved`() {
            // Standard ASCII printable characters
            #expect(ISO_32000.WinAnsiEncoding.decode(0x20) == " ")
            #expect(ISO_32000.WinAnsiEncoding.decode(0x41) == "A")
            #expect(ISO_32000.WinAnsiEncoding.decode(0x61) == "a")
            #expect(ISO_32000.WinAnsiEncoding.decode(0x7A) == "z")
        }

        @Test
        func `Smart quotes encoding`() {
            #expect(ISO_32000.WinAnsiEncoding.encode("\u{2018}") == 0x91)  // Left single quote
            #expect(ISO_32000.WinAnsiEncoding.encode("\u{2019}") == 0x92)  // Right single quote
            #expect(ISO_32000.WinAnsiEncoding.encode("\u{201C}") == 0x93)  // Left double quote
            #expect(ISO_32000.WinAnsiEncoding.encode("\u{201D}") == 0x94)  // Right double quote
        }

        @Test
        func `Dashes encoding`() {
            #expect(ISO_32000.WinAnsiEncoding.encode("\u{2013}") == 0x96)  // En dash
            #expect(ISO_32000.WinAnsiEncoding.encode("\u{2014}") == 0x97)  // Em dash
        }

        @Test
        func `Trademark symbol`() {
            #expect(ISO_32000.WinAnsiEncoding.encode("\u{2122}") == 0x99)
            #expect(ISO_32000.WinAnsiEncoding.decode(0x99) == "\u{2122}")
        }

        @Test
        func `Undefined bytes return nil`() {
            // Bytes 0x81, 0x8D, 0x8F, 0x90, 0x9D are undefined
            #expect(ISO_32000.WinAnsiEncoding.decode(0x81) == nil)
            #expect(ISO_32000.WinAnsiEncoding.decode(0x8D) == nil)
            #expect(ISO_32000.WinAnsiEncoding.decode(0x8F) == nil)
            #expect(ISO_32000.WinAnsiEncoding.decode(0x90) == nil)
            #expect(ISO_32000.WinAnsiEncoding.decode(0x9D) == nil)
        }

        @Test
        func `Encoding name`() {
            #expect(ISO_32000.WinAnsiEncoding.name == "WinAnsiEncoding")
        }

        @Test
        func `canEncode returns true for encodable scalars`() {
            #expect(ISO_32000.WinAnsiEncoding.canEncode(Unicode.Scalar("A")))
            #expect(ISO_32000.WinAnsiEncoding.canEncode(Unicode.Scalar(0x20AC)!))  // Euro
            #expect(ISO_32000.WinAnsiEncoding.canEncode(Unicode.Scalar(0x00FC)!))  // u with umlaut
        }

        @Test
        func `canEncode returns false for non-encodable scalars`() {
            #expect(!ISO_32000.WinAnsiEncoding.canEncode(Unicode.Scalar(0x4F60)!))  // Chinese character
            #expect(!ISO_32000.WinAnsiEncoding.canEncode(Unicode.Scalar(0x1F389)!))  // Emoji
        }

        @Test
        func `Collection wrapper isValid`() {
            let validBytes: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]  // "Hello"
            #expect(validBytes.winAnsi.isValid)
        }
    }

    // MARK: - PDFDocEncoding Tests (Table D.3)

    @Suite
    struct PDFDocEncodingTests {

        @Test
        func `Euro at 0xA0 differs from WinAnsi`() {
            // PDFDocEncoding has Euro at 160 (0xA0), not NBSP
            #expect(ISO_32000.PDFDocEncoding.decode(0xA0) == "\u{20AC}")
            // WinAnsiEncoding would have NBSP at 160
        }

        @Test
        func `Bullet at 0x80`() {
            // PDFDocEncoding has BULLET at 0x80
            #expect(ISO_32000.PDFDocEncoding.decode(0x80) == "\u{2022}")
        }

        @Test
        func `Diacritics in 0x18-0x1F range`() {
            // Table D.3 puts diacritical marks in bytes 24-31
            #expect(ISO_32000.PDFDocEncoding.decode(0x18) == "\u{02D8}")  // breve
            #expect(ISO_32000.PDFDocEncoding.decode(0x19) == "\u{02C7}")  // caron
            #expect(ISO_32000.PDFDocEncoding.decode(0x1A) == "\u{02C6}")  // circumflex
            #expect(ISO_32000.PDFDocEncoding.decode(0x1B) == "\u{02D9}")  // dotaccent
            #expect(ISO_32000.PDFDocEncoding.decode(0x1C) == "\u{02DD}")  // hungarumlaut
            #expect(ISO_32000.PDFDocEncoding.decode(0x1D) == "\u{02DB}")  // ogonek
            #expect(ISO_32000.PDFDocEncoding.decode(0x1E) == "\u{02DA}")  // ring
            #expect(ISO_32000.PDFDocEncoding.decode(0x1F) == "\u{02DC}")  // tilde
        }

        @Test
        func `Encoding name`() {
            #expect(ISO_32000.PDFDocEncoding.name == "PDFDocEncoding")
        }

        @Test
        func `Complete 256-byte mapping`() {
            // PDFDocEncoding should have all 256 positions defined
            var definedCount = 0
            for byte in 0..<256 {
                if ISO_32000.PDFDocEncoding.decode(UInt8(byte)) != nil {
                    definedCount += 1
                }
            }
            // Most positions should be defined (some control characters may be nil)
            #expect(definedCount > 200)
        }

        @Test
        func `detectEncoding UTF16BE`() {
            let utf16Data = Data([0xFE, 0xFF, 0x00, 0x48])  // BOM + "H"
            let detected = ISO_32000.PDFDocEncoding.detectEncoding(utf16Data)
            #expect(detected == .utf16BE)
        }

        @Test
        func `detectEncoding UTF8`() {
            let utf8Data = Data([0xEF, 0xBB, 0xBF, 0x48])  // BOM + "H"
            let detected = ISO_32000.PDFDocEncoding.detectEncoding(utf8Data)
            #expect(detected == .utf8)
        }

        @Test
        func `detectEncoding PDFDocEncoding`() {
            let pdfDocData = Data([0x48, 0x65, 0x6C, 0x6C, 0x6F])  // "Hello"
            let detected = ISO_32000.PDFDocEncoding.detectEncoding(pdfDocData)
            #expect(detected == .pdfDocEncoding)
        }
    }

    // MARK: - StandardEncoding Tests (Table D.2 STD column)

    @Suite
    struct StandardEncodingTests {

        @Test
        func `Encoding name not predefined`() {
            // Note: PDF processors shall NOT have this as a predefined encoding name
            #expect(ISO_32000.StandardEncoding.name == "StandardEncoding")
        }

        @Test
        func `Quote characters differ from ASCII`() {
            // StandardEncoding maps 0x27 to RIGHT SINGLE QUOTATION MARK, not apostrophe
            #expect(ISO_32000.StandardEncoding.decode(0x27) == "\u{2019}")  // U+2019
            // And 0x60 to LEFT SINGLE QUOTATION MARK, not grave
            #expect(ISO_32000.StandardEncoding.decode(0x60) == "\u{2018}")  // U+2018
        }

        @Test
        func `Ligatures in extended range`() {
            #expect(ISO_32000.StandardEncoding.decode(0xAE) == "\u{FB01}")  // fi
            #expect(ISO_32000.StandardEncoding.decode(0xAF) == "\u{FB02}")  // fl
        }

        @Test
        func `Fraction slash`() {
            #expect(ISO_32000.StandardEncoding.decode(0xA4) == "\u{2044}")  // FRACTION SLASH
        }

        @Test
        func `Em dash`() {
            #expect(ISO_32000.StandardEncoding.decode(0xD0) == "\u{2014}")  // U+2014
        }

        @Test
        func `ASCII letters preserved`() {
            #expect(ISO_32000.StandardEncoding.decode(0x41) == "A")
            #expect(ISO_32000.StandardEncoding.decode(0x5A) == "Z")
            #expect(ISO_32000.StandardEncoding.decode(0x61) == "a")
            #expect(ISO_32000.StandardEncoding.decode(0x7A) == "z")
        }

        @Test
        func `Many positions undefined`() {
            // StandardEncoding leaves many positions undefined
            #expect(ISO_32000.StandardEncoding.decode(0x00) == nil)
            #expect(ISO_32000.StandardEncoding.decode(0x7F) == nil)
            #expect(ISO_32000.StandardEncoding.decode(0x80) == nil)
        }
    }

    // MARK: - MacRomanEncoding Tests (Table D.2 MAC column)

    @Suite
    struct MacRomanEncodingTests {

        @Test
        func `Encoding name`() {
            #expect(ISO_32000.MacRomanEncoding.name == "MacRomanEncoding")
        }

        @Test
        func `Currency symbol at 0xDB not Euro`() {
            // Note 1: PDF maintains original Mac Roman mapping (currency), NOT Apple's later Euro
            #expect(ISO_32000.MacRomanEncoding.decode(0xDB) == "\u{00A4}")  // U+00A4 CURRENCY SIGN
        }

        @Test
        func `Non-breaking space at 0xCA`() {
            // Note 6: Code 312 (0xCA) is NBSP
            #expect(ISO_32000.MacRomanEncoding.decode(0xCA) == "\u{00A0}")  // NBSP
        }

        @Test
        func `Extended ASCII characters`() {
            #expect(ISO_32000.MacRomanEncoding.decode(0x80) == "\u{00C4}")  // A with umlaut
            #expect(ISO_32000.MacRomanEncoding.decode(0x81) == "\u{00C5}")  // A with ring
            #expect(ISO_32000.MacRomanEncoding.decode(0x82) == "\u{00C7}")  // C with cedilla
            #expect(ISO_32000.MacRomanEncoding.decode(0x83) == "\u{00C9}")  // E with acute
        }

        @Test
        func `Ligatures`() {
            #expect(ISO_32000.MacRomanEncoding.decode(0xDE) == "\u{FB01}")  // fi
            #expect(ISO_32000.MacRomanEncoding.decode(0xDF) == "\u{FB02}")  // fl
        }

        @Test
        func `ASCII range preserved`() {
            #expect(ISO_32000.MacRomanEncoding.decode(0x20) == " ")
            #expect(ISO_32000.MacRomanEncoding.decode(0x41) == "A")
            #expect(ISO_32000.MacRomanEncoding.decode(0x7E) == "~")
        }
    }

    // MARK: - MacExpertEncoding Tests (Table D.4)

    @Suite
    struct MacExpertEncodingTests {

        @Test
        func `Encoding name`() {
            #expect(ISO_32000.MacExpertEncoding.name == "MacExpertEncoding")
        }

        @Test
        func `Small capitals`() {
            // Uses Unicode small capital letters
            #expect(ISO_32000.MacExpertEncoding.decode(0x61) == "\u{1D00}")  // Asmall
            #expect(ISO_32000.MacExpertEncoding.decode(0x62) == "\u{0299}")  // Bsmall
            #expect(ISO_32000.MacExpertEncoding.decode(0x63) == "\u{1D04}")  // Csmall
        }

        @Test
        func `Ligatures`() {
            #expect(ISO_32000.MacExpertEncoding.decode(0x56) == "\u{FB00}")  // ff
            #expect(ISO_32000.MacExpertEncoding.decode(0x57) == "\u{FB01}")  // fi
            #expect(ISO_32000.MacExpertEncoding.decode(0x58) == "\u{FB02}")  // fl
            #expect(ISO_32000.MacExpertEncoding.decode(0x59) == "\u{FB03}")  // ffi
            #expect(ISO_32000.MacExpertEncoding.decode(0x5A) == "\u{FB04}")  // ffl
        }

        @Test
        func `Fractions`() {
            #expect(ISO_32000.MacExpertEncoding.decode(0x47) == "\u{00BC}")  // onequarter
            #expect(ISO_32000.MacExpertEncoding.decode(0x48) == "\u{00BD}")  // onehalf
            #expect(ISO_32000.MacExpertEncoding.decode(0x49) == "\u{00BE}")  // threequarters
        }

        @Test
        func `Oldstyle digits`() {
            #expect(ISO_32000.MacExpertEncoding.decode(0x30) == "0")  // zerooldstyle
            #expect(ISO_32000.MacExpertEncoding.decode(0x31) == "1")  // oneoldstyle
            #expect(ISO_32000.MacExpertEncoding.decode(0x39) == "9")  // nineoldstyle
        }

        @Test
        func `Fraction slash`() {
            #expect(ISO_32000.MacExpertEncoding.decode(0x2F) == "\u{2044}")  // FRACTION SLASH
        }
    }

    // MARK: - SymbolEncoding Tests (Table D.5)

    @Suite
    struct SymbolEncodingTests {

        @Test
        func `Encoding name`() {
            #expect(ISO_32000.SymbolEncoding.name == "SymbolEncoding")
        }

        @Test
        func `Greek uppercase letters`() {
            #expect(ISO_32000.SymbolEncoding.decode(0x41) == "\u{0391}")  // Alpha
            #expect(ISO_32000.SymbolEncoding.decode(0x42) == "\u{0392}")  // Beta
            #expect(ISO_32000.SymbolEncoding.decode(0x47) == "\u{0393}")  // Gamma
            #expect(ISO_32000.SymbolEncoding.decode(0x44) == "\u{0394}")  // Delta
            #expect(ISO_32000.SymbolEncoding.decode(0x57) == "\u{03A9}")  // Omega
        }

        @Test
        func `Greek lowercase letters`() {
            #expect(ISO_32000.SymbolEncoding.decode(0x61) == "\u{03B1}")  // alpha
            #expect(ISO_32000.SymbolEncoding.decode(0x62) == "\u{03B2}")  // beta
            #expect(ISO_32000.SymbolEncoding.decode(0x67) == "\u{03B3}")  // gamma
            #expect(ISO_32000.SymbolEncoding.decode(0x64) == "\u{03B4}")  // delta
            #expect(ISO_32000.SymbolEncoding.decode(0x77) == "\u{03C9}")  // omega
        }

        @Test
        func `Mathematical symbols`() {
            #expect(ISO_32000.SymbolEncoding.decode(0xB1) == "\u{00B1}")  // plusminus
            #expect(ISO_32000.SymbolEncoding.decode(0xB4) == "\u{00D7}")  // multiply
            #expect(ISO_32000.SymbolEncoding.decode(0xB8) == "\u{00F7}")  // divide
            #expect(ISO_32000.SymbolEncoding.decode(0xB9) == "\u{2260}")  // notequal
        }

        @Test
        func `Set theory symbols`() {
            #expect(ISO_32000.SymbolEncoding.decode(0xC7) == "\u{2229}")  // intersection
            #expect(ISO_32000.SymbolEncoding.decode(0xC8) == "\u{222A}")  // union
            #expect(ISO_32000.SymbolEncoding.decode(0xCE) == "\u{2208}")  // element
            #expect(ISO_32000.SymbolEncoding.decode(0xCF) == "\u{2209}")  // notelement
        }

        @Test
        func `Logic symbols`() {
            // 0xD9 = logicaland (∧), 0xDB = arrowdblboth (⇔)
            #expect(ISO_32000.SymbolEncoding.decode(0xD9) == "\u{2227}")  // logicaland
            #expect(ISO_32000.SymbolEncoding.decode(0xDB) == "\u{21D4}")  // arrowdblboth / equivalence
        }

        @Test
        func `Pi and infinity`() {
            #expect(ISO_32000.SymbolEncoding.decode(0x70) == "\u{03C0}")  // pi
            #expect(ISO_32000.SymbolEncoding.decode(0xA5) == "\u{221E}")  // infinity
        }

        @Test
        func `Digits preserved`() {
            #expect(ISO_32000.SymbolEncoding.decode(0x30) == "0")
            #expect(ISO_32000.SymbolEncoding.decode(0x39) == "9")
        }
    }

    // MARK: - ZapfDingbatsEncoding Tests (Table D.6)

    @Suite
    struct ZapfDingbatsEncodingTests {

        @Test
        func `Encoding name`() {
            #expect(ISO_32000.ZapfDingbatsEncoding.name == "ZapfDingbatsEncoding")
        }

        @Test
        func `Scissors and pointing hands`() {
            #expect(ISO_32000.ZapfDingbatsEncoding.decode(0x21) == "\u{2701}")  // a1 - scissors
            #expect(ISO_32000.ZapfDingbatsEncoding.decode(0x2A) == "\u{261B}")  // a11 - pointing hand
            #expect(ISO_32000.ZapfDingbatsEncoding.decode(0x2D) == "\u{270D}")  // a14 - writing hand
        }

        @Test
        func `Checkmarks and crosses`() {
            #expect(ISO_32000.ZapfDingbatsEncoding.decode(0x33) == "\u{2713}")  // a19 - check mark
            #expect(ISO_32000.ZapfDingbatsEncoding.decode(0x37) == "\u{2717}")  // a23 - ballot x
        }

        @Test
        func `Stars`() {
            #expect(ISO_32000.ZapfDingbatsEncoding.decode(0x48) == "\u{2605}")  // a35 - black star ★
            #expect(ISO_32000.ZapfDingbatsEncoding.decode(0x49) == "\u{2729}")  // a36 - stress outlined white star ✩
        }

        @Test
        func `Playing card suits`() {
            // Playing card suits are at 0xA8-0xAB per ISO 32000-2 Table D.6
            #expect(ISO_32000.ZapfDingbatsEncoding.decode(0xA8) == "\u{2663}")  // a112 - club ♣
            #expect(ISO_32000.ZapfDingbatsEncoding.decode(0xA9) == "\u{2666}")  // a111 - diamond ♦
            #expect(ISO_32000.ZapfDingbatsEncoding.decode(0xAA) == "\u{2665}")  // a110 - heart ♥
            #expect(ISO_32000.ZapfDingbatsEncoding.decode(0xAB) == "\u{2660}")  // a109 - spade ♠
        }

        @Test
        func `Circled numbers`() {
            // Circled numbers exist in ZapfDingbats
            #expect(ISO_32000.ZapfDingbatsEncoding.decode(0xAC) != nil)  // Should have some characters
        }

        @Test
        func `Arrows`() {
            // Arrow characters per ISO 32000-2 Table D.6
            #expect(ISO_32000.ZapfDingbatsEncoding.decode(0xD4) == "\u{2794}")  // a160 - heavy right arrow ➔
            #expect(ISO_32000.ZapfDingbatsEncoding.decode(0xD5) == "\u{2192}")  // a161 - rightward arrow →
        }

        @Test
        func `Dingbats Unicode block`() {
            // Most ZapfDingbats characters are in Unicode Dingbats block U+2700-U+27BF
            if let scissors = ISO_32000.ZapfDingbatsEncoding.decode(0x21) {
                let value = scissors.value
                #expect(value >= 0x2700 && value <= 0x27BF)
            }
        }
    }

    // MARK: - Cross-Encoding Comparison Tests

    @Suite
    struct CrossEncodingTests {

        @Test
        func `WinAnsi vs PDFDoc Euro position differs`() {
            // WinAnsi: Euro at 0x80
            // PDFDoc: Euro at 0xA0
            #expect(ISO_32000.WinAnsiEncoding.decode(0x80) == "\u{20AC}")
            #expect(ISO_32000.PDFDocEncoding.decode(0xA0) == "\u{20AC}")

            // They differ at these positions
            #expect(ISO_32000.WinAnsiEncoding.decode(0xA0) != ISO_32000.PDFDocEncoding.decode(0xA0))
        }

        @Test
        func `Standard vs WinAnsi quote handling differs`() {
            // StandardEncoding: 0x27 = RIGHT SINGLE QUOTATION MARK
            // WinAnsiEncoding: 0x27 = APOSTROPHE (ASCII)
            #expect(ISO_32000.StandardEncoding.decode(0x27) == "\u{2019}")  // U+2019
            #expect(ISO_32000.WinAnsiEncoding.decode(0x27) == "'")   // U+0027
        }

        @Test
        func `MacRoman vs WinAnsi ligatures at different positions`() {
            // MacRoman: fi at 0xDE, fl at 0xDF
            // WinAnsi: no ligatures (uses separate characters)
            #expect(ISO_32000.MacRomanEncoding.decode(0xDE) == "\u{FB01}")  // fi
            #expect(ISO_32000.WinAnsiEncoding.decode(0xDE) == "\u{00DE}")  // Thorn
        }

        @Test
        func `All encodings have correct names`() {
            #expect(ISO_32000.WinAnsiEncoding.name == "WinAnsiEncoding")
            #expect(ISO_32000.PDFDocEncoding.name == "PDFDocEncoding")
            #expect(ISO_32000.StandardEncoding.name == "StandardEncoding")
            #expect(ISO_32000.MacRomanEncoding.name == "MacRomanEncoding")
            #expect(ISO_32000.MacExpertEncoding.name == "MacExpertEncoding")
            #expect(ISO_32000.SymbolEncoding.name == "SymbolEncoding")
            #expect(ISO_32000.ZapfDingbatsEncoding.name == "ZapfDingbatsEncoding")
        }
    }

    // MARK: - Protocol Conformance Tests

    @Suite
    struct ProtocolConformanceTests {

        @Test
        func `All encodings have decode tables`() {
            #expect(ISO_32000.WinAnsiEncoding.decodeTable.count == 256)
            #expect(ISO_32000.PDFDocEncoding.decodeTable.count == 256)
            #expect(ISO_32000.StandardEncoding.decodeTable.count == 256)
            #expect(ISO_32000.MacRomanEncoding.decodeTable.count == 256)
            #expect(ISO_32000.MacExpertEncoding.decodeTable.count == 256)
            #expect(ISO_32000.SymbolEncoding.decodeTable.count == 256)
            #expect(ISO_32000.ZapfDingbatsEncoding.decodeTable.count == 256)
        }

        @Test
        func `Roundtrip encode-decode for WinAnsi ASCII`() {
            for byte: UInt8 in 0x20...0x7E {
                if let scalar = ISO_32000.WinAnsiEncoding.decode(byte) {
                    let encoded = ISO_32000.WinAnsiEncoding.encode(scalar)
                    #expect(encoded == byte, "Roundtrip failed for byte \(byte)")
                }
            }
        }

        @Test
        func `Scalar encoding extension`() {
            let scalars = "Hello".unicodeScalars
            let encoded = ISO_32000.WinAnsiEncoding.encode(scalars)
            #expect(encoded == [0x48, 0x65, 0x6C, 0x6C, 0x6F])
        }

        @Test
        func `String init from bytes`() {
            let bytes: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]
            let decoded = String(winAnsi: bytes)
            #expect(decoded == "Hello")
        }

        @Test
        func `String init with replacement from bytes`() {
            let bytes: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]
            let decoded = String(winAnsi: bytes, withReplacement: true)
            #expect(decoded == "Hello")
        }
    }
}
