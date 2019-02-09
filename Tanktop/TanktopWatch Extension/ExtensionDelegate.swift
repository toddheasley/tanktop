import WatchKit
import WatchConnectivity
import TankUtility

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {
    
    // MARK: WKExtensionDelegate
    func applicationDidFinishLaunching() {
        TankUtility.appGroup = "group.toddheasley.tanktop"
        WCSession.activate(delegate: self)
    }
    
    func applicationDidBecomeActive() {
        (WKExtension.shared().rootInterfaceController as? InterfaceController)?.refresh()
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            switch task {
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
