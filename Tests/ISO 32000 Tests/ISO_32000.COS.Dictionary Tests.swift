// ISO_32000.COS.Dictionary Tests.swift

import Testing
@testable import ISO_32000

@Suite
struct `ISO_32000.COS.Dictionary Tests` {

    // MARK: - Construction

    @Test
    func `Creates empty dictionary`() {
        let dict: ISO_32000.COS.Dictionary = [:]
        #expect(dict.isEmpty)
        #expect(dict.count == 0)
    }

    @Test
    func `Creates dictionary with initial entries`() throws {
        let dict: ISO_32000.COS.Dictionary = [
            .type: .name(.catalog),
            .pages: .integer(5)
        ]
        #expect(dict.count == 2)
        #expect(dict[.type] == .name(.catalog))
        #expect(dict[.pages] == .integer(5))
    }

    // MARK: - Subscript Access

    @Test
    func `Gets existing entry`() throws {
        var dict: ISO_32000.COS.Dictionary = [:]
        dict[.type] = .name(.catalog)
        #expect(dict[.type] == .name(.catalog))
    }

    @Test
    func `Gets nil for missing entry`() {
        let dict: ISO_32000.COS.Dictionary = [:]
        #expect(dict[.type] == nil)
    }

    @Test
    func `Sets new entry`() throws {
        var dict: ISO_32000.COS.Dictionary = [:]
        dict[.author] = .string(ISO_32000.COS.StringValue("Swift"))
        #expect(dict[.author] == .string(ISO_32000.COS.StringValue("Swift")))
    }

    @Test
    func `Overwrites existing entry`() throws {
        var dict: ISO_32000.COS.Dictionary = [:]
        dict[.type] = .name(.catalog)
        dict[.type] = .name(.page)
        #expect(dict[.type] == .name(.page))
    }

    @Test
    func `Removes entry by setting nil`() throws {
        var dict: ISO_32000.COS.Dictionary = [:]
        dict[.type] = .name(.catalog)
        dict[.type] = nil
        #expect(dict[.type] == nil)
        #expect(dict.isEmpty)
    }

    // MARK: - Keys and Values

    @Test
    func `Keys collection`() throws {
        let dict: ISO_32000.COS.Dictionary = [
            .type: .name(.page),
            .parent: .reference(ISO_32000.COS.IndirectReference(objectNumber: 2, generation: 0))
        ]
        let keys = Array(dict.keys)
        #expect(keys.count == 2)
        #expect(keys.contains(.type))
        #expect(keys.contains(.parent))
    }

    @Test
    func `Values collection`() throws {
        let dict: ISO_32000.COS.Dictionary = [
            .count: .integer(5),
            .length: .integer(100)
        ]
        let values = Array(dict.values)
        #expect(values.count == 2)
    }

    // MARK: - Sorted Entries

    @Test
    func `Sorted entries are alphabetical by key`() throws {
        let dict: ISO_32000.COS.Dictionary = [
            .type: .name(.page),
            .author: .string(ISO_32000.COS.StringValue("Test")),
            .count: .integer(1)
        ]
        let sorted = dict.sortedEntries
        #expect(sorted[0].key == .author)
        #expect(sorted[1].key == .count)
        #expect(sorted[2].key == .type)
    }

    // MARK: - Equality

    @Test
    func `Equal dictionaries with same entries`() throws {
        let a: ISO_32000.COS.Dictionary = [.type: .name(.page)]
        let b: ISO_32000.COS.Dictionary = [.type: .name(.page)]
        #expect(a == b)
    }

    @Test
    func `Unequal dictionaries with different entries`() throws {
        let a: ISO_32000.COS.Dictionary = [.type: .name(.page)]
        let b: ISO_32000.COS.Dictionary = [.type: .name(.catalog)]
        #expect(a != b)
    }

    // MARK: - Serialization

    @Test
    func `Serializes dictionary to PDF syntax`() throws {
        let dict: ISO_32000.COS.Dictionary = [.type: .name(.page)]
        var buffer: [UInt8] = []
        ISO_32000.COS.serializeDictionary(dict, into: &buffer)
        let str = String(decoding: buffer, as: UTF8.self)
        #expect(str.contains("<<"))
        #expect(str.contains(">>"))
        #expect(str.contains("/Type"))
    }
}
