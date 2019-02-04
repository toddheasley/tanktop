import XCTest
@testable import TankUtility

class StringTests: XCTestCase {
    
}

extension StringTests {
    func testCapacityInit() {
        XCTAssertEqual(String(capacity: Measurement(value: 120.0, unit: UnitVolume.gallons)), "120 gal")
        XCTAssertNil(String(capacity: nil))
    }
    
    func testTemperatureInit() {
        XCTAssertEqual(String(temperature: Measurement(value: 65.1, unit: UnitTemperature.fahrenheit)), "65°F")
        XCTAssertEqual(String(temperature: Measurement(value: 18.5, unit: UnitTemperature.celsius)), "65°F")
        XCTAssertNil(String(temperature: nil))
    }
    
    func testPercentInit() {
        XCTAssertEqual(String(percent: 0.0), "0%")
        XCTAssertEqual(String(percent: 0.1471), "15%")
        XCTAssertEqual(String(percent: 1.0), "100%")
        XCTAssertNil(String(percent: nil))
    }
    
    func testDateInit() {
        XCTAssertEqual(String(date: Date(timeIntervalSince1970: 0.0), timeZone: TimeZone(secondsFromGMT: 0)), "Jan 1, 1970 12:00 AM")
        XCTAssertNil(String(date: nil))
    }
}
