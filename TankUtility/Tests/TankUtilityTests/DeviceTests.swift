import XCTest
@testable import TankUtility

class DeviceTests: XCTestCase {
    
}

extension DeviceTests {
    func testIsAlerting() {
        guard var device: Device = try? JSONDecoder(device: "54ff69057492666782350667").decode(Device.self, from: data), device.lastReading?.tank == 0.2  else {
            XCTFail()
            return
        }
        device.alert.threshold = 0.21
        device.alert.isEnabled = false
        XCTAssertFalse(device.isAlerting)
        device.alert.isEnabled = true
        XCTAssertTrue(device.isAlerting)
        device.alert.threshold = 0.2
        XCTAssertFalse(device.isAlerting)
        UserDefaults.standard.alerts = [:]
    }
    
    func testAlert() {
        UserDefaults.standard.alerts = [:]
        guard var device: Device = try? JSONDecoder(device: "54ff69057492666782350667").decode(Device.self, from: data) else {
            XCTFail()
            return
        }
        XCTAssertEqual(device.alert.threshold, 0.25)
        XCTAssertTrue(device.alert.isEnabled)
        device.alert.threshold = 0.35
        XCTAssertEqual(device.alert.threshold, 0.35)
        device.alert.isEnabled = false
        XCTAssertFalse(device.alert.isEnabled)
        UserDefaults.standard.alerts = [:]
    }
}

extension DeviceTests {
    
    // MARK: Codable
    func testEncode() {
        guard let data: Data = try? JSONEncoder().encode(try? JSONDecoder(device: "54df6a066667531535371367").decode(Device.self, from: data)),
            let device: Device = try? JSONDecoder().decode(Device.self, from: data) else {
            XCTFail()
            return
        }
        XCTAssertEqual(device.id, "54df6a066667531535371367")
        XCTAssertEqual(device.name, "Sample Device")
        XCTAssertEqual(device.address, "6 Dane St., Somerville, MA 02143, USA")
        XCTAssertEqual(device.fuel, .propane)
        XCTAssertEqual(device.orientation, .vertical)
        XCTAssertEqual(device.capacity, Measurement(value: 100.0, unit: UnitVolume.gallons))
        XCTAssertEqual(device.lastReading?.tank, 0.2)
    }
    
    func testDecoderInit() {
        guard let device: Device = try? JSONDecoder(device: "54ff69057492666782350667").decode(Device.self, from: data) else {
            XCTFail()
            return
        }
        XCTAssertEqual(device.id, "54ff69057492666782350667")
        XCTAssertEqual(device.name, "Sample Device")
        XCTAssertEqual(device.address, "6 Dane St., Somerville, MA 02143, USA")
        XCTAssertEqual(device.fuel, .propane)
        XCTAssertEqual(device.orientation, .vertical)
        XCTAssertEqual(device.capacity, Measurement(value: 100.0, unit: UnitVolume.gallons))
        XCTAssertEqual(device.lastReading?.tank, 0.2)
    }
}

private let data: Data = """
{
    "name": "Sample Device",
    "address": "6 Dane St., Somerville, MA 02143, USA",
    "fuelType": "propane",
    "orientation": "vertical",
    "capacity": 100,
    "lastReading": {
        "tank": 20,
        "temperature": 72.12,
        "time": 1444338760345,
    }
}
""".data(using: .utf8)!
