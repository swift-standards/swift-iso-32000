// ISO 32000-2:2020, 8.4 Graphics state
//
// A PDF processor shall maintain an internal data structure called the graphics state
// that holds current graphics control parameters. These parameters define the global
// framework within which the graphics operators execute.

public import Geometry
public import ISO_32000_Shared

extension ISO_32000.`8` {
    /// ISO 32000-2:2020, 8.4 Graphics state
    public enum `4` {}
}

// MARK: - 8.4.1 General

extension ISO_32000.`8`.`4` {
    /// Graphics namespace for Section 8.4.
    public enum Graphics {}
}

extension ISO_32000.`8`.`4`.Graphics {
    /// Graphics state parameters as defined in ISO 32000-2:2020, Section 8.4.
    ///
    /// A PDF processor shall maintain an internal data structure called the graphics state
    /// that holds current graphics control parameters. These parameters define the global
    /// framework within which the graphics operators execute.
    ///
    /// The graphics state is divided into:
    /// - **Device-independent parameters** (Table 51): Appropriate for page descriptions
    /// - **Device-dependent parameters** (Table 52): Control rendering details
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.4.1
    public enum State {}
}

// MARK: - 8.4.3 Line Styles

extension ISO_32000.`8`.`4`.Graphics.State {
    /// Line style parameters namespace.
    public enum Line {}
}

// MARK: - 8.4.3.3 Line Cap Style (Table 53)

extension ISO_32000.`8`.`4`.Graphics.State.Line {
    /// Line cap style specifying the shape at endpoints of open stroked paths.
    ///
    /// Per ISO 32000-2:2020, Table 53, the line cap style shall specify the shape
    /// that shall be used at both ends of open subpaths (and dashes) when they are stroked.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.4.3.3, Table 53
    public enum Cap: Int, Sendable, Codable, Hashable, CaseIterable {
        /// Butt cap (value 0).
        ///
        /// The stroke shall be squared off at the endpoint of the path.
        /// There shall be no projection beyond the end of the path.
        case butt = 0

        /// Round cap (value 1).
        ///
        /// A semicircular arc with a diameter equal to the line width shall be
        /// drawn around the endpoint and shall be filled in.
        case round = 1

        /// Projecting square cap (value 2).
        ///
        /// The stroke shall continue beyond the endpoint of the path for a
        /// distance equal to half the line width and shall be squared off.
        case projectingSquare = 2
    }
}

// MARK: - 8.4.3.4 Line Join Style (Table 54)

extension ISO_32000.`8`.`4`.Graphics.State.Line {
    /// Line join style specifying the shape at corners of stroked paths.
    ///
    /// Per ISO 32000-2:2020, Table 54, the line join style shall specify the shape
    /// to be used at the corners of paths that are stroked. Join styles shall be
    /// significant only at points where consecutive segments of a path connect at
    /// an angle; segments that meet or intersect fortuitously shall receive no
    /// special treatment.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.4.3.4, Table 54
    public enum Join: Int, Sendable, Codable, Hashable, CaseIterable {
        /// Miter join (value 0).
        ///
        /// The outer edges of the strokes for the two segments shall be extended
        /// until they meet at an angle, as in a picture frame. If the segments
        /// meet at too sharp an angle (as defined by the miter limit parameter),
        /// a bevel join shall be used instead.
        case miter = 0

        /// Round join (value 1).
        ///
        /// An arc of a circle with a diameter equal to the line width shall be
        /// drawn around the point where the two segments meet, connecting the
        /// outer edges of the strokes for the two segments. This pie-slice-shaped
        /// figure shall be filled in, producing a rounded corner.
        case round = 1

        /// Bevel join (value 2).
        ///
        /// The two segments shall be finished with butt caps and the resulting
        /// notch beyond the ends of the segments shall be filled with a triangle.
        case bevel = 2
    }
}

// MARK: - 8.4.3.6 Line Dash Pattern (Table 55)

extension ISO_32000.`8`.`4`.Graphics.State.Line {
    /// Dash pattern namespace.
    public enum Dash {}
}

extension ISO_32000.`8`.`4`.Graphics.State.Line.Dash {
    /// Line dash pattern controlling the pattern of dashes and gaps for stroked paths.
    ///
    /// Per ISO 32000-2:2020, Section 8.4.3.6, the line dash pattern shall control
    /// the pattern of dashes and gaps used to stroke paths. It shall be specified
    /// by a dash array and a dash phase.
    ///
    /// ## Dash Array
    ///
    /// The dash array's elements shall be numbers that specify the lengths of
    /// alternating dashes and gaps; the numbers shall be nonnegative and not all zero.
    ///
    /// ## Dash Phase
    ///
    /// The dash phase shall be a number that specifies the distance into the dash
    /// pattern at which to start the dash. If the dash phase is negative, it shall
    /// be incremented by twice the sum of all lengths in the dash array until it
    /// is positive.
    ///
    /// ## Examples (Table 55)
    ///
    /// | Array | Phase | Description |
    /// |-------|-------|-------------|
    /// | `[]` | 0 | Solid line |
    /// | `[3]` | 0 | 3 on, 3 off, ... |
    /// | `[2]` | 1 | 1 on, 2 off, 2 on, 2 off, ... |
    /// | `[2, 1]` | 0 | 2 on, 1 off, 2 on, 1 off, ... |
    /// | `[3, 5]` | 6 | 2 off, 3 on, 5 off, 3 on, 5 off, ... |
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.4.3.6, Table 55
    public struct Pattern: Sendable, Codable, Hashable {
        /// The dash array specifying lengths of alternating dashes and gaps.
        ///
        /// Elements shall be nonnegative and not all zero.
        /// An empty array represents a solid line.
        public var array: [Double]

