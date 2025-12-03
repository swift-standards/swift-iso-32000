// ISO_32000.Writer.swift

extension ISO_32000 {
    /// PDF Writer - serializes documents to PDF format
    ///
    /// The writer handles:
    /// - PDF header and version
    /// - Object numbering and cross-references
    /// - Document structure (catalog, pages, fonts)
    /// - Trailer and xref table
    public struct Writer: Sendable {
        /// Stream compression callback
        public var compression: StreamCompression?

        /// Create a writer
        ///
        /// - Parameter compression: Optional compression for content streams
        public init(compression: StreamCompression? = nil) {
            self.compression = compression
        }

        /// Write a document to a buffer
        public mutating func write<Buffer: RangeReplaceableCollection>(
            _ document: Document,
            into buffer: inout Buffer
        ) where Buffer.Element == UInt8 {
            var state = WriterState()

            // Header
            writeHeader(document.version, into: &buffer)

            // Binary marker (ensures file is treated as binary)
            buffer.append(contentsOf: "%\u{E2}\u{E3}\u{CF}\u{D3}\n".utf8)

            // Collect all fonts used
            var allFonts: [COS.Name: Font] = [:]
            for page in document.pages {
                for (name, font) in page.resources.fonts {
                    allFonts[name] = font
                }
            }

            // Create font objects
            var fontRefs: [COS.Name: COS.IndirectReference] = [:]
            for (name, font) in allFonts.sorted(by: { $0.key.rawValue < $1.key.rawValue }) {
                let objNum = state.nextObjectNumber()
                fontRefs[name] = COS.IndirectReference(objectNumber: objNum)

                var fontDict = COS.Dictionary()
                fontDict[.type] = .name(.font)
                fontDict[.subtype] = .name(.type1)
                fontDict[.baseFont] = .name(font.baseFontName)

                state.objectOffsets[objNum] = buffer.count
                writeIndirectObject(objNum, object: .dictionary(fontDict), into: &buffer)
            }

            // Create page content streams
            var contentRefs: [[COS.IndirectReference]] = []
            for page in document.pages {
                var pageContentRefs: [COS.IndirectReference] = []
                for content in page.contents {
                    let objNum = state.nextObjectNumber()
                    pageContentRefs.append(COS.IndirectReference(objectNumber: objNum))

                    var streamData = content.data
                    var streamDict = COS.Dictionary()

                    // Apply compression if available
                    if let compress = compression {
                        var compressed: [UInt8] = []
                        compress.compress(streamData, into: &compressed)
                        if compressed.count < streamData.count {
                            streamData = compressed
                            streamDict[.filter] = .name(.flateDecode)
                        }
                    }

                    let stream = COS.Stream(dictionary: streamDict, data: streamData)
                    state.objectOffsets[objNum] = buffer.count
                    writeIndirectObject(objNum, object: .stream(stream), into: &buffer)
                }
                contentRefs.append(pageContentRefs)
            }

            // Create annotation objects for each page
            var annotationRefs: [[COS.IndirectReference]] = []
            for page in document.pages {
                var pageAnnotRefs: [COS.IndirectReference] = []
                for annotation in page.annotations {
                    let objNum = state.nextObjectNumber()
                    pageAnnotRefs.append(COS.IndirectReference(objectNumber: objNum))

                    var annotDict = COS.Dictionary()
                    annotDict[.type] = .name(.annot)

                    switch annotation {
                    case .link(let linkAnnot):
                        annotDict[.subtype] = .name(.link)
                        annotDict[.rect] = linkAnnot.rect.asArray
                        annotDict[.border] = .array([
                            .integer(0),
                            .integer(0),
                            .real(linkAnnot.borderWidth)
                        ])

                        // URI action
                        var actionDict = COS.Dictionary()
                        actionDict[.s] = .name(.uri)
                        actionDict[.uri] = .string(COS.StringValue(linkAnnot.uri))
                        annotDict[.a] = .dictionary(actionDict)
                    }

                    state.objectOffsets[objNum] = buffer.count
                    writeIndirectObject(objNum, object: .dictionary(annotDict), into: &buffer)
                }
                annotationRefs.append(pageAnnotRefs)
            }

            // Create page objects
            let pagesObjNum = state.nextObjectNumber()
            let pagesRef = COS.IndirectReference(objectNumber: pagesObjNum)

            var pageRefs: [COS.IndirectReference] = []
            for (i, page) in document.pages.enumerated() {
                let objNum = state.nextObjectNumber()
                pageRefs.append(COS.IndirectReference(objectNumber: objNum))

                var pageDict = COS.Dictionary()
                pageDict[.type] = .name(.page)
                pageDict[.parent] = .reference(pagesRef)
                pageDict[.mediaBox] = page.mediaBox.asArray

                if let cropBox = page.cropBox {
                    pageDict[.cropBox] = cropBox.asArray
                }

                if let rotation = page.rotation, rotation != 0 {
                    pageDict[.rotate] = .integer(Int64(rotation))
                }

                // Contents
                if contentRefs[i].count == 1 {
                    pageDict[.contents] = .reference(contentRefs[i][0])
                } else if contentRefs[i].count > 1 {
                    pageDict[.contents] = .array(contentRefs[i].map { .reference($0) })
                }

                // Annotations
                if !annotationRefs[i].isEmpty {
                    pageDict[.annots] = .array(annotationRefs[i].map { .reference($0) })
                }

                // Resources
                var resourcesDict = COS.Dictionary()

                // Font resources
                if !page.resources.fonts.isEmpty {
                    var fontResourceDict = COS.Dictionary()
                    for name in page.resources.fonts.keys.sorted(by: { $0.rawValue < $1.rawValue }) {
                        if let ref = fontRefs[name] {
                            fontResourceDict[name] = .reference(ref)
                        }
                    }
                    resourcesDict[.font] = .dictionary(fontResourceDict)
                }

                // ProcSet
                resourcesDict[.procSet] = .array([
                    .name(.pdf),
                    .name(.text)
                ])

                pageDict[.resources] = .dictionary(resourcesDict)

                state.objectOffsets[objNum] = buffer.count
                writeIndirectObject(objNum, object: .dictionary(pageDict), into: &buffer)
            }

            // Pages dictionary
            var pagesDict = COS.Dictionary()
            pagesDict[.type] = .name(.pages)
            pagesDict[.kids] = .array(pageRefs.map { .reference($0) })
            pagesDict[.count] = .integer(Int64(document.pages.count))

            state.objectOffsets[pagesObjNum] = buffer.count
            writeIndirectObject(pagesObjNum, object: .dictionary(pagesDict), into: &buffer)

            // Catalog
            let catalogObjNum = state.nextObjectNumber()
            var catalogDict = COS.Dictionary()
            catalogDict[.type] = .name(.catalog)
            catalogDict[.pages] = .reference(pagesRef)

            state.objectOffsets[catalogObjNum] = buffer.count
            writeIndirectObject(catalogObjNum, object: .dictionary(catalogDict), into: &buffer)

            // Info dictionary (optional)
            var infoRef: COS.IndirectReference?
            if let info = document.info {
                let infoObjNum = state.nextObjectNumber()
                infoRef = COS.IndirectReference(objectNumber: infoObjNum)

                var infoDict = COS.Dictionary()
                if let title = info.title {
                    infoDict[.title] = .string(COS.StringValue(title))
                }
                if let author = info.author {
                    infoDict[.author] = .string(COS.StringValue(author))
                }
                if let subject = info.subject {
                    infoDict[.subject] = .string(COS.StringValue(subject))
                }
                if let keywords = info.keywords {
                    infoDict[.keywords] = .string(COS.StringValue(keywords))
                }
                if let creator = info.creator {
                    infoDict[.creator] = .string(COS.StringValue(creator))
                }
                if let producer = info.producer {
                    infoDict[.producer] = .string(COS.StringValue(producer))
                }
                if let date = info.creationDate {
                    infoDict[.creationDate] = .string(COS.StringValue(date.pdfString))
                }
                if let date = info.modificationDate {
                    infoDict[.modDate] = .string(COS.StringValue(date.pdfString))
                }

                state.objectOffsets[infoObjNum] = buffer.count
                writeIndirectObject(infoObjNum, object: .dictionary(infoDict), into: &buffer)
            }

            // Cross-reference table
            let xrefOffset = buffer.count
            writeXref(state: state, into: &buffer)

            // Trailer
            writeTrailer(
                size: state.objectCount + 1,
                rootRef: COS.IndirectReference(objectNumber: catalogObjNum),
                infoRef: infoRef,
                xrefOffset: xrefOffset,
                into: &buffer
            )
        }

