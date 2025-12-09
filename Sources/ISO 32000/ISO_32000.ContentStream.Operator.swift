// ISO_32000.ContentStream.Operator.swift

import Geometry
import Formatting
import ISO_32000_7_Syntax

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
        ///
        /// - Parameters:
        ///   - a, b, c, d: Dimensionless scale/rotation coefficients
        ///   - e, f: Translation in user space units
        case transform(
            a: Double,
            b: Double,
            c: Double,
            d: Double,
            e: ISO_32000.UserSpace.X,
            f: ISO_32000.UserSpace.Y
        )

        // MARK: - Color (Section 8.6)

        /// Set stroking color in DeviceGray (gray G)
        /// Value is normalized 0-1
        case setStrokeGray(Double)

        /// Set non-stroking color in DeviceGray (gray g)
        /// Value is normalized 0-1
        case setFillGray(Double)

        /// Set stroking color in DeviceRGB (r g b RG)
        /// Values are normalized 0-1
        case setStrokeRGB(r: Double, g: Double, b: Double)

        /// Set non-stroking color in DeviceRGB (r g b rg)
        /// Values are normalized 0-1
        case setFillRGB(r: Double, g: Double, b: Double)

        /// Set stroking color in DeviceCMYK (c m y k K)
        /// Values are normalized 0-1
        case setStrokeCMYK(c: Double, m: Double, y: Double, k: Double)

        /// Set non-stroking color in DeviceCMYK (c m y k k)
        /// Values are normalized 0-1
        case setFillCMYK(c: Double, m: Double, y: Double, k: Double)

        // MARK: - Path Construction (Section 8.5.2)

        /// Begin new subpath (x y m)
        case moveTo(x: ISO_32000.UserSpace.X, y: ISO_32000.UserSpace.Y)

        /// Append line segment (x y l)
        case lineTo(x: ISO_32000.UserSpace.X, y: ISO_32000.UserSpace.Y)

        /// Append cubic Bezier curve (x1 y1 x2 y2 x3 y3 c)
        case curveTo(
            x1: ISO_32000.UserSpace.X, y1: ISO_32000.UserSpace.Y,
            x2: ISO_32000.UserSpace.X, y2: ISO_32000.UserSpace.Y,
            x3: ISO_32000.UserSpace.X, y3: ISO_32000.UserSpace.Y
        )

        /// Append rectangle (x y width height re)
        case rectangle(
            x: ISO_32000.UserSpace.X,
            y: ISO_32000.UserSpace.Y,
            width: ISO_32000.UserSpace.Width,
            height: ISO_32000.UserSpace.Height
        )

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
        case setFont(name: ISO_32000.COS.Name, size: ISO_32000.UserSpace.Unit)

        /// Set text leading (leading TL)
        case setTextLeading(ISO_32000.UserSpace.Height)

        /// Set character spacing (spacing Tc)
        case setCharacterSpacing(ISO_32000.UserSpace.Width)

        /// Set word spacing (spacing Tw)
        case setWordSpacing(ISO_32000.UserSpace.Width)

        /// Set horizontal scaling (scale Tz)
        /// This is a percentage (100 = normal), dimensionless
        case setHorizontalScaling(Double)

        /// Set text rise (rise Ts)
        case setTextRise(ISO_32000.UserSpace.Y)

        // MARK: - Text Positioning (Section 9.4.2)

        /// Move text position (tx ty Td)
        case moveTextPosition(tx: ISO_32000.UserSpace.X, ty: ISO_32000.UserSpace.Y)

        /// Move text position and set leading (tx ty TD)
        case moveTextPositionWithLeading(tx: ISO_32000.UserSpace.X, ty: ISO_32000.UserSpace.Y)

        /// Set text matrix (a b c d e f Tm)
        ///
        /// - Parameters:
        ///   - a, b, c, d: Dimensionless scale/rotation coefficients
        ///   - e, f: Translation in user space units
        case setTextMatrix(
            a: Double,
            b: Double,
            c: Double,
            d: Double,
            e: ISO_32000.UserSpace.X,
            f: ISO_32000.UserSpace.Y
        )

        /// Move to next line (T*)
        case nextLine

        // MARK: - Text Showing (Section 9.4.3)

        /// Show text string (string Tj)
        case showText(ISO_32000.COS.StringValue)

        // MARK: - Line Style (Section 8.4.3)

        /// Set line width (width w)
        case setLineWidth(ISO_32000.UserSpace.Width)

        /// Set line cap style (cap J)
        case setLineCap(LineCap)

        /// Set line join style (join j)
        case setLineJoin(LineJoin)

        /// Set miter limit (limit M)
        case setMiterLimit(ISO_32000.UserSpace.Width)

        /// Set dash pattern ([array] phase d)
        case setDashPattern(array: [ISO_32000.UserSpace.Width], phase: ISO_32000.UserSpace.Width)
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
            buffer.append(contentsOf: "\(a.formatted(.pdf)) \(b.formatted(.pdf)) \(c.formatted(.pdf)) \(d.formatted(.pdf)) \(e.formatted(.pdf)) \(f.formatted(.pdf)) cm".utf8)

        // Color
        case .setStrokeGray(let gray):
            buffer.append(contentsOf: "\(gray.formatted(.pdf)) G".utf8)

        case .setFillGray(let gray):
            buffer.append(contentsOf: "\(gray.formatted(.pdf)) g".utf8)

        case .setStrokeRGB(let r, let g, let b):
            buffer.append(contentsOf: "\(r.formatted(.pdf)) \(g.formatted(.pdf)) \(b.formatted(.pdf)) RG".utf8)

        case .setFillRGB(let r, let g, let b):
            buffer.append(contentsOf: "\(r.formatted(.pdf)) \(g.formatted(.pdf)) \(b.formatted(.pdf)) rg".utf8)

        case .setStrokeCMYK(let c, let m, let y, let k):
            buffer.append(contentsOf: "\(c.formatted(.pdf)) \(m.formatted(.pdf)) \(y.formatted(.pdf)) \(k.formatted(.pdf)) K".utf8)

        case .setFillCMYK(let c, let m, let y, let k):
            buffer.append(contentsOf: "\(c.formatted(.pdf)) \(m.formatted(.pdf)) \(y.formatted(.pdf)) \(k.formatted(.pdf)) k".utf8)

        // Path Construction
        case .moveTo(let x, let y):
            buffer.append(contentsOf: "\(x.formatted(.pdf)) \(y.formatted(.pdf)) m".utf8)

        case .lineTo(let x, let y):
            buffer.append(contentsOf: "\(x.formatted(.pdf)) \(y.formatted(.pdf)) l".utf8)

        case .curveTo(let x1, let y1, let x2, let y2, let x3, let y3):
            buffer.append(contentsOf: "\(x1.formatted(.pdf)) \(y1.formatted(.pdf)) \(x2.formatted(.pdf)) \(y2.formatted(.pdf)) \(x3.formatted(.pdf)) \(y3.formatted(.pdf)) c".utf8)

        case .rectangle(let x, let y, let width, let height):
            buffer.append(contentsOf: "\(x.formatted(.pdf)) \(y.formatted(.pdf)) \(width.formatted(.pdf)) \(height.formatted(.pdf)) re".utf8)

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
            buffer.append(contentsOf: "/\(name.rawValue) \(size.formatted(.pdf)) Tf".utf8)

        case .setTextLeading(let leading):
            buffer.append(contentsOf: "\(leading.formatted(.pdf)) TL".utf8)

        case .setCharacterSpacing(let spacing):
            buffer.append(contentsOf: "\(spacing.formatted(.pdf)) Tc".utf8)

        case .setWordSpacing(let spacing):
            buffer.append(contentsOf: "\(spacing.formatted(.pdf)) Tw".utf8)

        case .setHorizontalScaling(let scale):
            buffer.append(contentsOf: "\(scale.formatted(.pdf)) Tz".utf8)

        case .setTextRise(let rise):
            buffer.append(contentsOf: "\(rise.formatted(.pdf)) Ts".utf8)

        // Text Positioning
        case .moveTextPosition(let tx, let ty):
            buffer.append(contentsOf: "\(tx.formatted(.pdf)) \(ty.formatted(.pdf)) Td".utf8)

        case .moveTextPositionWithLeading(let tx, let ty):
            buffer.append(contentsOf: "\(tx.formatted(.pdf)) \(ty.formatted(.pdf)) TD".utf8)

        case .setTextMatrix(let a, let b, let c, let d, let e, let f):
            buffer.append(contentsOf: "\(a.formatted(.pdf)) \(b.formatted(.pdf)) \(c.formatted(.pdf)) \(d.formatted(.pdf)) \(e.formatted(.pdf)) \(f.formatted(.pdf)) Tm".utf8)

        case .nextLine:
            buffer.append(contentsOf: "T*".utf8)

        // Text Showing
        case .showText(let string):
            // Use WinAnsiEncoding for Standard 14 fonts
            buffer.append(contentsOf: string.asLiteralWinAnsi())
            buffer.append(contentsOf: " Tj".utf8)

        // Line Style
        case .setLineWidth(let width):
            buffer.append(contentsOf: "\(width.formatted(.pdf)) w".utf8)

        case .setLineCap(let cap):
            buffer.append(contentsOf: "\(cap.rawValue) J".utf8)

        case .setLineJoin(let join):
            buffer.append(contentsOf: "\(join.rawValue) j".utf8)

        case .setMiterLimit(let limit):
            buffer.append(contentsOf: "\(limit.formatted(.pdf)) M".utf8)

        case .setDashPattern(let array, let phase):
            let arrayStr = array.map { $0.formatted(.pdf) }.joined(separator: " ")
            buffer.append(contentsOf: "[\(arrayStr)] \(phase.formatted(.pdf)) d".utf8)
        }
    }
}

