import Foundation
import BackgroundTasks
import UserNotifications
import TankUtility

extension BGTaskScheduler {
    func registerRefresh() {
        register(forTaskWithIdentifier: BGTaskRequest.refresh.identifier, using: nil) { task in
            self.scheduleRefresh()
            TankUtility.devices { devices, _ in
                UNUserNotificationCenter.current().refreshAlerts(for: devices ?? []) { success in
                    task.setTaskCompleted(success: success)
                }
            }
        }
    }
    
    func scheduleRefresh() {
        guard !(TankUtility.username ?? "").isEmpty else {
            return
        }
        try? submit(.refresh)
    }
}

extension BGTaskRequest {
    static var refresh: BGTaskRequest {
        let request: BGAppRefreshTaskRequest = BGAppRefreshTaskRequest(identifier: "com.toddheasley.tanktop.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60.0)
        return request
    }
}