        /// The dash phase specifying distance into pattern at which to start.
        ///
        /// If negative, it shall be incremented by twice the sum of all lengths
        /// in the dash array until it is positive.
        public var phase: Double

        /// Create a dash pattern.
        ///
        /// - Parameters:
        ///   - array: Lengths of alternating dashes and gaps (empty for solid line)
        ///   - phase: Distance into pattern at which to start (default: 0)
        public init(array: [Double] = [], phase: Double = 0) {
            self.array = array
            self.phase = phase
        }

        /// A solid line (no dashes).
        ///
        /// Initial value per Table 51.
        public static let solid = Pattern(array: [], phase: 0)
    }
}

// MARK: - 8.6.5.8 Rendering Intent

extension ISO_32000.`8`.`4`.Graphics.State {
    /// Rendering namespace.
    public enum Rendering {}
}

extension ISO_32000.`8`.`4`.Graphics.State.Rendering {
    /// Rendering intent for CIE-based colour to device colour conversion.
    ///
    /// Per ISO 32000-2:2020, Section 8.6.5.8, the rendering intent specifies
    /// the style of colour reproduction to be used when converting CIE-based
    /// colours to device colours.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.6.5.8
    public enum Intent: String, Sendable, Codable, Hashable, CaseIterable {
        /// Relative colorimetric rendering intent.
        ///
        /// Colours are represented relative to the white point of the medium.
        /// Initial value per Table 51.
        case relativeColorimetric = "RelativeColorimetric"

        /// Absolute colorimetric rendering intent.
        ///
        /// Colours are represented in absolute terms.
        case absoluteColorimetric = "AbsoluteColorimetric"

        /// Saturation rendering intent.
        ///
        /// Preserves saturation at the expense of hue and lightness.
        case saturation = "Saturation"

        /// Perceptual rendering intent.
        ///
        /// Attempts to produce a pleasing visual appearance.
        case perceptual = "Perceptual"
    }
}

// MARK: - 8.6.5.9 Black Point Compensation (PDF 2.0)

extension ISO_32000.`8`.`4`.Graphics.State {
    /// Black point namespace.
    public struct BlackPoint {
        public var compensation: Compensation

        public init(compensation: Compensation) {
            self.compensation = compensation
        }
    }
}

extension ISO_32000.`8`.`4`.Graphics.State.BlackPoint {
    /// Black point compensation algorithm for CIE-based colour conversions.
    ///
    /// Per ISO 32000-2:2020 (PDF 2.0), Section 8.6.5.9, this parameter controls
    /// whether black point compensation is performed while doing CIE-based
    /// colour conversions.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.6.5.9, Table 51
    public enum Compensation: String, Sendable, Codable, Hashable, CaseIterable {
        /// Black point compensation is disabled.
        case off = "OFF"

        /// Black point compensation is enabled.
        case on = "ON"

        /// Semantics are up to the PDF processor.
        ///
        /// Initial value per Table 51.
        case `default` = "Default"
    }
}

// MARK: - 11.3.5 Blend Mode (PDF 1.4)

extension ISO_32000.`8`.`4`.Graphics.State {
    /// Blend namespace.
    public struct Blend {
        public var mode: Blend.Mode

        public init(
            mode: Blend.Mode
        ) {
            self.mode = mode
        }
    }
}

extension ISO_32000.`8`.`4`.Graphics.State.Blend {
    /// Blend mode for the transparent imaging model.
    ///
    /// Per ISO 32000-2:2020, Section 11.3.5, the blend mode determines how
    /// the source colour is combined with the backdrop colour during compositing.
    ///
    /// A PDF reader shall implicitly reset this parameter to its initial value
    /// at the beginning of execution of a transparency group XObject.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 11.3.5, Tables 134-135
    public enum Mode: String, Sendable, Codable, Hashable, CaseIterable {
        // MARK: - Standard Separable Blend Modes (Table 134)

        /// Normal blend mode.
        ///
        /// Selects the source colour, ignoring the backdrop.
        /// Initial value per Table 51.
        case normal = "Normal"

        /// Multiply blend mode.
        ///
        /// Multiplies the backdrop and source colour values.
        case multiply = "Multiply"

        /// Screen blend mode.
        ///
        /// Multiplies the complements of the backdrop and source colour values,
        /// then complements the result.
        case screen = "Screen"

        /// Overlay blend mode.
        ///
        /// Multiplies or screens the colours, depending on the backdrop colour value.
        case overlay = "Overlay"

