// ISO_32000.ContentStream.swift

import ISO_9899

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
        public mutating func transform(
            a: Double, b: Double, c: Double, d: Double, e: Double, f: Double
        ) {
            emit(.transform(a: a, b: b, c: c, d: d, e: e, f: f))
        }

        /// Translate (convenience wrapper for cm)
        public mutating func translate(x: Double, y: Double) {
            emit(.transform(a: 1, b: 0, c: 0, d: 1, e: x, f: y))
        }

        /// Scale (convenience wrapper for cm)
        public mutating func scale(x: Double, y: Double) {
            emit(.transform(a: x, b: 0, c: 0, d: y, e: 0, f: 0))
        }

        /// Rotate (convenience wrapper for cm)
        public mutating func rotate(angle: Double) {
            let cos_a = angle.c.cos
            let sin_a = angle.c.sin
            emit(.transform(a: cos_a, b: sin_a, c: -sin_a, d: cos_a, e: 0, f: 0))
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

        // MARK: - Path Construction Operators

        /// Begin a new subpath (m)
        public mutating func moveTo(x: Double, y: Double) {
            emit(.moveTo(x: x, y: y))
        }

        /// Append a line segment (l)
        public mutating func lineTo(x: Double, y: Double) {
            emit(.lineTo(x: x, y: y))
        }

        /// Append a cubic Bezier curve (c)
        public mutating func curveTo(
            x1: Double, y1: Double,
            x2: Double, y2: Double,
            x3: Double, y3: Double
        ) {
            emit(.curveTo(x1: x1, y1: y1, x2: x2, y2: y2, x3: x3, y3: y3))
        }

        /// Append a rectangle (re)
        public mutating func rectangle(x: Double, y: Double, width: Double, height: Double) {
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
        public mutating func setFont(_ font: ISO_32000.Font, size: Double) {
            fontsUsed.insert(font)
            emit(.setFont(name: font.resourceName, size: size))
        }

        /// Move text position (Td)
        public mutating func moveText(x: Double, y: Double) {
            emit(.moveTextPosition(tx: x, ty: y))
        }

        /// Move to next line with leading (TD)
        public mutating func moveTextWithLeading(x: Double, y: Double) {
            emit(.moveTextPositionWithLeading(tx: x, ty: y))
        }

        /// Set text matrix (Tm)
        public mutating func setTextMatrix(
            a: Double, b: Double, c: Double, d: Double, e: Double, f: Double
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
        public mutating func setTextLeading(_ leading: Double) {
            emit(.setTextLeading(leading))
        }

        /// Set character spacing (Tc)
        public mutating func setCharacterSpacing(_ spacing: Double) {
            emit(.setCharacterSpacing(spacing))
        }

        /// Set word spacing (Tw)
        public mutating func setWordSpacing(_ spacing: Double) {
            emit(.setWordSpacing(spacing))
        }

        /// Set horizontal scaling (Tz)
        public mutating func setHorizontalScaling(_ scale: Double) {
            emit(.setHorizontalScaling(scale))
        }

        /// Set text rise (Ts)
        public mutating func setTextRise(_ rise: Double) {
            emit(.setTextRise(rise))
        }

        // MARK: - Line Style Operators

        /// Set line width (w)
        public mutating func setLineWidth(_ width: Double) {
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
        public mutating func setMiterLimit(_ limit: Double) {
            emit(.setMiterLimit(limit))
        }

        /// Set dash pattern (d)
        public mutating func setDashPattern(array: [Double], phase: Double) {
            emit(.setDashPattern(array: array, phase: phase))
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
