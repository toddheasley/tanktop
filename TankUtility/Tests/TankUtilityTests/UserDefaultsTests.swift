import XCTest
@testable import TankUtility

class UserDefaultsTests: XCTestCase {
    
}

extension UserDefaultsTests {
    func testDevices() {
        UserDefaults.standard.removeObject(forKey: "devices")
        XCTAssertTrue(UserDefaults.standard.devices.isEmpty)
        guard let device: Device = try? JSONDecoder().decode(Device.self, from: data) else {
            XCTFail()
            return
        }
        UserDefaults.standard.devices = [
            device
        ]
        XCTAssertFalse(UserDefaults.standard.devices.isEmpty)
        XCTAssertEqual(UserDefaults.standard.devices.first?.name, device.name)
        UserDefaults.standard.devices = []
        XCTAssertTrue(UserDefaults.standard.devices.isEmpty)
        UserDefaults.standard.removeObject(forKey: "devices")
    }
    
    func testAlerts() {
        UserDefaults.standard.removeObject(forKey: "alerts")
        XCTAssertTrue(UserDefaults.standard.alerts.isEmpty)
        UserDefaults.standard.alerts = [
            "54df6a066667531535371367": Alert(threshold: 0.15)
        ]
        XCTAssertEqual(UserDefaults.standard.alerts.count, 1)
        XCTAssertEqual(UserDefaults.standard.alerts["54df6a066667531535371367"]?.threshold, 0.15)
        XCTAssertFalse(UserDefaults.standard.alerts["54df6a066667531535371367"]?.isEnabled ?? true)
        UserDefaults.standard.alerts["54ff69057492666782350667"] = Alert(isEnabled: true)
        XCTAssertEqual(UserDefaults.standard.alerts.count, 2)
        XCTAssertEqual(UserDefaults.standard.alerts["54df6a066667531535371367"]?.threshold, 0.15)
        XCTAssertFalse(UserDefaults.standard.alerts["54df6a066667531535371367"]?.isEnabled ?? true)
        XCTAssertEqual(UserDefaults.standard.alerts["54ff69057492666782350667"]?.threshold, 0.25)
        XCTAssertTrue(UserDefaults.standard.alerts["54ff69057492666782350667"]?.isEnabled ?? false)
        UserDefaults.standard.removeObject(forKey: "alerts")
    }
    
    func testPrimary() {
        UserDefaults.standard.removeObject(forKey: "primary")
        XCTAssertNil(UserDefaults.standard.primary)
        UserDefaults.standard.primary = "54df6a066667531535371367"
        XCTAssertEqual(UserDefaults.standard.primary, "54df6a066667531535371367")
        UserDefaults.standard.primary = nil
        XCTAssertNil(UserDefaults.standard.primary)
        UserDefaults.standard.removeObject(forKey: "primary")
    }
}

private let data: Data = """
{
    "id": "54df6a066667531535371367",
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