        /// Darken blend mode.
        ///
        /// Selects the darker of the backdrop and source colours.
        case darken = "Darken"

        /// Lighten blend mode.
        ///
        /// Selects the lighter of the backdrop and source colours.
        case lighten = "Lighten"

        /// Color dodge blend mode.
        ///
        /// Brightens the backdrop colour to reflect the source colour.
        case colorDodge = "ColorDodge"

        /// Color burn blend mode.
        ///
        /// Darkens the backdrop colour to reflect the source colour.
        case colorBurn = "ColorBurn"

        /// Hard light blend mode.
        ///
        /// Multiplies or screens the colours, depending on the source colour value.
        case hardLight = "HardLight"

        /// Soft light blend mode.
        ///
        /// Darkens or lightens the colours, depending on the source colour value.
        case softLight = "SoftLight"

        /// Difference blend mode.
        ///
        /// Subtracts the darker of the two colours from the lighter.
        case difference = "Difference"

        /// Exclusion blend mode.
        ///
        /// Produces an effect similar to Difference but lower in contrast.
        case exclusion = "Exclusion"

        // MARK: - Standard Non-Separable Blend Modes (Table 135)

        /// Hue blend mode.
        ///
        /// Creates a colour with the hue of the source and the saturation and
        /// luminosity of the backdrop.
        case hue = "Hue"

        /// Saturation blend mode.
        ///
        /// Creates a colour with the saturation of the source and the hue and
        /// luminosity of the backdrop.
        case saturation = "Saturation"

        /// Color blend mode.
        ///
        /// Creates a colour with the hue and saturation of the source and the
        /// luminosity of the backdrop.
        case color = "Color"

        /// Luminosity blend mode.
        ///
        /// Creates a colour with the luminosity of the source and the hue and
        /// saturation of the backdrop.
        case luminosity = "Luminosity"
    }
}

// MARK: - Table 51: Device-Independent Graphics State Parameters

extension ISO_32000.`8`.`4`.Graphics.State {
    /// Device namespace.
    public enum Device {}
}

extension ISO_32000.`8`.`4`.Graphics.State.Device {
    /// Combined device state (both independent and dependent).
    public struct Combined<TextState: Sendable>: Sendable {
        public var independent: Independent<TextState>
        public var dependent: Dependent
    }
}

extension ISO_32000.`8`.`4`.Graphics.State.Device {
    /// Device-independent graphics state parameters.
    ///
    /// Per ISO 32000-2:2020, Table 51, these parameters are device-independent
    /// and are appropriate to specify in page descriptions.
    ///
    /// A page description that is intended to be device-independent should not
    /// modify the device-dependent parameters (see `Dependent`).
    ///
    /// Generic over `TextState` to allow the text state type to be defined
    /// in Section 9.3 where it belongs per the spec. Use the concrete
    /// `ISO_32000.GraphicsState` typealias for the integrated version.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.4.1, Table 51
    public struct Independent<TextState: Sendable>: Sendable {
        // MARK: - Transformation

        /// Current Transformation Matrix (CTM).
        ///
        /// Maps positions from user coordinates to device coordinates.
        /// Modified by the `cm` operator.
        ///
        /// Initial value: a matrix that transforms default user coordinates to device coordinates.
        public var ctm: ISO_32000.AffineTransform<ISO_32000.UserSpace.Unit>

        // MARK: - Clipping (internal, not directly representable)

        // Note: clipping path is internal and not directly represented in PDF.
        // Initial value: the size of the MediaBox.

        // MARK: - Colour

        /// Current stroking colour space.
        ///
        /// The colour space in which stroking colour values shall be interpreted.
        ///
        /// Initial value: DeviceGray
        public var strokingColorSpace: ISO_32000.`8`.`4`.Graphics.State.ColorSpace

        /// Current nonstroking colour space.
        ///
        /// The colour space in which nonstroking colour values shall be interpreted.
        ///
        /// Initial value: DeviceGray
        public var nonstrokingColorSpace: ISO_32000.`8`.`4`.Graphics.State.ColorSpace

        /// Current stroking colour.
        ///
        /// The colour used for stroking operations.
        ///
        /// Initial value: black
        public var strokingColor: ISO_32000.`8`.`4`.Graphics.State.Color

        /// Current nonstroking colour.
        ///
        /// The colour used for all painting operations other than stroking.
        ///
        /// Initial value: black
        public var nonstrokingColor: ISO_32000.`8`.`4`.Graphics.State.Color

        // MARK: - Text State

        /// Text state parameters.
        ///
        /// A set of nine graphics state parameters that pertain only to the
        /// painting of text. See Section 9.3.
        public var textState: TextState

        // MARK: - Line Style

        /// Line width in user space units.
        ///
        /// The thickness of paths to be stroked. Stroking a path shall entail
        /// painting all points whose perpendicular distance from the path in
        /// user space is less than or equal to half the line width.
        ///
        /// A line width of 0 denotes the thinnest line that can be rendered
        /// at device resolution: 1 device pixel wide. However, zero-width
        /// lines should not be used as results are device-dependent.
        ///
        /// Initial value: 1.0
        public var lineWidth: ISO_32000.UserSpace.Unit

