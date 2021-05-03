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
    
    public init(from date: Date, in timeZone: TimeZone) {
        let components = Calendar(identifier: .gregorian).dateComponents(in: timeZone, from: date)
        year = components.year!
        month = components.month!
        day = components.day!
    }
}
