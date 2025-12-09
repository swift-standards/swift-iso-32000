// ISO 32000-2:2020, 9.4 Text objects
//
// Sections:
//   9.4.1  General
//   9.4.2  Text-positioning operators
//   9.4.3  Text-showing operators
//   9.4.4  Text space details

public import ISO_32000_Shared

extension ISO_32000.`9` {
    /// ISO 32000-2:2020, 9.4 Text objects
    public enum `4` {}
}

// MARK: - 9.4.1 Text Matrix

extension ISO_32000.`9`.`4` {
    /// Text matrix (Tm) and text line matrix (Tlm)
    ///
    /// A 3×3 transformation matrix stored as 6 values (a, b, c, d, e, f).
    /// The third column is always [0, 0, 1].
    ///
    /// Per ISO 32000-2:2020, Section 9.4.1:
    /// > A text object begins with the BT operator and ends with the ET operator.
    /// > At the beginning of a text object, Tm shall be the identity matrix.
    ///
    /// The matrix represents:
    /// ```
    /// | a  b  0 |
    /// | c  d  0 |
    /// | e  f  1 |
    /// ```
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 9.4.2 — Text-positioning operators
    public struct Matrix: Sendable, Hashable {
        /// Horizontal scaling component
        public var a: Double

        /// Vertical shearing component
        public var b: Double

        /// Horizontal shearing component
        public var c: Double

        /// Vertical scaling component
        public var d: Double

        /// Horizontal translation (x position)
        public var e: Double

        /// Vertical translation (y position)
        public var f: Double

        /// Create a text matrix with explicit values
        ///
        /// - Parameters:
        ///   - a: Horizontal scaling (default 1)
        ///   - b: Vertical shearing (default 0)
        ///   - c: Horizontal shearing (default 0)
        ///   - d: Vertical scaling (default 1)
        ///   - e: Horizontal translation (default 0)
        ///   - f: Vertical translation (default 0)
        public init(
            a: Double = 1, b: Double = 0,
            c: Double = 0, d: Double = 1,
            e: Double = 0, f: Double = 0
        ) {
            self.a = a
            self.b = b
            self.c = c
            self.d = d
            self.e = e
            self.f = f
        }

        /// The identity matrix [1 0 0 1 0 0]
        public static let identity = Matrix()

        /// Create a translation matrix
        ///
        /// - Parameters:
        ///   - tx: Horizontal translation
        ///   - ty: Vertical translation
        /// - Returns: A translation matrix
        public static func translation(tx: Double, ty: Double) -> Matrix {
            Matrix(a: 1, b: 0, c: 0, d: 1, e: tx, f: ty)
        }

        /// Create a scaling matrix
        ///
        /// - Parameters:
        ///   - sx: Horizontal scale factor
        ///   - sy: Vertical scale factor
        /// - Returns: A scaling matrix
        public static func scaling(sx: Double, sy: Double) -> Matrix {
            Matrix(a: sx, b: 0, c: 0, d: sy, e: 0, f: 0)
        }

        /// Concatenate two matrices (lhs × rhs)
        ///
        /// - Parameters:
        ///   - lhs: Left matrix
        ///   - rhs: Right matrix
        /// - Returns: The resulting matrix
        public static func concatenating(_ lhs: Matrix, _ rhs: Matrix) -> Matrix {
            Matrix(
                a: lhs.a * rhs.a + lhs.b * rhs.c,
                b: lhs.a * rhs.b + lhs.b * rhs.d,
                c: lhs.c * rhs.a + lhs.d * rhs.c,
                d: lhs.c * rhs.b + lhs.d * rhs.d,
                e: lhs.e * rhs.a + lhs.f * rhs.c + rhs.e,
                f: lhs.e * rhs.b + lhs.f * rhs.d + rhs.f
            )
        }

        /// Apply the Td operator: move to next line offset by (tx, ty)
        ///
        /// Per ISO 32000-2:2020, Section 9.4.2 (Td operator):
        /// > Tm = Tlm = [1 0 0; 0 1 0; tx ty 1] × Tlm
        ///
        /// - Parameters:
        ///   - tx: Horizontal offset
        ///   - ty: Vertical offset
        ///   - lineMatrix: The current text line matrix (Tlm)
        /// - Returns: The new text matrix (also becomes new Tlm)
        public static func td(tx: Double, ty: Double, lineMatrix: Matrix) -> Matrix {
            .concatenating(.translation(tx: tx, ty: ty), lineMatrix)
        }

