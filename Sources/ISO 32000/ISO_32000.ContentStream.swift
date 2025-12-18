// ISO_32000.ContentStream.swift

public import Geometry
import ISO_9899
import Standards

extension ISO_32000 {
    /// PDF Content Stream
    ///
    /// A content stream contains a sequence of operators that describe
    /// the visual contents of a PDF page.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let content = ContentStream { builder in
    ///     builder.beginText()
    ///     builder.setFont(.init(.helvetica), size: 12)
    ///     builder.moveText(x: 72, y: 720)
    ///     builder.showText("Hello, World!")
    ///     builder.endText()
    /// }
    /// ```
    public struct ContentStream: Sendable {
        /// Raw content stream bytes
        public var data: [UInt8]

        /// Fonts used in this content stream
        public var fontsUsed: Set<Font>

        /// Create an empty content stream
        public init() {
            self.data = []
            self.fontsUsed = []
        }

        /// Create a content stream from raw bytes
        public init(data: [UInt8], fontsUsed: Set<Font> = []) {
            self.data = data
            self.fontsUsed = fontsUsed
        }

        /// Create a content stream using a builder
        public init(_ build: (inout Builder) -> Void) {
            var builder = Builder()
            build(&builder)
            self.data = builder.data
            self.fontsUsed = builder.fontsUsed
        }
    }
}

// MARK: - Content Stream Builder

extension ISO_32000.ContentStream {
    /// Builder for constructing content streams
    public struct Builder: Sendable {
        /// Accumulated content stream data
        public var data: [UInt8] = []

        /// Fonts used in this content stream
        public var fontsUsed: Set<ISO_32000.Font> = []

        /// Create an empty builder
        public init() {}

        // MARK: - Emit Operator

        /// Emit an operator to the content stream
        private mutating func emit(_ op: Operator) {
            if !data.isEmpty {
                data.append(.ascii.lf)
            }
            op.serialize(into: &data)
        }

        // MARK: - Graphics State Operators

        /// Push graphics state (q)
        public mutating func saveGraphicsState() {
            emit(.saveState)
        }

        /// Pop graphics state (Q)
        public mutating func restoreGraphicsState() {
            emit(.restoreState)
        }

        /// Set transformation matrix (cm)
        ///
        /// - Parameters:
        ///   - a, b, c, d: Dimensionless scale/rotation coefficients
        ///   - e, f: Translation (displacement) in user space units
        public mutating func transform(
            a: Scale<1, Double>,
            b: Scale<1, Double>,
            c: Scale<1, Double>,
            d: Scale<1, Double>,
            e: ISO_32000.UserSpace.Dx,
            f: ISO_32000.UserSpace.Dy
        ) {
            emit(.transform(a: a, b: b, c: c, d: d, e: e, f: f))
        }

        /// Translate (convenience wrapper for cm)
        public mutating func translate(dx: ISO_32000.UserSpace.Dx, dy: ISO_32000.UserSpace.Dy) {
            emit(.transform(a: 1, b: 0, c: 0, d: 1, e: dx, f: dy))
        }

        /// Scale (convenience wrapper for cm)
        ///
        /// Scale factors are dimensionless multipliers.
        public mutating func scale(x: Scale<1, Double>, y: Scale<1, Double>) {
            emit(.transform(a: x, b: 0, c: 0, d: y, e: .init(0), f: .init(0)))
        }

        // MARK: - Color Operators

        /// Set stroking color in DeviceGray (G)
        public mutating func setStrokeColorGray(_ gray: Double) {
            emit(.setStrokeGray(gray))
        }

        /// Set non-stroking color in DeviceGray (g)
        public mutating func setFillColorGray(_ gray: Double) {
            emit(.setFillGray(gray))
        }

        /// Set stroking color in DeviceRGB (RG)
        public mutating func setStrokeColorRGB(r: Double, g: Double, b: Double) {
            emit(.setStrokeRGB(r: r, g: g, b: b))
        }

        /// Set non-stroking color in DeviceRGB (rg)
        public mutating func setFillColorRGB(r: Double, g: Double, b: Double) {
            emit(.setFillRGB(r: r, g: g, b: b))
        }

        /// Set stroking color in DeviceCMYK (K)
        public mutating func setStrokeColorCMYK(c: Double, m: Double, y: Double, k: Double) {
            emit(.setStrokeCMYK(c: c, m: m, y: y, k: k))
        }

