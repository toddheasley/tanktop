import UIKit
import TankUtility

extension UIAlertController {
    static func alert(error: TankUtility.Error) -> UIAlertController {
        let alertController: UIAlertController = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alertController
    }
}

extension TankUtility.Error {
    fileprivate var title: String {
        return "\(rawValue)"
    }
    
    fileprivate var message: String {
        switch self {
        case .badRequest:
            return "BAD REQUEST"
        case .unauthorized:
            return "UNAUTHORIZED"
        case .forbidden:
            return "FORBIDDEN"
        case .notFound:
            return "NOT FOUND"
        case .notAllowed:
            return "NOT ALLOWED"
        case .notAcceptable:
            return "NOT ACCEPTABLE"
        case .gone:
            return "GONE"
        case .tooManyRequests:
            return "TOO MANY REQUESTS"
        case .server:
            return "SERVER"
        case .unavailable:
            return "UNAVAILABLE"
        }
    }
}
