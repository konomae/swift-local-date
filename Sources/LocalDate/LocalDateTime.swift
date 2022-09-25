import Foundation

public struct LocalDateTime: Hashable {
    public var date: LocalDate
    public var time: LocalTime
    
    public init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, nanosecond: Int) {
        self.init(
            date: LocalDate(year: year, month: month, day: day),
            time: LocalTime(hour: hour, minute: minute, second: second, nanosecond: nanosecond)
        )
    }
    
    public init(date: LocalDate, time: LocalTime) {
        self.date = date
        self.time = time
    }
    
    public init(from date: Date = .init(), in timeZone: TimeZone = .current) {
        let components = Calendar.gregorian.dateComponents(in: timeZone, from: date)
        self.init(
            year: components.year!,
            month: components.month!,
            day: components.day!,
            hour: components.hour!,
            minute: components.minute!,
            second: components.second!,
            nanosecond: components.nanosecond!
        )
    }
    
    public init<S: StringProtocol>(from string: S) throws {
        let string = Substring(string).utf8
        
        guard let index = string.firstIndex(of: .init(ascii: "T")) else {
            throw FormatError()
        }
        
        let date = try LocalDate(from: Substring(string[..<index]))
        let time = try LocalTime(from: Substring(string[string.index(after: index)...]))
        
        self.init(date: date, time: time)
    }
    
    public var year: Int {
        date.year
    }
    
    public var month: Int {
        date.month
    }
    
    public var day: Int {
        date.day
    }
    
    public var hour: Int {
        time.hour
    }
    
    public var minute: Int {
        time.minute
    }
    
    public var second: Int {
        time.second
    }
    
    public var nanosecond: Int {
        time.nanosecond
    }
}

extension LocalDateTime: CustomStringConvertible {
    public var description: String {
        "\(date)T\(time)"
    }
}

extension LocalDateTime: LosslessStringConvertible {
    public init?(_ description: String) {
        try? self.init(from: description)
    }
}

extension LocalDateTime: Codable {
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

extension LocalDateTime: Comparable {
    public static func < (lhs: LocalDateTime, rhs: LocalDateTime) -> Bool {
        (lhs.date, lhs.time) < (rhs.date, rhs.time)
    }
}
