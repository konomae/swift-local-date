import XCTest
@testable import LocalDate

final class LocalDateTests: XCTestCase {
    func test_init() {
        let date = LocalDate(year: 2021, month: 5, day: 1)
        XCTAssertEqual(date.year, 2021)
        XCTAssertEqual(date.month, 5)
        XCTAssertEqual(date.day, 1)
    }
    
    func test_init_from_date_in_timeZone() {
        let date = LocalDate(from: Date(timeIntervalSince1970: 0), in: TimeZone(secondsFromGMT: 0)!)
        XCTAssertEqual(date.year, 1970)
        XCTAssertEqual(date.month, 1)
        XCTAssertEqual(date.day, 1)
    }
}
