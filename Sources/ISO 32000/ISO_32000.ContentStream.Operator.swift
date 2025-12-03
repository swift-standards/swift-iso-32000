// ISO_32000.ContentStream.Operator.swift

extension ISO_32000.ContentStream {
    /// PDF Content Stream Operator
    ///
    /// Represents all PDF graphics operators per ISO 32000-1 Section 8-9.
    /// Each case corresponds to a specific PDF operator.
    package enum Operator: Sendable, Equatable {
        // MARK: - Graphics State (Section 8.4.4)

        /// Push graphics state (q)
        case saveState

        /// Pop graphics state (Q)
        case restoreState

        /// Set transformation matrix (a b c d e f cm)
        case transform(a: Double, b: Double, c: Double, d: Double, e: Double, f: Double)

        // MARK: - Color (Section 8.6)

        /// Set stroking color in DeviceGray (gray G)
        case setStrokeGray(Double)

        /// Set non-stroking color in DeviceGray (gray g)
        case setFillGray(Double)

        /// Set stroking color in DeviceRGB (r g b RG)
        case setStrokeRGB(r: Double, g: Double, b: Double)

        /// Set non-stroking color in DeviceRGB (r g b rg)
        case setFillRGB(r: Double, g: Double, b: Double)

        /// Set stroking color in DeviceCMYK (c m y k K)
        case setStrokeCMYK(c: Double, m: Double, y: Double, k: Double)

        /// Set non-stroking color in DeviceCMYK (c m y k k)
        case setFillCMYK(c: Double, m: Double, y: Double, k: Double)

        // MARK: - Path Construction (Section 8.5.2)

        /// Begin new subpath (x y m)
        case moveTo(x: Double, y: Double)

        /// Append line segment (x y l)
        case lineTo(x: Double, y: Double)

        /// Append cubic Bezier curve (x1 y1 x2 y2 x3 y3 c)
        case curveTo(x1: Double, y1: Double, x2: Double, y2: Double, x3: Double, y3: Double)

        /// Append rectangle (x y width height re)
        case rectangle(x: Double, y: Double, width: Double, height: Double)

        /// Close current subpath (h)
        case closePath

        // MARK: - Path Painting (Section 8.5.3)

        /// Stroke the path (S)
        case stroke

        /// Close and stroke (s)
        case closeAndStroke

        /// Fill using non-zero winding rule (f)
        case fill

        /// Fill using even-odd rule (f*)
        case fillEvenOdd

        /// Fill and stroke (B)
        case fillAndStroke

        /// End path without painting (n)
        case endPath

        // MARK: - Clipping (Section 8.5.4)

        /// Clip using non-zero winding rule (W)
        case clip

        /// Clip using even-odd rule (W*)
        case clipEvenOdd

        // MARK: - Text State (Section 9.3)

        /// Begin text object (BT)
        case beginText

        /// End text object (ET)
        case endText

        /// Set text font and size (/name size Tf)
        case setFont(name: ISO_32000.COS.Name, size: Double)

        /// Set text leading (leading TL)
        case setTextLeading(Double)

        /// Set character spacing (spacing Tc)
        case setCharacterSpacing(Double)

        /// Set word spacing (spacing Tw)
        case setWordSpacing(Double)

        /// Set horizontal scaling (scale Tz)
        case setHorizontalScaling(Double)

        /// Set text rise (rise Ts)
        case setTextRise(Double)

        // MARK: - Text Positioning (Section 9.4.2)

        /// Move text position (tx ty Td)
        case moveTextPosition(tx: Double, ty: Double)

        /// Move text position and set leading (tx ty TD)
        case moveTextPositionWithLeading(tx: Double, ty: Double)

        /// Set text matrix (a b c d e f Tm)
        case setTextMatrix(a: Double, b: Double, c: Double, d: Double, e: Double, f: Double)

        /// Move to next line (T*)
        case nextLine

        // MARK: - Text Showing (Section 9.4.3)

        /// Show text string (string Tj)
        case showText(ISO_32000.COS.StringValue)

        // MARK: - Line Style (Section 8.4.3)

        /// Set line width (width w)
        case setLineWidth(Double)

        /// Set line cap style (cap J)
        case setLineCap(LineCap)

        /// Set line join style (join j)
        case setLineJoin(LineJoin)

        /// Set miter limit (limit M)
        case setMiterLimit(Double)

        /// Set dash pattern ([array] phase d)
        case setDashPattern(array: [Double], phase: Double)
    }
}

// MARK: - Operator Serialization

