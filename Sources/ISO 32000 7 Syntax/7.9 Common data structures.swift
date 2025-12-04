// ISO 32000-2:2020, 7.9 Common data structures
//
// Sections:
//   7.9.1  General
//   7.9.2  String object types
//   7.9.3  Text streams
//   7.9.4  Dates
//   7.9.5  Rectangles
//   7.9.6  Name trees
//   7.9.7  Number trees

public import ISO_32000_Shared

extension ISO_32000.`7` {
    /// ISO 32000-2:2020, 7.9 Common data structures
    public enum `9` {}
}

// MARK: - 7.9.4 Dates

extension ISO_32000.`7`.`9` {
    /// ISO 32000-2:2020, 7.9.4 Dates
    public enum `4` {}
}

extension ISO_32000.`7`.`9`.`4` {
    /// PDF Date representation
    ///
    /// Per ISO 32000-2 Section 7.9.4:
    /// > Date values used in a PDF file shall conform to a standard date format,
    /// > which closely follows that of the international standard ASN.1 (Abstract
    /// > Syntax Notation One). A date shall be a text string of the form:
    /// > `D:YYYYMMDDHHmmSSOHH'mm`
    ///
    /// ## Format Components
    ///
    /// - `YYYY`: Four-digit year
    /// - `MM`: Two-digit month (01–12)
    /// - `DD`: Two-digit day (01–31)
    /// - `HH`: Two-digit hour (00–23)
    /// - `mm`: Two-digit minute (00–59)
    /// - `SS`: Two-digit second (00–59)
    /// - `O`: Relationship to UTC (`+`, `-`, or `Z`)
    /// - `HH'mm`: Offset from UTC in hours and minutes
    ///
    /// ## Reference
    ///
    /// ISO 32000-2:2020, Section 7.9.4 — Dates
    public struct Date: Sendable, Hashable {
        public var year: Int
        public var month: Int
        public var day: Int
        public var hour: Int
        public var minute: Int
        public var second: Int

        public init(
            year: Int,
            month: Int,
            day: Int,
            hour: Int = 0,
            minute: Int = 0,
            second: Int = 0
        ) {
            self.year = year
            self.month = month
            self.day = day
            self.hour = hour
            self.minute = minute
            self.second = second
        }
    }
}

extension ISO_32000.`7`.`9`.`4`.Date: CustomStringConvertible {
    /// Format as PDF date string: `D:YYYYMMDDHHmmss`
    public var description: Swift.String {
        func pad(_ value: Int, width: Int) -> Swift.String {
            var s = Swift.String(value)
            while s.count < width {
                s = "0" + s
            }
            return s
        }
        return "D:\(pad(year, width: 4))\(pad(month, width: 2))\(pad(day, width: 2))\(pad(hour, width: 2))\(pad(minute, width: 2))\(pad(second, width: 2))"
    }
}

// MARK: - 7.9.5 Rectangles

extension ISO_32000.`7`.`9` {
    /// ISO 32000-2:2020, 7.9.5 Rectangles
    ///
    /// This section defines rectangles as arrays of four numbers representing
    /// coordinates. The actual types are generic and defined in ISO_32000_Shared,
    /// specialized here for Double (raw PDF values).
    public enum `5` {}
}

// Note: The generic Point<Unit>, Size<Unit>, and Rectangle<Unit> are defined
// in ISO_32000_Shared. Section 7.9.5 uses Double coordinates directly for
// raw PDF file representation. The typed UserSpace versions are in Section 8.3.2.3.
