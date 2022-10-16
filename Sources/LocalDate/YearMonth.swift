import Foundation

public struct YearMonth: Hashable {
    public var year: Int
    public var month: Int
    
    public init(year: Int, month: Int) {
        self.year = year
        self.month = month
    }
    
    public init(from date: Date = .init(), in timeZone: TimeZone = .current) {
        let components = Calendar.gregorian.dateComponents(in: timeZone, from: date)
        self.init(year: components.year!, month: components.month!)
    }
    
    public init<S: StringProtocol>(from string: S) throws {
        let string = Substring(string).utf8
        let hasSign = string.first == .init(ascii: "-")
        
        guard
            let i1 = string[string.index(string.startIndex, offsetBy: hasSign ? 1 : 0)...].firstIndex(of: .init(ascii: "-")),
            let year = Int(Substring(string[..<i1])),
            let month = Int(Substring(string[string.index(after: i1)...]))
        else {
            throw FormatError()
        }
        
        self.init(year: year, month: month)
    }
    
    public var endOfMonth: LocalDate {
        LocalDate(year: year, month: month, day: Month.lengthOfMonth(month, isLeapYear: isLeapYear(year)))
    }
    
    public func atDay(_ day: Int) -> LocalDate {
        LocalDate(year: year, month: month, day: day)
    }
    
    public func addingMonths(_ months: Int) -> Self {
        let (q, r) = ((year * 12) + month + months).quotientAndRemainder(dividingBy: 12)
        
        return Self(
            year: r <= 0 ? q - 1 : q,
            month: r <= 0 ? 12 + r : r
        )
    }
}

extension YearMonth: CustomStringConvertible {
    public var description: String {
        return "\(year, width: 4)-\(month, width: 2)"
    }
}

extension YearMonth: LosslessStringConvertible {
    public init?(_ description: String) {
        try? self.init(from: description)
    }
}

extension YearMonth: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        do {
            try self.init(from: string)
        } catch {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "invalid format",
                    underlyingError: error
                )
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

extension YearMonth: Comparable {
    public static func < (lhs: YearMonth, rhs: YearMonth) -> Bool {
        (lhs.year, lhs.month) < (rhs.year, rhs.month)
    }
}