        /// Convenience: write and return bytes
        public mutating func write(_ document: Document) -> [UInt8] {
            var buffer: [UInt8] = []
            write(document, into: &buffer)
            return buffer
        }

        // MARK: - Private Helpers

        private func writeHeader<Buffer: RangeReplaceableCollection>(
            _ version: Version,
            into buffer: inout Buffer
        ) where Buffer.Element == UInt8 {
            buffer.append(contentsOf: "\(version.header)\n".utf8)
        }

        private func writeIndirectObject<Buffer: RangeReplaceableCollection>(
            _ objectNumber: Int,
            object: COS.Object,
            into buffer: inout Buffer
        ) where Buffer.Element == UInt8 {
            buffer.append(contentsOf: "\(objectNumber) 0 obj\n".utf8)
            COS.serialize(object, into: &buffer)
            buffer.append(contentsOf: "\nendobj\n".utf8)
        }

        private func writeXref<Buffer: RangeReplaceableCollection>(
            state: WriterState,
            into buffer: inout Buffer
        ) where Buffer.Element == UInt8 {
            buffer.append(contentsOf: "xref\n".utf8)
            buffer.append(contentsOf: "0 \(state.objectCount + 1)\n".utf8)

            // Entry 0: free object (head of free list)
            buffer.append(contentsOf: "0000000000 65535 f \n".utf8)

            // Object entries
            for i in 1...state.objectCount {
                let offset = state.objectOffsets[i] ?? 0
                var offsetStr = Swift.String(offset)
                while offsetStr.count < 10 {
                    offsetStr = "0" + offsetStr
                }
                let entry = "\(offsetStr) 00000 n \n"
                buffer.append(contentsOf: entry.utf8)
            }
        }

