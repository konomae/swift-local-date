public struct Month: Hashable, ExpressibleByIntegerLiteral, LosslessStringConvertible {
    public let value: UInt8
    
    public init(integerLiteral value: UInt8) {
        self.init(value)!
    }
    
    public init?<I: BinaryInteger>(_ value: I) {
        guard (1...12).contains(value) else { return nil }
        self.value = UInt8(value)
    }
    
    public init?<S: StringProtocol>(_ text: S) {
        guard let value = UInt8(text) else { return nil }
        self.init(value)
    }
    
    public func addingMonth(_ month: Int) -> Month {
        let remainder = (Int(value) + month) % 12
        return Month(UInt8(remainder <= 0 ? 12 + remainder : remainder))!
    }
    
    static func lengthOfMonth( _ month: Int, isLeapYear: Bool) -> Int {
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
        value.description
    }
}

extension Month: Comparable {
    public static func < (lhs: Month, rhs: Month) -> Bool {
        lhs.value < rhs.value
    }
}
