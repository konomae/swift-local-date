@frozen
public enum Month: UInt8, CaseIterable {
    case january = 1
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
    
    public init?<I: BinaryInteger>(_ value: I) {
        guard (1...12).contains(value) else {
            return nil
        }
        self.init(rawValue: UInt8(value))
    }
    
    public func addingMonth(_ month: Int) -> Month {
        let remainder = (Int(rawValue) + month) % 12
        return Month(UInt8(remainder <= 0 ? 12 + remainder : remainder))!
    }
    
    static func lengthOfMonth(_ month: Int, isLeapYear: Bool) -> Int {
        switch month {
        case 2:
            return isLeapYear ? 29 : 28
        case 4, 6, 9, 11:
            return 30
        default:
            return 31
        }
    }
}

extension Month: CustomStringConvertible {
    public var description: String {
        rawValue.description
    }
}

extension Month: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension Month: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: UInt8) {
        self.init(value)!
    }
}

extension Month: LosslessStringConvertible {
    public init?<S: StringProtocol>(_ text: S) {
        guard let value = UInt8(text) else {
            return nil
        }
        self.init(value)
    }
}
