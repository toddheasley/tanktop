import UIKit
import UserNotifications
import WatchConnectivity
import TankUtility

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, WCSessionDelegate {
    @objc func handleContext(notification: Notification?) {
        try? WCSession.available?.updateApplicationContext(TankUtility.context)
    }
    
    // MARK: UIApplicationDelegate
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        TankUtility.appGroup = "group.toddheasley.tanktop"
        UNUserNotificationCenter.current().delegate = self
        WCSession.activate(delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(handleContext(notification:)), name: TankUtility.contextDidChangeNotification, object: nil)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        #if targetEnvironment(macCatalyst)
        window?.windowScene?.titlebar?.titleVisibility = .hidden
        #endif
        (window?.rootViewController as? MainViewController)?.refresh()
        
        try? WCSession.available?.updateApplicationContext(TankUtility.context)
        
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let scheme: String = URL.app().scheme, scheme == url.scheme else {
            return false
        }
        (window?.rootViewController as? MainViewController)?.open(device: url.host)
        return true
    }
    
    // MARK: UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        (window?.rootViewController as? MainViewController)?.open(device: response.notification.request.identifier)
        completionHandler()
    }

    
    // MARK: WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        try? session.updateApplicationContext(TankUtility.context)
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
