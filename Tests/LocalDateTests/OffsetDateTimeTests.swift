import XCTest
@testable import LocalDate

final class OffsetDateTimeTests: XCTestCase {
    func test_init() {
        let dateTime = OffsetDateTime(
            dateTime: LocalDateTime(
                date: LocalDate(year: 1970, month: 12, day: 31),
                time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
            ),
            offset: ZoneOffset(second: 3600)
        )
        
        XCTAssertEqual(
            dateTime.dateTime,
            LocalDateTime(
                date: LocalDate(year: 1970, month: 12, day: 31),
                time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
            )
        )
        XCTAssertEqual(dateTime.offset, ZoneOffset(second: 3600))
        XCTAssertEqual(
            dateTime,
            OffsetDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 4, offset: ZoneOffset(second: 3600))
        )
    }
    
    func test_init_from_string() throws {
        XCTAssertEqual(
            try OffsetDateTime(from: "1970-12-31T01:02:03.4+02:30"),
            OffsetDateTime(
                dateTime: LocalDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 400000000),
                offset: ZoneOffset(second: 9000)
            )
        )
        XCTAssertEqual(
            try OffsetDateTime(from: "1970-12-31T01:02:03.4-02:30"),
            OffsetDateTime(
                dateTime: LocalDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 400000000),
                offset: ZoneOffset(second: -9000)
            )
        )
        XCTAssertEqual(
            try OffsetDateTime(from: "1970-12-31T01:02:03.4Z"),
            OffsetDateTime(
                dateTime: LocalDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 400000000),
                offset: ZoneOffset(second: 0)
            )
        )
    }
    
    func test_init_from_string_error() throws {
        XCTAssertThrowsError(try OffsetDateTime(from: "")) {
            XCTAssertEqual($0 as? OffsetDateTime.Error, .invalidStringFormat)
        }
        
        XCTAssertThrowsError(try OffsetDateTime(from: "1970-12-31")) {
            XCTAssertEqual($0 as? LocalDateTime.Error, .invalidStringFormat)
        }
        
        XCTAssertThrowsError(try OffsetDateTime(from: "01:02:03.4")) {
            XCTAssertEqual($0 as? OffsetDateTime.Error, .invalidStringFormat)
        }
        
        XCTAssertThrowsError(try OffsetDateTime(from: "+02:30")) {
            XCTAssertEqual($0 as? LocalDateTime.Error, .invalidStringFormat)
        }
    }
    
    func test_description() {
        let dateTime = OffsetDateTime(
            dateTime: LocalDateTime(
                date: LocalDate(year: 1970, month: 12, day: 31),
                time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
            ),
            offset: ZoneOffset(second: 3600)
        )
        
        XCTAssertEqual(dateTime.description, "1970-12-31T01:02:03.000000004+01:00")
        XCTAssertEqual(String(describing: dateTime), "1970-12-31T01:02:03.000000004+01:00")
    }
    
    func test_init_from_description() {
        XCTAssertNil(OffsetDateTime("1970-12-31T01:02:03.000000004"))
        XCTAssertEqual(
            OffsetDateTime("1970-12-31T01:02:03.000000004+01:00"),
            OffsetDateTime(
                dateTime: LocalDateTime(
                    date: LocalDate(year: 1970, month: 12, day: 31),
                    time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
                ),
                offset: ZoneOffset(second: 3600)
            )
        )
    }
    
    func test_init_from_decoder() throws {
        XCTAssertEqual(
            try JSONDecoder().decode(OffsetDateTime.self, from: Data("\"1970-12-31T01:02:03.000000004+01:00\"".utf8)),
            OffsetDateTime(
                dateTime: LocalDateTime(
                    date: LocalDate(year: 1970, month: 12, day: 31),
                    time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
                ),
                offset: ZoneOffset(second: 3600)
            )
        )
        
        struct A: Decodable {
            var b: B
        }
        
        struct B: Decodable {
            var value: OffsetDateTime
        }
        
        XCTAssertThrowsError(try JSONDecoder().decode(A.self, from: Data(#"{"b": {"value": ""}}"#.utf8))) {
            if case let .dataCorrupted(context) = $0 as? DecodingError {
                XCTAssertEqual(context.codingPath.map(\.stringValue), ["b", "value"])
                XCTAssertEqual(context.debugDescription, "invalid format")
                XCTAssertEqual(context.underlyingError as? OffsetDateTime.Error, .invalidStringFormat)
            } else {
                XCTFail()
            }
        }
    }
    
    func test_encode_to_encoder() throws {
        XCTAssertEqual(
            try JSONEncoder().encode(OffsetDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 4, offset: ZoneOffset(second: 3600))),
            Data("\"1970-12-31T01:02:03.000000004+01:00\"".utf8)
        )
    }
    
    func test_comparable() throws {
        // same offset, different local date time
        XCTAssertLessThan(
            try OffsetDateTime(from: "1970-01-01T00:00:00+00:00"),
            try OffsetDateTime(from: "1970-01-01T00:00:01+00:00")
        )
        
        // same local date time, different offset
        XCTAssertLessThan(
            try OffsetDateTime(from: "1970-01-01T00:00:00+00:01"),
            try OffsetDateTime(from: "1970-01-01T00:00:00+00:00")
        )
        
        // same timestamp, different offset
        XCTAssertLessThan(
            try OffsetDateTime(from: "1970-01-01T00:00:00+01:00"),
            try OffsetDateTime(from: "1970-01-01T01:00:00+02:00")
        )
        
        // different nanosecond
        XCTAssertLessThan(
            try OffsetDateTime(from: "1970-01-01T00:00:00.000000001+00:00"),
            try OffsetDateTime(from: "1970-01-01T00:00:00.000000002+00:00")
        )
    }
}