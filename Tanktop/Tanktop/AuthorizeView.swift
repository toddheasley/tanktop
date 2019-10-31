import UIKit
import TankUtility

protocol AuthorizeViewDelegate {
    func authorizeView(_ view: AuthorizeView, didOpen url: URL)
    func authorizeViewDidAuthorize(_ view: AuthorizeView)
}

class AuthorizeView: UIView, UITextFieldDelegate, KeyboardDelegate {
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
    
    var contentInset: UIEdgeInsets = .zero {
        didSet {
            guard contentInset != oldValue else {
                return
            }
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
    private let deauthorizeControl: DeauthorizeControl = DeauthorizeControl()
    private let authorizeControl: AuthorizeControl = AuthorizeControl()
    private let usernameTextField: UITextField = .username
    private let passwordTextField: UITextField = .password
    
    // MARK: UIView
    override var description: String {
        return authorizeControl.description
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let contentSize: CGSize = CGSize(width: min(bounds.size.width - (contentInset.left + contentInset.right), 304.0), height: 414.0)
        
        authorizeControl.isAuthorized = error == nil && TankUtility.username != nil
        authorizeControl.frame.size.height = authorizeControl.intrinsicContentSize.height
        authorizeControl.frame.origin.y = 88.0
        
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
        contentView.frame.size.height = passwordTextField.frame.origin.y + passwordTextField.frame.size.height + authorizeControl.frame.origin.y
        contentView.frame.origin.x = max((bounds.size.width - contentView.frame.size.width) / 2.0, contentInset.left)
        keyboardWillChangeFrame(Keyboard.shared, duration: 0.0)
        
        accessibilityLabel = description
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentView)
        
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
        Keyboard.shared.delegate = self
        
        isAccessibilityElement = true
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
    
    // MARK: KeyboardDelegate
    func keyboardWillChangeFrame(_ keyboard: Keyboard, duration: TimeInterval) {
        let y: CGFloat = safeAreaInsets.top + contentInset.top
        let height: CGFloat = bounds.size.height - (max(safeAreaInsets.bottom * 2.0, keyboard.height) + contentInset.bottom + y)
        UIView.animate(withDuration: duration) {
            self.contentView.frame.origin.y = max((height - self.contentView.frame.size.height) / 2.0, 0.0) + y
        }
    }
}
