// ISO 32000-2:2020, 12.9 Measurement properties
//
// Sections:
//   12.9.1  General
//   12.9.2  Algorithm: Use of a number format array to create a formatted text string
//
// Tables:
//   Table 265 — Entries in a viewport dictionary
//   Table 266 — Entries in a measure dictionary
//   Table 267 — Additional entries in a rectilinear measure dictionary
//   Table 268 — Entries in a number format dictionary

public import ISO_32000_8_Graphics
public import ISO_32000_Shared

extension ISO_32000.`12` {
    /// ISO 32000-2:2020, 12.9 Measurement properties
    public enum `9` {}
}

// MARK: - Measurement Namespace

extension ISO_32000 {
    /// Measurement properties namespace
    ///
    /// Per ISO 32000-2:2020 Section 12.9.1:
    /// > PDF documents, such as those created by CAD software, may contain graphics
    /// > that are intended to represent real-world objects. Users of such documents
    /// > often require information about the scale and units of measurement.
    ///
    /// Measurement dictionaries provide information for converting page coordinates
    /// to real-world measurements with proper units.
    public enum Measurement {}
}

// MARK: - 12.9.1 Viewport Dictionary (Table 265)

extension ISO_32000.Measurement {
    /// Viewport dictionary (Table 265)
    ///
    /// A viewport is a rectangular region of a page that can have its own
    /// measurement scale.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 265 — Entries in a viewport dictionary
    public struct Viewport: Sendable, Hashable {
        /// Bounding box in default user space coordinates. Required.
        /// Lower-left followed by upper-right, determines orientation.
        public var bbox: ISO_32000.UserSpace.Rectangle

        /// Descriptive name for the viewport. Optional.
        public var name: String?

        /// Measure dictionary for this viewport. Optional.
        public var measure: Measure?

        /// Point data dictionary for geospatial data (PDF 2.0). Optional.
        public var ptData: Int?  // Object reference to point data dictionary

        public init(
            bbox: ISO_32000.UserSpace.Rectangle,
            name: String? = nil,
            measure: Measure? = nil,
            ptData: Int? = nil
        ) {
            self.bbox = bbox
            self.name = name
            self.measure = measure
            self.ptData = ptData
        }
    }
}

// MARK: - 12.9.1 Measure Dictionary (Table 266)

extension ISO_32000.Measurement {
    /// Measure dictionary (Table 266)
    ///
    /// Specifies an alternative coordinate system for a region of a page.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 266 — Entries in a measure dictionary
    public struct Measure: Sendable, Hashable {
        /// Content specific to the measure subtype
        public var content: Content

        public init(content: Content) {
            self.content = content
        }
    }
}

extension ISO_32000.Measurement.Measure {
    /// Measure subtype content (Table 266, Subtype entry)
    public enum Content: Sendable, Hashable {
        /// Rectilinear coordinate system (RL)
        case rectilinear(Rectilinear)
        /// Geospatial coordinate system (GEO, PDF 2.0)
        case geospatial(Geospatial)
    }
}

// MARK: - Rectilinear Measure Dictionary (Table 267)

extension ISO_32000.Measurement.Measure {
    /// Rectilinear measure dictionary (Table 267)
    ///
    /// A coordinate system where x and y axes are perpendicular with linear units.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 267 — Additional entries in a rectilinear measure dictionary
    public struct Rectilinear: Sendable, Hashable {
        /// Scale ratio text (e.g., "1/4 in = 1 ft"). Required.
        public var scaleRatio: String

        /// Number format array for x-axis measurement. Required.
        public var x: [ISO_32000.Measurement.NumberFormat]

        /// Number format array for y-axis measurement. Optional.
        /// Required when x and y have different units or conversion factors.
        public var y: [ISO_32000.Measurement.NumberFormat]?

        /// Number format array for distance measurement. Required.
        public var distance: [ISO_32000.Measurement.NumberFormat]

        /// Number format array for area measurement. Required.
        public var area: [ISO_32000.Measurement.NumberFormat]

        /// Number format array for angle measurement. Optional.
        public var angle: [ISO_32000.Measurement.NumberFormat]?

        /// Number format array for slope measurement. Optional.
        public var slope: [ISO_32000.Measurement.NumberFormat]?

        /// Origin of measurement coordinate system. Optional.
        /// Default: lower-left corner of viewport BBox.
        public var origin: Origin?

        /// Conversion factor from y-axis to x-axis units. Optional.
        /// Meaningful only when Y is present.
        public var cyx: Double?

