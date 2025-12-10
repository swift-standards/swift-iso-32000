// ISO 32000-2:2020, 9.3 Text state parameters and operators
//
// Sections:
//   9.3.1  General
//   9.3.2  Character spacing
//   9.3.3  Word spacing
//   9.3.4  Horizontal scaling
//   9.3.5  Leading
//   9.3.6  Text rendering mode
//   9.3.7  Text rise
//   9.3.8  Text knockout

public import ISO_32000_8_Graphics
public import ISO_32000_Shared

extension ISO_32000.`9` {
    /// ISO 32000-2:2020, 9.3 Text state parameters and operators
    public enum `3` {}
}

// MARK: - 9.3.1 Text State

extension ISO_32000.Text {
    /// Text state parameters (Table 102)
    ///
    /// The text state comprises those graphics state parameters that only affect text.
    /// These parameters are consulted when text is positioned and shown.
    ///
    /// Per ISO 32000-2:2020, Section 9.3.1:
    /// > The text state operators may appear outside text objects, and the values
    /// > they set are retained across text objects in a single content stream.
    /// > Like other graphics state parameters, these parameters shall be initialised
    /// > to their default values at the beginning of each page.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 102 — Text state parameters
    public struct State: Sendable, Equatable, Hashable, Codable {
        /// Character spacing (Tc)
        ///
        /// Added to the horizontal or vertical displacement of each glyph.
        /// Expressed in unscaled text space units.
        ///
        /// Initial value: 0
        public var characterSpacing: ISO_32000.UserSpace.Unit

        /// Word spacing (Tw)
        ///
        /// Applied only to ASCII SPACE (0x20).
        /// Expressed in unscaled text space units.
        ///
        /// Initial value: 0
        public var wordSpacing: ISO_32000.UserSpace.Unit

        /// Horizontal scaling (Th)
        ///
        /// Percentage of normal width (100 = normal).
        /// Affects glyph shape and horizontal displacement.
        ///
        /// Initial value: 100
        public var horizontalScaling: ISO_32000.UserSpace.Unit

        /// Leading (Tl)
        ///
        /// Vertical distance between baselines of adjacent lines.
        /// Expressed in unscaled text space units.
        /// Used by T*, ', and " operators.
        ///
        /// Initial value: 0
        public var leading: ISO_32000.UserSpace.Unit

        /// Text font reference (Tf)
        ///
        /// Reference to the font resource. Must be set before showing text.
        ///
        /// Initial value: none (must be set explicitly)
        public var font: Font.Reference?

        /// Text font size (Tfs)
        ///
        /// Scale factor for the font.
        /// Note: Negative font size is permitted per spec.
        ///
        /// Initial value: none (must be set explicitly)
        public var fontSize: ISO_32000.UserSpace.Unit?

        /// Text rendering mode (Tmode)
        ///
        /// Determines whether text is filled, stroked, clipped, or invisible.
        ///
        /// Initial value: 0 (fill)
        public var renderingMode: Rendering.Mode

        /// Text rise (Trise)
        ///
        /// Distance to move baseline up (positive) or down (negative).
        /// Useful for superscripts and subscripts.
        /// Expressed in unscaled text space units.
        ///
        /// Initial value: 0
        public var rise: ISO_32000.UserSpace.Unit

        /// Text knockout (Tk)
        ///
        /// Determines compositing behavior for overlapping glyphs.
        /// Set via TK entry in graphics state parameter dictionary.
        ///
        /// Initial value: true
        public var knockout: Bool

        public init(
            characterSpacing: ISO_32000.UserSpace.Unit = 0,
            wordSpacing: ISO_32000.UserSpace.Unit = 0,
            horizontalScaling: ISO_32000.UserSpace.Unit = 100,
            leading: ISO_32000.UserSpace.Unit = 0,
            font: Font.Reference? = nil,
            fontSize: ISO_32000.UserSpace.Unit? = nil,
            renderingMode: Rendering.Mode = .fill,
            rise: ISO_32000.UserSpace.Unit = 0,
            knockout: Bool = true
        ) {
            self.characterSpacing = characterSpacing
            self.wordSpacing = wordSpacing
            self.horizontalScaling = horizontalScaling
            self.leading = leading
            self.font = font
            self.fontSize = fontSize
            self.renderingMode = renderingMode
            self.rise = rise
            self.knockout = knockout
        }

