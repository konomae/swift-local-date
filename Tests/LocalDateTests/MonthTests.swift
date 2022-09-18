import XCTest
@testable import LocalDate

final class MonthTests: XCTestCase {
    func test_addingMonth() {
        let month: Month = 1
        XCTAssertEqual(month.addingMonth(1).value, 2)
        XCTAssertEqual(month.addingMonth(2).value, 3)
        XCTAssertEqual(month.addingMonth(3).value, 4)
        XCTAssertEqual(month.addingMonth(4).value, 5)
        XCTAssertEqual(month.addingMonth(5).value, 6)
        XCTAssertEqual(month.addingMonth(6).value, 7)
        XCTAssertEqual(month.addingMonth(7).value, 8)
        XCTAssertEqual(month.addingMonth(8).value, 9)
        XCTAssertEqual(month.addingMonth(9).value, 10)
        XCTAssertEqual(month.addingMonth(10).value, 11)
        XCTAssertEqual(month.addingMonth(11).value, 12)
        XCTAssertEqual(month.addingMonth(12).value, 1)
        XCTAssertEqual(month.addingMonth(13).value, 2)
        XCTAssertEqual(month.addingMonth(24).value, 1)
        XCTAssertEqual(month.addingMonth(25).value, 2)
        
        XCTAssertEqual(month.addingMonth(-1).value, 12)
        XCTAssertEqual(month.addingMonth(-11).value, 2)
        XCTAssertEqual(month.addingMonth(-12).value, 1)
        XCTAssertEqual(month.addingMonth(-13).value, 12)
        XCTAssertEqual(month.addingMonth(-24).value, 1)
        XCTAssertEqual(month.addingMonth(-25).value, 12)
    }
}
