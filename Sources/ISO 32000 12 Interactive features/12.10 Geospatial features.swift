// ISO 32000-2:2020, 12.10 Geospatial features

import ISO_32000_Shared

//12.10 Geospatial features
//12.10.1 General
//PDF is a common delivery mechanism for map and satellite imagery data. In PDF 2.0, a geospatial
//coordinate system is introduced ("Table 266 — Entries in a measure dictionary") along with a number
//of PDF constructs, as explained in this clause, to support geospatially registered content.
//12.10.2 Geospatial measure dictionary
//When the subtype of a measurement dictionary ("Table 266 — Entries in a measure dictionary") is
//GEO, additional entries are defined through a geospatial measure dictionary.
//A geospatial measure dictionary, "Table 269 — Additional entries in a geospatial measure dictionary"
//,
//contains a description of the earth-based coordinate system associated with the PDF object, and
//corresponding arrays of points in that coordinate system and the local object coordinate system. It may
//© ISO 2020 – All rights reserved 601
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//602 © ISO 2020 – All rights reserved
//contain a bounding polygon (the Bounds entry), which defines the region of the PDF object for which
//the geographic associations are valid. It may also contain a choice of default units (the PDU entry) for
//user displays of positions, distances and areas. An optional display coordinate system (the DCS entry)
//allows a document to be authored to display values in a coordinate system other than that associated
//with the source data. For example, a map may be created in a state planar coordinate system based on
//a 1927 datum, but it is possible to display its latitude and longitude values in the WGS84 datum
//corresponding to values reported by a GPS device.
//The entries of a geospatial measure dictionary are shown in "Table 269 — Additional entries in a
//geospatial measure dictionary"
//.
//Table 269 — Additional entries in a geospatial measure dictionary
//Key Type Description
//Bounds array (Optional; PDF 2.0) An array of numbers that shall be taken pairwise to define a
//series of points that describes the bounds of an area for which geospatial
//transformations are valid.
//For maps, this bounding polygon is known as a neatline. These numbers are
//expressed relative to a unit square that describes the BBox associated with a
//Viewport or form XObject, or the bounds of an image XObject. If not present, the
//default values shall define a rectangle describing the full unit square, with values
//of [0.0 0.0 0.0 1.0 1.0 1.0 1.0 0.0].
//NOTE 1 The polygon description need not be explicitly closed by repeating the first point
//values as a final point.
//GCS dictionary (Required; PDF 2.0) A geographic or projected coordinate system dictionary. See
//"Table 270 — Entries in a geographic coordinate system dictionary" and "Table
//271 — Entries in a projected coordinate system dictionary".
//DCS dictionary (Optional; PDF 2.0) A projected or geographic coordinate system that shall be used
//for the display of position values, such as latitude and longitude. See "Table 270 —
//Entries in a geographic coordinate system dictionary" and "Table 271 — Entries
//in a projected coordinate system dictionary". Formatting the displayed
//representation of these values is controlled by the interactive PDF processor.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 603
//Key Type Description
//PDU array (Optional; PDF 2.0) Preferred Display Units. An array of three names that identify in
//order a linear display unit, an area display unit, and an angular display unit.
//The following are valid linear display units:
//M a metre
//KM a kilometre
//FT an international foot
//USFT a U.S. Survey foot
//MI an international mile
//NM an international nautical mile
//The following are valid area display units:
//SQM a square metre
//HA a hectare (10,000 square metres)
//SQKM a square kilometre
//SQFT a square foot (US Survey)
//A an acre
//SQMI a square mile (international)
//The following are valid angular display units:
//DEG a degree
//GRD a grad (1/400 of a circle, or 0.9 degrees)
//GPTS array (Required; PDF 2.0) An array of numbers that shall be taken pairwise, defining
//points in geographic space as degrees of latitude and longitude, respectively when
//defining a geographic coordinate system. These values shall be based on the
//geographic coordinate system described in the GCS dictionary. When defining a
//projected coordinate system, this array contains values in a planar projected
//coordinate space as eastings and northings. For Geospatial3D, when Geospatial
//feature information is present (requirement type Geospatial3D) in a 3D
//annotation, the GPTS array is required to hold 3D point coordinates as triples
//rather than pairwise where the third value of each tripe is an elevation value.
//NOTE 2 Any projected coordinate system includes an underlying geographic coordinate
//system.
//LPTS array (Optional; PDF 2.0) An array of numbers that shall be taken pairwise to define
//points in a 2D unit square. The unit square is mapped to the rectangular bounds of
//the Viewport, image XObject, or forms XObject that contains the measure
//dictionary. This array shall contain the same number of number pairs as the GPTS
//array; each number pair is the unit square object position corresponding to the
//geospatial position in the GPTS array. For Geospatial3D, when Geospatial feature
//information is present in a 3D annotation (requirement type Geospatial3D), the
//LPTS array is required to hold 3D point coordinates as triples corresponding to
//the GPTS array in the 3D annotation view world coordinate space.
//PCSM array (Optional; PDF 2.0) A 12-element transformation matrix of real numbers, defining
//the transformation from XObject position coordinates to projected coordinate
//system. If GCS is a geographic coordinate system dictionary then PCSM should be
//ignored and GTPS used instead. If PCSM is present, it has priority over GPTS, and
//GPTS values may be ignored. This priority provides backward compatibility.
//NOTE 3 PCSM is an acronym for "Projected Coordinate System Matrix"
//.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//604 © ISO 2020 – All rights reserved
//12.10.3 Geographic coordinate system dictionary
//A geographic coordinate system (GEOGCS) specifies an ellipsoidal object in geographic coordinates:
//angular units of latitude and longitude. The geographic coordinate system shall be described in either
//or both of two well-established standards: as a numeric EPSG reference code, or as a Well Known Text
//(WKT) string, which contains a description of algorithms and parameters needed for transformations.
//"Table 270 — Entries in a geographic coordinate system dictionary" lists the entries in a geographic
//coordinate system dictionary. A geographic coordinate system dictionary may be a value of the GCS or
//the DCS entry of a geospatial measure dictionary. (See "Table 269 — Additional entries in a geospatial
//measure dictionary".)
//Table 270 — Entries in a geographic coordinate system dictionary
//Key Type Description
//Type name (Required; PDF 2.0) The type of PDF object that this dictionary describes.
//If present, shall be GEOGCS for a geographic coordinate system
//dictionary.
//EPSG integer (Optional; PDF 2.0) An EPSG reference code specifying the geographic
//coordinate system. Shall not be present if WKT is present.
//WKT ASCII string (Optional; PDF 2.0) A string of Well Known Text describing the
//geographic coordinate system. Shall not be present if EPSG is present.
//Either an EPSG code or a WKT string shall be present in a geographic coordinate system dictionary.
//The EPSG reference codes are described in a database available through http://www.epsg.org as
//administered by the International Association of Oil and Gas Producers (OGP). The WKT (Well Known
//Text) format is specified in ISO 19162.
//12.10.4 Projected coordinate system dictionary
//A projected coordinate system (PROJCS), which includes an embedded GEOGCS, specifies the
//algorithms and associated parameters used to transform points between geographic coordinates and a
//two-dimensional (projected) coordinate system. Any transformation between a three-dimensional
//curved geographic coordinate system and a two-dimensional coordinate system introduces distortions.
//For small areas, this distortion may be small enough to allow direct mapping between geographic
//coordinates and PDF object coordinates without requiring the use of a projected coordinate system.
//The projected coordinate system shall be described in either or both of two well-established
//standards: as a numeric EPSG reference code, or as a Well KnownText (WKT) string, which contains a
//description of algorithms and parameters needed for transformations.
//"Table 271 — Entries in a projected coordinate system dictionary" lists the entries in a projected
//coordinate system dictionary. A projected coordinate system dictionary may be a value of the GCS or
//the DCS entry of a geospatial measure dictionary, "Table 269 — Additional entries in a geospatial
//measure dictionary"
//.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//© ISO 2020 – All rights reserved 605
//Table 271 — Entries in a projected coordinate system dictionary
//Key Type Description
//Type name (Required; PDF 2.0) The type of PDF object that this dictionary
//describes; shall be PROJCS for a projected coordinate system
//dictionary.
//EPSG integer (Optional; PDF 2.0) An EPSG reference code specifying the
//projected coordinate system.
//WKT ASCII string (Optional; PDF 2.0) A string of Well Known Text describing the
//projected coordinate system.
//Either an EPSG code or a WKT string shall be required in the projected coordinate system dictionary.
//EXAMPLE 1 A WKT describing a geographic coordinate system
//An example of WKT description of a geographic coordinate system, formatted for readability. The EPSG
//code equivalent to the GCS_North_American_1983 geographic coordinate system is 4269.
//GEOGCS["GCS_North_American_1983"
//,
//DATUM[
//"D_North_American_1983"
//,
//SPHEROID["GRS_1980",6378137.0,298.257222101]
//],
//PRIMEM["Greenwich",0.0],
//UNIT["Degree",0.0174532925199433]
//]
//EXAMPLE 2 A WKT describing a projected coordinate system
//An example of WKT description of a projected coordinate system, formatted for readability. The EPSG code
//equivalent to the North_American_Albers_Equal_Area_Conic projected coordinate system is 102008.
//PROJCS["North_America_Albers_Equal_Area_Conic"
//,
//GEOGCS["GCS_North_American_1983"
//,
//DATUM["D_North_American_1983"
//,
//SPHEROID["GRS_1980",6378137.0, 298.257222101]
//],
//PRIMEM["Greenwich",0.0],
//UNIT["Degree",0.0174532925199433]
//],
//PROJECTION["Albers"],
//PARAMETER["False_Easting",0.0],
//PARAMETER["False_Northing",0.0],
//PARAMETER["Central_Meridian"
//,
//-96.0],
//PARAMETER["Standard_Parallel_1",20.0],
//PARAMETER["Standard_Parallel_2",60.0]
//PARAMETER["Latitude_Of_Origin",40.0],
//UNIT["Meter",1.0]
//]
//12.10.5 Point data dictionary
//Any 2D object (Viewport, image XObject, or form XObject) that contains a measure dictionary ("Table
//266 — Entries in a measure dictionary") of subtype GEO can optionally include a PtData entry. The
//value of a PtData entry is a point data dictionary or an array of point data dictionaries of extended data
//associated with points in the 2D space. "Table 272 — Entries in a point data dictionary" lists the entries
//of a point data dictionary.
//Sold by the PDF Association to 17781 | December 3, 2025 |
//Single user only, copying and networking prohibited.
//ISO 32000-2:2020(E)
//606 © ISO 2020 – All rights reserved
//Table 272 — Entries in a point data dictionary
//Key Type Description
//Type name (Required; PDF 2.0) The type of PDF object that this dictionary describes;
//shall be PtData for a point data dictionary.
//Subtype name (Required; PDF 2.0) Shall be Cloud.
//Names array (Required; PDF 2.0) An array of names that identify the internal data elements
//of the individual point arrays in the XPTS array.
//There are three predefined names:
//LAT latitude in degrees. The XPTS value is a number type.
//LON longitude in degrees. The XPTS value is a number type.
//ALT altitude in metres. The XPTS value is a number type.
//NOTE These names are, in effect, column headers for the array of XPTS values.
//XPTS array (Required; PDF 2.0) An array of arrays of values. The number of members in
//each interior array shall correspond to the size of the Names array; each
//member in the interior arrays is of a type defined by the corresponding name
//in the Names array.
//The XPTS array is a collection of tuples without any guaranteed ordering or
//relationship from point to point.
//The names LAT, LON, and ALT are predefined, and shall be used to associate altitude information with
//latitude and longitude positions.

