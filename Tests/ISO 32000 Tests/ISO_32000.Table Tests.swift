// ISO_32000.Table Tests.swift
// Tests for ISO 32000-2:2020 Table structure types (14.8.4.8.3)

import Testing
@testable import ISO_32000

// MARK: - Table Structure Type Tests (Table 371)

@Suite
struct `ISO_32000.Table Tests` {

    // MARK: - Table

    @Test
    func `Table with summary`() {
        let table = ISO_32000.`14`.`8`.`4`.`8`.`3`.Table(summary: "Sales data for Q4 2024")
        #expect(table.summary == "Sales data for Q4 2024")
    }

    @Test
    func `Table without summary`() {
        let table = ISO_32000.`14`.`8`.`4`.`8`.`3`.Table()
        #expect(table.summary == nil)
    }

    // MARK: - TR (Table Row)

    @Test
    func `TR creation`() {
        let row = ISO_32000.`14`.`8`.`4`.`8`.`3`.TR()
        #expect(row == ISO_32000.`14`.`8`.`4`.`8`.`3`.TR())
    }

    // MARK: - TH (Table Header)

    @Test
    func `TH with default values`() {
        let header = ISO_32000.`14`.`8`.`4`.`8`.`3`.TH()
        #expect(header.row.span == 1)
        #expect(header.col.span == 1)
        #expect(header.headers.isEmpty)
        #expect(header.scope == nil)
        #expect(header.short == nil)
    }

    @Test
    func `TH spanning multiple rows`() {
        let header = ISO_32000.`14`.`8`.`4`.`8`.`3`.TH(row: .init(span: 3))
        #expect(header.row.span == 3)
        #expect(header.col.span == 1)
    }

    @Test
    func `TH spanning multiple columns`() {
        let header = ISO_32000.`14`.`8`.`4`.`8`.`3`.TH(col: .init(span: 4))
        #expect(header.row.span == 1)
        #expect(header.col.span == 4)
    }

    @Test
    func `TH with row scope`() {
        let header = ISO_32000.`14`.`8`.`4`.`8`.`3`.TH(scope: .row)
        #expect(header.scope == .row)
    }

    @Test
    func `TH with column scope`() {
        let header = ISO_32000.`14`.`8`.`4`.`8`.`3`.TH(scope: .column)
        #expect(header.scope == .column)
    }

    @Test
    func `TH with both scope`() {
        let header = ISO_32000.`14`.`8`.`4`.`8`.`3`.TH(scope: .both)
        #expect(header.scope == .both)
    }

    @Test
    func `TH with headers association`() {
        let header = ISO_32000.`14`.`8`.`4`.`8`.`3`.TH(headers: ["h1", "h2", "h3"])
        #expect(header.headers == ["h1", "h2", "h3"])
    }

    @Test
    func `TH with short form (PDF 2.0)`() {
        let header = ISO_32000.`14`.`8`.`4`.`8`.`3`.TH(short: "Qty")
        #expect(header.short == "Qty")
    }

    @Test
    func `TH fully configured`() {
        let header = ISO_32000.`14`.`8`.`4`.`8`.`3`.TH(
            row: .init(span: 2),
            col: .init(span: 3),
            headers: ["region-header"],
            scope: .column,
            short: "Region"
        )
        #expect(header.row.span == 2)
        #expect(header.col.span == 3)
        #expect(header.headers == ["region-header"])
        #expect(header.scope == .column)
        #expect(header.short == "Region")
    }

    // MARK: - TD (Table Data)

    @Test
    func `TD with default values`() {
        let cell = ISO_32000.`14`.`8`.`4`.`8`.`3`.TD()
        #expect(cell.row.span == 1)
        #expect(cell.col.span == 1)
        #expect(cell.headers.isEmpty)
    }

    @Test
    func `TD spanning multiple rows`() {
        let cell = ISO_32000.`14`.`8`.`4`.`8`.`3`.TD(row: .init(span: 2))
        #expect(cell.row.span == 2)
    }

    @Test
    func `TD spanning multiple columns`() {
        let cell = ISO_32000.`14`.`8`.`4`.`8`.`3`.TD(col: .init(span: 5))
        #expect(cell.col.span == 5)
    }

    @Test
    func `TD with headers association`() {
        let cell = ISO_32000.`14`.`8`.`4`.`8`.`3`.TD(headers: ["name-header", "date-header"])
        #expect(cell.headers == ["name-header", "date-header"])
    }

    // MARK: - THead, TBody, TFoot

    @Test
    func `THead creation`() {
        let thead = ISO_32000.`14`.`8`.`4`.`8`.`3`.THead()
        #expect(thead == ISO_32000.`14`.`8`.`4`.`8`.`3`.THead())
    }

    @Test
    func `TBody creation`() {
        let tbody = ISO_32000.`14`.`8`.`4`.`8`.`3`.TBody()
        #expect(tbody == ISO_32000.`14`.`8`.`4`.`8`.`3`.TBody())
    }

    @Test
    func `TFoot creation`() {
        let tfoot = ISO_32000.`14`.`8`.`4`.`8`.`3`.TFoot()
        #expect(tfoot == ISO_32000.`14`.`8`.`4`.`8`.`3`.TFoot())
    }
}

// MARK: - Scope Tests (Table 384)

@Suite
struct `ISO_32000.TH.Scope Tests` {

    @Test
    func `Scope raw values match spec`() {
        #expect(ISO_32000.`14`.`8`.`4`.`8`.`3`.TH.Scope.row.rawValue == "Row")
        #expect(ISO_32000.`14`.`8`.`4`.`8`.`3`.TH.Scope.column.rawValue == "Column")
        #expect(ISO_32000.`14`.`8`.`4`.`8`.`3`.TH.Scope.both.rawValue == "Both")
    }

