import XCTest
@testable import TankUtility

class URLTests: XCTestCase {
    
}

extension URLTests {
    func testToken() {
        XCTAssertEqual(URL.token, URL(string: "https://data.tankutility.com/api/getToken"))
    }
    
    func testDevices() {
        XCTAssertEqual(URL.devices(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzgyMjQwODE0NjIsInYiOjAsImQiOnsidWleejoic2ltcGxlbG9naW46MzM1In0sImlhdCI6wwDIyMzk5NX0.kbYzxRtbGB2ke3IBgQTVMNQprHOWJZFgQQnPK6Wyas4", device: "54df6a066667531535371367"), URL(string: "https://data.tankutility.com/api/devices/54df6a066667531535371367?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzgyMjQwODE0NjIsInYiOjAsImQiOnsidWleejoic2ltcGxlbG9naW46MzM1In0sImlhdCI6wwDIyMzk5NX0.kbYzxRtbGB2ke3IBgQTVMNQprHOWJZFgQQnPK6Wyas4"))
        XCTAssertEqual(URL.devices(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzgyMjQwODE0NjIsInYiOjAsImQiOnsidWleejoic2ltcGxlbG9naW46MzM1In0sImlhdCI6wwDIyMzk5NX0.kbYzxRtbGB2ke3IBgQTVMNQprHOWJZFgQQnPK6Wyas4"), URL(string: "https://data.tankutility.com/api/devices?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzgyMjQwODE0NjIsInYiOjAsImQiOnsidWleejoic2ltcGxlbG9naW46MzM1In0sImlhdCI6wwDIyMzk5NX0.kbYzxRtbGB2ke3IBgQTVMNQprHOWJZFgQQnPK6Wyas4"))
    }
}
