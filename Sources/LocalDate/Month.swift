public struct Month: Hashable, ExpressibleByIntegerLiteral {
    public let value: UInt8
    
    public init(integerLiteral value: UInt8) {
        self.init(value)
    }
    
    public init(_ value: UInt8) {
        precondition((1...12).contains(value))
        self.value = value
    }
    
    public func addingMonth(_ month: Int) -> Month {
        let remainder = (Int(value) + month) % 12
        return Month(UInt8(remainder <= 0 ? 12 + remainder : remainder))
    }
}
