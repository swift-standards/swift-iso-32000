// ISO_32000.COS.Object.swift

extension ISO_32000.COS {
    /// A PDF object (COS object)
    ///
    /// Per ISO 32000-1 Section 7.3, PDF supports these object types:
    /// - Boolean, Integer, Real (numeric)
    /// - String (literal or hexadecimal)
    /// - Name (symbolic identifier)
    /// - Array (ordered collection)
    /// - Dictionary (key-value mapping)
    /// - Stream (dictionary + binary data)
    /// - Null
    /// - Indirect Reference (pointer to another object)
    public enum Object: Sendable, Hashable {
        /// Null object
        case null

        /// Boolean value
        case boolean(Bool)

        /// Integer value (platform-independent 64-bit)
        case integer(Int64)

        /// Real (floating-point) value
        case real(Double)

        /// PDF Name object
        case name(Name)

        /// PDF String object
        case string(StringValue)

        /// Array of objects
        case array([Object])

        /// Dictionary (name -> object mapping)
        case dictionary(Dictionary)

        /// Stream (dictionary + binary data)
        case stream(Stream)

        /// Indirect reference to another object
        case reference(IndirectReference)
    }
}

// MARK: - Convenience Initializers

extension ISO_32000.COS.Object {
    /// Create an integer object
    public static func integer(_ value: Int) -> Self {
        .integer(Int64(value))
    }

    /// Create a name object from a string
    public static func name(_ value: String) -> Self? {
        guard let name = try? ISO_32000.COS.Name(value) else { return nil }
        return .name(name)
    }

    /// Create a string object
    public static func string(_ value: String) -> Self {
        .string(ISO_32000.COS.StringValue(value))
    }
}

// MARK: - ExpressibleBy Protocols

extension ISO_32000.COS.Object: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .boolean(value)
    }
}

extension ISO_32000.COS.Object: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int64) {
        self = .integer(value)
    }
}

extension ISO_32000.COS.Object: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .real(value)
    }
}

extension ISO_32000.COS.Object: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: ISO_32000.COS.Object...) {
        self = .array(elements)
    }
}