        /// Line cap style.
        ///
        /// Specifies the shape at endpoints of open stroked paths.
        ///
        /// Initial value: `.butt` (0)
        public var lineCap: ISO_32000.`8`.`4`.Graphics.State.Line.Cap

        /// Line join style.
        ///
        /// Specifies the shape at corners of stroked paths.
        ///
        /// Initial value: `.miter` (0)
        public var lineJoin: ISO_32000.`8`.`4`.Graphics.State.Line.Join

        /// Miter limit.
        ///
        /// Imposes a maximum on the ratio of the miter length to the line width.
        /// When exceeded, the join is converted from miter to bevel.
        ///
        /// The miter limit is related to the angle φ between segments by:
        /// `miterLength / lineWidth = 1 / sin(φ/2)`
        ///
        /// Initial value: 10.0 (converts miters to bevels for angles < ~11.5°)
        public var miterLimit: ISO_32000.UserSpace.Unit

        /// Line dash pattern.
        ///
        /// Controls the pattern of dashes and gaps used to stroke paths.
        ///
        /// Initial value: `[]` `0` (solid line)
        public var dashPattern: ISO_32000.`8`.`4`.Graphics.State.Line.Dash.Pattern

        // MARK: - Rendering

        /// Rendering intent.
        ///
        /// The rendering intent used when converting CIE-based colours to device colours.
        ///
        /// Initial value: `.relativeColorimetric`
        public var renderingIntent: ISO_32000.`8`.`4`.Graphics.State.Rendering.Intent

        /// Stroke adjustment flag.
        ///
        /// (PDF 1.2) Specifies whether to compensate for possible rasterization
        /// effects when stroking a path with a line width that is small relative
        /// to the pixel resolution of the output device.
        ///
        /// Note: This is considered device-independent even though effects are device-dependent.
        ///
        /// Initial value: `false`
        public var strokeAdjustment: Bool

        // MARK: - Transparency (PDF 1.4)

        /// Blend mode.
        ///
        /// (PDF 1.4) The blend mode used in the transparent imaging model.
        /// Reset to initial value at beginning of transparency group XObject execution.
        ///
        /// Initial value: `.normal`
        public var blendMode: ISO_32000.`8`.`4`.Graphics.State.Blend.Mode

        /// Soft mask.
        ///
        /// (PDF 1.4) The soft mask specifying mask shape or opacity values.
        /// Reset to initial value at beginning of transparency group XObject execution.
        ///
        /// Initial value: `nil` (None)
        public var softMask: ISO_32000.`8`.`4`.Graphics.State.SoftMask?

        /// Stroking alpha constant.
        ///
        /// (PDF 1.4) The constant shape or opacity value for stroking operations.
        /// Reset to initial value at beginning of transparency group XObject execution.
        ///
        /// Initial value: 1.0
        public var strokingAlphaConstant: ISO_32000.UserSpace.Unit

        /// Nonstroking alpha constant.
        ///
        /// (PDF 1.4) The constant shape or opacity value for nonstroking operations.
        /// Reset to initial value at beginning of transparency group XObject execution.
        ///
        /// Initial value: 1.0
        public var nonstrokingAlphaConstant: ISO_32000.UserSpace.Unit

        /// Alpha source flag ("alpha is shape").
        ///
        /// (PDF 1.4) Specifies whether current soft mask and alpha constant shall
        /// be interpreted as shape values (`true`) or opacity values (`false`).
        /// Also governs interpretation of SMask entry in image dictionaries.
        ///
        /// Initial value: `false`
        public var alphaSource: Bool

        // MARK: - Black Point Compensation (PDF 2.0)

        /// Black point compensation.
        ///
        /// (PDF 2.0) Controls whether black point compensation is performed
        /// during CIE-based colour conversions.
        ///
        /// Initial value: `.default`
        public var blackPointCompensation: ISO_32000.`8`.`4`.Graphics.State.BlackPoint.Compensation

        // MARK: - Initializer

