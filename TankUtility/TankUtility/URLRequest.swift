import Foundation

extension URLRequest {
    static var token: URLRequest {
        var request: URLRequest = URLRequest(url: .token)
        request.addValue(URLRequest.authorization ?? "", forHTTPHeaderField: "Authorization")
        return request
    }
    
    static func devices(token: String, device id: String? = nil) -> URLRequest {
        return URLRequest(url: URL.devices(token: token, device: id))
    }
}

extension URLRequest {
    static var authorization: String? {
        var result: AnyObject?
        SecItemCopyMatching([
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: label as Any,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as CFDictionary, &result)
        guard let data: Data = result as? Data else {
            return nil
        }
        return "Basic \(data.base64EncodedString())"
    }
    
    static var username: String? {
        var result: AnyObject?
        SecItemCopyMatching([
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: label as Any,
            kSecReturnAttributes as String: kCFBooleanTrue as Any,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as CFDictionary, &result)
        return (result as? [String: Any])?[kSecAttrAccount as String] as? String
    }
    
    static func authorize(username: String, password: String) {
        deauthorize()
        SecItemAdd([
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccessible as String: kSecAttrAccessibleAlways,
            kSecAttrLabel as String: label as Any,
            kSecAttrAccount as String: username as Any,
            kSecValueData as String: "\(username):\(password)".data(using: .utf8, allowLossyConversion: false) as Any
        ] as CFDictionary, nil)
    }
    
    static func deauthorize() {
        guard let username: String = username else {
            return
        }
        SecItemDelete([
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username as Any
        ] as CFDictionary)
    }
    
    private static let label: String = "com.tankutility.api"
}
