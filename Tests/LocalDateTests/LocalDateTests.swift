import XCTest
@testable import LocalDate

final class LocalDateTests: XCTestCase {
    func test_init() {
        let date = LocalDate(year: 2021, month: 5, day: 1)
        XCTAssertEqual(date.year, 2021)
        XCTAssertEqual(date.month, 5)
        XCTAssertEqual(date.day, 1)
    }
    
    func test_init_from_date_in_timeZone() {
        var date = LocalDate(from: Date(timeIntervalSince1970: 0), in: TimeZone(secondsFromGMT: 0)!)
        XCTAssertEqual(date.year, 1970)
        XCTAssertEqual(date.month, 1)
        XCTAssertEqual(date.day, 1)
        
        date = LocalDate(from: Date(timeIntervalSince1970: 0), in: TimeZone(secondsFromGMT: -60)!)
        XCTAssertEqual(date.year, 1969)
        XCTAssertEqual(date.month, 12)
        XCTAssertEqual(date.day, 31)
    }
    
    func test_init_from_string() throws {
        var date = try LocalDate(from: "1970-01-01")
        XCTAssertEqual(date.year, 1970)
        XCTAssertEqual(date.month, 1)
        XCTAssertEqual(date.day, 1)
        
        date = try LocalDate(from: "1970/01/01")
        XCTAssertEqual(date.year, 1970)
        XCTAssertEqual(date.month, 1)
        XCTAssertEqual(date.day, 1)
    }
    
    func test_init_from_string_error() {
        XCTAssertThrowsError(try LocalDate(from: "19700101")) {
            XCTAssertEqual($0 as? LocalDate.Error, .invalidStringFormat)
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
    
    func test_string() {
        XCTAssertEqual(
            LocalDate(year: 1970, month: 1, day: 1).string(),
            "1970-01-01"
        )
    }
    
    func test_init_from_decoder() throws {
        let decoder = JSONDecoder()
        let date = try decoder.decode(LocalDate.self, from: Data("\"1970-01-01\"".utf8))
        XCTAssertEqual(date.year, 1970)
        XCTAssertEqual(date.month, 1)
        XCTAssertEqual(date.day, 1)
    }
    
    func test_encode_to_encoder() throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(LocalDate(year: 1970, month: 1, day: 1))
        XCTAssertEqual(data, Data("\"1970-01-01\"".utf8))
    }
}