        /// Set non-stroking color in DeviceCMYK (k)
        public mutating func setFillColorCMYK(c: Double, m: Double, y: Double, k: Double) {
            emit(.setFillCMYK(c: c, m: m, y: y, k: k))
        }

        // MARK: - Path Construction Operators

        /// Begin a new subpath (m)
        public mutating func moveTo(x: ISO_32000.UserSpace.X, y: ISO_32000.UserSpace.Y) {
            emit(.moveTo(x: x, y: y))
        }

        /// Append a line segment (l)
        public mutating func lineTo(x: ISO_32000.UserSpace.X, y: ISO_32000.UserSpace.Y) {
            emit(.lineTo(x: x, y: y))
        }

        /// Append a cubic Bezier curve (c)
        public mutating func curveTo(
            x1: ISO_32000.UserSpace.X,
            y1: ISO_32000.UserSpace.Y,
            x2: ISO_32000.UserSpace.X,
            y2: ISO_32000.UserSpace.Y,
            x3: ISO_32000.UserSpace.X,
            y3: ISO_32000.UserSpace.Y
        ) {
            emit(.curveTo(x1: x1, y1: y1, x2: x2, y2: y2, x3: x3, y3: y3))
        }

        /// Append a rectangle (re)
        public mutating func rectangle(
            x: ISO_32000.UserSpace.X,
            y: ISO_32000.UserSpace.Y,
            width: ISO_32000.UserSpace.Width,
            height: ISO_32000.UserSpace.Height
        ) {
            emit(.rectangle(x: x, y: y, width: width, height: height))
        }

        /// Close the current subpath (h)
        public mutating func closePath() {
            emit(.closePath)
        }

        // MARK: - Path Painting Operators

        /// Stroke the path (S)
        public mutating func stroke() {
            emit(.stroke)
        }

        /// Close and stroke (s)
        public mutating func closeAndStroke() {
            emit(.closeAndStroke)
        }

        /// Fill the path using non-zero winding rule (f)
        public mutating func fill() {
            emit(.fill)
        }

        /// Fill the path using even-odd rule (f*)
        public mutating func fillEvenOdd() {
            emit(.fillEvenOdd)
        }

        /// Fill and stroke (B)
        public mutating func fillAndStroke() {
            emit(.fillAndStroke)
        }

        /// End path without filling or stroking (n)
        public mutating func endPath() {
            emit(.endPath)
        }

        // MARK: - Clipping Operators

        /// Clip using non-zero winding rule (W)
        public mutating func clip() {
            emit(.clip)
        }

        /// Clip using even-odd rule (W*)
        public mutating func clipEvenOdd() {
            emit(.clipEvenOdd)
        }

        // MARK: - Text Operators

        /// Begin text object (BT)
        public mutating func beginText() {
            emit(.beginText)
        }

        /// End text object (ET)
        public mutating func endText() {
            emit(.endText)
        }

        /// Set text font and size (Tf)
        public mutating func setFont(_ font: ISO_32000.Font, size: ISO_32000.UserSpace.Size<1>) {
            fontsUsed.insert(font)
            emit(.setFont(name: font.resourceName, size: size))
        }

        /// Move text position by displacement (Td)
        public mutating func moveText(
            dx: ISO_32000.UserSpace.Dx,
            dy: ISO_32000.UserSpace.Dy
        ) {
            emit(.moveTextPosition(tx: dx, ty: dy))
        }

        /// Move text position by displacement and set leading (TD)
        public mutating func moveTextWithLeading(
            dx: ISO_32000.UserSpace.Dx,
            dy: ISO_32000.UserSpace.Dy
        ) {
            emit(.moveTextPositionWithLeading(tx: dx, ty: dy))
        }

        /// Set text matrix (Tm)
        ///
        /// - Parameters:
        ///   - a, b, c, d: Dimensionless scale/rotation coefficients
        ///   - e, f: Translation (displacement) in user space units
        public mutating func setTextMatrix(
            a: Scale<1, Double>,
            b: Scale<1, Double>,
            c: Scale<1, Double>,
            d: Scale<1, Double>,
            e: ISO_32000.UserSpace.Dx,
            f: ISO_32000.UserSpace.Dy
        ) {
            emit(.setTextMatrix(a: a, b: b, c: c, d: d, e: e, f: f))
        }

        /// Move to next line (T*)
        public mutating func nextLine() {
            emit(.nextLine)
        }

