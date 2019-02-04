import Foundation

public struct TankUtility {
    public enum Error: Int, Swift.Error {
        case badRequest = 400
        case unauthorized = 401
        case forbidden = 403
        case notFound = 404
        case notAllowed = 405
        case notAcceptable = 406
        case gone = 410
        case tooManyRequests = 429
        case server = 500
        case unavailable = 503
    }
    
    public static var appGroup: String? {
        didSet {
            UserDefaults.shared = UserDefaults(suiteName: appGroup) ?? .standard
        }
    }
    
    public static var primary: String? {
        set {
            UserDefaults.shared.primary = newValue
        }
        get {
            return UserDefaults.shared.primary
        }
    }
    
    public static var logo: Data {
        return try! Data.logo()
    }
    
    public static var username: String? {
        return URLRequest.username
    }
    
    public static func devices(completion: @escaping ([String], Error?) -> Void) {
        URLSession.shared.devices { devices, error in
            DispatchQueue.main.async {
                completion(Array(devices.prefix(10)), error != nil ? (error as? Error ?? .badRequest) : nil)
            }
        }
    }
    
    public static func device(id: String? = nil, completion: @escaping (Device?, Error?) -> Void) {
        if let id: String = id ?? UserDefaults.shared.primary {
            URLSession.shared.device(id: id) { device, error in
                DispatchQueue.main.async {
                    completion(device, error != nil ? (error as? Error ?? .notFound) : nil)
                }
            }
        } else {
            devices { ids, error in
                guard let id: String = ids.first else {
                    DispatchQueue.main.async {
                        completion(nil, .notFound)
                    }
                    return
                }
                device(id: id, completion: completion)
            }
        }
    }
    
    public static func alerting(completion: @escaping ([Device], Error?) -> Void) {
        URLSession.shared.alerting { devices, error in
            completion(devices, error != nil ? (error as? Error ?? .badRequest) : nil)
        }
    }
    
    public static func authorize(username: String, password: String, completion: ((Error?) -> Void)?) {
        URLRequest.authorize(username: username, password: password)
        URLSession.shared.token { _, error in
            DispatchQueue.main.async {
                completion?(error != nil ? (error as? Error ?? .unauthorized) : nil)
            }
        }
    }
    
    public static func deauthorize() {
        URLRequest.deauthorize()
    }
}
