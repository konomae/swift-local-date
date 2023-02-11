@testable import LocalDate
import XCTest

final class LocalDateTests: XCTestCase {
    func test_init() {
        let date = LocalDate(year: 1970, month: 1, day: 1)
        XCTAssertEqual(date.year, 1970)
        XCTAssertEqual(date.month, 1)
        XCTAssertEqual(date.day, 1)
    }
    
    func test_init_from_date_in_timeZone() {
        XCTAssertEqual(
            LocalDate(from: Date(timeIntervalSince1970: 0), in: TimeZone(secondsFromGMT: 0)!),
            LocalDate(year: 1970, month: 1, day: 1)
        )
        
        XCTAssertEqual(
            LocalDate(from: Date(timeIntervalSince1970: 0), in: TimeZone(secondsFromGMT: -3600)!),
            LocalDate(year: 1969, month: 12, day: 31)
        )
    }
    
    func test_init_from_string() throws {
        XCTAssertEqual(try LocalDate(from: "1970-01-01"), LocalDate(year: 1970, month: 1, day: 1))
        XCTAssertEqual(try LocalDate(from: "1970-12-31"), LocalDate(year: 1970, month: 12, day: 31))
        XCTAssertEqual(try LocalDate(from: "-0001-01-01"), LocalDate(year: -1, month: 1, day: 1))
    }
    
