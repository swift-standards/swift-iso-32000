// ISO_32000.ContentStream.swift

import ISO_9899
import Standards
public import Geometry

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
        ///   - e, f: Translation in user space units
        public mutating func transform(
            a: Double,
            b: Double,
            c: Double,
            d: Double,
            e: ISO_32000.UserSpace.X,
            f: ISO_32000.UserSpace.Y
        ) {
            emit(.transform(a: a, b: b, c: c, d: d, e: e, f: f))
        }

        /// Translate (convenience wrapper for cm)
        public mutating func translate(x: ISO_32000.UserSpace.X, y: ISO_32000.UserSpace.Y) {
            emit(.transform(a: 1, b: 0, c: 0, d: 1, e: x, f: y))
        }

        /// Scale (convenience wrapper for cm)
        ///
        /// Scale factors are dimensionless multipliers.
        public mutating func scale(x: Double, y: Double) {
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
            x1: ISO_32000.UserSpace.X, y1: ISO_32000.UserSpace.Y,
            x2: ISO_32000.UserSpace.X, y2: ISO_32000.UserSpace.Y,
            x3: ISO_32000.UserSpace.X, y3: ISO_32000.UserSpace.Y
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
        public mutating func setFont(_ font: ISO_32000.Font, size: ISO_32000.UserSpace.Unit) {
            fontsUsed.insert(font)
            emit(.setFont(name: font.resourceName, size: size))
        }

        /// Move text position (Td)
        public mutating func moveText(x: ISO_32000.UserSpace.X, y: ISO_32000.UserSpace.Y) {
            emit(.moveTextPosition(tx: x, ty: y))
        }

        /// Move to next line with leading (TD)
        public mutating func moveTextWithLeading(x: ISO_32000.UserSpace.X, y: ISO_32000.UserSpace.Y) {
            emit(.moveTextPositionWithLeading(tx: x, ty: y))
        }

        /// Set text matrix (Tm)
        ///
        /// - Parameters:
        ///   - a, b, c, d: Dimensionless scale/rotation coefficients
        ///   - e, f: Translation in user space units
        public mutating func setTextMatrix(
            a: Double, b: Double, c: Double, d: Double,
            e: ISO_32000.UserSpace.X, f: ISO_32000.UserSpace.Y
        ) {
            emit(.setTextMatrix(a: a, b: b, c: c, d: d, e: e, f: f))
        }

        /// Move to next line (T*)
        public mutating func nextLine() {
            emit(.nextLine)
        }

        /// Show text string (Tj)
        public mutating func showText(_ text: String) {
            emit(.showText(ISO_32000.COS.StringValue(text)))
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
        public mutating func setHorizontalScaling(_ scale: Double) {
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
        public mutating func setDashPattern(array: [ISO_32000.UserSpace.Width], phase: ISO_32000.UserSpace.Width) {
            emit(.setDashPattern(array: array, phase: phase))
        }

        // MARK: - UserSpace Type Overloads

        /// Set transformation matrix from an AffineTransform (cm)
        ///
        /// Note: AffineTransform's a,b,c,d are dimensionless coefficients (stored as UserSpace.Unit
        /// for type uniformity), while tx,ty are actual spatial translations.
        public mutating func transform(_ t: ISO_32000.UserSpace.AffineTransform) {
            emit(.transform(a: t.a.value, b: t.b.value, c: t.c.value, d: t.d.value, e: t.tx, f: t.ty))
        }

        /// Rotate by angle in radians (convenience wrapper for cm)
        public mutating func rotate(_ angle: Radian) {
            emit(.transform(a: angle.cos, b: angle.sin, c: -angle.sin, d: angle.cos, e: .init(0), f: .init(0)))
        }

        /// Rotate by angle in degrees (convenience wrapper for cm)
        public mutating func rotate(_ angle: Degree) {
            rotate(angle.radians)
        }

        /// Translate by a vector (convenience wrapper for cm)
        public mutating func translate(_ vector: ISO_32000.UserSpace.Vector) {
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
            emit(.curveTo(
                x1: control1.x, y1: control1.y,
                x2: control2.x, y2: control2.y,
                x3: end.x, y3: end.y
            ))
        }

        /// Append a rectangle (re)
        public mutating func rectangle(_ rect: ISO_32000.UserSpace.Rectangle) {
            emit(.rectangle(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height))
        }

        /// Move text position to a point (Td)
        public mutating func moveText(_ position: ISO_32000.UserSpace.Coordinate) {
            emit(.moveTextPosition(tx: position.x, ty: position.y))
        }

        /// Set text matrix from an AffineTransform (Tm)
        public mutating func setTextMatrix(_ t: ISO_32000.UserSpace.AffineTransform) {
            emit(.setTextMatrix(a: t.a.value, b: t.b.value, c: t.c.value, d: t.d.value, e: t.tx, f: t.ty))
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

// MARK: - UInt8.Serializable

extension ISO_32000.ContentStream: UInt8.Serializable {
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
