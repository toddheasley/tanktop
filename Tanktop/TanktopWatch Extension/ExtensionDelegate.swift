import WatchKit
import WatchConnectivity
import TankUtility

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    func refresh(completion: ((Error?) -> Void)? = nil) {
        TankUtility.device { device, error in
            (WKExtension.shared().rootInterfaceController as? InterfaceController)?.device = device
            ComplicationController.device = device
            WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(timeIntervalSinceNow: 7200.0), userInfo: nil) { error in
                completion?(error)
            }
        }
    }
    
    // MARK: WKExtensionDelegate
    func applicationDidFinishLaunching() {
        TankUtility.appGroup = "group.toddheasley.tanktop"
        WCSession.activate(delegate: self)
    }
    
    func applicationDidBecomeActive() {
        refresh()
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            switch task {
            case let refreshTask as WKApplicationRefreshBackgroundTask:
                self.refresh { _ in
                    refreshTask.setTaskCompletedWithSnapshot(true)
                }
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: .distantFuture, userInfo: nil)
            default:
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
    
    // MARK: WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        TankUtility.context = session.receivedApplicationContext
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        TankUtility.context = session.receivedApplicationContext
        applicationDidBecomeActive()
    }
}
