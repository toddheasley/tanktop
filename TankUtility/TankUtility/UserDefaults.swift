import Foundation

extension UserDefaults {
    static var shared: UserDefaults = .standard
    
    var primary: String? {
        set {
            set(newValue, forKey: "primary")
        }
        get {
            return string(forKey: "primary")
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
}
