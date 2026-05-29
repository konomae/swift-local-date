import Foundation
@testable import LocalDate
import Testing

struct ZoneOffsetTests {
    @Test
    func test_init() {
        let offset = ZoneOffset(second: 1)
        #expect(offset.second == 1)
    }

    @Test
    func test_init_hour_minute() {
        #expect(ZoneOffset(hour: 1).second == 3600)
        #expect(ZoneOffset(hour: 2, minute: 30).second == 9000)
        #expect(ZoneOffset(hour: -1).second == -3600)
        #expect(ZoneOffset(hour: -2, minute: -30).second == -9000)
    }

    @Test
    func test_init_from_timeZone() throws {
        #expect(try ZoneOffset(timeZone: #require(TimeZone(secondsFromGMT: 3600))) == ZoneOffset(second: 3600))
        #expect(try ZoneOffset(timeZone: #require(TimeZone(secondsFromGMT: -9000))) == ZoneOffset(second: -9000))
    }

    @Test
    func test_init_from_string() throws {
        #expect(try ZoneOffset(from: "+02:30") == ZoneOffset(second: 9000))
        #expect(try ZoneOffset(from: "-02:30") == ZoneOffset(second: -9000))
        #expect(try ZoneOffset(from: "Z") == ZoneOffset(second: 0))
    }

    @Test
    func test_init_from_string_error() throws {
        #expect(throws: FormatError()) {
            try ZoneOffset(from: "+")
        }
        #expect(throws: FormatError()) {
            try ZoneOffset(from: "-")
        }
        #expect(throws: FormatError()) {
            try ZoneOffset(from: "Z1")
        }
        #expect(throws: FormatError()) {
            try ZoneOffset(from: "")
        }
    }

    @Test
    func test_description() {
        #expect(ZoneOffset(second: 9000).description == "+02:30")
        #expect(ZoneOffset(second: -3600).description == "-01:00")
        #expect(ZoneOffset(second: 0).description == "Z")
        #expect(String(describing: ZoneOffset(second: 9000)) == "+02:30")
        #expect(String(describing: ZoneOffset(second: -3600)) == "-01:00")
        #expect(String(describing: ZoneOffset(second: 0)) == "Z")
    }

    @Test
    func test_init_from_description() {
        #expect(ZoneOffset("") == nil)
        #expect(ZoneOffset("-02:30") == ZoneOffset(second: -9000))
    }

    @Test
    func test_init_from_decoder() throws {
        #expect(try JSONDecoder().decode(ZoneOffset.self, from: Data("\"-02:30\"".utf8)) == ZoneOffset(second: -9000))

        struct A: Decodable {
            var b: B
        }

        struct B: Decodable {
            var value: ZoneOffset
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
    }

    @Test
    func test_encode_to_encoder() throws {
        #expect(try JSONEncoder().encode(ZoneOffset(second: -9000)) == Data("\"-02:30\"".utf8))
    }

    @Test
    func test_comparable() {
        // +01:00 < +00:00
        #expect(ZoneOffset(second: 3600) < ZoneOffset(second: 0))
        // +00:00 < -01:00
        #expect(ZoneOffset(second: 0) < ZoneOffset(second: -3600))
    }

    @Test
    func test_timeZone() {
        #expect(ZoneOffset(second: 3600).timeZone == TimeZone(secondsFromGMT: 3600))
        #expect(ZoneOffset(second: -9000).timeZone == TimeZone(secondsFromGMT: -9000))
    }
}
