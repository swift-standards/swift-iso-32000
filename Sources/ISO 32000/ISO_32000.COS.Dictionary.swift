// ISO_32000.COS.Dictionary.swift

extension ISO_32000.COS {
    /// PDF Dictionary object
    ///
    /// Per ISO 32000-1 Section 7.3.7, a dictionary is an associative table
    /// mapping names to objects.
    ///
    /// ## Serialization
    ///
    /// ```
    /// << /Type /Catalog /Pages 2 0 R >>
    /// ```
    public struct Dictionary: Sendable, Hashable {
        /// The underlying storage
        private var storage: [Name: Object]

        /// Create an empty dictionary
        public init() {
            self.storage = [:]
        }

        /// Create a dictionary with initial entries
        public init(_ entries: [Name: Object]) {
            self.storage = entries
        }

        /// Access dictionary entries
        public subscript(key: Name) -> Object? {
            get { storage[key] }
            set { storage[key] = newValue }
        }

        /// All keys in the dictionary
        public var keys: Swift.Dictionary<Name, Object>.Keys {
            storage.keys
        }

        /// All values in the dictionary
        public var values: Swift.Dictionary<Name, Object>.Values {
            storage.values
        }

        /// Number of entries
        public var count: Int {
            storage.count
        }

        /// Whether the dictionary is empty
        public var isEmpty: Bool {
            storage.isEmpty
        }

        /// Iterate over entries in a consistent order (sorted by key)
        public var sortedEntries: [(key: Name, value: Object)] {
            storage.sorted { $0.key.rawValue < $1.key.rawValue }
        }
    }
}

// MARK: - ExpressibleByDictionaryLiteral

extension ISO_32000.COS.Dictionary: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (ISO_32000.COS.Name, ISO_32000.COS.Object)...) {
        self.storage = [:]
        for (key, value) in elements {
            self.storage[key] = value
        }
    }
}

// MARK: - CustomStringConvertible

extension ISO_32000.COS.Dictionary: CustomStringConvertible {
    public var description: String {
        let entries = sortedEntries.map { "\($0.key) \($0.value)" }.joined(separator: " ")
        return "<< \(entries) >>"
    }
}
