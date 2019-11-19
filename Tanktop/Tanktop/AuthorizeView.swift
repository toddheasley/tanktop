import UIKit
import TankUtility

protocol AuthorizeViewDelegate {
    func authorizeView(_ view: AuthorizeView, didOpen url: URL)
    func authorizeViewDidAuthorize(_ view: AuthorizeView)
    func authorizeViewDidDismiss(_view: AuthorizeView)
}

class AuthorizeView: UIView, UITextFieldDelegate {
    var delegate: AuthorizeViewDelegate?
    
    var isAuthorized: Bool {
        return authorizeControl.isAuthorized
    }
    
    var error: TankUtility.Error? {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    @objc func handleAuthorize(_ control: AuthorizeControl?) {
        delegate?.authorizeView(self, didOpen: TankUtility.website)
    }
    
    @objc func handleDeauthorize(_ control: DeauthorizeControl?) {
        TankUtility.deauthorize()
        authorizeControl.isAuthorized = false
        delegate?.authorizeViewDidAuthorize(self)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    @objc func handleDismiss() {
        delegate?.authorizeViewDidDismiss(_view: self)
    }
    
    @objc func handleTextDidChange(_ textField: UITextField?) {
        passwordTextField.enablesReturnKeyAutomatically = !(usernameTextField.text ?? "").isEmpty
        passwordTextField.returnKeyType = passwordTextField.enablesReturnKeyAutomatically ? .go : .next
    }
    
    @discardableResult private func handle(error: TankUtility.Error?) -> Bool {
        guard error != nil else {
            return false
        }
        contentView.transform = CGAffineTransform(translationX: 32.0, y: 0.0)
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.29, initialSpringVelocity: 1.0, options: [.curveEaseInOut], animations: {
            self.contentView.transform = .identity
        })
        return true
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let contentView: UIView = UIView()
    private let dismissControl: UIControl = UIControl()
    private let deauthorizeControl: DeauthorizeControl = DeauthorizeControl()
    private let authorizeControl: AuthorizeControl = AuthorizeControl()
    private let usernameTextField: UITextField = .username
    private let passwordTextField: UITextField = .password
    
    // MARK: UIView
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentSize: CGSize = CGSize(width: 304.0, height: bounds.size.height - (safeAreaInsets.top + safeAreaInsets.bottom))
        
        authorizeControl.isAuthorized = error == nil && TankUtility.username != nil
        authorizeControl.frame.size.height = authorizeControl.intrinsicContentSize.height
        
        usernameTextField.frame.size.height = usernameTextField.sizeThatFits(contentView.bounds.size).height + 9.0
        usernameTextField.frame.origin.y = authorizeControl.frame.origin.y + authorizeControl.frame.size.height + 14.0
        usernameTextField.isEnabled = !isAuthorized
        
        passwordTextField.frame.size.height = usernameTextField.frame.size.height
        passwordTextField.frame.origin.y = usernameTextField.frame.origin.y + usernameTextField.frame.size.height + 16.0
        passwordTextField.isHidden = isAuthorized
        handleTextDidChange(nil)
        
        deauthorizeControl.isHidden = !isAuthorized
        deauthorizeControl.frame.size.height = deauthorizeControl.intrinsicContentSize.height
        deauthorizeControl.frame.origin.y = passwordTextField.frame.origin.y
        
        contentView.frame.size.width = contentSize.width
        contentView.frame.size.height = passwordTextField.frame.origin.y + passwordTextField.frame.size.height + (authorizeControl.frame.size.height * 3.0)
        contentView.frame.origin.x = (bounds.size.width - contentView.frame.size.width) / 2.0
        contentView.frame.origin.y = safeAreaInsets.top + max((contentSize.height - contentView.frame.size.height) / 2.0, 0.0)
        
        accessibilityElements = isAuthorized ? [
            authorizeControl,
            deauthorizeControl,
            dismissControl
        ] : [
            authorizeControl,
            usernameTextField,
            passwordTextField
        ]
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentView)
        
        dismissControl.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        dismissControl.frame.size = CGSize(width: 1.0, height: 1.0)
        dismissControl.accessibilityTraits = .button
        dismissControl.accessibilityLabel = "Dismiss"
        dismissControl.isAccessibilityElement = true
        contentView.addSubview(dismissControl)
        
        authorizeControl.addTarget(self, action: #selector(handleAuthorize(_:)), for: .touchUpInside)
        authorizeControl.autoresizingMask = [.flexibleWidth]
        authorizeControl.frame.size.width = contentView.bounds.size.width
        contentView.addSubview(authorizeControl)
        
        deauthorizeControl.addTarget(self, action: #selector(handleDeauthorize(_:)), for: .touchUpInside)
        deauthorizeControl.autoresizingMask = [.flexibleWidth]
        deauthorizeControl.frame.size.width = contentView.bounds.size.width
        contentView.addSubview(deauthorizeControl)
        
        usernameTextField.adjustsFontForContentSizeCategory = true
        usernameTextField.font = .preferredFont(forTextStyle: .body)
        usernameTextField.text = TankUtility.username
        usernameTextField.returnKeyType = .next
        usernameTextField.autoresizingMask = [.flexibleWidth]
        usernameTextField.frame.size.width = contentView.bounds.size.width
        usernameTextField.delegate = self
        contentView.addSubview(usernameTextField)
        
        passwordTextField.adjustsFontForContentSizeCategory = true
        passwordTextField.font = .preferredFont(forTextStyle: .body)
        passwordTextField.autoresizingMask = [.flexibleWidth]
        passwordTextField.frame.size.width = contentView.bounds.size.width
        passwordTextField.delegate = self
        contentView.addSubview(passwordTextField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
        default:
            if textField.returnKeyType == .go {
                TankUtility.authorize(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "") { error in
                    guard !self.handle(error: error) else {
                        return
                    }
                    self.authorizeControl.isAuthorized = true
                    self.delegate?.authorizeViewDidAuthorize(self)
                    self.passwordTextField.text = nil
                }
            } else {
                usernameTextField.becomeFirstResponder()
            }
        }
        return false
    }
}
