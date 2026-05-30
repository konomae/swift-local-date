import Foundation
@testable import LocalDate
import Testing

struct LocalDateTests {
    @Test
    func test_init() {
        let date = LocalDate(year: 1970, month: 1, day: 1)
        #expect(date.year == 1970)
        #expect(date.month == 1)
        #expect(date.day == 1)
    }

    @Test
    func init_from_date_in_timeZone() throws {
        #expect(try LocalDate(from: Date(timeIntervalSince1970: 0), in: #require(TimeZone(secondsFromGMT: 0))) == LocalDate(year: 1970, month: 1, day: 1))

        #expect(try LocalDate(from: Date(timeIntervalSince1970: 0), in: #require(TimeZone(secondsFromGMT: -3600))) == LocalDate(year: 1969, month: 12, day: 31))
    }

    @Test
    func init_from_string() throws {
        #expect(try LocalDate(from: "1970-01-01") == LocalDate(year: 1970, month: 1, day: 1))
        #expect(try LocalDate(from: "1970-12-31") == LocalDate(year: 1970, month: 12, day: 31))
        #expect(try LocalDate(from: "-0001-01-01") == LocalDate(year: -1, month: 1, day: 1))
    }

    @Test
    func init_from_string_error() {
        #expect(throws: FormatError()) {
            try LocalDate(from: "")
        }

