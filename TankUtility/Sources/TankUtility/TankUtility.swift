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
    
    public static var username: String? {
        return URLRequest.username
    }
    
    public static var primary: String? {
        return UserDefaults.shared.primary ?? UserDefaults.shared.devices.first?.id
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
    
    public static func device(id: String, completion: @escaping (Device?, Bool, Error?) -> Void) {
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
        context.reset()
        URLRequest.authorize(username: username, password: password)
        guard !URLRequest.isExample else {
            completion?(nil)
            return
        }
        URLSession.shared.token { _, error in
            DispatchQueue.main.async {
                completion?(error != nil ? (error as? Error ?? .unauthorized) : nil)
            }
        }
    }
    
    public static func deauthorize() {
        context.reset()
    }
}

extension TankUtility {
    struct Context: Codable {
        let authorization: Data? = URLRequest.authorization
        let devices: [Device] = UserDefaults.shared.devices
        let alerts: [String: Alert] = UserDefaults.shared.alerts
        let primary: String? = UserDefaults.shared.primary
        
        fileprivate func reset() {
            URLRequest.authorization = nil
            UserDefaults.shared.devices = []
        }
    }
    
    static var context: Context {
        set {
            URLRequest.authorization = newValue.authorization
            UserDefaults.shared.devices = newValue.devices
            UserDefaults.shared.alerts = newValue.alerts
            UserDefaults.shared.primary = newValue.primary
        }
        get {
            return Context()
        }
    }
}
