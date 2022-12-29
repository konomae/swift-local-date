@testable import LocalDate
import XCTest

final class LocalDateTimeTests: XCTestCase {
    func test_init() {
        let dateTime = LocalDateTime(
            date: LocalDate(year: 1970, month: 12, day: 31),
            time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
        )
        
        XCTAssertEqual(dateTime.date, LocalDate(year: 1970, month: 12, day: 31))
        XCTAssertEqual(dateTime.time, LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4))
        XCTAssertEqual(dateTime, LocalDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 4))
        
        XCTAssertEqual(dateTime.year, 1970)
        XCTAssertEqual(dateTime.month, 12)
        XCTAssertEqual(dateTime.day, 31)
        XCTAssertEqual(dateTime.hour, 1)
        XCTAssertEqual(dateTime.minute, 2)
        XCTAssertEqual(dateTime.second, 3)
        XCTAssertEqual(dateTime.nanosecond, 4)
    }
    
    func test_init_from_date_in_timeZone() {
        XCTAssertEqual(
            LocalDateTime(from: Date(timeIntervalSince1970: 0), in: TimeZone(secondsFromGMT: 0)!),
            LocalDateTime(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0)
        )
        
        XCTAssertEqual(
            LocalDateTime(from: Date(timeIntervalSince1970: 3599), in: TimeZone(secondsFromGMT: -3600)!),
            LocalDateTime(year: 1969, month: 12, day: 31, hour: 23, minute: 59, second: 59, nanosecond: 0)
        )
    }
    
    func test_init_from_string() throws {
        XCTAssertEqual(
            try LocalDateTime(from: "1970-01-01T23:59:59.9"),
            LocalDateTime(
                date: LocalDate(year: 1970, month: 1, day: 1),
                time: LocalTime(hour: 23, minute: 59, second: 59, nanosecond: 900000000)
            )
        )
    }
    
    func test_init_from_string_error() {
        XCTAssertThrowsError(try LocalDateTime(from: "1970-01-01 23:59:59.9")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
    }
    
    func test_description() {
        let dateTime = LocalDateTime(
            date: LocalDate(year: 1970, month: 12, day: 31),
            time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
        )
        
        XCTAssertEqual(dateTime.description, "1970-12-31T01:02:03.000000004")
        XCTAssertEqual(String(describing: dateTime), "1970-12-31T01:02:03.000000004")
    }
    
    func test_init_from_description() {
        XCTAssertNil(LocalDateTime("1970-12-31 01:02:03.4"))
        XCTAssertEqual(
            LocalDateTime("1970-12-31T01:02:03.04"),
            LocalDateTime(
                date: LocalDate(year: 1970, month: 12, day: 31),
                time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 40000000)
            )
        )
    }
    
    func test_init_from_decoder() throws {
        XCTAssertEqual(
            try JSONDecoder().decode(LocalDateTime.self, from: Data("\"1970-12-31T01:02:03.4\"".utf8)),
            LocalDateTime(
                date: LocalDate(year: 1970, month: 12, day: 31),
                time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 400000000)
            )
        )
        
        struct A: Decodable {
            var b: B
        }
        
        struct B: Decodable {
            var value: LocalDateTime
        }
        
        XCTAssertThrowsError(try JSONDecoder().decode(A.self, from: Data(#"{"b": {"value": "1970-12-31 01:02:03.4"}}"#.utf8))) {
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
            try JSONEncoder().encode(LocalDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 4)),
            Data("\"1970-12-31T01:02:03.000000004\"".utf8)
        )
    }
    
    func test_comparable() {
        XCTAssertLessThan(
            LocalDateTime(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0),
            LocalDateTime(year: 1970, month: 1, day: 2, hour: 0, minute: 0, second: 0, nanosecond: 0)
        )
        
        XCTAssertLessThan(
            LocalDateTime(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0),
            LocalDateTime(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 1)
        )
    }
    
    func test_atOffset() {
        XCTAssertEqual(
            LocalDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 4).atOffset(.init(second: 3600)),
            OffsetDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 4, offset: .init(second: 3600))
        )
    }
}
