public struct ZoneOffset: Hashable {
    public var second: Int
    
    public init(second: Int) {
        self.second = second
    }
    
    public init<S: StringProtocol>(from string: S) throws {
        self.init(second: try parse(string))
    }
}

extension ZoneOffset: CustomStringConvertible {
    public var description: String {
        if second == 0 {
            return "Z"
        }
        
        let s = abs(second)
        let hour = s / 60 / 60
        let minute = s / 60 % 60
        let sign = second < 0 ? "-" : "+"
        
        return sign + "\(hour, width: 2):\(minute, width: 2)"
    }
}

extension ZoneOffset: LosslessStringConvertible {
    public init?(_ description: String) {
        try? self.init(from: description)
    }
}

extension ZoneOffset: Codable {
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

extension ZoneOffset: Comparable {
    public static func < (lhs: ZoneOffset, rhs: ZoneOffset) -> Bool {
        rhs.second < lhs.second
    }
}

public extension ZoneOffset {
    enum Error: Swift.Error, Equatable {
        case invalidStringFormat
    }
}

private func parse<S: StringProtocol>(_ string: S) throws -> Int {
    if string.isEmpty {
        throw ZoneOffset.Error.invalidStringFormat
    }
    
    let string = Substring(string).utf8
    let sign: Int
    switch string[string.startIndex] {
    case .init(ascii: "Z") where string.count == 1:
        return 0
    case .init(ascii: "+"):
        sign = 1
    case .init(ascii: "-"):
        sign = -1
    default:
        throw ZoneOffset.Error.invalidStringFormat
    }
    
    guard
        let index = string.firstIndex(of: .init(ascii: ":")),
        let hour = Int(Substring(string[string.index(after: string.startIndex)..<index])),
        let minute = Int(Substring(string[string.index(after: index)...]))
    else {
        throw ZoneOffset.Error.invalidStringFormat
    }
    
    return sign * ((hour * 60 * 60) + (minute * 60))
}
