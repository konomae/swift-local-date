import XCTest
@testable import LocalDate

final class YearTests: XCTestCase {
    func test_isLeapYear() {
        XCTAssertTrue(isLeapYear(0))
        
        XCTAssertFalse(isLeapYear(1))
        XCTAssertFalse(isLeapYear(2))
        XCTAssertFalse(isLeapYear(3))
        XCTAssertTrue(isLeapYear(4))
        XCTAssertFalse(isLeapYear(5))
        
        XCTAssertFalse(isLeapYear(100))
        XCTAssertFalse(isLeapYear(200))
        XCTAssertFalse(isLeapYear(300))
        XCTAssertTrue(isLeapYear(400))
        XCTAssertFalse(isLeapYear(500))
        
        XCTAssertFalse(isLeapYear(1000))
        XCTAssertTrue(isLeapYear(2000))
        XCTAssertFalse(isLeapYear(3000))
        XCTAssertTrue(isLeapYear(4000))
        XCTAssertFalse(isLeapYear(5000))
    }
}
