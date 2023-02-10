@testable import LocalDate
import XCTest

final class YearMonthTests: XCTestCase {
    func test_init() {
        let date = YearMonth(year: 1970, month: 1)
        XCTAssertEqual(date.year, 1970)
        XCTAssertEqual(date.month, 1)
    }
    
    func test_init_from_date_in_timeZone() {
        XCTAssertEqual(
            YearMonth(from: Date(timeIntervalSince1970: 0), in: TimeZone(secondsFromGMT: 0)!),
            YearMonth(year: 1970, month: 1)
        )
        
        XCTAssertEqual(
            YearMonth(from: Date(timeIntervalSince1970: 0), in: TimeZone(secondsFromGMT: -3600)!),
            YearMonth(year: 1969, month: 12)
        )
    }
    
    func test_init_from_string() throws {
        XCTAssertEqual(try YearMonth(from: "1970-12"), YearMonth(year: 1970, month: 12))
        XCTAssertEqual(try YearMonth(from: "-0001-01"), YearMonth(year: -1, month: 1))
    }
    
    func test_init_from_string_error() {
        XCTAssertThrowsError(try YearMonth(from: "")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        
        XCTAssertThrowsError(try YearMonth(from: "-")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        
        XCTAssertThrowsError(try YearMonth(from: "1970-10-")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        
        XCTAssertThrowsError(try YearMonth(from: "-0001-10-")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        
        XCTAssertThrowsError(try YearMonth(from: "1970/01")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        
        XCTAssertThrowsError(try YearMonth(from: "197001")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
    }
    
    func test_description() {
        XCTAssertEqual(YearMonth(year: 1970, month: 1).description, "1970-01")
        XCTAssertEqual(YearMonth(year: -1, month: 1).description, "-0001-01")
        XCTAssertEqual(String(describing: YearMonth(year: 1970, month: 1)), "1970-01")
    }
    
    func test_init_from_description() {
        XCTAssertNil(YearMonth("197001"))
        XCTAssertEqual(
            YearMonth(YearMonth(year: 1970, month: 1).description),
            YearMonth(year: 1970, month: 1)
        )
    }
    
    func test_init_from_decoder() throws {
        XCTAssertEqual(
            try JSONDecoder().decode(YearMonth.self, from: Data("\"1970-01\"".utf8)),
            YearMonth(year: 1970, month: 1)
        )
        
        struct A: Decodable {
            var b: B
        }
        
        struct B: Decodable {
            var value: YearMonth
        }
        
        XCTAssertThrowsError(try JSONDecoder().decode(A.self, from: Data(#"{"b": {"value": "197001"}}"#.utf8))) {
            if case let .dataCorrupted(context) = $0 as? DecodingError {
                XCTAssertEqual(context.codingPath.map(\.stringValue), ["b", "value"])
                XCTAssertEqual(context.debugDescription, "invalid format")
                XCTAssertEqual(context.underlyingError as? FormatError, FormatError())
            } else {
                XCTFail()
            }
        }
    }
    
    func test_encode_to_encoder() throws {
        XCTAssertEqual(
            try JSONEncoder().encode(YearMonth(year: 1970, month: 1)),
            Data("\"1970-01\"".utf8)
        )
    }
    
    func test_comparable() {
        XCTAssertLessThan(
            YearMonth(year: 1969, month: 12),
            YearMonth(year: 1970, month: 1)
        )
        
        XCTAssertLessThan(
            YearMonth(year: 1970, month: 1),
            YearMonth(year: 1970, month: 2)
        )
    }
    
    func test_endOfMonth() {
        XCTAssertEqual(YearMonth(year: 2001, month: 1).endOfMonth, LocalDate(year: 2001, month: 1, day: 31))
        XCTAssertEqual(YearMonth(year: 2001, month: 2).endOfMonth, LocalDate(year: 2001, month: 2, day: 28))
        XCTAssertEqual(YearMonth(year: 2001, month: 3).endOfMonth, LocalDate(year: 2001, month: 3, day: 31))
        XCTAssertEqual(YearMonth(year: 2001, month: 4).endOfMonth, LocalDate(year: 2001, month: 4, day: 30))
        XCTAssertEqual(YearMonth(year: 2001, month: 5).endOfMonth, LocalDate(year: 2001, month: 5, day: 31))
        XCTAssertEqual(YearMonth(year: 2001, month: 6).endOfMonth, LocalDate(year: 2001, month: 6, day: 30))
        XCTAssertEqual(YearMonth(year: 2001, month: 7).endOfMonth, LocalDate(year: 2001, month: 7, day: 31))
        XCTAssertEqual(YearMonth(year: 2001, month: 8).endOfMonth, LocalDate(year: 2001, month: 8, day: 31))
        XCTAssertEqual(YearMonth(year: 2001, month: 9).endOfMonth, LocalDate(year: 2001, month: 9, day: 30))
        XCTAssertEqual(YearMonth(year: 2001, month: 10).endOfMonth, LocalDate(year: 2001, month: 10, day: 31))
        XCTAssertEqual(YearMonth(year: 2001, month: 11).endOfMonth, LocalDate(year: 2001, month: 11, day: 30))
        XCTAssertEqual(YearMonth(year: 2001, month: 12).endOfMonth, LocalDate(year: 2001, month: 12, day: 31))
        
        // leap year
        XCTAssertEqual(YearMonth(year: 2000, month: 2).endOfMonth, LocalDate(year: 2000, month: 2, day: 29))
    }
    
    func test_atDay() {
        XCTAssertEqual(YearMonth(year: 2000, month: 1).atDay(1), LocalDate(year: 2000, month: 1, day: 1))
    }
    
    func test_addingMonths() {
        XCTAssertEqual(YearMonth(year: 0, month: 1).addingMonths(0), YearMonth(year: 0, month: 1))
        
        XCTAssertEqual(YearMonth(year: 0, month: 1).addingMonths(1), YearMonth(year: 0, month: 2))
        XCTAssertEqual(YearMonth(year: 0, month: 1).addingMonths(2), YearMonth(year: 0, month: 3))
        XCTAssertEqual(YearMonth(year: 0, month: 1).addingMonths(12), YearMonth(year: 1, month: 1))
        XCTAssertEqual(YearMonth(year: 0, month: 1).addingMonths(13), YearMonth(year: 1, month: 2))
        
        XCTAssertEqual(YearMonth(year: 0, month: 1).addingMonths(-1), YearMonth(year: -1, month: 12))
        XCTAssertEqual(YearMonth(year: 0, month: 1).addingMonths(-2), YearMonth(year: -1, month: 11))
        XCTAssertEqual(YearMonth(year: 0, month: 1).addingMonths(-12), YearMonth(year: -1, month: 1))
        XCTAssertEqual(YearMonth(year: 0, month: 1).addingMonths(-13), YearMonth(year: -2, month: 12))
    }
    
    func test_lengthOfMonth() {
        XCTAssertEqual(YearMonth(year: 1970, month: 1).lengthOfMonth, 31)
        XCTAssertEqual(YearMonth(year: 1970, month: 2).lengthOfMonth, 28)
        XCTAssertEqual(YearMonth(year: 1970, month: 3).lengthOfMonth, 31)
        XCTAssertEqual(YearMonth(year: 1970, month: 4).lengthOfMonth, 30)
        XCTAssertEqual(YearMonth(year: 1970, month: 5).lengthOfMonth, 31)
        XCTAssertEqual(YearMonth(year: 1970, month: 6).lengthOfMonth, 30)
        XCTAssertEqual(YearMonth(year: 1970, month: 7).lengthOfMonth, 31)
        XCTAssertEqual(YearMonth(year: 1970, month: 8).lengthOfMonth, 31)
        XCTAssertEqual(YearMonth(year: 1970, month: 9).lengthOfMonth, 30)
        XCTAssertEqual(YearMonth(year: 1970, month: 10).lengthOfMonth, 31)
        XCTAssertEqual(YearMonth(year: 1970, month: 11).lengthOfMonth, 30)
        XCTAssertEqual(YearMonth(year: 1970, month: 12).lengthOfMonth, 31)
        
        // leap year
        XCTAssertEqual(YearMonth(year: 2000, month: 2).lengthOfMonth, 29)
    }
}