        /// Horizontal scaling as a multiplier (Th / 100)
        @inlinable
        public var horizontalScalingFactor: Double {
            horizontalScaling.value / 100.0
        }
    }
}

// MARK: - Font Reference

extension ISO_32000.Text {
    /// Font namespace
    public enum Font {}
}

extension ISO_32000.Text.Font {
    /// A reference to a font resource
    ///
    /// References a font by its resource name as used in the page's
    /// Font subdictionary.
    public struct Reference: Sendable, Equatable, Hashable, Codable {
        /// The font resource name (e.g., "F1", "F2")
        public var name: String

        /// Create a font reference
        ///
        /// - Parameter name: The font resource name
        public init(name: String) {
            self.name = name
        }
    }
}

// MARK: - 9.3.6 Text Rendering Mode

extension ISO_32000.Text {
    /// Rendering namespace
    public enum Rendering {}
}

extension ISO_32000.Text.Rendering {
    /// Text rendering modes (Table 104)
    ///
    /// Determines whether showing text causes glyph outlines to be
    /// stroked, filled, used as a clipping boundary, or some combination.
    ///
    /// Per ISO 32000-2:2020, Section 9.3.6:
    /// > If the text rendering mode calls for filling, the current nonstroking
    /// > colour in the graphics state shall be used; if it calls for stroking,
    /// > the current stroking colour shall be used.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 104 — Text rendering modes
    public enum Mode: Int, Sendable, Equatable, Hashable, Codable, CaseIterable {
        /// Fill text (mode 0)
        case fill = 0

        /// Stroke text (mode 1)
        case stroke = 1

        /// Fill, then stroke text (mode 2)
        case fillStroke = 2

        /// Neither fill nor stroke text — invisible (mode 3)
        case invisible = 3

        /// Fill text and add to path for clipping (mode 4)
        case fillClip = 4

        /// Stroke text and add to path for clipping (mode 5)
        case strokeClip = 5

        /// Fill, then stroke text and add to path for clipping (mode 6)
        case fillStrokeClip = 6

        /// Add text to path for clipping (mode 7)
        case clip = 7

        /// Whether this mode fills the glyph outlines
        public var fills: Bool {
            switch self {
            case .fill, .fillStroke, .fillClip, .fillStrokeClip:
                true
            case .stroke, .invisible, .strokeClip, .clip:
                false
            }
        }

        /// Whether this mode strokes the glyph outlines
        public var strokes: Bool {
            switch self {
            case .stroke, .fillStroke, .strokeClip, .fillStrokeClip:
                true
            case .fill, .invisible, .fillClip, .clip:
                false
            }
        }

        /// Whether this mode adds to the clipping path
        public var clips: Bool {
            switch self {
            case .fillClip, .strokeClip, .fillStrokeClip, .clip:
                true
            case .fill, .stroke, .fillStroke, .invisible:
                false
            }
        }

        /// Whether this mode renders anything visible
        public var isVisible: Bool {
            self != .invisible && self != .clip
        }
    }
}

// MARK: - Section Typealiases

extension ISO_32000.`9`.`3` {
    /// Text state parameters (Table 102)
    public typealias State = ISO_32000.Text.State

    /// Text rendering mode (Table 104)
    public typealias RenderingMode = ISO_32000.Text.Rendering.Mode
}