        /// Create device-independent graphics state with specified values.
        ///
        /// Most parameters have sensible defaults per ISO 32000-2:2020 Table 51.
        /// The `textState` parameter must be provided as it depends on the
        /// concrete `TextState` type.
        public init(
            ctm: ISO_32000.AffineTransform<ISO_32000.UserSpace.Unit> = .identity,
            strokingColorSpace: ISO_32000.`8`.`4`.Graphics.State.ColorSpace = .deviceGray,
            nonstrokingColorSpace: ISO_32000.`8`.`4`.Graphics.State.ColorSpace = .deviceGray,
            strokingColor: ISO_32000.`8`.`4`.Graphics.State.Color = .gray(0),
            nonstrokingColor: ISO_32000.`8`.`4`.Graphics.State.Color = .gray(0),
            textState: TextState,
            lineWidth: ISO_32000.UserSpace.Unit = 1,
            lineCap: ISO_32000.`8`.`4`.Graphics.State.Line.Cap = .butt,
            lineJoin: ISO_32000.`8`.`4`.Graphics.State.Line.Join = .miter,
            miterLimit: ISO_32000.UserSpace.Unit = 10,
            dashPattern: ISO_32000.`8`.`4`.Graphics.State.Line.Dash.Pattern = .solid,
            renderingIntent: ISO_32000.`8`.`4`.Graphics.State.Rendering.Intent =
                .relativeColorimetric,
            strokeAdjustment: Bool = false,
            blendMode: ISO_32000.`8`.`4`.Graphics.State.Blend.Mode = .normal,
            softMask: ISO_32000.`8`.`4`.Graphics.State.SoftMask? = nil,
            strokingAlphaConstant: ISO_32000.UserSpace.Unit = 1,
            nonstrokingAlphaConstant: ISO_32000.UserSpace.Unit = 1,
            alphaSource: Bool = false,
            blackPointCompensation: ISO_32000.`8`.`4`.Graphics.State.BlackPoint.Compensation =
                .default
        ) {
            self.ctm = ctm
            self.strokingColorSpace = strokingColorSpace
            self.nonstrokingColorSpace = nonstrokingColorSpace
            self.strokingColor = strokingColor
            self.nonstrokingColor = nonstrokingColor
            self.textState = textState
            self.lineWidth = lineWidth
            self.lineCap = lineCap
            self.lineJoin = lineJoin
            self.miterLimit = miterLimit
            self.dashPattern = dashPattern
            self.renderingIntent = renderingIntent
            self.strokeAdjustment = strokeAdjustment
            self.blendMode = blendMode
            self.softMask = softMask
            self.strokingAlphaConstant = strokingAlphaConstant
            self.nonstrokingAlphaConstant = nonstrokingAlphaConstant
            self.alphaSource = alphaSource
            self.blackPointCompensation = blackPointCompensation
        }
    }
}

// MARK: - Table 52: Device-Dependent Graphics State Parameters

extension ISO_32000.`8`.`4`.Graphics.State.Device {
    /// Device-dependent graphics state parameters.
    ///
    /// Per ISO 32000-2:2020, Table 52, these parameters control details of
    /// the rendering (scan conversion) process and are device-dependent.
    ///
    /// A page description that is intended to be device-independent should
    /// NOT modify these parameters.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.4.1, Table 52
    public struct Dependent: Sendable {
        // MARK: - Overprint Control (PDF 1.2/1.3)

        /// Stroking overprint flag.
        ///
        /// (PDF 1.2, separate parameter in PDF 1.3) Specifies whether painting
        /// in one set of colourants should cause corresponding areas of other
        /// colourants to be erased (`false`) or left unchanged (`true`).
        ///
        /// Initial value: `false`
        public var strokingOverprint: Bool

        /// Nonstroking overprint flag.
        ///
        /// (PDF 1.3) Specifies overprint for nonstroking operations.
        ///
        /// Initial value: `false`
        public var nonstrokingOverprint: Bool

        /// Overprint mode.
        ///
        /// (PDF 1.3) Specifies whether a colour component value of 0 in a
        /// DeviceCMYK colour space should erase that component (`0`) or
        /// leave it unchanged (`1`) when overprinting.
        ///
        /// Initial value: 0
        public var overprintMode: Int

        // MARK: - Colour Conversion Functions (PDF 1.2)

        // Note: Black generation, undercolor removal, and transfer functions
        // are represented as function objects which require more complex modeling.
        // For now, we use an enum to represent the special "Default" value.

        /// Black generation function status.
        ///
        /// (PDF 1.2) The black-generation function that calculates the level
        /// of black when converting RGB to CMYK.
        ///
        /// Initial value: device-dependent
        public var blackGeneration: ISO_32000.`8`.`4`.Graphics.State.FunctionOrDefault

        /// Undercolor removal function status.
        ///
        /// (PDF 1.2) The undercolour-removal function that calculates reduction
        /// in cyan, magenta, yellow to compensate for black added by black generation.
        ///
        /// Initial value: device-dependent
        public var undercolorRemoval: ISO_32000.`8`.`4`.Graphics.State.FunctionOrDefault

        /// Transfer function status.
        ///
        /// (PDF 1.2, deprecated in PDF 2.0) The transfer function that adjusts
        /// device colour levels to compensate for nonlinear response.
        ///
        /// Initial value: device-dependent
        @available(*, deprecated, message: "Deprecated in PDF 2.0")
        public var transfer: ISO_32000.`8`.`4`.Graphics.State.FunctionOrDefault

        // MARK: - Halftone (PDF 1.2)

        /// Halftone status.
        ///
        /// (PDF 1.2) The halftone screen for gray and colour rendering.
        ///
        /// Initial value: device-dependent
        public var halftone: ISO_32000.`8`.`4`.Graphics.State.HalftoneOrDefault

        /// Halftone origin.
        ///
        /// (PDF 2.0) The X and Y location of the halftone origin in current
        /// coordinate system (user space).
        public var halftoneOrigin: ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Coordinate?

        // MARK: - Rendering Precision

        /// Flatness tolerance.
        ///
        /// The precision with which curves shall be rendered on the output device.
        /// The value (positive number) gives the maximum error tolerance measured
        /// in output device pixels; smaller numbers give smoother curves at the
        /// expense of more computation and memory use.
        ///
        /// Initial value: 1.0
        public var flatness: Double

