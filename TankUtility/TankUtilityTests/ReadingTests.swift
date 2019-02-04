import XCTest
@testable import TankUtility

class ReadingTests: XCTestCase {
    
}

extension ReadingTests {
    
    // MARK: Decodable
    func testDecodeInit() {
        guard let data: Data = data(resource: .bundle, type: "json"),
            let reading: Reading = try? JSONDecoder().decode(Reading.self, from: data) else {
            XCTFail()
            return
        }
        XCTAssertEqual(reading.tank, 0.2)
        XCTAssertEqual(reading.temperature, Measurement(value: 72.12, unit: UnitTemperature.fahrenheit))
        XCTAssertEqual(reading.date, Date(timeIntervalSince1970: 1444338760.345))
    }
}
