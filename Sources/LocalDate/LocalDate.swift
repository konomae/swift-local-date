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
    
    public init<S: StringProtocol>(from string: S) throws {
        let string = Substring(string).utf8
        let hasSign = string.first == .init(ascii: "-")
        
        guard
            let i1 = string[string.index(string.startIndex, offsetBy: hasSign ? 1 : 0)...].firstIndex(of: .init(ascii: "-")),
            let i2 = string[string.index(after: i1)...].firstIndex(of: .init(ascii: "-")),
            let year = Int(Substring(string[..<i1])),
            let month = Int(Substring(string[string.index(after: i1)..<i2])),
            let day = Int(Substring(string[string.index(after: i2)...]))
        else {
            throw Error.invalidStringFormat
        }
        
        self.init(year: year, month: month, day: day)
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
}

extension LocalDate: CustomStringConvertible {
    public var description: String {
        return "\(year, width: 4)-\(month, width: 2)-\(day, width: 2)"
    }
}

extension LocalDate: LosslessStringConvertible {
    public init?(_ description: String) {
        try? self.init(from: description)
    }
}

extension LocalDate: Codable {
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
