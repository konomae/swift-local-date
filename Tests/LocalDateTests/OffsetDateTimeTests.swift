import Foundation
@testable import LocalDate
import Testing

struct OffsetDateTimeTests {
    @Test
    func test_init() {
        let dateTime = OffsetDateTime(
            dateTime: LocalDateTime(
                date: LocalDate(year: 1970, month: 12, day: 31),
                time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
            ),
            offset: ZoneOffset(second: 3600)
        )

        #expect(dateTime.dateTime == LocalDateTime(
            date: LocalDate(year: 1970, month: 12, day: 31),
            time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
        ))
        #expect(dateTime.offset == ZoneOffset(second: 3600))
        #expect(dateTime == OffsetDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 4, offset: ZoneOffset(second: 3600)))

        #expect(dateTime.year == 1970)
        #expect(dateTime.month == 12)
        #expect(dateTime.day == 31)
        #expect(dateTime.hour == 1)
        #expect(dateTime.minute == 2)
        #expect(dateTime.second == 3)
        #expect(dateTime.nanosecond == 4)
    }

    @Test
    func init_from_date_in_timeZone() throws {
        #expect(try OffsetDateTime(from: Date(timeIntervalSince1970: 0), in: #require(TimeZone(secondsFromGMT: 0))) == OffsetDateTime(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0, offset: ZoneOffset(second: 0)))

        #expect(try OffsetDateTime(from: Date(timeIntervalSince1970: 3599), in: #require(TimeZone(secondsFromGMT: -3600))) == OffsetDateTime(year: 1969, month: 12, day: 31, hour: 23, minute: 59, second: 59, nanosecond: 0, offset: ZoneOffset(second: -3600)))
    }

    @Test
    func init_from_string() throws {
        #expect(try OffsetDateTime(from: "1970-12-31T01:02:03.4+02:30") == OffsetDateTime(
            dateTime: LocalDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 400000000),
            offset: ZoneOffset(second: 9000)
        ))
        #expect(try OffsetDateTime(from: "1970-12-31T01:02:03.4-02:30") == OffsetDateTime(
            dateTime: LocalDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 400000000),
            offset: ZoneOffset(second: -9000)
        ))
        #expect(try OffsetDateTime(from: "1970-12-31T01:02:03.4Z") == OffsetDateTime(
            dateTime: LocalDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 400000000),
            offset: ZoneOffset(second: 0)
        ))
    }

    @Test
    func init_from_string_error() throws {
        #expect(throws: FormatError()) {
            try OffsetDateTime(from: "")
        }

        #expect(throws: FormatError()) {
            try OffsetDateTime(from: "1970-12-31")
        }

        #expect(throws: FormatError()) {
            try OffsetDateTime(from: "01:02:03.4")
        }

        #expect(throws: FormatError()) {
            try OffsetDateTime(from: "+02:30")
        }
    }

    @Test
    func test_description() {
        let dateTime = OffsetDateTime(
            dateTime: LocalDateTime(
                date: LocalDate(year: 1970, month: 12, day: 31),
                time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
            ),
            offset: ZoneOffset(second: 3600)
        )

        #expect(dateTime.description == "1970-12-31T01:02:03.000000004+01:00")
        #expect(String(describing: dateTime) == "1970-12-31T01:02:03.000000004+01:00")
    }

    @Test
    func init_from_description() {
        #expect(OffsetDateTime("1970-12-31T01:02:03.000000004") == nil)
        #expect(OffsetDateTime("1970-12-31T01:02:03.000000004+01:00") == OffsetDateTime(
            dateTime: LocalDateTime(
                date: LocalDate(year: 1970, month: 12, day: 31),
                time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
            ),
            offset: ZoneOffset(second: 3600)
        ))
    }

    @Test
    func init_from_decoder() throws {
        #expect(try JSONDecoder().decode(OffsetDateTime.self, from: Data("\"1970-12-31T01:02:03.000000004+01:00\"".utf8)) == OffsetDateTime(
            dateTime: LocalDateTime(
                date: LocalDate(year: 1970, month: 12, day: 31),
                time: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
            ),
            offset: ZoneOffset(second: 3600)
        ))

        #if compiler(>=6.1)
        struct A: Decodable {
            var b: B
        }

        struct B: Decodable {
            var value: OffsetDateTime
        }

        let error = try #require(throws: DecodingError.self) {
            try JSONDecoder().decode(A.self, from: Data(#"{"b": {"value": ""}}"#.utf8))
        }
        if case let .dataCorrupted(context) = error {
            #expect(context.codingPath.map(\.stringValue) == ["b", "value"])
            #expect(context.debugDescription == "invalid format")
            #expect(context.underlyingError as? FormatError == FormatError())
        } else {
            Issue.record()
        }
        #endif
    }

    @Test
    func encode_to_encoder() throws {
        #expect(try JSONEncoder().encode(OffsetDateTime(year: 1970, month: 12, day: 31, hour: 1, minute: 2, second: 3, nanosecond: 4, offset: ZoneOffset(second: 3600))) == Data("\"1970-12-31T01:02:03.000000004+01:00\"".utf8))
    }

    @Test
    func comparable() throws {
        // same offset, different local date time
        #expect(try OffsetDateTime(from: "1970-01-01T00:00:00+00:00") < OffsetDateTime(from: "1970-01-01T00:00:01+00:00"))

        // same local date time, different offset
        #expect(try OffsetDateTime(from: "1970-01-01T00:00:00+00:01") < OffsetDateTime(from: "1970-01-01T00:00:00+00:00"))

        // same timestamp, different offset
        #expect(try OffsetDateTime(from: "1970-01-01T00:00:00+01:00") < OffsetDateTime(from: "1970-01-01T01:00:00+02:00"))

        // different nanosecond
        #expect(try OffsetDateTime(from: "1970-01-01T00:00:00.000000001+00:00") < OffsetDateTime(from: "1970-01-01T00:00:00.000000002+00:00"))
    }

    @Test
    func test_date() {
        #expect(OffsetDateTime(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0, offset: .utc).date == Date(timeIntervalSince1970: 0))

        #expect(OffsetDateTime(year: 1969, month: 12, day: 31, hour: 23, minute: 59, second: 59, nanosecond: 0, offset: .utc).date == Date(timeIntervalSince1970: -1))

        #expect(OffsetDateTime(year: 1970, month: 1, day: 1, hour: 1, minute: 29, second: 59, nanosecond: 0, offset: .init(second: 5400)).date == Date(timeIntervalSince1970: -1))

        #expect(OffsetDateTime(year: 1969, month: 12, day: 31, hour: 22, minute: 29, second: 59, nanosecond: 0, offset: .init(second: -5400)).date == Date(timeIntervalSince1970: -1))
    }
}