    @Test
    func `Scope allCases`() {
        let cases = ISO_32000.`14`.`8`.`4`.`8`.`3`.TH.Scope.allCases
        #expect(cases.count == 3)
        #expect(cases.contains(.row))
        #expect(cases.contains(.column))
        #expect(cases.contains(.both))
    }
}

// MARK: - Caption Tests (Table 372)

@Suite
struct `ISO_32000.Caption Tests` {

    @Test
    func `Caption creation`() {
        let caption = ISO_32000.`14`.`8`.`4`.`8`.`4`.Caption()
        #expect(caption == ISO_32000.`14`.`8`.`4`.`8`.`4`.Caption())
    }
}

// MARK: - Hashable Tests

@Suite
struct `ISO_32000.Table.Hashable Tests` {

    @Test
    func `Table is Hashable`() {
        var set: Set<ISO_32000.`14`.`8`.`4`.`8`.`3`.Table> = []
        set.insert(.init(summary: "test"))
        set.insert(.init(summary: "test"))
        #expect(set.count == 1)
    }

    @Test
    func `TH is Hashable`() {
        var set: Set<ISO_32000.`14`.`8`.`4`.`8`.`3`.TH> = []
        set.insert(.init(scope: .row))
        set.insert(.init(scope: .row))
        #expect(set.count == 1)
    }

    @Test
    func `TD is Hashable`() {
        var set: Set<ISO_32000.`14`.`8`.`4`.`8`.`3`.TD> = []
        set.insert(.init(col: .init(span: 2)))
        set.insert(.init(col: .init(span: 2)))
        #expect(set.count == 1)
    }
}

// MARK: - Serialization Tests

@Suite
struct `ISO_32000.Table.Serialization Tests` {

    @Test
    func `TH serializes to PDF bytes`() {
        let header = ISO_32000.`14`.`8`.`4`.`8`.`3`.TH(
            col: .init(span: 2),
            scope: .column
        )

        var buffer: [UInt8] = []
        ISO_32000.`14`.`8`.`4`.`8`.`3`.TH.serialize(header, into: &buffer)

        let output = String(bytes: buffer, encoding: .utf8)!
        #expect(output.contains("/S /TH"))
        #expect(output.contains("/ColSpan 2"))
        #expect(output.contains("/Scope /Column"))
    }

    @Test
    func `TD serializes to PDF bytes`() {
        let cell = ISO_32000.`14`.`8`.`4`.`8`.`3`.TD(
            row: .init(span: 3),
            headers: ["h1"]
        )

        var buffer: [UInt8] = []
        ISO_32000.`14`.`8`.`4`.`8`.`3`.TD.serialize(cell, into: &buffer)

        let output = String(bytes: buffer, encoding: .utf8)!
        #expect(output.contains("/S /TD"))
        #expect(output.contains("/RowSpan 3"))
        #expect(output.contains("/Headers"))
    }

    @Test
    func `Table with summary serializes`() {
        let table = ISO_32000.`14`.`8`.`4`.`8`.`3`.Table(summary: "Test table")

        var buffer: [UInt8] = []
        ISO_32000.`14`.`8`.`4`.`8`.`3`.Table.serialize(table, into: &buffer)

        let output = String(bytes: buffer, encoding: .utf8)!
        #expect(output.contains("/S /Table"))
        #expect(output.contains("/Summary"))
    }

    @Test
    func `TH default values omit optional attributes`() {
        let header = ISO_32000.`14`.`8`.`4`.`8`.`3`.TH()

        var buffer: [UInt8] = []
        ISO_32000.`14`.`8`.`4`.`8`.`3`.TH.serialize(header, into: &buffer)

        let output = String(bytes: buffer, encoding: .utf8)!
        // Default span=1 should be omitted
        #expect(!output.contains("/RowSpan"))
        #expect(!output.contains("/ColSpan"))
        #expect(!output.contains("/Headers"))
        #expect(!output.contains("/Scope"))
        #expect(!output.contains("/Short"))
    }
}

// MARK: - Well-Known Name Tests

@Suite
struct `ISO_32000.Table.Name Tests` {

    @Test
    func `Table structure type names`() {
        #expect(ISO_32000.COS.Name.table.rawValue == "Table")
        #expect(ISO_32000.COS.Name.tr.rawValue == "TR")
        #expect(ISO_32000.COS.Name.th.rawValue == "TH")
        #expect(ISO_32000.COS.Name.td.rawValue == "TD")
        #expect(ISO_32000.COS.Name.thead.rawValue == "THead")
        #expect(ISO_32000.COS.Name.tbody.rawValue == "TBody")
        #expect(ISO_32000.COS.Name.tfoot.rawValue == "TFoot")
    }

    @Test
    func `Table attribute names`() {
        #expect(ISO_32000.COS.Name.rowSpan.rawValue == "RowSpan")
        #expect(ISO_32000.COS.Name.colSpan.rawValue == "ColSpan")
        #expect(ISO_32000.COS.Name.headersAttr.rawValue == "Headers")
        #expect(ISO_32000.COS.Name.scopeAttr.rawValue == "Scope")
        #expect(ISO_32000.COS.Name.summaryAttr.rawValue == "Summary")
        #expect(ISO_32000.COS.Name.shortAttr.rawValue == "Short")
    }

    @Test
    func `Scope value names`() {
        #expect(ISO_32000.COS.Name.row.rawValue == "Row")
        #expect(ISO_32000.COS.Name.column.rawValue == "Column")
        #expect(ISO_32000.COS.Name.both.rawValue == "Both")
    }
}
