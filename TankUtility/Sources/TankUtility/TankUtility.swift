import Foundation

public struct TankUtility {
    public static var website: URL {
        return .website
    }
    
    public static var support: URL {
        return .support
    }
    
    public static var appGroup: String? {
        didSet {
            UserDefaults.shared = UserDefaults(suiteName: appGroup) ?? .standard
        }
    }
    
    public static var username: String? {
        return URLRequest.username
    }
    
    public static var current: String? {
        return UserDefaults.shared.current ?? UserDefaults.shared.devices.first?.id
    }
    
    public static func devices(completion: @escaping ([Device]?, Error?) -> Void) {
        if URLRequest.isExample, let devices: [Device] = Device.examples {
            UserDefaults.shared.devices = devices
            completion(devices, nil)
        } else {
            URLSession.shared.devices { devices, error in
                DispatchQueue.main.async {
                    guard let devices: [Device] = devices else {
                        completion(nil, error as? Error ?? .badRequest)
                        return
                    }
                    UserDefaults.shared.devices = devices
                    completion(devices, nil)
                }
            }
        }
    }
    
    public static func device(id: String? = nil, completion: @escaping (Device?, Bool, Error?) -> Void) {
        guard let id: String = id ?? current, !id.isEmpty else {
            completion(nil, true, .notFound)
            return
        }
        if URLRequest.isExample, let devices: [Device] = Device.examples {
            for device in devices {
                guard device.id == id else {
                    continue
                }
                completion(device, true, nil)
                return
            }
            completion(nil, true, .notFound)
        } else {
            for device in UserDefaults.shared.devices {
                guard device.id == id else {
                    continue
                }
                completion(device, false, nil)
                break
            }
            URLSession.shared.device(id: id) { device, error in
                DispatchQueue.main.async {
                    guard let device: Device = device else {
                        completion(nil, true, error as? Error ?? .notFound)
                        return
                    }
                    for (index, _) in UserDefaults.shared.devices.enumerated() {
                        guard UserDefaults.shared.devices[index].id == device.id else {
                            continue
                        }
                        UserDefaults.shared.devices[index] = device
                        break
                    }
                    completion(device, true, nil)
                }
            }
        }
    }
    
    public static func authorize(username: String, password: String, completion: ((Error?) -> Void)?) {
        Context.reset()
        URLRequest.authorize(username: username, password: password)
        guard !URLRequest.isExample else {
            completion?(nil)
            return
        }
        URLSession.shared.token { token, error in
            if token == nil {
                deauthorize()
            }
            DispatchQueue.main.async {
                completion?(error != nil ? (error as? Error ?? .unauthorized) : nil)
            }
        }
    }
    
    public static func deauthorize() {
        Context.reset()
    }
}

extension TankUtility {
    public static let contextDidChangeNotification: Notification.Name = Notification.Name("contextDidChange")
    
    public static var context: [String: Any] {
        set {
            guard let data: Data = newValue[Key.context.stringValue] as? Data,
                let context: Context = try? JSONDecoder().decode(Context.self, from: data) else {
                return
            }
            URLRequest.authorization = context.authorization
            UserDefaults.shared.devices = context.devices
            UserDefaults.shared.alerts = context.alerts
            UserDefaults.shared.current = context.current
        }
        get {
            return [
                Key.context.stringValue: try! JSONEncoder().encode(Context())
            ]
        }
    }
    
    private enum Key: CodingKey {
        case context
    }
    
    private struct Context: Codable {
        let authorization: Data?
        let devices: [Device]
        let alerts: [String: Alert]
        let current: String?
        
        init() {
            authorization = URLRequest.authorization
            devices = UserDefaults.shared.devices
            alerts = UserDefaults.shared.alerts
            current = UserDefaults.shared.current
        }
                
        fileprivate static func reset() {
            URLRequest.authorization = nil
            UserDefaults.shared.current = nil
            UserDefaults.shared.devices = []
            UserDefaults.shared.alerts = [:]
            Token.reset()
            NotificationCenter.default.post(Notification(name: contextDidChangeNotification))
        }
    }
}

extension TankUtility {
    public enum Error: Int, Swift.Error, CustomStringConvertible {
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
        
        init?(response: URLResponse?) {
            guard let response: HTTPURLResponse = response as? HTTPURLResponse else {
                return nil
            }
            self.init(rawValue: response.statusCode)
        }
        
        // MARK: CustomStringConvertible
        public var description: String {
            switch self {
            case .badRequest:
                return "bad request"
            case .unauthorized:
                return "unauthorized"
            case .forbidden:
                return "forbidden"
            case .notFound:
                return "not found"
            case .notAllowed:
                return "method not allowed"
            case .notAcceptable:
                return "not acceptable"
            case .gone:
                return "gone"
            case .tooManyRequests:
                return "too many requests"
            case .server:
                return "internal server error"
            case .unavailable:
                return "service unavailable"
            }
        }
    }
}
