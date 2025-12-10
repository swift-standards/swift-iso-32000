// ISO_32000.COS.Object Tests.swift

import Testing

@testable import ISO_32000

@Suite
struct `ISO_32000.COS.Object Tests` {

    // MARK: - Null

    @Test
    func `Null object`() {
        let obj = ISO_32000.COS.Object.null
        if case .null = obj {
            // pass
        } else {
            Issue.record("Expected null object")
        }
    }

    // MARK: - Boolean

    @Test
    func `Boolean true`() {
        let obj = ISO_32000.COS.Object.boolean(true)
        if case .boolean(let value) = obj {
            #expect(value == true)
        } else {
            Issue.record("Expected boolean object")
        }
    }

    @Test
    func `Boolean false`() {
        let obj = ISO_32000.COS.Object.boolean(false)
        if case .boolean(let value) = obj {
            #expect(value == false)
        } else {
            Issue.record("Expected boolean object")
        }
    }

    @Test
    func `Boolean via literal`() {
        let obj: ISO_32000.COS.Object = true
        #expect(obj == .boolean(true))
    }

    // MARK: - Integer

    @Test
    func `Integer positive`() {
        let obj = ISO_32000.COS.Object.integer(42)
        if case .integer(let value) = obj {
            #expect(value == 42)
        } else {
            Issue.record("Expected integer object")
        }
    }

    @Test
    func `Integer negative`() {
        let obj = ISO_32000.COS.Object.integer(-100)
        if case .integer(let value) = obj {
            #expect(value == -100)
        } else {
            Issue.record("Expected integer object")
        }
    }

    @Test
    func `Integer via literal`() {
        let obj: ISO_32000.COS.Object = 42
        #expect(obj == .integer(42))
    }

    @Test
    func `Integer from Int`() {
        let obj = ISO_32000.COS.Object.integer(100)
        #expect(obj == .integer(100))
    }

    // MARK: - Real

    @Test
    func `Real positive`() {
        let obj = ISO_32000.COS.Object.real(3.14159)
        if case .real(let value) = obj {
            #expect(abs(value - 3.14159) < 0.0001)
        } else {
            Issue.record("Expected real object")
        }
    }

    @Test
    func `Real negative`() {
        let obj = ISO_32000.COS.Object.real(-2.5)
        if case .real(let value) = obj {
            #expect(value == -2.5)
        } else {
            Issue.record("Expected real object")
        }
    }

    @Test
    func `Real via literal`() {
        let obj: ISO_32000.COS.Object = 3.14
        if case .real(let value) = obj {
            #expect(abs(value - 3.14) < 0.001)
        } else {
            Issue.record("Expected real object")
        }
    }

    // MARK: - Name

    @Test
    func `Name object`() {
        let obj = ISO_32000.COS.Object.name(.type)
        if case .name(let name) = obj {
            #expect(name == .type)
        } else {
            Issue.record("Expected name object")
        }
    }

    @Test
    func `Name from string convenience`() {
        let obj = ISO_32000.COS.Object.name("Custom")
        #expect(obj != nil)
        if case .name(let name) = obj {
            #expect(name.rawValue == "Custom")
        }
    }

    @Test
    func `Name from invalid string returns nil`() {
        let obj = ISO_32000.COS.Object.name("Has Space")
        #expect(obj == nil)
    }

    // MARK: - String

    @Test
    func `String object`() {
        let obj = ISO_32000.COS.Object.string(ISO_32000.COS.StringValue("Hello"))
        if case .string(let str) = obj {
            #expect(str.value == "Hello")
        } else {
            Issue.record("Expected string object")
        }
    }

    @Test
    func `String from string convenience`() {
        let obj = ISO_32000.COS.Object.string("World")
        if case .string(let str) = obj {
            #expect(str.value == "World")
        } else {
            Issue.record("Expected string object")
        }
    }

    // MARK: - Array

    @Test
    func `Array object`() {
        let obj = ISO_32000.COS.Object.array([.integer(1), .integer(2), .integer(3)])
        if case .array(let elements) = obj {
            #expect(elements.count == 3)
        } else {
            Issue.record("Expected array object")
        }
    }

    @Test
    func `Array via literal`() {
        let obj: ISO_32000.COS.Object = [1, 2, 3]
        if case .array(let elements) = obj {
            #expect(elements.count == 3)
            #expect(elements[0] == .integer(1))
        } else {
            Issue.record("Expected array object")
        }
    }

    @Test
    func `Mixed array`() {
        let obj: ISO_32000.COS.Object = [1, 2.5, true]
        if case .array(let elements) = obj {
            #expect(elements.count == 3)
            #expect(elements[0] == .integer(1))
            if case .real(_) = elements[1] {
                // pass
            } else {
                Issue.record("Expected real at index 1")
            }
            #expect(elements[2] == .boolean(true))
        } else {
            Issue.record("Expected array object")
        }
    }

    // MARK: - Dictionary

    @Test
    func `Dictionary object`() {
        let dict: ISO_32000.COS.Dictionary = [.type: .name(.page)]
        let obj = ISO_32000.COS.Object.dictionary(dict)
        if case .dictionary(let d) = obj {
            #expect(d[.type] == .name(.page))
        } else {
            Issue.record("Expected dictionary object")
        }
    }

    // MARK: - Reference

    @Test
    func `Indirect reference`() {
        let ref = ISO_32000.COS.IndirectReference(objectNumber: 5, generation: 0)
        let obj = ISO_32000.COS.Object.reference(ref)
        if case .reference(let r) = obj {
            #expect(r.objectNumber == 5)
            #expect(r.generation == 0)
        } else {
            Issue.record("Expected reference object")
        }
    }

    // MARK: - Equality

    @Test
    func `Objects of same type and value are equal`() {
        #expect(ISO_32000.COS.Object.integer(42) == .integer(42))
        #expect(ISO_32000.COS.Object.boolean(true) == .boolean(true))
        #expect(ISO_32000.COS.Object.null == .null)
    }

    @Test
    func `Objects of different types are not equal`() {
        #expect(ISO_32000.COS.Object.integer(1) != .real(1.0))
        #expect(ISO_32000.COS.Object.boolean(true) != .integer(1))
    }
}
