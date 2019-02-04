import XCTest
@testable import TankUtility

class UserDefaultsTests: XCTestCase {
    
}

extension UserDefaultsTests {
    func testPrimary() {
        UserDefaults.standard.removeObject(forKey: "primary")
        XCTAssertNil(UserDefaults.standard.primary)
        UserDefaults.standard.primary = "54df6a066667531535371367"
        XCTAssertEqual(UserDefaults.standard.primary, "54df6a066667531535371367")
        UserDefaults.standard.primary = "54ff69057492666782350667"
        XCTAssertEqual(UserDefaults.standard.primary, "54ff69057492666782350667")
        UserDefaults.standard.primary = nil
        XCTAssertNil(UserDefaults.standard.primary)
        UserDefaults.standard.removeObject(forKey: "primary")
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
}
