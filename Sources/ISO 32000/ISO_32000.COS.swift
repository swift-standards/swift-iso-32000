// ISO_32000.COS.swift

extension ISO_32000 {
    /// Carousel Object System (COS) - PDF's low-level object model
    ///
    /// COS defines the fundamental data types used in PDF files:
    /// - Boolean, Integer, Real, String, Name, Array, Dictionary, Stream
    /// - Null and Indirect References
    ///
    /// All PDF content is built from these primitive types.
    ///
    /// ## See Also
    ///
    /// - ISO 32000-1 Section 7.3: Objects
    public enum CarouselObjectSystem {}
    
    public typealias COS = CarouselObjectSystem
}
