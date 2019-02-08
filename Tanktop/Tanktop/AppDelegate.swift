import UIKit
import UserNotifications
import WatchConnectivity
import TankUtility

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, WCSessionDelegate {
    
    // MARK: UIApplicationDelegate
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        TankUtility.appGroup = "group.toddheasley.tanktop"
        application.setMinimumBackgroundFetchInterval(7200.0)
        UNUserNotificationCenter.current().delegate = self
        WCSession.activate(delegate: self)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        try? WCSession.available?.updateApplicationContext(TankUtility.context)
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        TankUtility.alerting { devices, error in
            guard error == nil else {
                completionHandler(.failed)
                return
            }
            UNUserNotificationCenter.current().refreshAlerts(for: devices) { newData in
                completionHandler(newData ? .newData : .noData)
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let scheme: String = URL.app().scheme, scheme == url.scheme else {
            return false
        }
        if let id: String = url.host, !id.isEmpty {
            (window?.rootViewController as? MainViewController)?.open(device: id)
        }
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
