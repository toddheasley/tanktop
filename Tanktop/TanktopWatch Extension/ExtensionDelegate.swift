import WatchKit
import TankUtility

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    // MARK: WKExtensionDelegate
    func applicationDidFinishLaunching() {
        TankUtility.appGroup = "group.toddheasley.tanktop"
    }
    
    func applicationDidBecomeActive() {
        
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
}
