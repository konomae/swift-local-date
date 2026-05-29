import Foundation
@testable import LocalDate
import Testing

struct YearMonthTests {
    @Test
    func test_init() {
        let date = YearMonth(year: 1970, month: 1)
        #expect(date.year == 1970)
        #expect(date.month == 1)
    }
    
    @Test
    func test_init_from_date_in_timeZone() throws {
        #expect(try YearMonth(from: Date(timeIntervalSince1970: 0), in: #require(TimeZone(secondsFromGMT: 0))) == YearMonth(year: 1970, month: 1))
        
        #expect(try YearMonth(from: Date(timeIntervalSince1970: 0), in: #require(TimeZone(secondsFromGMT: -3600))) == YearMonth(year: 1969, month: 12))
    }
    
    @Test
    func test_init_from_string() throws {
        #expect(try YearMonth(from: "1970-12") == YearMonth(year: 1970, month: 12))
        #expect(try YearMonth(from: "-0001-01") == YearMonth(year: -1, month: 1))
    }
    
    @Test
    func test_init_from_string_error() {
        #expect(throws: FormatError()) {
            try YearMonth(from: "")
        }
        
        #expect(throws: FormatError()) {
            try YearMonth(from: "-")
        }
        
        #expect(throws: FormatError()) {
            try YearMonth(from: "1970-10-")
        }
        
        #expect(throws: FormatError()) {
            try YearMonth(from: "-0001-10-")
        }
        
        #expect(throws: FormatError()) {
            try YearMonth(from: "1970/01")
        }
        
        #expect(throws: FormatError()) {
            try YearMonth(from: "197001")
        }
    }
    
    @Test
    func test_description() {
        #expect(YearMonth(year: 1970, month: 1).description == "1970-01")
        #expect(YearMonth(year: -1, month: 1).description == "-0001-01")
        #expect(String(describing: YearMonth(year: 1970, month: 1)) == "1970-01")
    }
    
    @Test
    func test_init_from_description() {
        #expect(YearMonth("197001") == nil)
        #expect(YearMonth(YearMonth(year: 1970, month: 1).description) == YearMonth(year: 1970, month: 1))
    }
    
    @Test
    func test_init_from_decoder() throws {
        #expect(try JSONDecoder().decode(YearMonth.self, from: Data("\"1970-01\"".utf8)) == YearMonth(year: 1970, month: 1))
        
        struct A: Decodable {
            var b: B
        }
        
        struct B: Decodable {
            var value: YearMonth
        }
        
        let error = try #require(throws: DecodingError.self) {
            try JSONDecoder().decode(A.self, from: Data(#"{"b": {"value": "197001"}}"#.utf8))
        }
        if case let .dataCorrupted(context) = error {
            #expect(context.codingPath.map(\.stringValue) == ["b", "value"])
            #expect(context.debugDescription == "invalid format")
            #expect(context.underlyingError as? FormatError == FormatError())
        } else {
            Issue.record()
        }
    }
    
    @Test
    func test_encode_to_encoder() throws {
        #expect(try JSONEncoder().encode(YearMonth(year: 1970, month: 1)) == Data("\"1970-01\"".utf8))
    }
    
    @Test
    func test_comparable() {
        #expect(YearMonth(year: 1969, month: 12) < YearMonth(year: 1970, month: 1))
        
        #expect(YearMonth(year: 1970, month: 1) < YearMonth(year: 1970, month: 2))
    }
    
    @Test
    func test_endOfMonth() {
        #expect(YearMonth(year: 2001, month: 1).endOfMonth == LocalDate(year: 2001, month: 1, day: 31))
        #expect(YearMonth(year: 2001, month: 2).endOfMonth == LocalDate(year: 2001, month: 2, day: 28))
        #expect(YearMonth(year: 2001, month: 3).endOfMonth == LocalDate(year: 2001, month: 3, day: 31))
        #expect(YearMonth(year: 2001, month: 4).endOfMonth == LocalDate(year: 2001, month: 4, day: 30))
        #expect(YearMonth(year: 2001, month: 5).endOfMonth == LocalDate(year: 2001, month: 5, day: 31))
        #expect(YearMonth(year: 2001, month: 6).endOfMonth == LocalDate(year: 2001, month: 6, day: 30))
        #expect(YearMonth(year: 2001, month: 7).endOfMonth == LocalDate(year: 2001, month: 7, day: 31))
        #expect(YearMonth(year: 2001, month: 8).endOfMonth == LocalDate(year: 2001, month: 8, day: 31))
        #expect(YearMonth(year: 2001, month: 9).endOfMonth == LocalDate(year: 2001, month: 9, day: 30))
        #expect(YearMonth(year: 2001, month: 10).endOfMonth == LocalDate(year: 2001, month: 10, day: 31))
        #expect(YearMonth(year: 2001, month: 11).endOfMonth == LocalDate(year: 2001, month: 11, day: 30))
        #expect(YearMonth(year: 2001, month: 12).endOfMonth == LocalDate(year: 2001, month: 12, day: 31))
        
        // leap year
        #expect(YearMonth(year: 2000, month: 2).endOfMonth == LocalDate(year: 2000, month: 2, day: 29))
    }
    
    @Test
    func test_atDay() {
        #expect(YearMonth(year: 2000, month: 1).atDay(1) == LocalDate(year: 2000, month: 1, day: 1))
    }
    
    @Test
    func test_addingMonths() {
        #expect(YearMonth(year: 0, month: 1).addingMonths(0) == YearMonth(year: 0, month: 1))
        
        #expect(YearMonth(year: 0, month: 1).addingMonths(1) == YearMonth(year: 0, month: 2))
        #expect(YearMonth(year: 0, month: 1).addingMonths(2) == YearMonth(year: 0, month: 3))
        #expect(YearMonth(year: 0, month: 1).addingMonths(12) == YearMonth(year: 1, month: 1))
        #expect(YearMonth(year: 0, month: 1).addingMonths(13) == YearMonth(year: 1, month: 2))
        
        #expect(YearMonth(year: 0, month: 1).addingMonths(-1) == YearMonth(year: -1, month: 12))
        #expect(YearMonth(year: 0, month: 1).addingMonths(-2) == YearMonth(year: -1, month: 11))
        #expect(YearMonth(year: 0, month: 1).addingMonths(-12) == YearMonth(year: -1, month: 1))
        #expect(YearMonth(year: 0, month: 1).addingMonths(-13) == YearMonth(year: -2, month: 12))
    }
    
    @Test
    func test_lengthOfMonth() {
        #expect(YearMonth(year: 1970, month: 1).lengthOfMonth == 31)
        #expect(YearMonth(year: 1970, month: 2).lengthOfMonth == 28)
        #expect(YearMonth(year: 1970, month: 3).lengthOfMonth == 31)
        #expect(YearMonth(year: 1970, month: 4).lengthOfMonth == 30)
        #expect(YearMonth(year: 1970, month: 5).lengthOfMonth == 31)
        #expect(YearMonth(year: 1970, month: 6).lengthOfMonth == 30)
        #expect(YearMonth(year: 1970, month: 7).lengthOfMonth == 31)
        #expect(YearMonth(year: 1970, month: 8).lengthOfMonth == 31)
        #expect(YearMonth(year: 1970, month: 9).lengthOfMonth == 30)
        #expect(YearMonth(year: 1970, month: 10).lengthOfMonth == 31)
        #expect(YearMonth(year: 1970, month: 11).lengthOfMonth == 30)
        #expect(YearMonth(year: 1970, month: 12).lengthOfMonth == 31)
        
        // leap year
        #expect(YearMonth(year: 2000, month: 2).lengthOfMonth == 29)
    }
}
