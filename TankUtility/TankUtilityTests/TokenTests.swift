import XCTest
@testable import TankUtility

class TokenTests: XCTestCase {
    
}

extension TokenTests {
    
    // MARK: Decodable
    func testDecodeInit() {
        guard let data: Data = data(resource: .bundle, type: "json"),
            let token: Token = (try? JSONDecoder().decode([Token].self, from: data))?.first else {
            XCTFail()
            return
        }
        XCTAssertEqual(token.description, "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzgyMjQwODE0NjIsInYiOjAsImQiOnsidWleejoic2ltcGxlbG9naW46MzM1In0sImlhdCI6wwDIyMzk5NX0.kbYzxRtbGB2ke3IBgQTVMNQprHOWJZFgQQnPK6Wyas4")
        XCTAssertEqual(token.date.timeIntervalSince1970, Date().timeIntervalSince1970, accuracy: 1.0)
    }
}