        #expect(throws: FormatError()) {
            try LocalDate(from: "-")
        }

        #expect(throws: FormatError()) {
            try LocalDate(from: "-0001-10")
        }

        #expect(throws: FormatError()) {
            try LocalDate(from: "1970-10")
        }

        #expect(throws: FormatError()) {
            try LocalDate(from: "1970-10-")
        }

        #expect(throws: FormatError()) {
            try LocalDate(from: "-0001-10-")
        }

        #expect(throws: FormatError()) {
            try LocalDate(from: "1970/01/01")
        }

        #expect(throws: FormatError()) {
            try LocalDate(from: "1970-01-01-")
        }

        #expect(throws: FormatError()) {
            try LocalDate(from: "19700101")
        }

        #expect(throws: FormatError()) {
            try LocalDate(from: "1970-01-01T00:00:00+00:00")
        }
    }

    @Test
    func date_in_timeZone() throws {
        #expect(try LocalDate(year: 1970, month: 1, day: 1).date(in: #require(TimeZone(secondsFromGMT: 0))) == Date(timeIntervalSince1970: 0))

        #expect(try LocalDate(year: 1970, month: 1, day: 1).date(in: #require(TimeZone(secondsFromGMT: -3600))) == Date(timeIntervalSince1970: 3600))
    }

    @Test
    func test_description() {
        #expect(LocalDate(year: 1970, month: 1, day: 1).description == "1970-01-01")
        #expect(LocalDate(year: -1, month: 1, day: 1).description == "-0001-01-01")
        #expect(String(describing: LocalDate(year: 1970, month: 1, day: 1)) == "1970-01-01")
    }

    @Test
    func init_from_description() {
        #expect(LocalDate("19700101") == nil)
        #expect(LocalDate(LocalDate(year: 1970, month: 1, day: 1).description) == LocalDate(year: 1970, month: 1, day: 1))
    }

    @Test
    func init_from_decoder() throws {
        #expect(try JSONDecoder().decode(LocalDate.self, from: Data("\"1970-01-01\"".utf8)) == LocalDate(year: 1970, month: 1, day: 1))

        #if compiler(>=6.1)
        struct A: Decodable {
            var b: B
        }

        struct B: Decodable {
            var value: LocalDate
        }

        let error = try #require(throws: DecodingError.self) {
            try JSONDecoder().decode(A.self, from: Data(#"{"b": {"value": "19700101"}}"#.utf8))
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
        #expect(try JSONEncoder().encode(LocalDate(year: 1970, month: 1, day: 1)) == Data("\"1970-01-01\"".utf8))
    }

    @Test
    func comparable() {
        #expect(LocalDate(year: 1969, month: 12, day: 31) < LocalDate(year: 1970, month: 1, day: 1))

        #expect(LocalDate(year: 1970, month: 1, day: 1) < LocalDate(year: 1970, month: 2, day: 1))

        #expect(LocalDate(year: 1970, month: 1, day: 1) < LocalDate(year: 1970, month: 1, day: 2))
    }

    @Test
    func test_atTime() {
        #expect(LocalDate(year: 1970, month: 1, day: 2).atTime(.init(hour: 3, minute: 4, second: 5, nanosecond: 6)) == LocalDateTime(year: 1970, month: 1, day: 2, hour: 3, minute: 4, second: 5, nanosecond: 6))
    }

    @Test
    func test_addingMonths() {
        #expect(LocalDate(year: 0, month: 1, day: 1).addingMonths(0) == LocalDate(year: 0, month: 1, day: 1))

        #expect(LocalDate(year: 0, month: 1, day: 1).addingMonths(1) == LocalDate(year: 0, month: 2, day: 1))
        #expect(LocalDate(year: 0, month: 1, day: 1).addingMonths(2) == LocalDate(year: 0, month: 3, day: 1))
        #expect(LocalDate(year: 0, month: 1, day: 1).addingMonths(12) == LocalDate(year: 1, month: 1, day: 1))
        #expect(LocalDate(year: 0, month: 1, day: 1).addingMonths(13) == LocalDate(year: 1, month: 2, day: 1))

        #expect(LocalDate(year: 0, month: 1, day: 1).addingMonths(-1) == LocalDate(year: -1, month: 12, day: 1))
        #expect(LocalDate(year: 0, month: 1, day: 1).addingMonths(-2) == LocalDate(year: -1, month: 11, day: 1))
        #expect(LocalDate(year: 0, month: 1, day: 1).addingMonths(-12) == LocalDate(year: -1, month: 1, day: 1))
        #expect(LocalDate(year: 0, month: 1, day: 1).addingMonths(-13) == LocalDate(year: -2, month: 12, day: 1))

        // last valid day
        #expect(LocalDate(year: 0, month: 1, day: 31).addingMonths(1) == LocalDate(year: 0, month: 2, day: 29))
        #expect(LocalDate(year: 0, month: 1, day: 31).addingMonths(2) == LocalDate(year: 0, month: 3, day: 31))
        #expect(LocalDate(year: 0, month: 1, day: 31).addingMonths(3) == LocalDate(year: 0, month: 4, day: 30))
        #expect(LocalDate(year: 0, month: 1, day: 31).addingMonths(13) == LocalDate(year: 1, month: 2, day: 28))
    }

    @Test
    func test_until() {
        // same
        #expect(LocalDate(year: 0, month: 1, day: 1).until(LocalDate(year: 0, month: 1, day: 1)) == Period(years: 0, months: 0, days: 0))

        // basic
        #expect(LocalDate(year: 0, month: 1, day: 1).until(LocalDate(year: 1, month: 3, day: 4)) == Period(years: 1, months: 2, days: 3))
        #expect(LocalDate(year: 1, month: 3, day: 4).until(LocalDate(year: 0, month: 1, day: 1)) == Period(years: -1, months: -2, days: -3))

        // year boundaries
        #expect(LocalDate(year: 0, month: 2, day: 28).until(LocalDate(year: 4, month: 2, day: 28)) == Period(years: 4, months: 0, days: 0))
        #expect(LocalDate(year: 0, month: 2, day: 28).until(LocalDate(year: 4, month: 2, day: 27)) == Period(years: 3, months: 11, days: 30))
        #expect(LocalDate(year: 0, month: 2, day: 29).until(LocalDate(year: 4, month: 2, day: 28)) == Period(years: 3, months: 11, days: 30))
        #expect(LocalDate(year: 0, month: 2, day: 29).until(LocalDate(year: 1, month: 3, day: 1)) == Period(years: 1, months: 0, days: 1))

        // year boundaries (negative)
        #expect(LocalDate(year: 4, month: 2, day: 28).until(LocalDate(year: 0, month: 2, day: 28)) == Period(years: -4, months: 0, days: 0))
        #expect(LocalDate(year: 4, month: 2, day: 27).until(LocalDate(year: 0, month: 2, day: 28)) == Period(years: -3, months: -11, days: -28))
        #expect(LocalDate(year: 4, month: 2, day: 28).until(LocalDate(year: 0, month: 2, day: 29)) == Period(years: -3, months: -11, days: -28))
        #expect(LocalDate(year: 1, month: 3, day: 1).until(LocalDate(year: 0, month: 2, day: 29)) == Period(years: -1, months: 0, days: -1))

        // days
        #expect(LocalDate(year: 0, month: 2, day: 29).until(LocalDate(year: 0, month: 3, day: 1)) == Period(years: 0, months: 0, days: 1))
        #expect(LocalDate(year: 0, month: 2, day: 28).until(LocalDate(year: 0, month: 3, day: 1)) == Period(years: 0, months: 0, days: 2))
        #expect(LocalDate(year: 1, month: 2, day: 28).until(LocalDate(year: 1, month: 3, day: 1)) == Period(years: 0, months: 0, days: 1))

        // days (negative)
        #expect(LocalDate(year: 0, month: 3, day: 1).until(LocalDate(year: 0, month: 2, day: 29)) == Period(years: 0, months: 0, days: -1))
        #expect(LocalDate(year: 0, month: 3, day: 1).until(LocalDate(year: 0, month: 2, day: 28)) == Period(years: 0, months: 0, days: -2))
        #expect(LocalDate(year: 1, month: 3, day: 1).until(LocalDate(year: 1, month: 2, day: 28)) == Period(years: 0, months: 0, days: -1))
    }
}
