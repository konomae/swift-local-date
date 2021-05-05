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
        year = components.year!
        month = components.month!
        day = components.day!
    }
    
    public init(from string: String) throws {
        guard let date = formatter.date(from: string) else {
            throw Error.invalidStringFormat
        }
        
        self.init(from: date)
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
        formatter.string(from: date(in: formatter.timeZone))
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

public extension LocalDate {
    enum Error: Swift.Error, Equatable {
        case invalidStringFormat
    }
}

private let formatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "en_US_POSIX")
    f.dateFormat = "yyyy-MM-dd"
    f.timeZone = TimeZone(secondsFromGMT: 0)!
    return f
}()
