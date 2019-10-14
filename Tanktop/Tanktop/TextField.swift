import UIKit

protocol TextFieldDelegate {
    func textDidChange(field: TextField)
    func textDidReturn(field: TextField)
}

class TextField: UIView, UITextFieldDelegate {
    enum InputType {
        case username, password
    }
    
    var delegate: TextFieldDelegate?
    
    var text: String {
        set {
            textField.text = newValue
        }
        get {
            return textField.text ?? ""
        }
    }
    
    var returnKeyType: UIReturnKeyType {
        set {
            textField.returnKeyType = newValue
            textField.reloadInputViews()
        }
        get {
            return textField.returnKeyType
        }
    }
    
    private(set) var inputType: InputType {
        set {
            switch newValue {
            case .username:
                textField.placeholder = "Email Address"
                textField.keyboardType = .emailAddress
            case .password:
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
            }
        }
        get {
            return textField.isSecureTextEntry ? .password : .username
        }
    }
    
    var isEditing: Bool {
        set {
            if newValue {
                textField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
        get {
            return textField.isEditing
        }
    }
    
    convenience init(input inputType: InputType) {
        self.init()
        self.inputType = inputType
    }
    
    @objc func handleText() {
        guard textField.isEditing else {
            return
        }
        delegate?.textDidChange(field: self)
    }
    
    private let textField: UITextField = UITextField()
    
    // MARK: UIView
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame.size.width = bounds.size.width - (textField.frame.origin.x * 2.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        textField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textField.frame = bounds
        textField.delegate = self
        addSubview(textField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleText), name: UITextField.textDidChangeNotification, object: nil)
        inputType = .username
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textDidReturn(field: self)
        return true
    }
}
