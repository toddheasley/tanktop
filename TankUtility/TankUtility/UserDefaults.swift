import Foundation

extension UserDefaults {
    static var shared: UserDefaults = .standard
    
    var data: Data? {
        set {
            removeObject(forKey: "alerts")
            removeObject(forKey: "primary")
            guard let data: Data = newValue, let object: [String: Any] = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)) as? [String: Any] else {
                return
            }
            if let alerts: Data = object["alerts"] as? Data {
                set(alerts, forKey: "alerts")
            }
            if let primary: String = object["primary"] as? String, !primary.isEmpty {
                set(primary, forKey: "primary")
            }
        }
        get {
            var object: [String: Any] = [:]
            if let alerts: Data = data(forKey: "alerts") {
                object["alerts"] = alerts
            }
            if let primary: String = string(forKey: "primary"), !primary.isEmpty {
                object["primary"] = primary
            }
            
            return !object.isEmpty ? try? NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false) : nil
        }
    }
    
    var alerts: [String: Alert] {
        set {
            guard let data: Data = try? JSONEncoder().encode(newValue) else {
                return
            }
            set(data, forKey: "alerts")
        }
        get {
            guard let data: Data = data(forKey: "alerts") else {
                return [:]
            }
            return (try? JSONDecoder().decode([String: Alert].self, from: data)) ?? [:]
        }
    }
    
    var primary: String? {
        set {
            set(newValue, forKey: "primary")
        }
        get {
            return string(forKey: "primary")
        }
    }
}
