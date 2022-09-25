import Foundation

public struct LocalTime: Hashable {
    public var hour: Int
    public var minute: Int
    public var second: Int
    public var nanosecond: Int
    
    public init(hour: Int, minute: Int, second: Int, nanosecond: Int) {
        self.hour = hour
        self.minute = minute
        self.second = second
        self.nanosecond = nanosecond
    }
    
    public init(from date: Date = .init(), in timeZone: TimeZone = .current) {
        let components = Calendar.gregorian.dateComponents(in: timeZone, from: date)
        self.init(hour: components.hour!, minute: components.minute!, second: components.second!, nanosecond: components.nanosecond!)
    }
    
    public init<S: StringProtocol>(from string: S) throws {
        var string = Substring(string).utf8
        
        let nanosecond: Int
        if let index = string.lastIndex(of: .init(ascii: ".")) {
            let secfrac = string[string.index(after: index)...]
            guard let n = Int(Substring(secfrac)) else {
                throw FormatError()
            }
            nanosecond = n * Int(pow(10, Double(9 - secfrac.count)))
            string = string[..<index]
        } else {
            nanosecond = 0
        }
        
        guard
            let i1 = string.firstIndex(of: .init(ascii: ":")),
            let i2 = string[string.index(after: i1)...].firstIndex(of: .init(ascii: ":")),
            let hour = Int(Substring(string[..<i1])),
            let minute = Int(Substring(string[string.index(after: i1)..<i2])),
            let second = Int(Substring(string[string.index(after: i2)...]))
        else {
            throw FormatError()
        }
        
        self.init(hour: hour, minute: minute, second: second, nanosecond: nanosecond)
    }
}

extension LocalTime: CustomStringConvertible {
    public var description: String {
        let s = "\(hour, width: 2):\(minute, width: 2):\(second, width: 2)"
        
        guard nanosecond != 0 else {
            return s
        }
        
        let n = "\(nanosecond, width: 9)".utf8
        return s + "." + String(n.prefix(through: n.lastIndex { $0 != .init(ascii: "0") }!))!
    }
}

extension LocalTime: LosslessStringConvertible {
    public init?(_ description: String) {
        try? self.init(from: description)
    }
}

extension LocalTime: Codable {
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

extension LocalTime: Comparable {
    public static func < (lhs: LocalTime, rhs: LocalTime) -> Bool {
        (lhs.hour, lhs.minute, lhs.second, lhs.nanosecond) < (rhs.hour, rhs.minute, rhs.second, rhs.nanosecond)
    }
}
