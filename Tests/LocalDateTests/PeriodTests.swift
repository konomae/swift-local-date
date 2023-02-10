import LocalDate
import XCTest

final class PeriodTests: XCTestCase {
    func test_init() {
        let period = Period(years: 1, months: 2, days: 3)
        XCTAssertEqual(period.years, 1)
        XCTAssertEqual(period.months, 2)
        XCTAssertEqual(period.days, 3)
    }
}
