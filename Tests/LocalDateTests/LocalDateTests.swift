import XCTest
@testable import LocalDate

final class LocalDateTests: XCTestCase {
    func test_init() {
        let date = LocalDate(year: 2021, month: 5, day: 1)
        XCTAssertEqual(date.year, 2021)
        XCTAssertEqual(date.month, 5)
        XCTAssertEqual(date.day, 1)
    }
}