// 9.3 Text state parameters and operators
// 9.3.1 General
// The text state comprises those graphics state parameters that only affect text. There are nine
// parameters in the text state (see "Table 102 — Text state parameters").
// Table 102 — Text state parameters
// Parameter Description
// T
// c Character spacing
// T
// w Word spacing
// Th Horizontal scaling
// Tl Leading
// Tf Text font
// Tfs Text font size
// Tmode Text rendering mode
// Trise Text rise
// Tk Text knockout
// Except for the previously described Tf and Tfs, these parameters are discussed further in subsequent
// subclauses. (As described in 9.4, "Text objects", three additional text-related parameters may occur
// only within a text object: Tm, the text matrix; Tlm, the text line matrix; and Trm, the text rendering
// matrix.) The values of the text state parameters shall be consulted when text is positioned and shown
// (using the operators described in 9.4.2, "Text-positioning operators" and 9.4.3, "Text-showing
// operators"). In particular, the spacing and scaling parameters shall be used in a computation described
// in 9.4.4, "Text space details". The text state parameters may be set using the operators listed in "Table
// 300 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// 103 — Text state operators"
// . All text state parameters shall apply to Type 3 fonts unless otherwise
// stated.
// NOTE Negative text font size is permitted.
// The text knockout parameter, Tk, shall be set through the TK entry in a graphics state parameter
// dictionary by using the gs operator (see 8.4.5, "Graphics state parameter dictionaries"). There is no
// specific operator for setting this parameter.
// The text state operators may appear outside text objects, and the values they set are retained across
// text objects in a single content stream. Like other graphics state parameters, these parameters shall be
// initialised to their default values at the beginning of each page.
// Table 103 — Text state operators
// Operands Operator Description
// charSpace Tc Set the character spacing, T
// c, to charSpace, which shall be a number
// expressed in unscaled text space units. Character spacing shall be used by
// the Tj, TJ, and ' operators. Initial value: 0.
// wordSpace Tw Set the word spacing, Tw, to wordSpace, which shall be a number
// expressed in unscaled text space units. Word spacing shall be used by the
// Tj, TJ, and ' operators. Initial value: 0.
// scale Tz Set the horizontal scaling, Th, to (scale ÷ 100). scale shall be a number
// specifying the percentage of the normal width. Initial value: 100 (normal
// width).
// leading TL Set the text leading, Tl, to leading, which shall be a number expressed in
// unscaled text space units. Text leading shall be used only by the T*
// ,
// ', and "
// operators. Initial value: 0.
// font size Tf Set the text font, Tf, to font and the text font size, Tfs, to size. font shall be
// the name of a font resource in the Font subdictionary of the current
// resource dictionary; size shall be a number representing a scale factor.
// There is no initial value for either font or size; they shall be specified
// explicitly by using Tf before any text is shown. Zero sized text shall not
// mark or clip any pixels (depending on text render mode).
// render Tr Set the text rendering mode, Tmode, to render, which shall be an integer.
// Initial value: 0.
// rise Ts Set the text rise, Trise, to rise, which shall be a number expressed in
// unscaled text space units. Initial value: 0.
// Some of these parameters are expressed in unscaled text space units. This means that they shall be
// specified in a coordinate system that shall be defined by the text matrix, Tm but shall not be scaled by
// the font size parameter, Tfs .
// 9.3.2 Character spacing
// The character-spacing parameter, T
// c, shall be a number specified in unscaled text space units (although
// © ISO 2020 – All rights reserved 301
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// it shall be subject to scaling by the Th parameter if the writing mode is horizontal). When the glyph for
// each character in the string is rendered, T
// c shall be added to the horizontal or vertical component of the
// glyph’s displacement, depending on the writing mode. See 9.2.4, "Glyph positioning and metrics", for a
// discussion of glyph displacements. In the default coordinate system, horizontal coordinates increase
// from left to right and vertical coordinates from bottom to top. Therefore, for horizontal writing, a
// positive value of T
// c has the effect of expanding the distance between glyphs (see "Figure 56 —
// Character spacing in horizontal writing"), whereas for vertical writing, a negative value of T
// has this
// c
// effect.
// Figure 56 — Character spacing in horizontal writing
// 9.3.3 Word spacing
// Word spacing works the same way as character spacing but shall apply only to the ASCII SPACE
// character (20h). The word-spacing parameter, T
// w, shall be added to the glyph’s horizontal or vertical
// displacement (depending on the writing mode). For horizontal writing, a positive value for T
// has the
// w
// effect of increasing the spacing between words. For vertical writing, a positive value for T
// decreases
// w
// the spacing between words (and a negative value increases it), since vertical coordinates increase from
// bottom to top. "Figure 57 — Word spacing in horizontal writing" illustrates the effect of word spacing
// in horizontal writing.
// Figure 57 — Word spacing in horizontal writing
// Word spacing shall be applied to every occurrence of the single-byte character code 32 in a string
// when using a simple font (including Type 3) or a composite font that defines code 32 as a single-byte
// code. It shall not apply to occurrences of the byte value 32 in multiple-byte codes.
// 9.3.4 Horizontal scaling
// The horizontal scaling parameter, Th, adjusts the width of glyphs by stretching or compressing them in
// the horizontal direction. Its value shall be specified as a percentage of the normal width of the glyphs,
// with 100 being the normal width. The scaling shall apply to the horizontal coordinate in text space,
// 302 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// independently of the writing mode. It shall affect both the glyph’s shape and its horizontal
// displacement (that is, its displacement vector). If the writing mode is horizontal, it shall also affect the
// spacing parameters T
// and T
// c
// w, as well as any positioning adjustments performed by the TJ operator.
// "Figure 58 — Horizontal scaling" shows the effect of horizontal scaling.
// Figure 58 — Horizontal scaling
// 9.3.5 Leading
// The leading parameter, Tl, shall be specified in unscaled text space units. It specifies the vertical
// distance between the baselines of adjacent lines of text, as shown in "Figure 59 — Leading"
// .
// Figure 59 — Leading
// The leading parameter shall be used by the TD, T*,
// ', and " operators; see "Table 106 — Text-
// positioning operators" for a precise description of its effects. This parameter shall apply to the vertical
// coordinate in text space, independently of the writing mode.
// 9.3.6 Text rendering mode
// The text rendering mode, Tmode, determines whether showing text shall cause glyph outlines to be
// stroked, filled, used as a clipping boundary, or some combination of the three. Stroking, filling, and
// clipping shall have the same effects for a text object as they do for a path object (see 8.5.3, "Path-
// painting operators" and 8.5.4, "Clipping path operators"), although they are specified in an entirely
// different way. The graphics state parameters affecting those operations, such as line width, shall be
// interpreted in user space rather than in text space.
// NOTE 1 The text rendering modes are shown in "Table 104 — Text rendering modes". In the examples, a
// stroke colour of black and a fill colour of light gray are used. For the clipping modes (4 to 7), a
// series of lines has been drawn through the glyphs to show where the clipping occurs.
// If the text rendering mode calls for filling, the current nonstroking colour in the graphics state shall be
// used; if it calls for stroking, the current stroking colour shall be used. In modes that perform both filling
// and stroking, the effect shall be as if each glyph outline were filled and then stroked in separate
// operations. If any of the glyphs overlap, the result shall be equivalent to filling and stroking them one at
// © ISO 2020 – All rights reserved 303
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// a time, producing the appearance of stacked opaque glyphs, rather than first filling and then stroking
// them all at once. In the transparent imaging model, these combined filling and stroking modes shall be
// subject to further considerations; see 11.7.4.4, "Special path-painting considerations"
// .
// The behaviour of the clipping modes requires further explanation. Glyph outlines shall begin
// accumulating if a BT operator is executed while the text rendering mode is set to a clipping mode or if
// it is set to a clipping mode within a text object. Glyphs shall accumulate until the text object is ended by
// an ET operator; the text rendering mode shall not be changed back to a nonclipping mode before that
// point.
// Table 104 — Text rendering modes
// Mode Example Description
// 0 Fill text.
// 1 Stroke text.
// 2 Fill, then stroke text.
// 3 Neither fill nor stroke text (invisible).
// 4 Fill text and add to path for clipping.
// 5 Stroke text and add to path for clipping.
// 6 Fill, then stroke text and add to path for
// clipping.
// 7 Add text to path for clipping.
// At the end of the text object identified by the ET operator the accumulated glyph outlines, if any, shall
// be combined into a single path, treating the individual outlines as subpaths of that path and applying
// the non-zero winding number rule (see 8.5.3.3.2, "Non-zero winding number rule"). The current
// clipping path in the graphics state shall be set to the intersection of this path with the previous clipping
// path. As is the case for path objects, this clipping shall occur after all filling and stroking operations for
// the text object have occurred. It remains in effect until a previous clipping path is restored by an
// invocation of the Q operator.
// NOTE 2 Due to the use of non-zero winding number rule, the direction of the paths comprising each
// glyph can cause different output for overlapping glyphs.
// If no glyphs are shown or if the only glyphs shown have no outlines (for example, if they are ASCII
// SPACE characters (20h)), no clipping shall occur.
// 304 © ISO 2020 – All rights reserved
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// NOTE 3 Certain degenerate glyph sub-paths that are not visible when filled can become apparent when
// stroking, e.g., a zero line with round end caps will paint a circle according to the current stroke
// width.
// The e and f components of Tm shall be updated for each glyph drawn when using text rendering mode
// 3 or 7 in exactly the same way as would be done for other text rendering modes.
// Where text is drawn using a Type 3 font:
// • if text rendering mode is set to a value of 3 or 7, the text shall not be rendered.
// • if text rendering mode is set to a value other than 3 or 7, the text shall be rendered using the glyph
// descriptions in the Type 3 font.
// • If text rendering mode is set to a value of 4, 5, 6 or 7, nothing shall be added to the clipping path.
// 9.3.7 Text rise
// Text rise, Trise, shall specify the distance, in unscaled text space units, to move the baseline up or down
// from its default location. Positive values of text rise shall move the baseline up. "Figure 60 — Text rise"
// illustrates the effect of the text rise. Text rise shall apply to the vertical coordinate in text space,
// regardless of the writing mode.
// NOTE Adjustments to the baseline are useful for drawing superscripts or subscripts. The default
// location of the baseline can be restored by setting the text rise to 0.
// Figure 60 — Text rise
// 9.3.8 Text knockout
// The text knockout parameter, Tk (PDF 1.4), shall be a boolean value that determines what text elements
// shall be considered elementary objects for purposes of colour compositing in the transparent imaging
// model. Unlike other text state parameters, there is no specific operator for setting this parameter; it
// may be set only through the TK entry in a graphics state parameter dictionary by using the gs operator
// (see 8.4.5, "Graphics state parameter dictionaries"). The text knockout parameter shall apply only to
// entire text objects. Any TK value in a graphics state parameter dictionary installed using the gs
// operator shall be ignored between the BT and ET operators delimiting a text object. The text knockout
// parameter controls the behaviour of glyphs obtained from any font type, including Type 3. Its initial
// © ISO 2020 – All rights reserved 305
// Sold by the PDF Association to 17781 | December 3, 2025 |
// Single user only, copying and networking prohibited.
// ISO 32000-2:2020(E)
// value shall be true. If the parameter is false, each glyph in a text object shall be treated as a separate
// elementary object; when glyphs overlap, they shall composite with one another.
// If the parameter is true, the behaviour shall be equivalent to treating the entire text object as if it were
// a non-isolated knockout transparency group; see 11.4.6, "Knockout groups" where each glyph is an
// individual element in that group’s transparency stack. When glyphs overlap, later glyphs shall
// overwrite ("knock out") earlier ones in the area of overlap. The following additional rules shall apply:
// • Graphics state parameters, including transparency parameters, shall be inherited from the
// context in which the text object appears. They shall not be saved and restored. The transparency
// parameters shall not be reset at the beginning of the transparency group (as they are when a
// transparency group XObject is explicitly invoked). Changes made to graphics state parameters
// within the text object shall persist beyond the end of the text object.
// • After the implicit transparency group for the text object has been completely evaluated, the group
// results shall be composited with the backdrop, using the Normal blend mode and alpha and soft
// mask values of 1.0.
// NOTE With the above listed exceptions, the compositing described in 11.4.6, "Knockout groups" applies
// when the text knockout graphics parameter is true including the handling of masks.
// #imageLiteral(resourceName: "Screenshot 2025-12-09 at 14.58.56.png")
// #imageLiteral(resourceName: "Screenshot 2025-12-09 at 14.59.14.png")
