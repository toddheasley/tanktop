import UIKit

extension UITextField {
    static var username: UITextField {
        let textField: UITextField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email Address"
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        return textField
    }
    
    static var password: UITextField {
        let textField: UITextField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        return textField
    }
}