extension ISO_32000.ContentStream.Operator {
    /// Serialize this operator into a byte buffer
    package func serialize<Buffer: RangeReplaceableCollection>(
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        switch self {
        // Graphics State
        case .saveState:
            buffer.append(contentsOf: "q".utf8)

        case .restoreState:
            buffer.append(contentsOf: "Q".utf8)

        case .transform(let a, let b, let c, let d, let e, let f):
            buffer.append(contentsOf: "\(formatNumber(a)) \(formatNumber(b)) \(formatNumber(c)) \(formatNumber(d)) \(formatNumber(e)) \(formatNumber(f)) cm".utf8)

        // Color
        case .setStrokeGray(let gray):
            buffer.append(contentsOf: "\(formatNumber(gray)) G".utf8)

        case .setFillGray(let gray):
            buffer.append(contentsOf: "\(formatNumber(gray)) g".utf8)

        case .setStrokeRGB(let r, let g, let b):
            buffer.append(contentsOf: "\(formatNumber(r)) \(formatNumber(g)) \(formatNumber(b)) RG".utf8)

        case .setFillRGB(let r, let g, let b):
            buffer.append(contentsOf: "\(formatNumber(r)) \(formatNumber(g)) \(formatNumber(b)) rg".utf8)

        case .setStrokeCMYK(let c, let m, let y, let k):
            buffer.append(contentsOf: "\(formatNumber(c)) \(formatNumber(m)) \(formatNumber(y)) \(formatNumber(k)) K".utf8)

        case .setFillCMYK(let c, let m, let y, let k):
            buffer.append(contentsOf: "\(formatNumber(c)) \(formatNumber(m)) \(formatNumber(y)) \(formatNumber(k)) k".utf8)

        // Path Construction
        case .moveTo(let x, let y):
            buffer.append(contentsOf: "\(formatNumber(x)) \(formatNumber(y)) m".utf8)

        case .lineTo(let x, let y):
            buffer.append(contentsOf: "\(formatNumber(x)) \(formatNumber(y)) l".utf8)

        case .curveTo(let x1, let y1, let x2, let y2, let x3, let y3):
            buffer.append(contentsOf: "\(formatNumber(x1)) \(formatNumber(y1)) \(formatNumber(x2)) \(formatNumber(y2)) \(formatNumber(x3)) \(formatNumber(y3)) c".utf8)

        case .rectangle(let x, let y, let width, let height):
            buffer.append(contentsOf: "\(formatNumber(x)) \(formatNumber(y)) \(formatNumber(width)) \(formatNumber(height)) re".utf8)

        case .closePath:
            buffer.append(contentsOf: "h".utf8)

        // Path Painting
        case .stroke:
            buffer.append(contentsOf: "S".utf8)

        case .closeAndStroke:
            buffer.append(contentsOf: "s".utf8)

        case .fill:
            buffer.append(contentsOf: "f".utf8)

        case .fillEvenOdd:
            buffer.append(contentsOf: "f*".utf8)

        case .fillAndStroke:
            buffer.append(contentsOf: "B".utf8)

        case .endPath:
            buffer.append(contentsOf: "n".utf8)

        // Clipping
        case .clip:
            buffer.append(contentsOf: "W".utf8)

        case .clipEvenOdd:
            buffer.append(contentsOf: "W*".utf8)

        // Text State
        case .beginText:
            buffer.append(contentsOf: "BT".utf8)

        case .endText:
            buffer.append(contentsOf: "ET".utf8)

        case .setFont(let name, let size):
            buffer.append(contentsOf: "/\(name.rawValue) \(formatNumber(size)) Tf".utf8)

        case .setTextLeading(let leading):
            buffer.append(contentsOf: "\(formatNumber(leading)) TL".utf8)

        case .setCharacterSpacing(let spacing):
            buffer.append(contentsOf: "\(formatNumber(spacing)) Tc".utf8)

        case .setWordSpacing(let spacing):
            buffer.append(contentsOf: "\(formatNumber(spacing)) Tw".utf8)

        case .setHorizontalScaling(let scale):
            buffer.append(contentsOf: "\(formatNumber(scale)) Tz".utf8)

        case .setTextRise(let rise):
            buffer.append(contentsOf: "\(formatNumber(rise)) Ts".utf8)

        // Text Positioning
        case .moveTextPosition(let tx, let ty):
            buffer.append(contentsOf: "\(formatNumber(tx)) \(formatNumber(ty)) Td".utf8)

        case .moveTextPositionWithLeading(let tx, let ty):
            buffer.append(contentsOf: "\(formatNumber(tx)) \(formatNumber(ty)) TD".utf8)

        case .setTextMatrix(let a, let b, let c, let d, let e, let f):
            buffer.append(contentsOf: "\(formatNumber(a)) \(formatNumber(b)) \(formatNumber(c)) \(formatNumber(d)) \(formatNumber(e)) \(formatNumber(f)) Tm".utf8)

        case .nextLine:
            buffer.append(contentsOf: "T*".utf8)

        // Text Showing
        case .showText(let string):
            buffer.append(contentsOf: string.asLiteral())
            buffer.append(contentsOf: " Tj".utf8)

        // Line Style
        case .setLineWidth(let width):
            buffer.append(contentsOf: "\(formatNumber(width)) w".utf8)

        case .setLineCap(let cap):
            buffer.append(contentsOf: "\(cap.rawValue) J".utf8)

        case .setLineJoin(let join):
            buffer.append(contentsOf: "\(join.rawValue) j".utf8)

        case .setMiterLimit(let limit):
            buffer.append(contentsOf: "\(formatNumber(limit)) M".utf8)

        case .setDashPattern(let array, let phase):
            let arrayStr = array.map { formatNumber($0) }.joined(separator: " ")
            buffer.append(contentsOf: "[\(arrayStr)] \(formatNumber(phase)) d".utf8)
        }
    }

    /// Format a number for PDF output
    private func formatNumber(_ value: Double) -> String {
        if value == value.rounded() && abs(value) < 1e9 {
            return String(Int(value))
        }

        let isNegative = value < 0
        let absValue = abs(value)
        let intPart = Int64(absValue)
        let fracPart = absValue - Double(intPart)

        let fracDigits = Int64((fracPart * 10_000).rounded())

        var result = isNegative ? "-" : ""
        result += String(intPart)

        if fracDigits != 0 {
            result += "."
            var fracStr = String(fracDigits)
            while fracStr.count < 4 {
                fracStr = "0" + fracStr
            }
            while fracStr.hasSuffix("0") {
                fracStr.removeLast()
            }
            result += fracStr
        }

        return result
    }
}
