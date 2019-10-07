import XCTest
@testable import TankUtility

class ReadingTests: XCTestCase {
    
}

extension ReadingTests {
    
    // MARK: Codable
    func testEncode() {
        guard let data: Data = try? JSONEncoder().encode(try? JSONDecoder().decode(Reading.self, from: data)),
            let reading: Reading = try? JSONDecoder().decode(Reading.self, from: data) else {
            XCTFail()
            return
        }
        XCTAssertEqual(reading.tank, 0.2)
        XCTAssertEqual(reading.temperature, Measurement(value: 72.12, unit: UnitTemperature.fahrenheit))
        XCTAssertEqual(reading.date, Date(timeIntervalSince1970: 1444338760.345))
    }
    
    func testDecodeInit() {
        guard let reading: Reading = try? JSONDecoder().decode(Reading.self, from: data) else {
            XCTFail()
            return
        }
        XCTAssertEqual(reading.tank, 0.2)
        XCTAssertEqual(reading.temperature, Measurement(value: 72.12, unit: UnitTemperature.fahrenheit))
        XCTAssertEqual(reading.date, Date(timeIntervalSince1970: 1444338760.345))
    }
}

private let data: Data = """
{
    "tank": 20,
    "temperature": 72.12,
    "time": 1444338760345
}
""".data(using: .utf8)!
