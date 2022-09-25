import Foundation

public struct OffsetDateTime: Hashable {
    public var dateTime: LocalDateTime
    public var offset: ZoneOffset
    
    public init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, nanosecond: Int, offset: ZoneOffset) {
        self.init(
            dateTime: LocalDateTime(
                date: LocalDate(year: year, month: month, day: day),
                time: LocalTime(hour: hour, minute: minute, second: second, nanosecond: nanosecond)
            ),
            offset: offset
        )
    }
    
    public init(dateTime: LocalDateTime, offset: ZoneOffset) {
        self.dateTime = dateTime
        self.offset = offset
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
            nanosecond: components.nanosecond!,
            offset: ZoneOffset(timeZone: timeZone)
        )
    }
    
    public init<S: StringProtocol>(from string: S) throws {
        let string = Substring(string).utf8
        
        guard let index = string.lastIndex(where: { $0 == .init(ascii: "Z") || $0 == .init(ascii: "+") || $0 == .init(ascii: "-") }) else {
            throw FormatError()
        }

        self.init(
            dateTime: try LocalDateTime(from: Substring(string[..<index])),
            offset: try ZoneOffset(from: Substring(string[index...]))
        )
    }
    
    var dateComponentsWithoutNanosecond: DateComponents {
        DateComponents(
            calendar: .gregorian,
            timeZone: offset.timeZone,
            year: dateTime.date.year,
            month: dateTime.date.month,
            day: dateTime.date.day,
            hour: dateTime.time.hour,
            minute: dateTime.time.minute,
            second: dateTime.time.second
        )
    }
    
    public var year: Int {
        dateTime.date.year
    }
    
    public var month: Int {
        dateTime.date.month
    }
    
    public var day: Int {
        dateTime.date.day
    }
    
    public var hour: Int {
        dateTime.time.hour
    }
    
    public var minute: Int {
        dateTime.time.minute
    }
    
    public var second: Int {
        dateTime.time.second
    }
    
    public var nanosecond: Int {
        dateTime.time.nanosecond
    }
}

extension OffsetDateTime: CustomStringConvertible {
    public var description: String {
        "\(dateTime)\(offset)"
    }
}

extension OffsetDateTime: LosslessStringConvertible {
    public init?(_ description: String) {
        try? self.init(from: description)
    }
}


extension OffsetDateTime: Codable {
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

extension OffsetDateTime: Comparable {
    public static func < (lhs: OffsetDateTime, rhs: OffsetDateTime) -> Bool {
        let leftDate = lhs.dateComponentsWithoutNanosecond.date!
        let rightDate = rhs.dateComponentsWithoutNanosecond.date!
        
        if (leftDate, lhs.dateTime.time.nanosecond) == (rightDate, rhs.dateTime.time.nanosecond) {
            return lhs.dateTime < rhs.dateTime
        }
        
        return (leftDate, lhs.dateTime.time.nanosecond) < (rightDate, rhs.dateTime.time.nanosecond)
    }
}
