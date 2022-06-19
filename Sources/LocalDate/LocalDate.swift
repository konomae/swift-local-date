import Foundation

public struct LocalDate: Hashable {
    public var year: Int
    public var month: Int
    public var day: Int
    
    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    public init(from date: Date = .init(), in timeZone: TimeZone = .current) {
        let components = Calendar(identifier: .gregorian).dateComponents(in: timeZone, from: date)
        self.init(year: components.year!, month: components.month!, day: components.day!)
    }
    
    public init(from string: String) throws {
        let hasSign = string.hasPrefix("-")
        let startIndex = string.index(string.startIndex, offsetBy: hasSign ? 1 : 0)
        
        let components = string[startIndex...].utf8.split(
            separator: .init(ascii: "-"),
            maxSplits: 3,
            omittingEmptySubsequences: false
        )
        
        guard
            components.count == 3,
            let year = Int(Substring(components[0])),
            let month = Int(Substring(components[1])),
            let day = Int(Substring(components[2]))
        else {
            throw Error.invalidStringFormat
        }
        
        self.init(year: year * (hasSign ? -1 : 1), month: month, day: day)
    }
    
    public func date(in timeZone: TimeZone) -> Date {
        let components = DateComponents(
            calendar: Calendar(identifier: .gregorian),
            timeZone: timeZone,
            year: year,
            month: month,
            day: day
        )
        
        return components.date!
    }
    
    public func string() -> String {
        String(format: "%04ld-%02ld-%02ld", year, month, day)
    }
}

extension LocalDate: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        try self.init(from: string)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string())
    }
}

extension LocalDate: Comparable {
    public static func < (lhs: LocalDate, rhs: LocalDate) -> Bool {
        (lhs.year, lhs.month, lhs.day) < (rhs.year, rhs.month, rhs.day)
    }
}

public extension LocalDate {
    enum Error: Swift.Error, Equatable {
        case invalidStringFormat
    }
}
