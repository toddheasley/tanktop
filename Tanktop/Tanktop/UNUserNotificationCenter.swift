import Foundation
import UserNotifications
import TankUtility

extension UNUserNotificationCenter {
    func refreshAlerts(for devices: [Device], completion: ((Bool) -> Void)? = nil) {
        completion?(false)
        return
        
        /*
        getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                self.removeAllPendingNotificationRequests()
                self.removeAllDeliveredNotifications()
                var result: Bool = false
                for device in devices {
                    guard let request: UNNotificationRequest = UNNotificationRequest(device: device) else {
                        continue
                    }
                    self.add(request, withCompletionHandler: nil)
                    result = true
                }
                completion?(result)
            default:
                completion?(false)
            }
        } */
    }
    
    func requestAuthorization() {
        guard TankUtility.username != nil else {
            return
        }
        requestAuthorization(options: [.alert, .badge]) { _, _ in
            
        }
    }
}

fileprivate extension UNNotificationRequest {
    convenience init?(device: Device) {
        guard let content: UNNotificationContent = UNMutableNotificationContent(device: device) else {
            return nil
        }
        self.init(identifier: device.id, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 30.0, repeats: false))
    }
}

fileprivate extension UNMutableNotificationContent {
    convenience init?(device: Device) {
        guard device.isAlerting else {
            return nil
        }
        self.init()
        title = "\(device.name)"
        subtitle = "\(device.address)"
        body = "\(device.fuel.description.capitalized) tank is below \(String(percent: device.alert.threshold)!)"
    }
}
