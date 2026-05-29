import Foundation
@testable import LocalDate
import Testing

struct LocalDateTimeTests {
    @Test
    func test_init() {
        let dateTime = LocalDateTime(
            date: LocalDate(year: 1970, month: 12, day: 31),
            time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
        )
        
        #expect(dateTime.date == LocalDate(year: 1970, month: 12, day: 31))
        #expect(dateTime.time == LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4))
        #expect(dateTime == LocalDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 4))
        
        #expect(dateTime.year == 1970)
        #expect(dateTime.month == 12)
        #expect(dateTime.day == 31)
        #expect(dateTime.hour == 1)
        #expect(dateTime.minute == 2)
        #expect(dateTime.second == 3)
        #expect(dateTime.nanosecond == 4)
    }
    
    @Test
    func test_init_from_date_in_timeZone() throws {
        #expect(try LocalDateTime(from: Date(timeIntervalSince1970: 0), in: #require(TimeZone(secondsFromGMT: 0))) == LocalDateTime(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0))
        
        #expect(try LocalDateTime(from: Date(timeIntervalSince1970: 3599), in: #require(TimeZone(secondsFromGMT: -3600))) == LocalDateTime(year: 1969, month: 12, day: 31, hour: 23, minute: 59, second: 59, nanosecond: 0))
    }
    
    @Test
    func test_init_from_string() throws {
        #expect(try LocalDateTime(from: "1970-01-01T23:59:59.9") == LocalDateTime(
            date: LocalDate(year: 1970, month: 1, day: 1),
            time: LocalTime(hour: 23, minute: 59, second: 59, nanosecond: 900000000)
        ))
    }
    
    @Test
    func test_init_from_string_error() {
        #expect(throws: FormatError()) {
            try LocalDateTime(from: "1970-01-01 23:59:59.9")
        }
    }
    
    @Test
    func test_description() {
        let dateTime = LocalDateTime(
            date: LocalDate(year: 1970, month: 12, day: 31),
            time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
        )
        
        #expect(dateTime.description == "1970-12-31T01:02:03.000000004")
        #expect(String(describing: dateTime) == "1970-12-31T01:02:03.000000004")
    }
    
    @Test
    func test_init_from_description() {
        #expect(LocalDateTime("1970-12-31 01:02:03.4") == nil)
        #expect(LocalDateTime("1970-12-31T01:02:03.04") == LocalDateTime(
            date: LocalDate(year: 1970, month: 12, day: 31),
            time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 40000000)
        ))
    }
    
    @Test
    func test_init_from_decoder() throws {
        #expect(try JSONDecoder().decode(LocalDateTime.self, from: Data("\"1970-12-31T01:02:03.4\"".utf8)) == LocalDateTime(
            date: LocalDate(year: 1970, month: 12, day: 31),
            time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 400000000)
        ))
        
        struct A: Decodable {
            var b: B
        }
        
        struct B: Decodable {
            var value: LocalDateTime
        }
        
        let error = try #require(throws: DecodingError.self) {
            try JSONDecoder().decode(A.self, from: Data(#"{"b": {"value": "1970-12-31 01:02:03.4"}}"#.utf8))
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
        #expect(try JSONEncoder().encode(LocalDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 4)) == Data("\"1970-12-31T01:02:03.000000004\"".utf8))
    }
    
    @Test
    func test_comparable() {
        #expect(LocalDateTime(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0) < LocalDateTime(year: 1970, month: 1, day: 2, hour: 0, minute: 0, second: 0, nanosecond: 0))
        
        #expect(LocalDateTime(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0) < LocalDateTime(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 1))
    }
    
    @Test
    func test_atOffset() {
        #expect(LocalDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 4).atOffset(.init(second: 3600)) == OffsetDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 4, offset: .init(second: 3600)))
    }
}
