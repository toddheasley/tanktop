import Foundation
import UserNotifications
import TankUtility

extension UNUserNotificationCenter {
    func refreshAlerts(for devices: [Device], completion: ((Bool) -> Void)? = nil) {
        getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
                completion?(false)
            case .authorized, .provisional:
                guard !(TankUtility.username ?? "").isEmpty else {
                    fallthrough
                }
                for device in devices {
                    guard let request: UNNotificationRequest = UNNotificationRequest(device: device) else {
                        continue
                    }
                    self.add(request) { error in
                        request.notified = Date()
                    }
                }
                completion?(true)
            case .denied:
                UserDefaults.standard.notified = [:]
                self.removeAllPendingNotificationRequests()
                self.removeAllDeliveredNotifications()
                fallthrough
            default:
                completion?(false)
            }
        }
    }
    
    func requestAuthorization() {
        guard TankUtility.username != nil else {
            return
        }
        requestAuthorization(options: [.alert, .badge]) { _, _ in
            
        }
    }
}

extension UNNotificationRequest {
    fileprivate var notified: Date? {
        set {
            if let date: Date = newValue {
                UserDefaults.standard.notified[identifier] = date
            } else {
                UserDefaults.standard.notified.removeValue(forKey: identifier)
            }
        }
        get {
            return UserDefaults.standard.notified[identifier]
        }
    }
    
    fileprivate convenience init?(device: Device) {
        guard let content: UNNotificationContent = UNMutableNotificationContent(device: device) else {
            return nil
        }
        if let date: Date = UserDefaults.standard.notified[device.id], Date() < Date(timeInterval: 86400.0, since: date) {
            return nil
        }
        self.init(identifier: device.id, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 60.0, repeats: false))
    }
}

extension UNMutableNotificationContent {
    fileprivate convenience init?(device: Device) {
        guard device.isAlerting else {
            return nil
        }
        self.init()
        title = "\(device.name)"
        subtitle = "\(device.address)"
        body = "\(device.fuel.description.capitalized) tank is below \(String(percent: device.alert.threshold)!)"
    }
}

extension UserDefaults {
    fileprivate var notified: [String: Date] {
        set {
            set(newValue, forKey: "notified")
        }
        get {
            return dictionary(forKey: "notified") as? [String: Date] ?? [:]
        }
    }
}
