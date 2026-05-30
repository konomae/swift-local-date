import Foundation
@testable import LocalDate
import Testing

struct LocalTimeTests {
    @Test
    func test_init() {
        let time = LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
        #expect(time.hour == 1)
        #expect(time.minute == 2)
        #expect(time.second == 3)
        #expect(time.nanosecond == 4)
    }
    
    @Test
    func test_init_from_date_in_timeZone() throws {
        #expect(try LocalTime(from: Date(timeIntervalSince1970: 0), in: #require(TimeZone(secondsFromGMT: 0))) == LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 0))
        
        #expect(try LocalTime(from: Date(timeIntervalSince1970: 3599), in: #require(TimeZone(secondsFromGMT: -3600))) == LocalTime(hour: 23, minute: 59, second: 59, nanosecond: 0))
    }
    
    @Test
    func test_init_from_string() throws {
        #expect(try LocalTime(from: "00:00:00") == LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 0))
        #expect(try LocalTime(from: "23:59:59") == LocalTime(hour: 23, minute: 59, second: 59, nanosecond: 0))
        
        #expect(try LocalTime(from: "00:00:00.0") == LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 0))
        #expect(try LocalTime(from: "23:59:59.999") == LocalTime(hour: 23, minute: 59, second: 59, nanosecond: 999000000))
        #expect(try LocalTime(from: "23:59:59.999999999") == LocalTime(hour: 23, minute: 59, second: 59, nanosecond: 999999999))
        #expect(try LocalTime(from: "23:59:59.000000001") == LocalTime(hour: 23, minute: 59, second: 59, nanosecond: 1))
        #expect(try LocalTime(from: "23:59:59.1") == LocalTime(hour: 23, minute: 59, second: 59, nanosecond: 100000000))
    }
    
    @Test
    func test_init_from_string_error() throws {
        #expect(throws: FormatError()) {
            try LocalTime(from: "00:00:00.")
        }
        #expect(throws: FormatError()) {
            try LocalTime(from: "235959")
        }
    }
    
    @Test
    func test_description() {
        #expect(LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4).description == "01:02:03.000000004")
        #expect(LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 400000000).description == "01:02:03.4")
        #expect(LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 40000000).description == "01:02:03.04")
        #expect(LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4050).description == "01:02:03.00000405")
        #expect(LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 0).description == "01:02:03")
        #expect(String(describing: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)) == "01:02:03.000000004")
    }
    
    @Test
    func test_init_from_description() {
        #expect(LocalTime("235959") == nil)
        #expect(LocalTime(LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4).description) == LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4))
    }
    
    @Test
    func test_init_from_decoder() throws {
        #expect(try JSONDecoder().decode(LocalTime.self, from: Data("\"01:02:03.4\"".utf8)) == LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 400000000))
        
        #if compiler(>=6.1)
        struct A: Decodable {
            var b: B
        }
        
        struct B: Decodable {
            var value: LocalTime
        }
        
        let error = try #require(throws: DecodingError.self) {
            try JSONDecoder().decode(A.self, from: Data(#"{"b": {"value": "235959"}}"#.utf8))
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
    func test_encode_to_encoder() throws {
        #expect(try JSONEncoder().encode(LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)) == Data("\"01:02:03.000000004\"".utf8))
    }
    
    @Test
    func test_comparable() {
        #expect(LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 0) < LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 1))
        
        #expect(LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 0) < LocalTime(hour: 0, minute: 0, second: 1, nanosecond: 0))
        
        #expect(LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 0) < LocalTime(hour: 0, minute: 1, second: 0, nanosecond: 0))
        
        #expect(LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 0) < LocalTime(hour: 1, minute: 0, second: 0, nanosecond: 0))
    }
}
