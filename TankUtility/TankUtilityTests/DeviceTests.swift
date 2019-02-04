import XCTest
@testable import TankUtility

class DeviceTests: XCTestCase {
    
}

extension DeviceTests {
    func testIsAlerting() {
        guard let data: Data = data(resource: .bundle, type: "json"),
            var device: Device = try? JSONDecoder().decode(Device.self, from: data), device.lastReading?.tank == 0.2  else {
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
        guard let data: Data = data(resource: .bundle, type: "json"),
            var device: Device = try? JSONDecoder().decode(Device.self, from: data) else {
            XCTFail()
            return
        }
        XCTAssertEqual(device.alert.threshold, 0.25)
        XCTAssertFalse(device.alert.isEnabled)
        device.alert.threshold = 0.35
        XCTAssertEqual(device.alert.threshold, 0.35)
        device.alert.isEnabled = true
        XCTAssertTrue(device.alert.isEnabled)
        UserDefaults.standard.alerts = [:]
    }
}

extension DeviceTests {
    
    // MARK: Decodable
    func testDecodeInit() {
        guard let data: Data = data(resource: .bundle, type: "json"),
            let device: Device = try? JSONDecoder().decode(Device.self, from: data) else {
            XCTFail()
            return
        }
        XCTAssertEqual(device.name, "Sample Device")
        XCTAssertEqual(device.address, "6 Dane St., Somerville, MA 02143, USA")
        XCTAssertEqual(device.fuel, .propane)
        XCTAssertEqual(device.orientation, .vertical)
        XCTAssertEqual(device.capacity, Measurement(value: 100.0, unit: UnitVolume.gallons))
        XCTAssertEqual(device.lastReading?.tank, 0.2)
    }
}
