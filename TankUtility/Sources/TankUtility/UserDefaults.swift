import Foundation

extension UserDefaults {
    static var shared: UserDefaults = .standard
    
    var devices: [Device] {
        set {
            set(try? JSONEncoder().encode(newValue), forKey: Key.devices.stringValue)
            let ids: [String] = devices.map { device in
                return device.id
            }
            alerts = alerts.filter { alert in
                return ids.contains(alert.key)
            }
            primary = primary ?? nil
        }
        get {
            guard let data: Data = data(forKey: Key.devices.stringValue),
                let devices: [Device] = try? JSONDecoder().decode([Device].self, from: data) else {
                return []
            }
            return devices
        }
    }
    
    var alerts: [String: Alert] {
        set {
            set(try? JSONEncoder().encode(newValue), forKey: Key.alerts.stringValue)
        }
        get {
            guard let data: Data = data(forKey: Key.alerts.stringValue),
                let alerts: [String: Alert] = try? JSONDecoder().decode([String: Alert].self, from: data) else {
                return [:]
            }
            return alerts
        }
    }
    
    var primary: String? {
        set {
            set(newValue, forKey: Key.primary.stringValue)
        }
        get {
            return string(forKey: Key.primary.stringValue)
        }
    }
    
    private enum Key: String, CodingKey {
        case devices, alerts, primary
    }
}