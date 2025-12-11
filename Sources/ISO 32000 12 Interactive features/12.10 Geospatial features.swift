// ISO 32000-2:2020, 12.10 Geospatial features
//
// Sections:
//   12.10.1  General
//   12.10.2  Geospatial measure dictionary (Table 269)
//   12.10.3  Geographic coordinate system dictionary (Table 270)
//   12.10.4  Projected coordinate system dictionary (Table 271)
//   12.10.5  Point data dictionary (Table 272)

public import ISO_32000_Shared

extension ISO_32000.`12` {
    /// ISO 32000-2:2020, 12.10 Geospatial features
    public enum `10` {}
}

// MARK: - Geospatial Namespace

extension ISO_32000 {
    /// Geospatial features namespace (PDF 2.0)
    ///
    /// Per ISO 32000-2:2020 Section 12.10.1:
    /// > PDF is a common delivery mechanism for map and satellite imagery data.
    /// > In PDF 2.0, a geospatial coordinate system is introduced along with
    /// > a number of PDF constructs to support geospatially registered content.
    public enum Geospatial {}
}

// MARK: - 12.10.2 Geospatial Measure Dictionary (Table 269)

extension ISO_32000.Geospatial {
    /// Geospatial measure dictionary (Table 269)
    ///
    /// Contains a description of the earth-based coordinate system associated
    /// with the PDF object and transformation data between coordinate systems.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 269 — Additional entries in a geospatial measure dictionary
    public struct Measure: Sendable, Hashable {
        /// Bounding polygon (neatline) for valid transformation area. Optional.
        /// Array of coordinate pairs relative to unit square.
        /// Default: [0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 0.0]
        public var bounds: [Double]?

        /// Geographic or projected coordinate system. Required.
        public var gcs: CoordinateSystem

        /// Display coordinate system for position values. Optional.
        public var dcs: CoordinateSystem?

        /// Preferred display units [linear, area, angular]. Optional.
        public var pdu: PreferredDisplayUnits?

        /// Array of geographic/projected points. Required.
        /// Lat/long pairs for geographic, easting/northing for projected.
        public var gpts: [Double]

        /// Array of local points in unit square. Optional.
        /// Same number of pairs as GPTS.
        public var lpts: [Double]?

        /// 12-element transformation matrix to projected coordinate system. Optional.
        /// Has priority over GPTS when GCS is a projected coordinate system.
        public var pcsm: [Double]?

        public init(
            bounds: [Double]? = nil,
            gcs: CoordinateSystem,
            dcs: CoordinateSystem? = nil,
            pdu: PreferredDisplayUnits? = nil,
            gpts: [Double],
            lpts: [Double]? = nil,
            pcsm: [Double]? = nil
        ) {
            self.bounds = bounds
            self.gcs = gcs
            self.dcs = dcs
            self.pdu = pdu
            self.gpts = gpts
            self.lpts = lpts
            self.pcsm = pcsm
        }
    }
}

// MARK: - Preferred Display Units

extension ISO_32000.Geospatial.Measure {
    /// Preferred display units (Table 269, PDU entry)
    public struct PreferredDisplayUnits: Sendable, Hashable {
        public var linear: LinearUnit
        public var area: AreaUnit
        public var angular: AngularUnit

        public init(linear: LinearUnit, area: AreaUnit, angular: AngularUnit) {
            self.linear = linear
            self.area = area
            self.angular = angular
        }
    }

    /// Linear display units (Table 269)
    public enum LinearUnit: String, Sendable, Hashable, Codable, CaseIterable {
        /// Metre
        case m = "M"
        /// Kilometre
        case km = "KM"
        /// International foot
        case ft = "FT"
        /// U.S. Survey foot
        case usFoot = "USFT"
        /// International mile
        case mile = "MI"
        /// International nautical mile
        case nauticalMile = "NM"
    }

    /// Area display units (Table 269)
    public enum AreaUnit: String, Sendable, Hashable, Codable, CaseIterable {
        /// Square metre
        case sqm = "SQM"
        /// Hectare (10,000 square metres)
        case ha = "HA"
        /// Square kilometre
        case sqkm = "SQKM"
        /// Square foot (US Survey)
        case sqft = "SQFT"
        /// Acre
        case acre = "A"
        /// Square mile (international)
        case sqmi = "SQMI"
    }

