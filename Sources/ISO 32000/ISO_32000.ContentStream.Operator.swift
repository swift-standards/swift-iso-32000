// ISO_32000.ContentStream.Operator.swift

import Formatting
import Geometry
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
            x1: ISO_32000.UserSpace.X,
            y1: ISO_32000.UserSpace.Y,
            x2: ISO_32000.UserSpace.X,
            y2: ISO_32000.UserSpace.Y,
            x3: ISO_32000.UserSpace.X,
            y3: ISO_32000.UserSpace.Y
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
        case setHorizontalScaling(Scale<1>)

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

        /// Show text (bytes Tj)
        ///
        /// Takes pre-encoded bytes (e.g., WinAnsiEncoding for Standard 14 fonts).
        /// The bytes are serialized as a PDF literal string with proper escaping.
        case showText([UInt8])

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

        // MARK: - Marked Content (Section 14.6)

        /// Begin marked-content sequence (/tag BMC)
        case beginMarkedContent(tag: ISO_32000.COS.Name)

        /// Begin marked-content sequence with property list (/tag <<...>> BDC)
        case beginMarkedContentWithProperties(tag: ISO_32000.COS.Name, properties: ISO_32000.COS.Dictionary)

        /// End marked-content sequence (EMC)
        case endMarkedContent
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
            buffer.append(.ascii.q)

        case .restoreState:
            buffer.append(.ascii.Q)

        case .transform(let a, let b, let c, let d, let e, let f):
            a.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            b.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            c.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            d.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            e.serialize(into: &buffer)
            buffer.append(.ascii.space)
            f.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.c, .ascii.m])

        // Color
        case .setStrokeGray(let gray):
            gray.pdf.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.G])

        case .setFillGray(let gray):
            gray.pdf.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.g])

        case .setStrokeRGB(let r, let g, let b):
            r.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            g.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            b.pdf.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.R, .ascii.G])

        case .setFillRGB(let r, let g, let b):
            r.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            g.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            b.pdf.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.r, .ascii.g])

        case .setStrokeCMYK(let c, let m, let y, let k):
            c.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            m.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            y.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            k.pdf.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.K])

        case .setFillCMYK(let c, let m, let y, let k):
            c.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            m.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            y.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            k.pdf.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.k])

        // Path Construction
        case .moveTo(let x, let y):
            x.serialize(into: &buffer)
            buffer.append(.ascii.space)
            y.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.m])

        case .lineTo(let x, let y):
            x.serialize(into: &buffer)
            buffer.append(.ascii.space)
            y.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.l])

        case .curveTo(let x1, let y1, let x2, let y2, let x3, let y3):
            x1.serialize(into: &buffer)
            buffer.append(.ascii.space)
            y1.serialize(into: &buffer)
            buffer.append(.ascii.space)
            x2.serialize(into: &buffer)
            buffer.append(.ascii.space)
            y2.serialize(into: &buffer)
            buffer.append(.ascii.space)
            x3.serialize(into: &buffer)
            buffer.append(.ascii.space)
            y3.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.c])

        case .rectangle(let x, let y, let width, let height):
            x.serialize(into: &buffer)
            buffer.append(.ascii.space)
            y.serialize(into: &buffer)
            buffer.append(.ascii.space)
            width.serialize(into: &buffer)
            buffer.append(.ascii.space)
            height.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.r, .ascii.e])

        case .closePath:
            buffer.append(.ascii.h)

        // Path Painting
        case .stroke:
            buffer.append(.ascii.S)

        case .closeAndStroke:
            buffer.append(.ascii.s)

        case .fill:
            buffer.append(.ascii.f)

        case .fillEvenOdd:
            buffer.append(contentsOf: [.ascii.f, .ascii.asterisk])

        case .fillAndStroke:
            buffer.append(.ascii.B)

        case .endPath:
            buffer.append(.ascii.n)

        // Clipping
        case .clip:
            buffer.append(.ascii.W)

        case .clipEvenOdd:
            buffer.append(contentsOf: [.ascii.W, .ascii.asterisk])

        // Text State
        case .beginText:
            buffer.append(contentsOf: [.ascii.B, .ascii.T])

        case .endText:
            buffer.append(contentsOf: [.ascii.E, .ascii.T])

        case .setFont(let name, let size):
            buffer.append(.ascii.forwardSlash)
            buffer.append(contentsOf: name.rawValue.utf8)
            buffer.append(.ascii.space)
            size.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.T, .ascii.f])

        case .setTextLeading(let leading):
            leading.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.T, .ascii.L])

        case .setCharacterSpacing(let spacing):
            spacing.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.T, .ascii.c])

        case .setWordSpacing(let spacing):
            spacing.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.T, .ascii.w])

        case .setHorizontalScaling(let scale):
            scale.value.pdf.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.T, .ascii.z])

        case .setTextRise(let rise):
            rise.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.T, .ascii.s])

        // Text Positioning
        case .moveTextPosition(let tx, let ty):
            tx.serialize(into: &buffer)
            buffer.append(.ascii.space)
            ty.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.T, .ascii.d])

        case .moveTextPositionWithLeading(let tx, let ty):
            tx.serialize(into: &buffer)
            buffer.append(.ascii.space)
            ty.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.T, .ascii.D])

        case .setTextMatrix(let a, let b, let c, let d, let e, let f):
            a.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            b.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            c.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            d.pdf.serialize(into: &buffer)
            buffer.append(.ascii.space)
            e.serialize(into: &buffer)
            buffer.append(.ascii.space)
            f.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.T, .ascii.m])

        case .nextLine:
            buffer.append(contentsOf: [.ascii.T, .ascii.asterisk])

        // Text Showing
        case .showText(let bytes):
            // Serialize pre-encoded bytes as PDF literal string
            ISO_32000.`7`.`3`.Table.`3`.serializeLiteralString(bytes, into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.T, .ascii.j])

        // Line Style
        case .setLineWidth(let width):
            width.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.w])

        case .setLineCap(let cap):
            cap.rawValue.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.J])

        case .setLineJoin(let join):
            join.rawValue.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.j])

        case .setMiterLimit(let limit):
            limit.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.M])

        case .setDashPattern(let array, let phase):
            buffer.append(.ascii.leftSquareBracket)
            for (index, value) in array.enumerated() {
                if index > 0 { buffer.append(.ascii.space) }
                value.serialize(into: &buffer)
            }
            buffer.append(contentsOf: [.ascii.rightSquareBracket, .ascii.space])
            phase.serialize(into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.d])

        // Marked Content
        case .beginMarkedContent(let tag):
            buffer.append(.ascii.forwardSlash)
            buffer.append(contentsOf: tag.rawValue.utf8)
            buffer.append(contentsOf: [.ascii.space, .ascii.B, .ascii.M, .ascii.C])

        case .beginMarkedContentWithProperties(let tag, let properties):
            buffer.append(.ascii.forwardSlash)
            buffer.append(contentsOf: tag.rawValue.utf8)
            buffer.append(.ascii.space)
            ISO_32000.COS.Dictionary.serialize(properties, into: &buffer)
            buffer.append(contentsOf: [.ascii.space, .ascii.B, .ascii.D, .ascii.C])

        case .endMarkedContent:
            buffer.append(contentsOf: [.ascii.E, .ascii.M, .ascii.C])
        }
    }
}

// MARK: - PDF Number Serialization for Geometry Types

extension ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit: Binary.Serializable {
    /// Serialize UserSpace.Unit to PDF number format
    ///
    /// Delegates to `Double.pdf.serialize(into:)` for PDF-specific formatting.
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        value.value.pdf.serialize(into: &buffer)
    }
}

extension Geometry.X: Binary.Serializable where Scalar == ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
    /// Serialize Geometry.X to PDF number format
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        value.value.serialize(into: &buffer)
    }
}

extension Geometry.Y: Binary.Serializable where Scalar == ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
    /// Serialize Geometry.Y to PDF number format
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        value.value.serialize(into: &buffer)
    }
}

extension Geometry.Width: Binary.Serializable
where Scalar == ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
    /// Serialize Geometry.Width to PDF number format
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        value.value.serialize(into: &buffer)
    }
}

extension Geometry.Height: Binary.Serializable
where Scalar == ISO_32000.`8`.`3`.`2`.`3`.UserSpace.Unit {
    /// Serialize Geometry.Height to PDF number format
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        value.value.serialize(into: &buffer)
    }
}