        /// Show pre-encoded text bytes (Tj)
        ///
        /// This is the primitive form - bytes are emitted directly as a PDF literal string.
        public mutating func showText(_ bytes: [UInt8]) {
            emit(.showText(bytes))
        }

        /// Show text string (Tj) - convenience overload that encodes to WinAnsi
        ///
        /// Encodes the string using WinAnsiEncoding (for Standard 14 fonts).
        /// Characters not in WinAnsiEncoding are replaced with `?`.
        public mutating func showText(_ text: String) {
            let bytes = [UInt8](winAnsi: text, withFallback: true)
            emit(.showText(bytes))
        }

        /// Set text leading (TL)
        public mutating func setTextLeading(_ leading: ISO_32000.UserSpace.Height) {
            emit(.setTextLeading(leading))
        }

        /// Set character spacing (Tc)
        public mutating func setCharacterSpacing(_ spacing: ISO_32000.UserSpace.Width) {
            emit(.setCharacterSpacing(spacing))
        }

        /// Set word spacing (Tw)
        public mutating func setWordSpacing(_ spacing: ISO_32000.UserSpace.Width) {
            emit(.setWordSpacing(spacing))
        }

        /// Set horizontal scaling (Tz)
        ///
        /// Scale is a percentage (100 = normal).
        public mutating func setHorizontalScaling(_ scale: Scale<1, Double>) {
            emit(.setHorizontalScaling(scale))
        }

        /// Set text rise (Ts)
        public mutating func setTextRise(_ rise: ISO_32000.UserSpace.Y) {
            emit(.setTextRise(rise))
        }

        // MARK: - Line Style Operators

        /// Set line width (w)
        public mutating func setLineWidth(_ width: ISO_32000.UserSpace.Width) {
            emit(.setLineWidth(width))
        }

        /// Set line cap style (J)
        public mutating func setLineCap(_ cap: LineCap) {
            emit(.setLineCap(cap))
        }

        /// Set line join style (j)
        public mutating func setLineJoin(_ join: LineJoin) {
            emit(.setLineJoin(join))
        }

        /// Set miter limit (M)
        public mutating func setMiterLimit(_ limit: ISO_32000.UserSpace.Width) {
            emit(.setMiterLimit(limit))
        }

        /// Set dash pattern (d)
        public mutating func setDashPattern(
            array: [ISO_32000.UserSpace.Width],
            phase: ISO_32000.UserSpace.Width
        ) {
            emit(.setDashPattern(array: array, phase: phase))
        }

        // MARK: - Marked Content Operators (Section 14.6)

        /// Begin marked-content sequence (BMC)
        ///
        /// Use this for simple structure tags without properties.
        public mutating func beginMarkedContent(tag: ISO_32000.COS.Name) {
            emit(.beginMarkedContent(tag: tag))
        }

        /// Begin marked-content sequence with properties (BDC)
        ///
        /// Use this when the structure element has attributes (e.g., RowSpan, ColSpan).
        public mutating func beginMarkedContent(
            tag: ISO_32000.COS.Name,
            properties: ISO_32000.COS.Dictionary
        ) {
            emit(.beginMarkedContentWithProperties(tag: tag, properties: properties))
        }

        /// End marked-content sequence (EMC)
        public mutating func endMarkedContent() {
            emit(.endMarkedContent)
        }

        /// Begin marked-content span with ActualText for text extraction (BDC)
        ///
        /// Per ISO 32000-2:2020, Section 14.9.4 (Replacement Text):
        /// > The ActualText entry in the property list of a marked-content sequence,
        /// > or in the structure element dictionary of a structure element that contains
        /// > marked content, provides an alternate description of the marked content
        /// > for extraction and accessibility purposes.
        ///
        /// Use this to provide semantic text that should be extracted when copying,
        /// while allowing the visual representation to differ (e.g., word-wrapped lines).
        ///
        /// - Parameter actualText: The text that should be extracted when copying from the PDF
        public mutating func beginActualTextSpan(_ actualText: String) {
            let properties: ISO_32000.COS.Dictionary = [
                .actualText: .string(actualText)
            ]
            emit(.beginMarkedContentWithProperties(tag: .span, properties: properties))
        }

        /// End marked-content span (convenience alias for endMarkedContent)
        public mutating func endActualTextSpan() {
            emit(.endMarkedContent)
        }

        // MARK: - UserSpace Type Overloads