    /// Angular display units (Table 269)
    public enum AngularUnit: String, Sendable, Hashable, Codable, CaseIterable {
        /// Degree
        case deg = "DEG"
        /// Grad (1/400 of a circle, 0.9 degrees)
        case grd = "GRD"
    }
}

// MARK: - Coordinate System

extension ISO_32000.Geospatial {
    /// Coordinate system (geographic or projected)
    public enum CoordinateSystem: Sendable, Hashable {
        /// Geographic coordinate system (GEOGCS)
        case geographic(Geographic)
        /// Projected coordinate system (PROJCS)
        case projected(Projected)
    }
}

// MARK: - 12.10.3 Geographic Coordinate System (Table 270)

extension ISO_32000.Geospatial {
    /// Geographic coordinate system dictionary (Table 270)
    ///
    /// Specifies an ellipsoidal object in geographic coordinates
    /// (angular units of latitude and longitude).
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 270 — Entries in a geographic coordinate system dictionary
    public struct Geographic: Sendable, Hashable {
        /// Coordinate system reference (EPSG or WKT). Required.
        public var reference: CoordinateReference

        public init(reference: CoordinateReference) {
            self.reference = reference
        }
    }
}

// MARK: - 12.10.4 Projected Coordinate System (Table 271)

extension ISO_32000.Geospatial {
    /// Projected coordinate system dictionary (Table 271)
    ///
    /// Specifies algorithms and parameters for transforming between geographic
    /// coordinates and a two-dimensional (projected) coordinate system.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 271 — Entries in a projected coordinate system dictionary
    public struct Projected: Sendable, Hashable {
        /// Coordinate system reference (EPSG or WKT). Required.
        public var reference: CoordinateReference

        public init(reference: CoordinateReference) {
            self.reference = reference
        }
    }
}

// MARK: - Coordinate Reference

extension ISO_32000.Geospatial {
    /// Coordinate system reference (EPSG code or WKT string)
    ///
    /// Either an EPSG code or a WKT string shall be present.
    public enum CoordinateReference: Sendable, Hashable {
        /// EPSG reference code (from http://www.epsg.org)
        case epsg(Int)
        /// Well Known Text string (ISO 19162)
        case wkt(String)
    }
}

// MARK: - 12.10.5 Point Data Dictionary (Table 272)

extension ISO_32000.Geospatial {
    /// Point data dictionary (Table 272)
    ///
    /// Extended data associated with points in 2D space.
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Table 272 — Entries in a point data dictionary
    public struct PointData: Sendable, Hashable {
        /// Names identifying internal data elements. Required.
        /// Predefined: LAT (latitude), LON (longitude), ALT (altitude in metres).
        public var names: [PointDataName]

        /// Array of arrays of values. Required.
        /// Each interior array corresponds to Names.
        public var xpts: [[PointDataValue]]

        public init(names: [PointDataName], xpts: [[PointDataValue]]) {
            self.names = names
            self.xpts = xpts
        }
    }
}

extension ISO_32000.Geospatial.PointData {
    /// Predefined point data names (Table 272)
    public enum PointDataName: Sendable, Hashable {
        /// Latitude in degrees
        case lat
        /// Longitude in degrees
        case lon
        /// Altitude in metres
        case alt
        /// Custom name
        case custom(String)
    }

    /// Point data value (type depends on name)
    public enum PointDataValue: Sendable, Hashable {
        case number(Double)
        case string(String)
    }
}

// MARK: - Section Typealiases

extension ISO_32000.`12`.`10` {
    /// Geospatial measure dictionary (Table 269)
    public typealias Measure = ISO_32000.Geospatial.Measure

    /// Coordinate system (geographic or projected)
    public typealias CoordinateSystem = ISO_32000.Geospatial.CoordinateSystem

    /// Geographic coordinate system dictionary (Table 270)
    public typealias Geographic = ISO_32000.Geospatial.Geographic

    /// Projected coordinate system dictionary (Table 271)
    public typealias Projected = ISO_32000.Geospatial.Projected

    /// Point data dictionary (Table 272)
    public typealias PointData = ISO_32000.Geospatial.PointData
}
