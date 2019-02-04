import XCTest
@testable import TankUtility

class URLRequestTests: XCTestCase {
    func testToken() {
        XCTAssertEqual(URLRequest.token.httpMethod, "GET")
        XCTAssertEqual(URLRequest.token.url, URL.token)
        XCTAssertEqual(URLRequest.token.allHTTPHeaderFields?.first?.key, "Authorization")
    }
    
    func testDevices() {
        XCTAssertEqual(URLRequest.devices(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzgyMjQwODE0NjIsInYiOjAsImQiOnsidWleejoic2ltcGxlbG9naW46MzM1In0sImlhdCI6wwDIyMzk5NX0.kbYzxRtbGB2ke3IBgQTVMNQprHOWJZFgQQnPK6Wyas4").httpMethod, "GET")
        XCTAssertEqual(URLRequest.devices(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzgyMjQwODE0NjIsInYiOjAsImQiOnsidWleejoic2ltcGxlbG9naW46MzM1In0sImlhdCI6wwDIyMzk5NX0.kbYzxRtbGB2ke3IBgQTVMNQprHOWJZFgQQnPK6Wyas4").url, URL.devices(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzgyMjQwODE0NjIsInYiOjAsImQiOnsidWleejoic2ltcGxlbG9naW46MzM1In0sImlhdCI6wwDIyMzk5NX0.kbYzxRtbGB2ke3IBgQTVMNQprHOWJZFgQQnPK6Wyas4"))
        XCTAssertEqual(URLRequest.devices(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzgyMjQwODE0NjIsInYiOjAsImQiOnsidWleejoic2ltcGxlbG9naW46MzM1In0sImlhdCI6wwDIyMzk5NX0.kbYzxRtbGB2ke3IBgQTVMNQprHOWJZFgQQnPK6Wyas4", device: "54df6a066667531535371367").httpMethod, "GET")
        XCTAssertEqual(URLRequest.devices(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzgyMjQwODE0NjIsInYiOjAsImQiOnsidWleejoic2ltcGxlbG9naW46MzM1In0sImlhdCI6wwDIyMzk5NX0.kbYzxRtbGB2ke3IBgQTVMNQprHOWJZFgQQnPK6Wyas4", device: "54df6a066667531535371367").url, URL(string: "https://data.tankutility.com/api/devices/54df6a066667531535371367?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzgyMjQwODE0NjIsInYiOjAsImQiOnsidWleejoic2ltcGxlbG9naW46MzM1In0sImlhdCI6wwDIyMzk5NX0.kbYzxRtbGB2ke3IBgQTVMNQprHOWJZFgQQnPK6Wyas4"))
    }
}

extension URLRequestTests {
    func testAuthorization() {
        URLRequest.authorize(username: "toddheasley@me.com", password: "P@$$w0rd")
        XCTAssertEqual(URLRequest.authorization, "Basic dG9kZGhlYXNsZXlAbWUuY29tOlBAJCR3MHJk")
        URLRequest.deauthorize()
        XCTAssertNil(URLRequest.authorization)
    }
    
    func testUsername() {
        URLRequest.authorize(username: "toddheasley@me.com", password: "P@$$w0rd")
        XCTAssertEqual(URLRequest.username, "toddheasley@me.com")
        URLRequest.deauthorize()
        XCTAssertNil(URLRequest.username)
    }
    
    func testAuthorize() {
        URLRequest.authorize(username: "toddheasley@me.com", password: "12345678")
        XCTAssertEqual(URLRequest.authorization, "Basic dG9kZGhlYXNsZXlAbWUuY29tOjEyMzQ1Njc4")
        URLRequest.authorize(username: "toddheasley@me.com", password: "P@$$w0rd")
        XCTAssertEqual(URLRequest.authorization, "Basic dG9kZGhlYXNsZXlAbWUuY29tOlBAJCR3MHJk")
        URLRequest.deauthorize()
        XCTAssertNil(URLRequest.authorization)
    }
    
    func testDeauthorize() {
        URLRequest.authorize(username: "toddheasley@me.com", password: "P@$$w0rd")
        XCTAssertNotNil(URLRequest.authorization)
        URLRequest.deauthorize()
        XCTAssertNil(URLRequest.authorization)
    }
}