        /// Smoothness tolerance.
        ///
        /// (PDF 1.3) The precision with which colour gradients are to be rendered.
        /// The value (0 to 1.0) gives maximum error tolerance as a fraction of the
        /// range of each colour component; smaller numbers give smoother colour
        /// transitions at the expense of more computation and memory use.
        ///
        /// Initial value: device-dependent
        public var smoothness: Double?

        // MARK: - Initializer

        /// Create device-dependent graphics state with default initial values.
        public init() {
            self.strokingOverprint = false
            self.nonstrokingOverprint = false
            self.overprintMode = 0
            self.blackGeneration = .default
            self.undercolorRemoval = .default
            self.transfer = .default
            self.halftone = .default
            self.halftoneOrigin = nil
            self.flatness = 1.0
            self.smoothness = nil
        }
    }
}

// MARK: - Supporting Types

extension ISO_32000.`8`.`4`.Graphics.State {
    /// Represents either a function or the Default value.
    ///
    /// Used for black generation, undercolor removal, and transfer functions.
    public enum FunctionOrDefault: Sendable, Hashable {
        /// Use the function that was in effect at the start of the page.
        case `default`

        /// Identity function (for transfer).
        case identity

        /// A custom function (represented by reference).
        case function(FunctionReference)
    }

    /// A reference to a PDF function object.
    ///
    /// Functions in PDF are complex objects that may be sampled (Type 0),
    /// exponential interpolation (Type 2), stitching (Type 3), or
    /// PostScript calculator (Type 4).
    public struct FunctionReference: Sendable, Hashable {
        /// The function type.
        public var type: FunctionType

        /// Create a function reference.
        public init(type: FunctionType) {
            self.type = type
        }
    }

    /// PDF function types.
    public enum FunctionType: Int, Sendable, Codable, Hashable {
        /// Sampled function.
        case sampled = 0

        /// Exponential interpolation function.
        case exponentialInterpolation = 2

        /// Stitching function.
        case stitching = 3

        /// PostScript calculator function.
        case postScriptCalculator = 4
    }

    /// Represents either a halftone or the Default value.
    public enum HalftoneOrDefault: Sendable, Hashable {
        /// Use the halftone that was in effect at the start of the page.
        case `default`

        /// A halftone dictionary or stream.
        case halftone(HalftoneReference)
    }

    /// A reference to a halftone dictionary or stream.
    public struct HalftoneReference: Sendable, Hashable {
        /// The halftone type.
        public var type: HalftoneType

        /// Create a halftone reference.
        public init(type: HalftoneType) {
            self.type = type
        }
    }

    /// PDF halftone types.
    public enum HalftoneType: Int, Sendable, Codable, Hashable {
        /// Type 1: Defines a single halftone screen by a frequency, angle, and spot function.
        case type1 = 1

        /// Type 5: Defines halftone screens for individual colorants.
        case type5 = 5

        /// Type 6: Defines a halftone screen with a threshold array.
        case type6 = 6

        /// Type 10: Defines a halftone screen with a threshold array (different format).
        case type10 = 10

        /// Type 16: Defines a halftone screen with a 16-bit threshold array.
        case type16 = 16
    }

    /// A soft mask dictionary.
    ///
    /// Per ISO 32000-2:2020, Section 11.6.5.1.
    public struct SoftMask: Sendable, Hashable {
        /// The soft mask subtype.
        public var subtype: SoftMaskSubtype

        /// Create a soft mask.
        public init(subtype: SoftMaskSubtype) {
            self.subtype = subtype
        }
    }

    /// Soft mask subtypes.
    public enum SoftMaskSubtype: String, Sendable, Codable, Hashable {
        /// Alpha mask.
        case alpha = "Alpha"

        /// Luminosity mask.
        case luminosity = "Luminosity"
    }

    /// Colour space identifiers.
    ///
    /// Per ISO 32000-2:2020, Section 8.6.
    public enum ColorSpace: Sendable, Hashable {
        // Device colour spaces
        case deviceGray
        case deviceRGB
        case deviceCMYK

        // CIE-based colour spaces
        case calGray
        case calRGB
        case lab
        case iccBased

        // Special colour spaces
        case indexed
        case pattern
        case separation
        case deviceN
    }

    /// A colour value.
    ///
    /// The interpretation depends on the current colour space.
    public enum Color: Sendable, Hashable {
        /// Gray value (0 = black, 1 = white).
        case gray(Double)

        /// RGB values (each 0-1).
        case rgb(r: Double, g: Double, b: Double)

        /// CMYK values (each 0-1).
        case cmyk(c: Double, m: Double, y: Double, k: Double)

        /// Black (gray 0).
        public static let black = Color.gray(0)

        /// White (gray 1).
        public static let white = Color.gray(1)
    }
}

// MARK: - 8.4.2 Graphics State Stack