        /// Set transformation matrix from an AffineTransform (cm)
        ///
        /// Note: AffineTransform's a,b,c,d are dimensionless Scale coefficients,
        /// while tx,ty are actual spatial translations (displacements).
        public mutating func transform(_ t: ISO_32000.UserSpace.AffineTransform) {
            emit(
                .transform(
                    a: t.a,
                    b: t.b,
                    c: t.c,
                    d: t.d,
                    e: t.tx,
                    f: t.ty
                )
            )
        }

        /// Rotate by angle in radians (convenience wrapper for cm)
        public mutating func rotate(_ angle: Radian<Double>) {
            emit(
                .transform(
                    a: angle.cos,
                    b: angle.sin,
                    c: -angle.sin,
                    d: angle.cos,
                    e: .init(0),
                    f: .init(0)
                )
            )
        }

        /// Rotate by angle in degrees (convenience wrapper for cm)
        public mutating func rotate(_ angle: Degree<Double>) {
            rotate(angle.radians)
        }

        /// Translate by a vector (convenience wrapper for cm)
        public mutating func translate(_ vector: ISO_32000.UserSpace.Vector<2>) {
            emit(.transform(a: 1, b: 0, c: 0, d: 1, e: vector.dx, f: vector.dy))
        }

        /// Begin a new subpath at a point (m)
        public mutating func moveTo(_ point: ISO_32000.UserSpace.Coordinate) {
            emit(.moveTo(x: point.x, y: point.y))
        }

        /// Append a line segment to a point (l)
        public mutating func lineTo(_ point: ISO_32000.UserSpace.Coordinate) {
            emit(.lineTo(x: point.x, y: point.y))
        }

        /// Append a cubic Bezier curve with control points (c)
        public mutating func curveTo(
            control1: ISO_32000.UserSpace.Coordinate,
            control2: ISO_32000.UserSpace.Coordinate,
            end: ISO_32000.UserSpace.Coordinate
        ) {
            emit(
                .curveTo(
                    x1: control1.x,
                    y1: control1.y,
                    x2: control2.x,
                    y2: control2.y,
                    x3: end.x,
                    y3: end.y
                )
            )
        }

        /// Append a rectangle (re)
        public mutating func rectangle(_ rect: ISO_32000.UserSpace.Rectangle) {
            emit(
                .rectangle(
                    x: rect.origin.x,
                    y: rect.origin.y,
                    width: rect.width,
                    height: rect.height
                )
            )
        }

        /// Append a circle path using 4 cubic Bézier curves.
        ///
        /// Uses the Circle's built-in Bézier approximation with constant k ≈ 0.5522847498.
        ///
        /// - Parameter circle: The circle to draw (from Geometry package)
        public mutating func circle(_ circle: ISO_32000.UserSpace.Circle) {
            let start = circle.bezierStartPoint
            emit(.moveTo(x: start.x, y: start.y))

            for segment in circle.bezierCurves {
                emit(
                    .curveTo(
                        x1: segment.control1.x,
                        y1: segment.control1.y,
                        x2: segment.control2.x,
                        y2: segment.control2.y,
                        x3: segment.end.x,
                        y3: segment.end.y
                    )
                )
            }

            emit(.closePath)
        }

        /// Move text position by a displacement vector (Td)
        public mutating func moveText(_ displacement: ISO_32000.UserSpace.Vector<2>) {
            emit(.moveTextPosition(tx: displacement.dx, ty: displacement.dy))
        }

        /// Set text matrix from an AffineTransform (Tm)
        public mutating func setTextMatrix(_ t: ISO_32000.UserSpace.AffineTransform) {
            emit(
                .setTextMatrix(
                    a: t.a,
                    b: t.b,
                    c: t.c,
                    d: t.d,
                    e: t.tx,
                    f: t.ty
                )
            )
        }
    }
}

// MARK: - Line Style Types

extension ISO_32000.ContentStream {
    /// Line cap styles
    public enum LineCap: Int, Sendable {
        case butt = 0
        case round = 1
        case square = 2
    }

    /// Line join styles
    public enum LineJoin: Int, Sendable {
        case miter = 0
        case round = 1
        case bevel = 2
    }
}

// MARK: - Binary.Serializable

extension ISO_32000.ContentStream: Binary.Serializable {
    /// Serialize content stream data to bytes
    ///
    /// Streams the raw content stream data directly to the buffer.
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ stream: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        buffer.append(contentsOf: stream.data)
    }
}
