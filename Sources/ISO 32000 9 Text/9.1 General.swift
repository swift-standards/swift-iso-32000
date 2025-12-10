// ISO 32000-2:2020, 9.1 General

public import ISO_32000_Annex_D
public import ISO_32000_Shared

// 9 Text
// 9.1 General
// This clause describes the special facilities in PDF for dealing with text — specifically, for representing
// characters with glyphs from fonts. A glyph is a graphical shape and is subject to all graphical
// manipulations, such as coordinate transformation. Because of the importance of text in most page
// descriptions, PDF provides higher-level facilities to describe, select, and render glyphs conveniently
// and efficiently.
// The first subclause is a general description of how glyphs from fonts are painted on the page.
// Subsequent subclauses cover these topics in detail:
// Text state. A subset of the graphics state parameters pertain to text, including parameters that select
// the font, scale the glyphs to an appropriate size, and accomplish other graphical effects.
// Text objects and operators. The text operators specify the glyphs to be painted, represented by string
// objects whose values shall be interpreted as sequences of character codes. A text object encloses a
// sequence of text operators and associated parameters.
// Font data structures. Font dictionaries and associated data structures provide information that a PDF
// processor needs to interpret the text and position the glyphs properly. The definitions of the glyphs
// themselves shall be contained in font programs, which may be embedded in the PDF file, built into a
// PDF processor, or obtained from an external font program.

extension ISO_32000 {
    /// A text element combining content bytes with text state.
    ///
    /// Per ISO 32000-2:2020 Section 9.4, a PDF text object consists of operators
    /// that show text strings and set text state parameters. This struct models
    /// the fundamental unit: encoded character bytes plus the text state that
    /// controls how they are rendered.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // From String (encodes to WinAnsi)
    /// let text = ISO_32000.Text("Hello, World!")
    ///
    /// // With custom state
    /// var state = ISO_32000.Text.State()
    /// state.fontSize = 24
    /// let heading = ISO_32000.Text("Heading", state: state)
    ///
    /// // From raw bytes
    /// let raw = ISO_32000.Text(bytes: [0x48, 0x65, 0x6C, 0x6C, 0x6F])
    /// ```
    ///
    /// ## Storage
    ///
    /// Content is stored as `[UInt8]` (encoded bytes), not `String`, because:
    /// - PDF text operators work with byte sequences
    /// - Encoding happens once at construction, not at render time
    /// - Matches the PDF specification model
    public struct Text: Sendable, Equatable, Hashable {
        /// The text content as encoded bytes (typically WinAnsi or UTF-16BE).
        public var content: [UInt8]

        /// The text state parameters controlling rendering.
        public var state: State

        /// Create a text element from a String.
        ///
        /// The string is encoded to WinAnsi. Characters not representable
        /// in WinAnsi are replaced with a fallback character.
        ///
        /// - Parameters:
        ///   - string: The text content.
        ///   - state: Text state parameters. Defaults to initial state.
        public init(_ string: String, state: State = .init()) {
            self.content = [UInt8](winAnsi: string, withFallback: true)
            self.state = state
        }

        /// Create a text element from raw bytes.
        ///
        /// Use this when you have pre-encoded bytes or need precise
        /// control over the byte sequence.
        ///
        /// - Parameters:
        ///   - bytes: The encoded text content.
        ///   - state: Text state parameters. Defaults to initial state.
        public init(bytes: [UInt8], state: State = .init()) {
            self.content = bytes
            self.state = state
        }

        /// The text content as a String, if decodable from WinAnsi.
        ///
        /// Returns `nil` if the bytes cannot be decoded to a valid String.
        public var string: String? {
            String(winAnsi: content)
        }
    }
}
