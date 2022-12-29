@testable import LocalDate
import XCTest

final class ZoneOffsetTests: XCTestCase {
    func test_init() {
        let offset = ZoneOffset(second: 1)
        XCTAssertEqual(offset.second, 1)
    }
    
    func test_init_hour_minute() {
        XCTAssertEqual(ZoneOffset(hour: 1).second, 3600)
        XCTAssertEqual(ZoneOffset(hour: 2, minute: 30).second, 9000)
        XCTAssertEqual(ZoneOffset(hour: -1).second, -3600)
        XCTAssertEqual(ZoneOffset(hour: -2, minute: -30).second, -9000)
    }
    
    func test_init_from_timeZone() {
        XCTAssertEqual(ZoneOffset(timeZone: TimeZone(secondsFromGMT: 3600)!), ZoneOffset(second: 3600))
        XCTAssertEqual(ZoneOffset(timeZone: TimeZone(secondsFromGMT: -9000)!), ZoneOffset(second: -9000))
    }
    
    func test_init_from_string() throws {
        XCTAssertEqual(try ZoneOffset(from: "+02:30"), ZoneOffset(second: 9000))
        XCTAssertEqual(try ZoneOffset(from: "-02:30"), ZoneOffset(second: -9000))
        XCTAssertEqual(try ZoneOffset(from: "Z"), ZoneOffset(second: 0))
    }

    func test_init_from_string_error() throws {
        XCTAssertThrowsError(try ZoneOffset(from: "+")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        XCTAssertThrowsError(try ZoneOffset(from: "-")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        XCTAssertThrowsError(try ZoneOffset(from: "Z1")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
        XCTAssertThrowsError(try ZoneOffset(from: "")) {
            XCTAssertEqual($0 as? FormatError, FormatError())
        }
    }
    
    func test_description() {
        XCTAssertEqual(ZoneOffset(second: 9000).description, "+02:30")
        XCTAssertEqual(ZoneOffset(second: -3600).description, "-01:00")
        XCTAssertEqual(ZoneOffset(second: 0).description, "Z")
        XCTAssertEqual(String(describing: ZoneOffset(second: 9000)), "+02:30")
        XCTAssertEqual(String(describing: ZoneOffset(second: -3600)), "-01:00")
        XCTAssertEqual(String(describing: ZoneOffset(second: 0)), "Z")
    }
    
    func test_init_from_description() {
        XCTAssertNil(ZoneOffset(""))
        XCTAssertEqual(ZoneOffset("-02:30"), ZoneOffset(second: -9000))
    }
    
    func test_init_from_decoder() throws {
        XCTAssertEqual(
            try JSONDecoder().decode(ZoneOffset.self, from: Data("\"-02:30\"".utf8)),
            ZoneOffset(second: -9000)
        )
        
        struct A: Decodable {
            var b: B
        }
        
        struct B: Decodable {
            var value: ZoneOffset
        }
        
        XCTAssertThrowsError(try JSONDecoder().decode(A.self, from: Data(#"{"b": {"value": ""}}"#.utf8))) {
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
            try JSONEncoder().encode(ZoneOffset(second: -9000)),
            Data("\"-02:30\"".utf8)
        )
    }
    
    func test_comparable() throws {
        // +01:00 < +00:00
        XCTAssertLessThan(ZoneOffset(second: 3600), ZoneOffset(second: 0))
        // +00:00 < -01:00
        XCTAssertLessThan(ZoneOffset(second: 0), ZoneOffset(second: -3600))
    }
    
    func test_timeZone() {
        XCTAssertEqual(ZoneOffset(second: 3600).timeZone, TimeZone(secondsFromGMT: 3600))
        XCTAssertEqual(ZoneOffset(second: -9000).timeZone, TimeZone(secondsFromGMT: -9000))
    }
}
