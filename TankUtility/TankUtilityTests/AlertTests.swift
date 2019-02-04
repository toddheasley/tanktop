import XCTest
@testable import TankUtility

class AlertTests: XCTestCase {
    func testThreshold() {
        var alert: Alert = Alert()
        XCTAssertEqual(alert.threshold, 0.25)
        alert.threshold = 0.0
        XCTAssertEqual(alert.threshold, 0.1)
        alert.threshold = 0.1
        XCTAssertEqual(alert.threshold, 0.1)
        alert.threshold = 0.5
        XCTAssertEqual(alert.threshold, 0.5)
        alert.threshold = 0.9
        XCTAssertEqual(alert.threshold, 0.9)
        alert.threshold = 1.0
        XCTAssertEqual(alert.threshold, 0.9)
    }
}
