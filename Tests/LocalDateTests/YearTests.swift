@testable import LocalDate
import Testing

struct YearTests {
    @Test
    func test_isLeapYear() {
        #expect(isLeapYear(0))
        
        #expect(!isLeapYear(1))
        #expect(!isLeapYear(2))
        #expect(!isLeapYear(3))
        #expect(isLeapYear(4))
        #expect(!isLeapYear(5))
        
        #expect(!isLeapYear(100))
        #expect(!isLeapYear(200))
        #expect(!isLeapYear(300))
        #expect(isLeapYear(400))
        #expect(!isLeapYear(500))
        
        #expect(!isLeapYear(1000))
        #expect(isLeapYear(2000))
        #expect(!isLeapYear(3000))
        #expect(isLeapYear(4000))
        #expect(!isLeapYear(5000))
    }
}
