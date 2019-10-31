import UIKit
import TankUtility

extension UIAlertController {
    static func alert(error: TankUtility.Error) -> UIAlertController {
        let alertController: UIAlertController = UIAlertController(title: "Error", message: "\(error.rawValue)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alertController
    }
}
