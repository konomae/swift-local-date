import XCTest
@testable import LocalDate

final class LocalTimeTests: XCTestCase {
    func test_init() {
        let time = LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
        XCTAssertEqual(time.hour, 1)
        XCTAssertEqual(time.minute, 2)
        XCTAssertEqual(time.second, 3)
        XCTAssertEqual(time.nanosecond, 4)
    }
    
    func test_init_from_date_in_timeZone() {
        XCTAssertEqual(
            LocalTime(from: Date(timeIntervalSince1970: 0), in: TimeZone(secondsFromGMT: 0)!),
            LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 0)
        )
        
        XCTAssertEqual(
            LocalTime(from: Date(timeIntervalSince1970: 0), in: TimeZone(secondsFromGMT: 0)!),
            LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 0)
        )
        
        XCTAssertEqual(
            LocalTime(from: Date(timeIntervalSince1970: 3599), in: TimeZone(secondsFromGMT: -3600)!),
            LocalTime(hour: 23, minute: 59, second: 59, nanosecond: 0)
        )
    }
    
    func test_init_from_string() throws {
        XCTAssertEqual(try LocalTime(from: "00:00:00"), LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 0))
        XCTAssertEqual(try LocalTime(from: "23:59:59"), LocalTime(hour: 23, minute: 59, second: 59, nanosecond: 0))
        
        XCTAssertEqual(try LocalTime(from: "00:00:00.0"), LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 0))
        XCTAssertEqual(try LocalTime(from: "23:59:59.999999999"), LocalTime(hour: 23, minute: 59, second: 59, nanosecond: 999999999))
        XCTAssertEqual(try LocalTime(from: "23:59:59.000000001"), LocalTime(hour: 23, minute: 59, second: 59, nanosecond: 1))
        XCTAssertEqual(try LocalTime(from: "23:59:59.1"), LocalTime(hour: 23, minute: 59, second: 59, nanosecond: 100000000))
    }
    
    func test_init_from_string_error() throws {
        XCTAssertThrowsError(try LocalTime(from: "00:00:00.")) {
            XCTAssertEqual($0 as? LocalTime.Error, .invalidStringFormat)
        }
        XCTAssertThrowsError(try LocalTime(from: "235959")) {
            XCTAssertEqual($0 as? LocalTime.Error, .invalidStringFormat)
        }
    }
    
    func test_description() {
        XCTAssertEqual(LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4).description, "01:02:03.000000004")
        XCTAssertEqual(LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 400000000).description, "01:02:03.4")
        XCTAssertEqual(LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 40000000).description, "01:02:03.04")
        XCTAssertEqual(LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4050).description, "01:02:03.00000405")
        XCTAssertEqual(LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 0).description, "01:02:03")
        XCTAssertEqual(String(describing: LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)), "01:02:03.000000004")
    }
    
    func test_init_from_description() {
        XCTAssertNil(LocalTime("235959"))
        XCTAssertEqual(
            LocalTime(LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4).description),
            LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)
        )
    }
    
    func test_init_from_decoder() throws {
        XCTAssertEqual(
            try JSONDecoder().decode(LocalTime.self, from: Data("\"01:02:03.4\"".utf8)),
            LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 400000000)
        )
    }
    
    func test_encode_to_encoder() throws {
        XCTAssertEqual(
            try JSONEncoder().encode(LocalTime(hour: 1, minute: 2, second: 3, nanosecond: 4)),
            Data("\"01:02:03.000000004\"".utf8)
        )
    }
    
    func test_comparable() {
        XCTAssertLessThan(
            LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 0),
            LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 1)
        )
        
        XCTAssertLessThan(
            LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 0),
            LocalTime(hour: 0, minute: 0, second: 1, nanosecond: 0)
        )
        
        XCTAssertLessThan(
            LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 0),
            LocalTime(hour: 0, minute: 1, second: 0, nanosecond: 0)
        )
        
        XCTAssertLessThan(
            LocalTime(hour: 0, minute: 0, second: 0, nanosecond: 0),
            LocalTime(hour: 1, minute: 0, second: 0, nanosecond: 0)
        )
    }
}