        /// Compute the text rendering matrix (Trm)
        ///
        /// The complete transformation from text space to device space.
        ///
        /// Per ISO 32000-2:2020, Section 9.4.4:
        /// > Trm = [Tfs×Th  0      0  ]
        /// >       [0       Tfs    0  ] × Tm × CTM
        /// >       [0       Trise  1  ]
        ///
        /// - Parameters:
        ///   - textMatrix: Current text matrix (Tm)
        ///   - fontSize: Text font size (Tfs)
        ///   - horizontalScaling: Horizontal scaling as percentage (Th)
        ///   - rise: Text rise (Trise)
        ///   - ctm: Current transformation matrix (CTM)
        /// - Returns: The text rendering matrix (Trm)
        ///
        /// ## Reference
        ///
        /// ISO 32000-2:2020, Section 9.4.4 — Text space details
        public static func rendering(
            textMatrix: Matrix,
            fontSize: Double,
            horizontalScaling: Double,
            rise: Double,
            ctm: Matrix
        ) -> Matrix {
            let th = horizontalScaling / 100.0

            // Build the font size/scaling matrix
            let fontMatrix = Matrix(
                a: fontSize * th, b: 0,
                c: 0, d: fontSize,
                e: 0, f: rise
            )

            // Concatenate: fontMatrix × Tm × CTM
            return .concatenating(.concatenating(fontMatrix, textMatrix), ctm)
        }
    }
}

// MARK: - 9.4.4 Glyph Displacement

extension ISO_32000.`9`.`4` {
    /// Glyph displacement calculation
    ///
    /// Per ISO 32000-2:2020, Section 9.4.4:
    /// > tx = ((w0 - Tj/1000) × Tfs + Tc + Tw) × Th
    /// > ty = (w1 - Tj/1000) × Tfs + Tc + Tw
    ///
    /// where:
    /// - w0, w1: glyph's horizontal and vertical displacements
    /// - Tj: position adjustment from TJ array (if any)
    /// - Tfs: text font size
    /// - Th: horizontal scaling
    /// - Tc: character spacing
    /// - Tw: word spacing (only for space character)
    public enum Displacement {
        /// Calculate horizontal displacement for a glyph
        ///
        /// - Parameters:
        ///   - glyphWidth: The glyph's width (w0) in text space units
        ///   - adjustment: Position adjustment from TJ array (in thousandths)
        ///   - fontSize: Text font size (Tfs)
        ///   - characterSpacing: Character spacing (Tc)
        ///   - wordSpacing: Word spacing (Tw), applied only for space
        ///   - horizontalScaling: Horizontal scaling percentage (Th)
        ///   - isSpace: Whether this is a space character (0x20)
        /// - Returns: The horizontal displacement (tx)
        public static func horizontal(
            glyphWidth: Double,
            adjustment: Double = 0,
            fontSize: Double,
            characterSpacing: Double,
            wordSpacing: Double,
            horizontalScaling: Double,
            isSpace: Bool
        ) -> Double {
            let th = horizontalScaling / 100.0
            let tw = isSpace ? wordSpacing : 0
            return ((glyphWidth - adjustment / 1000.0) * fontSize + characterSpacing + tw) * th
        }

        /// Calculate vertical displacement for a glyph (vertical writing mode)
        ///
        /// - Parameters:
        ///   - glyphHeight: The glyph's height (w1) in text space units
        ///   - adjustment: Position adjustment from TJ array (in thousandths)
        ///   - fontSize: Text font size (Tfs)
        ///   - characterSpacing: Character spacing (Tc)
        ///   - wordSpacing: Word spacing (Tw), applied only for space
        ///   - isSpace: Whether this is a space character (0x20)
        /// - Returns: The vertical displacement (ty)
        public static func vertical(
            glyphHeight: Double,
            adjustment: Double = 0,
            fontSize: Double,
            characterSpacing: Double,
            wordSpacing: Double,
            isSpace: Bool
        ) -> Double {
            let tw = isSpace ? wordSpacing : 0
            return (glyphHeight - adjustment / 1000.0) * fontSize + characterSpacing + tw
        }
    }
}

