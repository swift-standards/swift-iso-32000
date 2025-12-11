// ISO_32000.Writer.swift

import Standards

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
            var state = Writer.State()

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

                // ZapfDingbats and Symbol have built-in encodings (ISO 32000-2 Annex D)
                // Other Standard 14 fonts use WinAnsiEncoding for proper glyph mapping
                if font.family != .zapfDingbats && font.family != .symbol {
                    fontDict[.encoding] = .name(.winAnsiEncoding)
                }

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

            // Pre-allocate page object numbers (needed for destination links)
            // We allocate: 1 for pages dict + N for each page
            let pagesObjNum = state.nextObjectNumber()
            let pagesRef = COS.IndirectReference(objectNumber: pagesObjNum)

            var pageRefs: [COS.IndirectReference] = []
            for _ in document.pages {
                let objNum = state.nextObjectNumber()
                pageRefs.append(COS.IndirectReference(objectNumber: objNum))
            }

            // Create annotation objects for each page (now pageRefs are available)
            var annotRefs: [[COS.IndirectReference]] = []
            for page in document.pages {
                var pageAnnotRefs: [COS.IndirectReference] = []
                for annotation in page.annotations {
                    let objNum = state.nextObjectNumber()
                    pageAnnotRefs.append(COS.IndirectReference(objectNumber: objNum))

                    var annotDict = COS.Dictionary()
                    annotDict[.type] = .name(.annot)
                    // Safe: Subtype raw values are valid PDF names
                    annotDict[.subtype] = .name(try! COS.Name(annotation.subtype.rawValue))
                    annotDict[.rect] = COS.Object(annotation.rect)

                    // Border (common entry)
                    if let border = annotation.border {
                        annotDict[.border] = .array([
                            .real(border.horizontalRadius),
                            .real(border.verticalRadius),
                            .real(border.width),
                        ])
                    }

                    // Serialize type-specific content
                    switch annotation.content {
                    case .link(let link):
                        switch link.target {
                        case .uri(let uri):
                            // URI action for external links
                            var actionDict = COS.Dictionary()
                            actionDict[.s] = .name(.uri)
                            actionDict[.uri] = .string(COS.StringValue(uri))
                            annotDict[.a] = .dictionary(actionDict)

                        case .destination(let dest):
                            // Direct destination for internal links
                            annotDict[.dest] = serializeDestination(dest, pageRefs: pageRefs)
                        }

                    default:
                        // Other annotation types not yet fully implemented in serialization
                        break
                    }

                    state.objectOffsets[objNum] = buffer.count
                    writeIndirectObject(objNum, object: .dictionary(annotDict), into: &buffer)
                }
                annotRefs.append(pageAnnotRefs)
            }

            // Write page objects (object numbers already allocated above)
            for (i, page) in document.pages.enumerated() {
                let pageRef = pageRefs[i]

                var pageDict = COS.Dictionary()
                pageDict[.type] = .name(.page)
                pageDict[.parent] = .reference(pagesRef)
                pageDict[.mediaBox] = COS.Object(page.mediaBox)

                if let cropBox = page.cropBox {
                    pageDict[.cropBox] = COS.Object(cropBox)
                }

                if let rotation = page.rotation, rotation != 0 {
                    pageDict[.rotate] = .integer(Int64(rotation.value))
                }

                // Contents
                if contentRefs[i].count == 1 {
                    pageDict[.contents] = .reference(contentRefs[i][0])
                } else if contentRefs[i].count > 1 {
                    pageDict[.contents] = .array(contentRefs[i].map { .reference($0) })
                }

                // Annotations
                if !annotRefs[i].isEmpty {
                    pageDict[.annots] = .array(annotRefs[i].map { .reference($0) })
                }

                // Resources
                var resourcesDict = COS.Dictionary()

                // Font resources
                if !page.resources.fonts.isEmpty {
                    var fontResourceDict = COS.Dictionary()
                    for name in page.resources.fonts.keys
                        .sorted(by: { $0.rawValue < $1.rawValue }) {
                        if let ref = fontRefs[name] {
                            fontResourceDict[name] = .reference(ref)
                        }
                    }
                    resourcesDict[.font] = .dictionary(fontResourceDict)
                }

                // ProcSet
                resourcesDict[.procSet] = .array([
                    .name(.pdf),
                    .name(.text),
                ])

                pageDict[.resources] = .dictionary(resourcesDict)

                state.objectOffsets[pageRef.objectNumber] = buffer.count
                writeIndirectObject(pageRef.objectNumber, object: .dictionary(pageDict), into: &buffer)
            }

            // Pages dictionary
            var pagesDict = COS.Dictionary()
            pagesDict[.type] = .name(.pages)
            pagesDict[.kids] = .array(pageRefs.map { .reference($0) })
            pagesDict[.count] = .integer(Int64(document.pages.count))

            state.objectOffsets[pagesObjNum] = buffer.count
            writeIndirectObject(pagesObjNum, object: .dictionary(pagesDict), into: &buffer)

            // Outline (if present)
            var outlineRef: COS.IndirectReference?
            if let outline = document.outline, !outline.isEmpty {
                outlineRef = writeOutline(outline, pageRefs: pageRefs, state: &state, into: &buffer)
            }

            // Catalog
            let catalogObjNum = state.nextObjectNumber()
            var catalogDict = COS.Dictionary()
            catalogDict[.type] = .name(.catalog)
            catalogDict[.pages] = .reference(pagesRef)

            if let outlineRef = outlineRef {
                catalogDict[.outlines] = .reference(outlineRef)
            }

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
                    infoDict[.creationDate] = .string(COS.StringValue(date.description))
                }
                if let date = info.modificationDate {
                    infoDict[.modDate] = .string(COS.StringValue(date.description))
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
            state: Writer.State,
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

        // MARK: - Outline Writing

        /// Helper type for tracking outline item metadata during serialization
        private struct OutlineFlatItem {
            let item: Outline.Item
            let objNum: Int
            let parentObjNum: Int
            let prevObjNum: Int?
            let nextObjNum: Int?
            let firstChildObjNum: Int?
            let lastChildObjNum: Int?
        }

        private func writeOutline<Buffer: RangeReplaceableCollection>(
            _ outline: Outline.Root,
            pageRefs: [COS.IndirectReference],
            state: inout Writer.State,
            into buffer: inout Buffer
        ) -> COS.IndirectReference where Buffer.Element == UInt8 {
            // Outline root object number
            let outlineObjNum = state.nextObjectNumber()
            let outlineRef = COS.IndirectReference(objectNumber: outlineObjNum)

            // First pass: assign object numbers to all items in depth-first order
            // We track items by their flat index
            var itemObjNums: [Int] = []  // flatIndex -> objNum
            var allItems: [Outline.Item] = []

            func assignObjectNumbers(_ items: [Outline.Item]) {
                for item in items {
                    let objNum = state.nextObjectNumber()
                    itemObjNums.append(objNum)
                    allItems.append(item)
                    if !item.children.isEmpty {
                        assignObjectNumbers(item.children)
                    }
                }
            }
            assignObjectNumbers(outline.items)

            // Second pass: build flat list with correct references
            var flatItems: [OutlineFlatItem] = []
            var currentIndex = 0

            func buildFlatList(_ items: [Outline.Item], parentObjNum: Int) {
                // First, collect object numbers for all items at this level
                var siblingObjNums: [Int] = []
                var tempIndex = currentIndex
                for item in items {
                    siblingObjNums.append(itemObjNums[tempIndex])
                    tempIndex += 1
                    tempIndex += countDescendants(item)
                }

                // Now build the flat items with correct sibling references
                for (i, item) in items.enumerated() {
                    let myObjNum = itemObjNums[currentIndex]
                    currentIndex += 1

                    // Previous and next siblings from our pre-collected list
                    let prevObjNum = i > 0 ? siblingObjNums[i - 1] : nil
                    let nextObjNum = i < items.count - 1 ? siblingObjNums[i + 1] : nil

                    // First and last child
                    var firstChildObjNum: Int? = nil
                    var lastChildObjNum: Int? = nil
                    if !item.children.isEmpty {
                        firstChildObjNum = itemObjNums[currentIndex]  // Next item is first child
                        // Last child: need to find it
                        var lastChildIndex = currentIndex
                        for (j, child) in item.children.enumerated() {
                            if j == item.children.count - 1 {
                                lastChildObjNum = itemObjNums[lastChildIndex]
                            }
                            lastChildIndex += 1
                            lastChildIndex += countDescendants(child)
                        }
                    }

                    flatItems.append(OutlineFlatItem(
                        item: item,
                        objNum: myObjNum,
                        parentObjNum: parentObjNum,
                        prevObjNum: prevObjNum,
                        nextObjNum: nextObjNum,
                        firstChildObjNum: firstChildObjNum,
                        lastChildObjNum: lastChildObjNum
                    ))

                    if !item.children.isEmpty {
                        buildFlatList(item.children, parentObjNum: myObjNum)
                    }
                }
            }

            // Helper to count all descendants of an item
            func countDescendants(_ item: Outline.Item) -> Int {
                var count = 0
                for child in item.children {
                    count += 1
                    count += countDescendants(child)
                }
                return count
            }

            buildFlatList(outline.items, parentObjNum: outlineObjNum)

            // Write outline root dictionary
            var outlineDict = COS.Dictionary()
            outlineDict[.type] = .name(.outlines)

            if !outline.items.isEmpty {
                outlineDict[.first] = .reference(COS.IndirectReference(objectNumber: itemObjNums[0]))
                // Find last top-level item's object number
                var lastTopLevelIndex = 0
                for (i, item) in outline.items.enumerated() {
                    if i == outline.items.count - 1 {
                        break
                    }
                    lastTopLevelIndex += 1
                    lastTopLevelIndex += countDescendants(item)
                }
                outlineDict[.last] = .reference(COS.IndirectReference(objectNumber: itemObjNums[lastTopLevelIndex]))
            }

            outlineDict[.count] = .integer(Int64(outline.count))

            state.objectOffsets[outlineObjNum] = buffer.count
            writeIndirectObject(outlineObjNum, object: .dictionary(outlineDict), into: &buffer)

            // Write all outline item dictionaries
            for fi in flatItems {
                var itemDict = COS.Dictionary()
                itemDict[.title] = .string(COS.StringValue(fi.item.title))
                itemDict[.parent] = .reference(COS.IndirectReference(objectNumber: fi.parentObjNum))

                if let prev = fi.prevObjNum {
                    itemDict[.prev] = .reference(COS.IndirectReference(objectNumber: prev))
                }
                if let next = fi.nextObjNum {
                    itemDict[.next] = .reference(COS.IndirectReference(objectNumber: next))
                }
                if let first = fi.firstChildObjNum {
                    itemDict[.first] = .reference(COS.IndirectReference(objectNumber: first))
                }
                if let last = fi.lastChildObjNum {
                    itemDict[.last] = .reference(COS.IndirectReference(objectNumber: last))
                }

                // Count: positive if open, negative if closed
                if !fi.item.children.isEmpty {
                    let descendantCount = fi.item.visibleDescendantCount - 1
                    let countValue = fi.item.isOpen ? descendantCount : -descendantCount
                    itemDict[.count] = .integer(Int64(countValue))
                }

                // Target (destination or action)
                if let target = fi.item.target {
                    switch target {
                    case .destination(let destination):
                        itemDict[.dest] = serializeDestination(destination, pageRefs: pageRefs)
                    case .action:
                        // Action serialization not yet implemented
                        break
                    }
                }

                state.objectOffsets[fi.objNum] = buffer.count
                writeIndirectObject(fi.objNum, object: .dictionary(itemDict), into: &buffer)
            }

            return outlineRef
        }

        private func serializeDestination(
            _ dest: Destination,
            pageRefs: [COS.IndirectReference]
        ) -> COS.Object {
            switch dest {
            case .xyz(let page, let left, let top, let zoom):
                let pageRef = pageRefs.indices.contains(page) ? pageRefs[page] : pageRefs[0]
                return .array([
                    .reference(pageRef),
                    .name(.xyz),
                    left.map { .real($0.value) } ?? .null,
                    top.map { .real($0.value) } ?? .null,
                    zoom.map { .real($0) } ?? .null
                ])

            case .fit(let page):
                let pageRef = pageRefs.indices.contains(page) ? pageRefs[page] : pageRefs[0]
                return .array([.reference(pageRef), .name(.fit)])

            case .fitH(let page, let top):
                let pageRef = pageRefs.indices.contains(page) ? pageRefs[page] : pageRefs[0]
                return .array([
                    .reference(pageRef),
                    .name(.fitH),
                    top.map { .real($0.value) } ?? .null
                ])

            case .fitV(let page, let left):
                let pageRef = pageRefs.indices.contains(page) ? pageRefs[page] : pageRefs[0]
                return .array([
                    .reference(pageRef),
                    .name(.fitV),
                    left.map { .real($0.value) } ?? .null
                ])

            case .fitR(let page, let left, let bottom, let right, let top):
                let pageRef = pageRefs.indices.contains(page) ? pageRefs[page] : pageRefs[0]
                return .array([
                    .reference(pageRef),
                    .name(.fitR),
                    .real(left.value),
                    .real(bottom.value),
                    .real(right.value),
                    .real(top.value)
                ])

            case .fitB(let page):
                let pageRef = pageRefs.indices.contains(page) ? pageRefs[page] : pageRefs[0]
                return .array([.reference(pageRef), .name(.fitB)])

            case .fitBH(let page, let top):
                let pageRef = pageRefs.indices.contains(page) ? pageRefs[page] : pageRefs[0]
                return .array([
                    .reference(pageRef),
                    .name(.fitBH),
                    top.map { .real($0.value) } ?? .null
                ])

            case .fitBV(let page, let left):
                let pageRef = pageRefs.indices.contains(page) ? pageRefs[page] : pageRefs[0]
                return .array([
                    .reference(pageRef),
                    .name(.fitBV),
                    left.map { .real($0.value) } ?? .null
                ])

            case .named(let name):
                return .string(COS.StringValue(name))
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

            COS.Dictionary.serialize(trailerDict, into: &buffer)

            buffer.append(contentsOf: "\nstartxref\n".utf8)
            buffer.append(contentsOf: "\(xrefOffset)\n".utf8)
            buffer.append(contentsOf: "%%EOF\n".utf8)
        }
    }
}

// MARK: - Writer State

extension ISO_32000.Writer {
    /// Internal state for PDF writing
    struct State {
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

// MARK: - Binary.Serializable

extension ISO_32000.Document: Binary.Serializable {
    /// Serialize a PDF document to bytes
    ///
    /// Uses a default Writer without compression.
    /// For compression support, use `Writer.write(_:into:)` directly.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Simple usage with .bytes property
    /// let pdfBytes = document.bytes
    ///
    /// // Streaming to a buffer
    /// var buffer: [UInt8] = []
    /// document.serialize(into: &buffer)
    /// ```
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ document: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == UInt8 {
        var writer = ISO_32000.Writer()
        writer.write(document, into: &buffer)
    }
}