        private func writeTrailer<Buffer: RangeReplaceableCollection>(
            size: Int,
            rootRef: COS.IndirectReference,
            infoRef: COS.IndirectReference?,
            xrefOffset: Int,
            into buffer: inout Buffer
        ) where Buffer.Element == UInt8 {
            buffer.append(contentsOf: "trailer\n".utf8)

            var trailerDict = COS.Dictionary()
            trailerDict[.size] = .integer(Int64(size))
            trailerDict[.root] = .reference(rootRef)

            if let info = infoRef {
                trailerDict[.info] = .reference(info)
            }

            COS.serializeDictionary(trailerDict, into: &buffer)

            buffer.append(contentsOf: "\nstartxref\n".utf8)
            buffer.append(contentsOf: "\(xrefOffset)\n".utf8)
            buffer.append(contentsOf: "%%EOF\n".utf8)
        }
    }
}

// MARK: - Writer State

extension ISO_32000 {
    /// Internal state for PDF writing
    struct WriterState {
        var objectCount: Int = 0
        var objectOffsets: [Int: Int] = [:]

        mutating func nextObjectNumber() -> Int {
            objectCount += 1
            return objectCount
        }
    }
}

// MARK: - Stream Compression

extension ISO_32000 {
    /// Stream compression callback
    ///
    /// This allows the core ISO 32000 module to support compression without
    /// depending on RFC 1950/1951 directly.
    ///
    /// Uses `inout` pattern for consistency with RFC compress APIs.
    public struct StreamCompression: Sendable {
        private let _compress: @Sendable ([UInt8], inout [UInt8]) -> Void

        /// Create a compression callback
        public init(compress: @escaping @Sendable ([UInt8], inout [UInt8]) -> Void) {
            self._compress = compress
        }

        /// Compress data into output buffer
        public func compress(_ input: [UInt8], into output: inout [UInt8]) {
            _compress(input, &output)
        }
    }
}