    func test_init_from_string_error() {
        XCTAssertThrowsError(try LocalDate(from: "")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        
        XCTAssertThrowsError(try LocalDate(from: "-")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        
        XCTAssertThrowsError(try LocalDate(from: "-0001-10")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        
        XCTAssertThrowsError(try LocalDate(from: "1970-10")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        
        XCTAssertThrowsError(try LocalDate(from: "1970-10-")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        
        XCTAssertThrowsError(try LocalDate(from: "-0001-10-")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        
        XCTAssertThrowsError(try LocalDate(from: "1970/01/01")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        
        XCTAssertThrowsError(try LocalDate(from: "1970-01-01-")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        
        XCTAssertThrowsError(try LocalDate(from: "19700101")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        
        XCTAssertThrowsError(try LocalDate(from: "1970-01-01T00:00:00+00:00")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
    }
    
    func test_date_in_timeZone() {
        XCTAssertEqual(
            LocalDate(year: 1970, month: 1, day: 1).date(in: TimeZone(secondsFromGMT: 0)!),
            Date(timeIntervalSince1970: 0)
        )
        
        XCTAssertEqual(
            LocalDate(year: 1970, month: 1, day: 1).date(in: TimeZone(secondsFromGMT: -3600)!),
            Date(timeIntervalSince1970: 3600)
        )
    }
    
    func test_description() {
        XCTAssertEqual(LocalDate(year: 1970, month: 1, day: 1).description, "1970-01-01")
        XCTAssertEqual(LocalDate(year: -1, month: 1, day: 1).description, "-0001-01-01")
        XCTAssertEqual(String(describing: LocalDate(year: 1970, month: 1, day: 1)), "1970-01-01")
    }
    
    func test_init_from_description() {
        XCTAssertNil(LocalDate("19700101"))
        XCTAssertEqual(
            LocalDate(LocalDate(year: 1970, month: 1, day: 1).description),
            LocalDate(year: 1970, month: 1, day: 1)
        )
    }
    
    func test_init_from_decoder() throws {
        XCTAssertEqual(
            try JSONDecoder().decode(LocalDate.self, from: Data("\"1970-01-01\"".utf8)),
            LocalDate(year: 1970, month: 1, day: 1)
        )
        
        struct A: Decodable {
            var b: B
        }
        
        struct B: Decodable {
            var value: LocalDate
        }
        
        XCTAssertThrowsError(try JSONDecoder().decode(A.self, from: Data(#"{"b": {"value": "19700101"}}"#.utf8))) {
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
            try JSONEncoder().encode(LocalDate(year: 1970, month: 1, day: 1)),
            Data("\"1970-01-01\"".utf8)
        )
    }
    
    func test_comparable() {
        XCTAssertLessThan(
            LocalDate(year: 1969, month: 12, day: 31),
            LocalDate(year: 1970, month: 1, day: 1)
        )
        
        XCTAssertLessThan(
            LocalDate(year: 1970, month: 1, day: 1),
            LocalDate(year: 1970, month: 2, day: 1)
        )
        
        XCTAssertLessThan(
            LocalDate(year: 1970, month: 1, day: 1),
            LocalDate(year: 1970, month: 1, day: 2)
        )
    }
    
    func test_atTime() {
        XCTAssertEqual(
            LocalDate(year: 1970, month: 1, day: 2).atTime(.init(hour: 3, minute: 4, second: 5, nanosecond: 6)),
            LocalDateTime(year: 1970, month: 1, day: 2, hour: 3, minute: 4, second: 5, nanosecond: 6)
        )
    }
    
    func test_addingMonths() {
        XCTAssertEqual(LocalDate(year: 0, month: 1, day: 1).addingMonths(0), LocalDate(year: 0, month: 1, day: 1))
        
        XCTAssertEqual(LocalDate(year: 0, month: 1, day: 1).addingMonths(1), LocalDate(year: 0, month: 2, day: 1))
        XCTAssertEqual(LocalDate(year: 0, month: 1, day: 1).addingMonths(2), LocalDate(year: 0, month: 3, day: 1))
        XCTAssertEqual(LocalDate(year: 0, month: 1, day: 1).addingMonths(12), LocalDate(year: 1, month: 1, day: 1))
        XCTAssertEqual(LocalDate(year: 0, month: 1, day: 1).addingMonths(13), LocalDate(year: 1, month: 2, day: 1))
        
        XCTAssertEqual(LocalDate(year: 0, month: 1, day: 1).addingMonths(-1), LocalDate(year: -1, month: 12, day: 1))
        XCTAssertEqual(LocalDate(year: 0, month: 1, day: 1).addingMonths(-2), LocalDate(year: -1, month: 11, day: 1))
        XCTAssertEqual(LocalDate(year: 0, month: 1, day: 1).addingMonths(-12), LocalDate(year: -1, month: 1, day: 1))
        XCTAssertEqual(LocalDate(year: 0, month: 1, day: 1).addingMonths(-13), LocalDate(year: -2, month: 12, day: 1))
        
        // last valid day
        XCTAssertEqual(LocalDate(year: 0, month: 1, day: 31).addingMonths(1), LocalDate(year: 0, month: 2, day: 29))
        XCTAssertEqual(LocalDate(year: 0, month: 1, day: 31).addingMonths(2), LocalDate(year: 0, month: 3, day: 31))
        XCTAssertEqual(LocalDate(year: 0, month: 1, day: 31).addingMonths(3), LocalDate(year: 0, month: 4, day: 30))
        XCTAssertEqual(LocalDate(year: 0, month: 1, day: 31).addingMonths(13), LocalDate(year: 1, month: 2, day: 28))
    }

    func test_until() {
        // same
        XCTAssertEqual(
            LocalDate(year: 0, month: 1, day: 1).until(LocalDate(year: 0, month: 1, day: 1)),
            Period(years: 0, months: 0, days: 0)
        )
        
        // basic
        XCTAssertEqual(
            LocalDate(year: 0, month: 1, day: 1).until(LocalDate(year: 1, month: 3, day: 4)),
            Period(years: 1, months: 2, days: 3)
        )
        XCTAssertEqual(
            LocalDate(year: 1, month: 3, day: 4).until(LocalDate(year: 0, month: 1, day: 1)),
            Period(years: -1, months: -2, days: -3)
        )
        
        // year boundaries
        XCTAssertEqual(
            LocalDate(year: 0, month: 2, day: 28).until(LocalDate(year: 4, month: 2, day: 28)),
            Period(years: 4, months: 0, days: 0)
        )
        XCTAssertEqual(
            LocalDate(year: 0, month: 2, day: 28).until(LocalDate(year: 4, month: 2, day: 27)),
            Period(years: 3, months: 11, days: 30)
        )
        XCTAssertEqual(
            LocalDate(year: 0, month: 2, day: 29).until(LocalDate(year: 4, month: 2, day: 28)),
            Period(years: 3, months: 11, days: 30)
        )
        XCTAssertEqual(
            LocalDate(year: 0, month: 2, day: 29).until(LocalDate(year: 1, month: 3, day: 1)),
            Period(years: 1, months: 0, days: 1)
        )
        
        // year boundaries (negative)
        XCTAssertEqual(
            LocalDate(year: 4, month: 2, day: 28).until(LocalDate(year: 0, month: 2, day: 28)),
            Period(years: -4, months: 0, days: 0)
        )
        XCTAssertEqual(
            LocalDate(year: 4, month: 2, day: 27).until(LocalDate(year: 0, month: 2, day: 28)),
            Period(years: -3, months: -11, days: -28)
        )
        XCTAssertEqual(
            LocalDate(year: 4, month: 2, day: 28).until(LocalDate(year: 0, month: 2, day: 29)),
            Period(years: -3, months: -11, days: -28)
        )
        XCTAssertEqual(
            LocalDate(year: 1, month: 3, day: 1).until(LocalDate(year: 0, month: 2, day: 29)),
            Period(years: -1, months: 0, days: -1)
        )
        
        // days
        XCTAssertEqual(
            LocalDate(year: 0, month: 2, day: 29).until(LocalDate(year: 0, month: 3, day: 1)),
            Period(years: 0, months: 0, days: 1)
        )
        XCTAssertEqual(
            LocalDate(year: 0, month: 2, day: 28).until(LocalDate(year: 0, month: 3, day: 1)),
            Period(years: 0, months: 0, days: 2)
        )
        XCTAssertEqual(
            LocalDate(year: 1, month: 2, day: 28).until(LocalDate(year: 1, month: 3, day: 1)),
            Period(years: 0, months: 0, days: 1)
        )
        
        // days (negative)
        XCTAssertEqual(
            LocalDate(year: 0, month: 3, day: 1).until(LocalDate(year: 0, month: 2, day: 29)),
            Period(years: 0, months: 0, days: -1)
        )
        XCTAssertEqual(
            LocalDate(year: 0, month: 3, day: 1).until(LocalDate(year: 0, month: 2, day: 28)),
            Period(years: 0, months: 0, days: -2)
        )
        XCTAssertEqual(
            LocalDate(year: 1, month: 3, day: 1).until(LocalDate(year: 1, month: 2, day: 28)),
            Period(years: 0, months: 0, days: -1)
        )
    }
}