extension ISO_32000.`8`.`4`.Graphics.State {
    /// Graphics state stack supporting save/restore operations.
    ///
    /// Per ISO 32000-2:2020, Section 8.4.2, a PDF document typically contains
    /// many graphical elements that are independent of each other and nested
    /// to multiple levels. The graphics state stack allows these elements to
    /// make local changes to the graphics state without disturbing the graphics
    /// state of the surrounding environment.
    ///
    /// The stack is a LIFO (last in, first out) data structure:
    /// - The `q` operator shall push a copy of the entire graphics state onto the stack.
    /// - The `Q` operator shall restore the entire graphics state by popping it from the stack.
    ///
    /// Occurrences of `q` and `Q` operators shall be **balanced** within a given
    /// content stream (or within the sequence of streams specified in a page
    /// dictionary's Contents array).
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.4.2
    public struct Stack<State: Sendable>: Sendable {
        /// Internal stack storage.
        private var states: [State]

        // MARK: - Initializers

        /// Create a stack with an initial state.
        ///
        /// - Parameter initial: The initial graphics state
        public init(initial: State) {
            self.states = [initial]
        }

        // MARK: - Current State Access

        /// The current graphics state (top of stack).
        public var current: State {
            get { states[states.count - 1] }
            set { states[states.count - 1] = newValue }
        }

        /// The depth of the stack (number of states).
        ///
        /// The depth is always at least 1 (the base state).
        public var depth: Int {
            states.count
        }

        // MARK: - Stack Operations (q/Q)

        /// Save the current graphics state (push copy onto stack).
        ///
        /// Corresponds to PDF's `q` operator.
        ///
        /// Per ISO 32000-2:2020, Section 8.4.2:
        /// > The q operator shall push a copy of the entire graphics state onto the stack.
        public mutating func save() {
            states.append(current)
        }

        /// Restore the previous graphics state (pop from stack).
        ///
        /// Corresponds to PDF's `Q` operator.
        ///
        /// Per ISO 32000-2:2020, Section 8.4.2:
        /// > The Q operator shall restore the entire graphics state to its former
        /// > value by popping it from the stack.
        ///
        /// If only one state remains, this is a no-op (cannot pop the base state).
        ///
        /// - Returns: `true` if a state was restored, `false` if at base state
        @discardableResult
        public mutating func restore() -> Bool {
            guard states.count > 1 else { return false }
            states.removeLast()
            return true
        }

        /// Execute a closure with a saved graphics state, automatically restoring after.
        ///
        /// This ensures balanced `q`/`Q` operations.
        ///
        /// - Parameter body: The closure to execute with saved state
        /// - Returns: The result of the closure
        public mutating func withSavedState<T>(_ body: (inout Self) throws -> T) rethrows -> T {
            save()
            defer { restore() }
            return try body(&self)
        }
    }
}

// MARK: - 8.4.4 Graphics State Operators (Table 56)

extension ISO_32000.`8`.`4` {
    /// Graphics state operators.
    ///
    /// Per ISO 32000-2:2020, Table 56, these operators set the values of
    /// parameters in the graphics state.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 8.4.4, Table 56
    public enum Operator: Sendable, Hashable {
        /// `q` - Save the current graphics state on the graphics state stack.
        case q

        /// `Q` - Restore the graphics state by popping from the stack.
        case Q

        /// `a b c d e f cm` - Modify the CTM by concatenating the specified matrix.
        ///
        /// The operands specify a matrix written as six separate numbers, not as an array.
        case cm(a: Double, b: Double, c: Double, d: Double, e: Double, f: Double)

        /// `lineWidth w` - Set the line width in the graphics state.
        case w(lineWidth: Double)

        /// `lineCap J` - Set the line cap style in the graphics state.
        case J(lineCap: Graphics.State.Line.Cap)

        /// `lineJoin j` - Set the line join style in the graphics state.
        case j(lineJoin: Graphics.State.Line.Join)

        /// `miterLimit M` - Set the miter limit in the graphics state.
        case M(miterLimit: Double)

        /// `dashArray dashPhase d` - Set the line dash pattern in the graphics state.
        case d(dashArray: [Double], dashPhase: Double)

        /// `intent ri` - Set the colour rendering intent in the graphics state.
        case ri(intent: Graphics.State.Rendering.Intent)

        /// `flatness i` - Set the flatness tolerance in the graphics state.
        ///
        /// `flatness` is a number in the range 0 to 100; a value of 0 shall
        /// specify the output device's default flatness tolerance.
        case i(flatness: Double)

        /// `dictName gs` - Set parameters from a graphics state parameter dictionary.
        ///
        /// `dictName` shall be the name of a graphics state parameter dictionary
        /// in the ExtGState subdictionary of the current resource dictionary.
        case gs(dictName: String)
    }
}

// MARK: - Equatable Conformances

extension ISO_32000.`8`.`4`.Graphics.State.Device.Independent: Equatable
where TextState: Equatable {}

extension ISO_32000.`8`.`4`.Graphics.State.Device.Dependent: Equatable {}

extension ISO_32000.`8`.`4`.Graphics.State.Stack: Equatable
where State: Equatable {}

// MARK: - Hashable Conformances

extension ISO_32000.`8`.`4`.Graphics.State.Device.Independent: Hashable
where TextState: Hashable {}

extension ISO_32000.`8`.`4`.Graphics.State.Device.Dependent: Hashable {}

