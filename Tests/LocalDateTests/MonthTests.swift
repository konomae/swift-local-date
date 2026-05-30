@testable import LocalDate
import Testing

struct MonthTests {
    @Test
    func test_init() {
        #expect(Month(0 as Int) == nil)
        #expect(Month(1 as Int) == 1)
        #expect(Month(12 as Int) == 12)
        #expect(Month(13 as Int) == nil)
        #expect(Month(-10 as Int) == nil)
    }
    
    @Test
    func init_integerLiteral() {
        #expect(Month(1) == 1)
        #expect(Month(12) == 12)
        #expect(Month(integerLiteral: 1) == 1)
        #expect(Month(integerLiteral: 12) == 12)
    }
    
    @Test
    func init_text() {
        #expect(Month("0") == nil)
        #expect(Month("1") == Month(1))
        #expect(Month("12") == Month(12))
        #expect(Month("13") == nil)
        #expect(Month("") == nil)
    }
    
    @Test
    func test_addingMonth() {
        let month: Month = 1
        #expect(month.addingMonth(1) == 2)
        #expect(month.addingMonth(2) == 3)
        #expect(month.addingMonth(3) == 4)
        #expect(month.addingMonth(4) == 5)
        #expect(month.addingMonth(5) == 6)
        #expect(month.addingMonth(6) == 7)
        #expect(month.addingMonth(7) == 8)
        #expect(month.addingMonth(8) == 9)
        #expect(month.addingMonth(9) == 10)
        #expect(month.addingMonth(10) == 11)
        #expect(month.addingMonth(11) == 12)
        #expect(month.addingMonth(12) == 1)
        #expect(month.addingMonth(13) == 2)
        #expect(month.addingMonth(24) == 1)
        #expect(month.addingMonth(25) == 2)
        
        #expect(month.addingMonth(-1) == 12)
        #expect(month.addingMonth(-11) == 2)
        #expect(month.addingMonth(-12) == 1)
        #expect(month.addingMonth(-13) == 12)
        #expect(month.addingMonth(-24) == 1)
        #expect(month.addingMonth(-25) == 12)
    }
    
    @Test
    func test_length() {
        #expect(Month(1).length(isLeapYear: false) == 31)
        #expect(Month(2).length(isLeapYear: false) == 28)
        #expect(Month(3).length(isLeapYear: false) == 31)
        #expect(Month(4).length(isLeapYear: false) == 30)
        #expect(Month(5).length(isLeapYear: false) == 31)
        #expect(Month(6).length(isLeapYear: false) == 30)
        #expect(Month(7).length(isLeapYear: false) == 31)
        #expect(Month(8).length(isLeapYear: false) == 31)
        #expect(Month(9).length(isLeapYear: false) == 30)
        #expect(Month(10).length(isLeapYear: false) == 31)
        #expect(Month(11).length(isLeapYear: false) == 30)
        #expect(Month(12).length(isLeapYear: false) == 31)
        
        // leap year
        #expect(Month(2).length(isLeapYear: true) == 29)
    }
    
    @Test
    func test_lengthOfMonth() {
        #expect(Month.lengthOfMonth(1, isLeapYear: false) == 31)
        #expect(Month.lengthOfMonth(2, isLeapYear: false) == 28)
        #expect(Month.lengthOfMonth(3, isLeapYear: false) == 31)
        #expect(Month.lengthOfMonth(4, isLeapYear: false) == 30)
        #expect(Month.lengthOfMonth(5, isLeapYear: false) == 31)
        #expect(Month.lengthOfMonth(6, isLeapYear: false) == 30)
        #expect(Month.lengthOfMonth(7, isLeapYear: false) == 31)
        #expect(Month.lengthOfMonth(8, isLeapYear: false) == 31)
        #expect(Month.lengthOfMonth(9, isLeapYear: false) == 30)
        #expect(Month.lengthOfMonth(10, isLeapYear: false) == 31)
        #expect(Month.lengthOfMonth(11, isLeapYear: false) == 30)
        #expect(Month.lengthOfMonth(12, isLeapYear: false) == 31)
        
        // leap year
        #expect(Month.lengthOfMonth(2, isLeapYear: true) == 29)
    }
    
    @Test
    func description() {
        #expect(String(describing: Month(1)) == "1")
        #expect(String(describing: Month(12)) == "12")
    }
    
    @Test
    func comparable() {
        #expect(Month(1) < Month(2))
    }
}