// MARK: - TJ Array Element

extension ISO_32000.`9`.`4` {
    /// Element in a TJ array
    ///
    /// Per ISO 32000-2:2020, Table 107 (TJ operator):
    /// > Each element of array shall be either a string or a number.
    /// > If the element is a string, this operator shall show the string.
    /// > If it is a number, the operator shall adjust the text position.
    ///
    /// The number is expressed in thousandths of a unit of text space
    /// and is subtracted from the current position.
    public enum TJElement: Sendable {
        /// A text string to show (bytes, not decoded)
        case string([UInt8])

        /// A position adjustment in thousandths of text space unit
        ///
        /// Positive values move left (horizontal) or down (vertical).
        case adjustment(Double)
    }
}

// MARK: - Convenience Typealiases

extension ISO_32000.Text {
    /// Text matrix
    public typealias Matrix = ISO_32000.`9`.`4`.Matrix

    /// TJ array element
    public typealias TJElement = ISO_32000.`9`.`4`.TJElement
}


//9.4 Text objects
//9.4.1 General
//A PDF text object consists of operators that may show text strings, move the text position, and set text
//state and certain other parameters. In addition, three parameters may be specified only within a text
//object and shall not persist from one text object to the next:
//• Tm, the text matrix.
//• Tlm, the text line matrix.
//• Trm, the text rendering matrix, which is actually just an intermediate result that combines the
//effects of text state parameters, the text matrix (Tm), and the current transformation matrix.
//A text object begins with the BT operator and ends with the ET operator, as shown in the Example, and
//described in "Table 105 — Text object operators"
//.
//NOTE Although text objects cannot be statically nested, text can be shown using a Type 3 font whose
//glyph descriptions include any graphics objects, including another text object. Likewise, the
//current colour can be a tiling pattern whose pattern cell includes a text object.
//EXAMPLE
//BT
//ET
//…Zero or more text operators or other allowed operators…
//Table 105 — Text object operators
//Operands Operator Description
//— BT Begin a text object, initializing the text matrix, Tm, and the text line
//matrix, Tlm, to the identity matrix. Text objects shall not be nested;
//a second BT shall not appear before an ET.
//306 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Operands Operator Description
//— ET End a text object, discarding the text matrix.
//These specific categories of text-related operators may appear in a text object:
//• Text state operators, described in 9.3, "Text state parameters and operators"
//.
//• Text-positioning operators, described in 9.4.2, "Text-positioning operators"
//.
//• Text-showing operators, described in 9.4.3, "Text-showing operators"
//.
//The latter two subclauses also provide further details about these text object parameters. The other
//operators that may appear in a text object are those related to the general graphics state, colour, and
//marked-content, as shown in "Figure 9 — Graphics objects"
//.
//When the graphics state stack operators q and Q (see 8.4.2, "Graphics state stack") are combined with
//the text object operators BT and ET, each pair of matching operators (q … Q) shall be properly
//(separately) nested. Therefore, the sequences
//q
//BT
//…
//ET
//Q
//and
//BT
//q
//…
//Q
//ET
//are valid, but
//q
//BT
//…
//Q
//ET
//and
//BT
//q
//…
//ET
//Q
//are not valid.
//NOTE The above paragraph and example sequences were added in this document (2020).
//9.4.2 Text-positioning operators
//Text space is the coordinate system in which text is shown. It shall be defined by the text matrix, Tm,
//and the text state parameters Tfs, Th, and Trise, which together shall determine the transformation from
//text space to user space. Specifically, the origin of the first glyph shown by a text-showing operator
//shall be placed at the origin of text space. If text space has been translated, scaled, or rotated, then the
//position, size, or orientation of the glyph in user space shall be correspondingly altered.
//© ISO 2020 – All rights reserved 307
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//The text-positioning operators shall only appear within text objects.
//Table 106 — Text-positioning operators
//Operands Operator Description
//tx ty Td Move to the start of the next line, offset from the start of the
//current line by (tx, ty). tx and ty shall denote numbers
//expressed in unscaled text space units. More precisely, this
//operator shall perform these assignments:
//𝑇𝑚
//0 1 0
//= 𝑇𝑙𝑚 = [ 1 0 0
//𝑡𝑥 𝑡𝑦 1] × 𝑇𝑙𝑚
//tx ty TD Move to the start of the next line, offset from the start of the
//current line by (tx, ty). As a side effect, this operator shall set
//the leading parameter in the text state. This operator shall
//have the same effect as this code:
//-ty TL
//tx ty Td
//a b c d e f Tm Set the text matrix, Tm, and the text line matrix, Tlm:
//𝑐 𝑑 0
//𝑇 𝑚 = 𝑇𝑙𝑚 = [𝑎 𝑏 0
//𝑒 𝑓 1]
//The operands shall all be numbers, and the initial value for
//Tm and Tlm shall be the identity matrix, [1 0 0 1 0 0].
//Although the operands specify a matrix, they shall be passed
//to Tm as six separate numbers, not as an array.
//The matrix specified by the operands shall not be
//concatenated onto the current text matrix, but shall replace
//it.
//— T* Move to the start of the next line. This operator has the same
//effect as the code
//0 –Tl TD
//where Tl denotes the current leading parameter in the text
//state. The negative of Tl is used here because Tl is the text
//leading expressed as a positive number. Going to the next
//line entails decreasing the y coordinate.
//At the beginning of a text object, Tm shall be the identity matrix; therefore, the origin of text space shall
//be initially the same as that of user space. The text-positioning operators, described in "Table 106 —
//Text-positioning operators" alter Tm and thereby control the placement of glyphs that are subsequently
//painted. Also, the text-showing operators, described in "Table 107 — Text-showing operators", update
//Tm (by altering its e and f translation components) to take into account the horizontal or vertical
//displacement of each glyph painted as well as any character or word-spacing parameters in the text
//state.
//308 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Additionally, within a text object, a PDF processor shall keep track of a text line matrix, Tlm, which
//captures the value of Tm at the beginning of a line of text. The text-positioning and text-showing
//operators shall read and set Tlm on specific occasions mentioned in "Table 106 — Text-positioning
//operators" and "Table 107 — Text-showing operators"
//.
//NOTE This can be used to compactly represent evenly spaced lines of text.
//9.4.3 Text-showing operators
//The text-showing operators ("Table 107 — Text-showing operators") shall show text on the page,
//repositioning text space as they do so. All of the operators shall interpret the text string and apply the
//text state parameters as described in "Table 107 — Text-showing operators"
//.
//The text-showing operators shall only appear within text objects.
//Table 107 — Text-showing operators
//Operands Operator Description
//string Tj Show a text string.
//string ' Move to the next line and show a text string. This operator shall have
//the same effect as the code
//T*
//string Tj
//aw ac string " Move to the next line and show a text string, using aw as the word
//spacing and ac as the character spacing (setting the corresponding
//parameters in the text state). aw and ac shall be numbers expressed in
//unscaled text space units. This operator shall have the same effect as
//this code:
//a
//Tw
//w
//a
//Tc
//c
//string '
//Array TJ Show zero or more text strings, allowing individual glyph positioning.
//Each element of array shall be either a string or a number. If the
//element is a string, this operator shall show the string. If it is a
//number, the operator shall adjust the text position by that amount;
//that is, it shall translate the text matrix, Tm . The number shall be
//expressed in thousandths of a unit of text space (see 9.4.4, "Text space
//details"). This amount shall be subtracted from the current horizontal
//or vertical coordinate, depending on the writing mode. In the default
//coordinate system, a positive adjustment has the effect of moving the
//next glyph painted either to the left or down by the given amount.
//"Figure 61 — Operation of the TJ operator in horizontal writing"
//shows an example of the effect of passing offsets to TJ.
//© ISO 2020 – All rights reserved 309
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//Figure 61 — Operation of the TJ operator in horizontal writing
//A string operand of a text-showing operator shall be interpreted as a sequence of character codes
//identifying the glyphs to be painted.
//With a simple font, each byte of the string shall be treated as a separate character code. The character
//code shall then be looked up in the font’s encoding to select the glyph, as described in 9.6.5, "Character
//encoding"
//.
//With a composite font (PDF 1.2), multiple-byte codes may be used to select glyphs. In this instance, one
//or more consecutive bytes of the string shall be treated as a single character code. The code lengths
//and the mappings from codes to glyphs are defined in a data structure called a CMap, described in 9.7,
//"Composite fonts"
//.
//The strings shall conform to the syntax for string objects. When a string is written by enclosing the data
//in parentheses, bytes whose values are equal to those of the ASCII characters LEFT PARENTHESIS
//(28h), RIGHT PARENTHESIS (29h), and REVERSE SOLIDUS (5Ch) (backslash) shall be preceded by a
//REVERSE SOLIDUS) character. All other byte values between 0 and 255 may be used in a string object.
//These rules apply to each individual byte in a string object, whether the string is interpreted by the
//text-showing operators as single-byte or multiple-byte character codes.
//Strings presented to the text-showing operators may be of any length — even an empty string or a
//single character code per string — and may be placed on the page in any order. The grouping of glyphs
//into strings has no significance for the display of text. Showing multiple glyphs with one invocation of a
//text-showing operator such as Tj shall produce the same results as showing them with a separate
//invocation for each glyph.
//NOTE 1 Use of longer text strings is generally more efficient.
//NOTE 2 In some cases, the text that is extracted can vary depending on the grouping of glyphs into
//strings. See, for example, 14.8.2.5.3, "Reverse-order show strings"
//.
//NOTE 3 Empty strings are valid.
//9.4.4 Text space details
//As stated in 9.4.2, "Text-positioning operators", text shall be shown in text space, defined by the
//combination of the text matrix, Tm, and the text state parameters Tfs, Th, and Trise . This determines how
//text coordinates are transformed into user space. Both the glyph’s shape and its displacement
//(horizontal or vertical) shall be interpreted in text space.
//NOTE 1 Glyphs are actually defined in glyph space, whose definition varies according to the font type as
//discussed in 9.2.4, "Glyph positioning and metrics". Glyph coordinates are first transformed from
//glyph space to text space before being subjected to the transformations described in Note 2.
//310 © ISO 2020 – All rights reserved
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//NOTE 2 Conceptually, the entire transformation from text space to device space can be represented by a
//text rendering matrix, Trm :
//𝑇 𝑟𝑚 = [𝑇 𝑓𝑠 × 𝑇ℎ 0 0
//0 𝑇𝑟𝑖𝑠𝑒 1] × 𝑇 𝑚 × 𝐶𝑇𝑀
//0 𝑇 𝑓𝑠 0
//Trm is a temporary matrix; conceptually, it is recomputed before each glyph is painted during a
//text-showing operation.
//After the glyph is painted, the text matrix shall be updated according to the glyph displacement and any
//spacing parameters that apply. First, a combined displacement shall be computed, denoted by tx in
//horizontal writing mode or ty in vertical writing mode (the variable corresponding to the other writing
//mode shall be set to 0):
//𝑡𝑥 = ((𝑤0 −
//𝑡𝑦 = (𝑤1 −
//where
//𝑇 𝑗
//1000) × 𝑇 𝑓𝑠 + 𝑇 𝑐 + 𝑇 𝑤) × 𝑇ℎ
//𝑇 𝑗
//1000) × 𝑇 𝑓𝑠 + 𝑇 𝑐 + 𝑇 𝑤
//w0 and w1 denote the glyph’s horizontal and vertical displacements
//Tj denotes a number in a TJ array, if any, which specifies a position adjustment
//Tfs and Th denote the current text font size and horizontal scaling parameters in the graphics state
//T
//c
//and T
//w
//applicable
//denote the current character-and word-spacing parameters in the graphics state, if
//The text matrix then shall be updated as follows:
//0 1 0
//𝑇 𝑚 = [ 1 0 0
//𝑡𝑥 𝑡𝑦 1] × 𝑇 𝑚
