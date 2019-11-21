import UIKit
import SafariServices
import TankUtility

extension UIViewController {
    var mainViewController: MainViewController? {
        return (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? MainViewController
    }
    
    @discardableResult func handle(error: TankUtility.Error?) -> Bool {
        switch error {
        case nil:
            return false
        case .unauthorized:
            mainViewController?.present(AuthorizeViewController(error: error), animated: true, completion: nil)
            return true
        default:
            mainViewController?.present(UIAlertController.alert(error: error!), animated: true, completion: nil)
            return true
        }
    }
}
