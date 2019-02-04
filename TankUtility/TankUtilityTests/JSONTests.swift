import XCTest
@testable import TankUtility

class JSONTests: XCTestCase {
    
}

extension JSONTests {
    
    // MARK: Decodable
    func testDecodeInit() {
        guard let data: Data = data(resource: .bundle, type: "json"), let json: [JSON] = try? JSONDecoder().decode([JSON].self, from: data), json.count == 3 else {
            XCTFail()
            return
        }
        XCTAssertEqual(json[0].value as? [String], ["54df6a066667531535371367", "54ff69057492666782350667"])
        XCTAssertEqual((json[1].value as? Device)?.name, "Sample Device")
        XCTAssertEqual((json[2].value as? Token)?.description, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzgyMjQwODE0NjIsInYiOjAsImQiOnsidWleejoic2ltcGxlbG9naW46MzM1In0sImlhdCI6wwDIyMzk5NX0.kbYzxRtbGB2ke3IBgQTVMNQprHOWJZFgQQnPK6Wyas4")
    }
}
