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
    
    public static var username: String? {
        return URLRequest.username
    }
    
    public static var context: [String: Any] {
        set {
            URLRequest.authorization = newValue["authorization"] as? Data
            UserDefaults.shared.data = newValue["data"] as? Data
        }
        get {
            var context: [String: Any] = [:]
            if let authorization: Data = URLRequest.authorization, !authorization.isEmpty {
                context["authorization"] = authorization
                if let data: Data = UserDefaults.shared.data {
                    context["data"] = data
                }
            }
            return context
        }
    }
    
    public static func devices(completion: @escaping ([String], Error?) -> Void) {
        func validate(_ devices: [String]) {
            primary = devices.contains(primary ?? "") ? primary : nil
        }
        
        if let examples: [Device] = examples {
            let devices: [String] = examples.map { example in
                return example.id
            }
            validate(devices)
            completion(devices, nil)
        } else {
            URLSession.shared.devices { devices, error in
                let devices: [String] = Array(devices.prefix(10))
                validate(devices)
                DispatchQueue.main.async {
                    completion(devices, error != nil ? (error as? Error ?? .badRequest) : nil)
                }
            }
        }
    }
    
    public static func device(id: String? = nil, completion: @escaping (Device?, Error?) -> Void) {
        if let examples: [Device] = examples {
            for example in examples {
                guard example.id == (id ?? UserDefaults.shared.primary) ?? examples.first?.id else {
                    continue
                }
                completion(example, nil)
                return
            }
            completion(nil, .notFound)
        } else if let id: String = id ?? UserDefaults.shared.primary {
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
        if let examples: [Device] = examples {
            completion(examples.filter { example in
                return example.isAlerting
            }, nil)
        } else {
            URLSession.shared.alerting { devices, error in
                completion(devices, error != nil ? (error as? Error ?? .badRequest) : nil)
            }
        }
    }
    
    public static func authorize(username: String, password: String, completion: ((Error?) -> Void)?) {
        URLRequest.authorize(username: username, password: password)
        if let _: [Device] = examples {
            completion?(nil)
        } else {
            URLSession.shared.token { _, error in
                DispatchQueue.main.async {
                    completion?(error != nil ? (error as? Error ?? .unauthorized) : nil)
                }
            }
        }
    }
    
    public static func deauthorize() {
        primary = nil
        URLRequest.deauthorize()
    }
    
    private static var examples: [Device]? {
        class Example {
            
        }
        
        guard username == "tanktop@example.com",
            let url: URL = Bundle(for: Example.self).url(forResource: "TankUtility", withExtension: "json"),
            let data: Data = try? Data(contentsOf: url),
            let devices: [Device] = try? JSONDecoder().decode([Device].self, from: data) else {
            return nil
        }
        var examples: [Device] = []
        for (index, var device) in devices.enumerated() {
            device.id = "example\(index)"
            examples.append(device)
        }
        return examples
    }
}
