import WatchKit
import TankUtility

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    
    // MARK: WKExtensionDelegate
    func applicationDidFinishLaunching() {
        TankUtility.appGroup = "group.toddheasley.tanktop"
    }
    
    func applicationDidBecomeActive() {
        (WKExtension.shared().rootInterfaceController as? InterfaceController)?.device = nil
    }
}
