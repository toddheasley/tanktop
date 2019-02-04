import XCTest
import Cocoa
@testable import TankUtility

class DataTests: XCTestCase {
    
}

extension DataTests {
    func testLogo() {
        do {
            let data: Data = try Data.logo()
            XCTAssertNotNil(NSImage(data: data))
        } catch {
            XCTFail()
        }
    }
}
