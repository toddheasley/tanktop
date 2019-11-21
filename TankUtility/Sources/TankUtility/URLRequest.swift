import Foundation

extension URLRequest {
    static var token: URLRequest {
        var request: URLRequest = URLRequest(url: .token)
        if let authorization: String = URLRequest.authorization?.base64EncodedString() {
            request.addValue("Basic \(authorization)", forHTTPHeaderField: "Authorization")
        }
        request.cachePolicy = .reloadIgnoringLocalCacheData
        return request
    }
    
    static func devices(token: String, device id: String? = nil) -> URLRequest {
        return URLRequest(url: URL.devices(token: token, device: id))
    }
}

extension URLRequest {
    static var authorization: Data? {
        set {
            deauthorize()
            guard let data: Data = newValue,
                let username: String = String(data: data, encoding: .utf8)?.components(separatedBy: ":").first, !username.isEmpty else {
                return
            }
            SecItemAdd([
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
                kSecAttrLabel as String: label as Any,
                kSecAttrAccount as String: username as Any,
                kSecValueData as String: data as Any
            ] as CFDictionary, nil)
        }
        get{
            var result: AnyObject?
            SecItemCopyMatching([
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrLabel as String: label as Any,
                kSecReturnData as String: kCFBooleanTrue as Any,
                kSecMatchLimit as String: kSecMatchLimitOne
            ] as CFDictionary, &result)
            return result as? Data
        }
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
        authorization = "\(username):\(password)".data(using: .utf8, allowLossyConversion: false)
    }
    
    static func deauthorize() {
        SecItemDelete([
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: label as Any
        ] as CFDictionary)
    }
    
    private static let label: String = "com.tankutility.api"
}

extension URLRequest {
    static var isExample: Bool {
        return username == "tankutility@example.com"
    }
}
