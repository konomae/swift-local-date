import XCTest
@testable import LocalDate

final class MonthTests: XCTestCase {
    func test_init() {
        XCTAssertNil(Month.init(0))
        XCTAssertEqual(Month.init(1), 1)
        XCTAssertEqual(Month.init(12), 12)
        XCTAssertNil(Month.init(13))
        XCTAssertNil(Month.init(-1))
    }
    
    func test_init_text() {
        XCTAssertNil(Month("0"))
        XCTAssertEqual(Month("1"), Month(1))
        XCTAssertEqual(Month("12"), Month(12))
        XCTAssertNil(Month("13"))
        XCTAssertNil(Month(""))
    }
    
    func test_addingMonth() {
        let month: Month = 1
        XCTAssertEqual(month.addingMonth(1), 2)
        XCTAssertEqual(month.addingMonth(2), 3)
        XCTAssertEqual(month.addingMonth(3), 4)
        XCTAssertEqual(month.addingMonth(4), 5)
        XCTAssertEqual(month.addingMonth(5), 6)
        XCTAssertEqual(month.addingMonth(6), 7)
        XCTAssertEqual(month.addingMonth(7), 8)
        XCTAssertEqual(month.addingMonth(8), 9)
        XCTAssertEqual(month.addingMonth(9), 10)
        XCTAssertEqual(month.addingMonth(10), 11)
        XCTAssertEqual(month.addingMonth(11), 12)
        XCTAssertEqual(month.addingMonth(12), 1)
        XCTAssertEqual(month.addingMonth(13), 2)
        XCTAssertEqual(month.addingMonth(24), 1)
        XCTAssertEqual(month.addingMonth(25), 2)
        
        XCTAssertEqual(month.addingMonth(-1), 12)
        XCTAssertEqual(month.addingMonth(-11), 2)
        XCTAssertEqual(month.addingMonth(-12), 1)
        XCTAssertEqual(month.addingMonth(-13), 12)
        XCTAssertEqual(month.addingMonth(-24), 1)
        XCTAssertEqual(month.addingMonth(-25), 12)
    }
    
    func test_lengthOfMonth() {
        XCTAssertEqual(Month.lengthOfMonth(1, isLeapYear: false), 31)
        XCTAssertEqual(Month.lengthOfMonth(2, isLeapYear: false), 28)
        XCTAssertEqual(Month.lengthOfMonth(3, isLeapYear: false), 31)
        XCTAssertEqual(Month.lengthOfMonth(4, isLeapYear: false), 30)
        XCTAssertEqual(Month.lengthOfMonth(5, isLeapYear: false), 31)
        XCTAssertEqual(Month.lengthOfMonth(6, isLeapYear: false), 30)
        XCTAssertEqual(Month.lengthOfMonth(7, isLeapYear: false), 31)
        XCTAssertEqual(Month.lengthOfMonth(8, isLeapYear: false), 31)
        XCTAssertEqual(Month.lengthOfMonth(9, isLeapYear: false), 30)
        XCTAssertEqual(Month.lengthOfMonth(10, isLeapYear: false), 31)
        XCTAssertEqual(Month.lengthOfMonth(11, isLeapYear: false), 30)
        XCTAssertEqual(Month.lengthOfMonth(12, isLeapYear: false), 31)
        
        // leap year
        XCTAssertEqual(Month.lengthOfMonth(2, isLeapYear: true), 29)
    }
    
    func test_description() {
        XCTAssertEqual(String(describing: Month(1)), "1")
        XCTAssertEqual(String(describing: Month(12)), "12")
    }
    
    func test_comparable() {
        XCTAssertLessThan(Month(1), Month(2))
    }
}
