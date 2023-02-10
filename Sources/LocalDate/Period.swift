public struct Period: Hashable, Sendable {
    public let years: Int
    public let months: Int
    public let days: Int
    
    public init(years: Int, months: Int, days: Int) {
        self.years = years
        self.months = months
        self.days = days
    }
}