extension ISO_32000.`8`.`4`.Graphics.State.Stack: Hashable
where State: Hashable {}

// MARK: - Stack Convenience Extensions for Device.Independent

extension ISO_32000.`8`.`4`.Graphics.State.Stack {

    // MARK: - Transformation Helpers

    /// Apply a transformation to the current CTM.
    ///
    /// This composes the given transform with the current CTM.
    ///
    /// - Parameter transform: The transform to concatenate
    @inlinable
    public mutating func concatenate<TextState>(
        _ transform: ISO_32000.AffineTransform<ISO_32000.UserSpace.Unit>
    ) where State == ISO_32000.`8`.`4`.Graphics.State.Device.Independent<TextState> {
        current.ctm = current.ctm.concatenating(transform)
    }

    /// Translate the current coordinate system.
    ///
    /// - Parameters:
    ///   - x: Horizontal translation in user space units
    ///   - y: Vertical translation in user space units
    @inlinable
    public mutating func translate<TextState>(
        x: ISO_32000.UserSpace.Unit,
        y: ISO_32000.UserSpace.Unit
    ) where State == ISO_32000.`8`.`4`.Graphics.State.Device.Independent<TextState> {
        concatenate(.translation(x: x, y: y))
    }

    /// Scale the current coordinate system.
    ///
    /// - Parameters:
    ///   - x: Horizontal scale factor
    ///   - y: Vertical scale factor
    @inlinable
    public mutating func scale<TextState>(
        x: ISO_32000.UserSpace.Unit,
        y: ISO_32000.UserSpace.Unit
    ) where State == ISO_32000.`8`.`4`.Graphics.State.Device.Independent<TextState> {
        concatenate(.scale(x: x, y: y))
    }

    /// Rotate the current coordinate system.
    ///
    /// - Parameter angle: Rotation angle in radians
    @inlinable
    public mutating func rotate<TextState>(
        _ angle: Radian
    ) where State == ISO_32000.`8`.`4`.Graphics.State.Device.Independent<TextState> {
        let c = ISO_32000.UserSpace.Unit(angle.cos)
        let s = ISO_32000.UserSpace.Unit(angle.sin)
        let rotation = ISO_32000.AffineTransform<ISO_32000.UserSpace.Unit>(
            a: c,
            b: s,
            c: -s,
            d: c,
            tx: .init(0),
            ty: .init(0)
        )
        concatenate(rotation)
    }

    // MARK: - Color Helpers

    /// Set the nonstroking (fill) color on the current state.
    @inlinable
    public mutating func setFillColor<TextState>(
        _ color: ISO_32000.`8`.`4`.Graphics.State.Color
    ) where State == ISO_32000.`8`.`4`.Graphics.State.Device.Independent<TextState> {
        current.nonstrokingColor = color
    }

    /// Set the stroking (stroke) color on the current state.
    @inlinable
    public mutating func setStrokeColor<TextState>(
        _ color: ISO_32000.`8`.`4`.Graphics.State.Color
    ) where State == ISO_32000.`8`.`4`.Graphics.State.Device.Independent<TextState> {
        current.strokingColor = color
    }

    // MARK: - Line Style Helpers

    /// Set the line width on the current state.
    @inlinable
    public mutating func setLineWidth<TextState>(
        _ width: ISO_32000.UserSpace.Unit
    ) where State == ISO_32000.`8`.`4`.Graphics.State.Device.Independent<TextState> {
        current.lineWidth = width
    }

    /// Set the line cap style on the current state.
    @inlinable
    public mutating func setLineCap<TextState>(
        _ cap: ISO_32000.`8`.`4`.Graphics.State.Line.Cap
    ) where State == ISO_32000.`8`.`4`.Graphics.State.Device.Independent<TextState> {
        current.lineCap = cap
    }

    /// Set the line join style on the current state.
    @inlinable
    public mutating func setLineJoin<TextState>(
        _ join: ISO_32000.`8`.`4`.Graphics.State.Line.Join
    ) where State == ISO_32000.`8`.`4`.Graphics.State.Device.Independent<TextState> {
        current.lineJoin = join
    }

    /// Set the dash pattern on the current state.
    @inlinable
    public mutating func setDashPattern<TextState>(
        _ pattern: ISO_32000.`8`.`4`.Graphics.State.Line.Dash.Pattern
    ) where State == ISO_32000.`8`.`4`.Graphics.State.Device.Independent<TextState> {
        current.dashPattern = pattern
    }

    // MARK: - Comonad-like Operations

    /// Extract the current state (comonad extract).
    ///
    /// This is equivalent to accessing `current`.
    @inlinable
    public func extract() -> State {
        current
    }

    /// Duplicate the stack (comonad duplicate).
    ///
    /// For practical purposes, this is equivalent to `save()`.
    @inlinable
    public mutating func duplicate() {
        save()
    }

    /// Extend a function over the stack (comonad extend).
    ///
    /// - Parameter f: A function from Stack to a value
    /// - Returns: The result of applying f to the current stack
    @inlinable
    public func extend<T>(_ f: (Self) -> T) -> T {
        f(self)
    }
}