        public init(
            scaleRatio: String,
            x: [ISO_32000.Measurement.NumberFormat],
            y: [ISO_32000.Measurement.NumberFormat]? = nil,
            distance: [ISO_32000.Measurement.NumberFormat],
            area: [ISO_32000.Measurement.NumberFormat],
            angle: [ISO_32000.Measurement.NumberFormat]? = nil,
            slope: [ISO_32000.Measurement.NumberFormat]? = nil,
            origin: Origin? = nil,
            cyx: Double? = nil
        ) {
            self.scaleRatio = scaleRatio
            self.x = x
            self.y = y
            self.distance = distance
            self.area = area
            self.angle = angle
            self.slope = slope
            self.origin = origin
            self.cyx = cyx
        }
    }
}

extension ISO_32000.Measurement.Measure.Rectilinear {
    /// Origin point for measurement coordinate system
    public struct Origin: Sendable, Hashable {
        public var x: Double
        public var y: Double

        public init(x: Double, y: Double) {
            self.x = x
            self.y = y
        }
    }
}

// MARK: - Geospatial Measure (placeholder for 12.10)

extension ISO_32000.Measurement.Measure {
    /// Geospatial measure dictionary (PDF 2.0)
    ///
    /// Defines relationship between PDF object space and earth model.
    /// See 12.10 Geospatial features for full implementation.
    public struct Geospatial: Sendable, Hashable {
        /// Reference to full geospatial measure implementation
        public var geoMeasure: ISO_32000.Geospatial.Measure?

        public init(geoMeasure: ISO_32000.Geospatial.Measure? = nil) {
            self.geoMeasure = geoMeasure
        }
    }
}

// MARK: - Number Format Dictionary (Table 268)

extension ISO_32000.Measurement {
    /// Number format dictionary (Table 268)
    ///
    /// Represents a specific unit of measurement with formatting rules.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 268 — Entries in a number format dictionary
    public struct NumberFormat: Sendable, Hashable {
        /// Unit label for display. Required.
        public var unitLabel: String

        /// Conversion factor from previous unit. Required.
        public var conversionFactor: Double

        /// Fractional display mode. Optional. Default: .decimal
        public var fractionalMode: FractionalMode?

        /// Precision or denominator. Optional.
        /// For decimal: multiple of 10 (default 100).
        /// For fraction: denominator (default 16).
        public var precision: Int?

        /// If true, don't reduce fractions or truncate zeros. Default: false.
        public var fixedDenominator: Bool?

        /// Text between thousands. Default: ",".
        public var thousandsSeparator: String?

        /// Decimal separator text. Default: ".".
        public var decimalSeparator: String?

        /// Prefix text before label. Default: " ".
        public var prefixSeparator: String?

        /// Suffix text after label. Default: " ".
        public var suffixSeparator: String?

        /// Label position relative to value. Default: .suffix.
        public var labelPosition: LabelPosition?

        public init(
            unitLabel: String,
            conversionFactor: Double,
            fractionalMode: FractionalMode? = nil,
            precision: Int? = nil,
            fixedDenominator: Bool? = nil,
            thousandsSeparator: String? = nil,
            decimalSeparator: String? = nil,
            prefixSeparator: String? = nil,
            suffixSeparator: String? = nil,
            labelPosition: LabelPosition? = nil
        ) {
            self.unitLabel = unitLabel
            self.conversionFactor = conversionFactor
            self.fractionalMode = fractionalMode
            self.precision = precision
            self.fixedDenominator = fixedDenominator
            self.thousandsSeparator = thousandsSeparator
            self.decimalSeparator = decimalSeparator
            self.prefixSeparator = prefixSeparator
            self.suffixSeparator = suffixSeparator
            self.labelPosition = labelPosition
        }
    }
}

extension ISO_32000.Measurement.NumberFormat {
    /// Fractional display mode (Table 268, F entry)
    public enum FractionalMode: String, Sendable, Hashable, Codable, CaseIterable {
        /// Show as decimal to precision specified by D entry
        case decimal = "D"
        /// Show as fraction with denominator from D entry
        case fraction = "F"
        /// Round to nearest whole unit
        case round = "R"
        /// Truncate to whole units
        case truncate = "T"
    }

    /// Label position relative to value (Table 268, O entry)
    public enum LabelPosition: String, Sendable, Hashable, Codable, CaseIterable {
        /// Label is suffix to value
        case suffix = "S"
        /// Label is prefix to value
        case prefix = "P"
    }
}

// MARK: - Section Typealiases

extension ISO_32000.`12`.`9` {
    /// Viewport dictionary (Table 265)
    public typealias Viewport = ISO_32000.Measurement.Viewport

    /// Measure dictionary (Table 266)
    public typealias Measure = ISO_32000.Measurement.Measure

    /// Number format dictionary (Table 268)
    public typealias NumberFormat = ISO_32000.Measurement.NumberFormat
}
