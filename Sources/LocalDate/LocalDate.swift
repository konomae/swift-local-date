import Foundation

public struct LocalDate {
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
        let f = ISO8601DateFormatter()
        f.formatOptions = .withFullDate
        
        guard let date = f.date(from: string) else {
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
}

public extension LocalDate {
    enum Error: Swift.Error, Equatable {
        case invalidStringFormat
    }
}
