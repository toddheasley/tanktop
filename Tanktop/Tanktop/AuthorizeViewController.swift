import UIKit
import WatchConnectivity
import SafariServices
import TankUtility

protocol AuthorizeViewDelegate {
    func viewDidAuthorize()
}

class AuthorizeViewController: UIViewController, TextFieldDelegate, KeyboardDelegate {
    var delegate: AuthorizeViewDelegate?
    
    @objc func handleAuthorize(_ control: AuthorizeControl?) {
        present(SFSafariViewController(url: URL(string: "https://tankutility.com")!), animated: true, completion: nil)
    }
    
    convenience init(delegate: AuthorizeViewDelegate) {
        self.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    private let contentView: UIView = UIView()
    private let authorizeControl: AuthorizeControl = AuthorizeControl()
    private let usernameTextField: TextField = TextField(input: .username)
    private let passwordTextField: TextField = TextField(input: .password)
    
    private func handle(error: TankUtility.Error?) {
        contentView.transform = CGAffineTransform(translationX: 32.0, y: 0.0)
        UIView.animate(withDuration: 0.37, delay: 0.0, usingSpringWithDamping: 0.29, initialSpringVelocity: 1.0, options: [.curveEaseInOut], animations: {
            self.contentView.transform = .identity
        })
    }
    
    // MARK: UIViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Keyboard.shared.delegate = self
        
        usernameTextField.text = TankUtility.username ?? ""
        TankUtility.deauthorize()
        try? WCSession.available?.updateApplicationContext(TankUtility.context)
        if let _: String = TankUtility.username {
            passwordTextField.isEditing = true
        } else {
            usernameTextField.isEditing = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Keyboard.shared.delegate = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentView.frame.size.height = passwordTextField.frame.origin.y + passwordTextField.frame.size.height
        keyboardWillChange(to: Keyboard.shared, duration: 0.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        contentView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        contentView.frame.size.width = 290.0
        contentView.frame.origin.x = (view.bounds.size.width - contentView.frame.size.width) / 2.0
        view.addSubview(contentView)
        
        authorizeControl.addTarget(self, action: #selector(handleAuthorize(_:)), for: .touchUpInside)
        authorizeControl.frame.size.width = contentView.bounds.size.width
        authorizeControl.frame.size.height = authorizeControl.intrinsicContentSize.height + 16.0
        contentView.addSubview(authorizeControl)
        
        usernameTextField.frame.size.width = contentView.bounds.size.width
        usernameTextField.frame.size.height = 49.0
        usernameTextField.frame.origin.y = authorizeControl.frame.size.height + 16.0
        usernameTextField.delegate = self
        contentView.addSubview(usernameTextField)
        
        passwordTextField.frame.size = usernameTextField.frame.size
        passwordTextField.frame.origin.y = (usernameTextField.frame.origin.y + usernameTextField.frame.size.height) + 16.0
        passwordTextField.delegate = self
        contentView.addSubview(passwordTextField)
    }
    
    // MARK: TextFieldDelegate
    func textDidChange(field: TextField) {
        passwordTextField.returnKeyType = !usernameTextField.text.isEmpty && !passwordTextField.text.isEmpty ? .go : .default
    }
    
    func textDidReturn(field: TextField) {
        switch field.inputType {
        case .username:
            passwordTextField.isEditing = true
        case .password:
            switch passwordTextField.returnKeyType {
            case .go:
                TankUtility.authorize(username: usernameTextField.text, password: passwordTextField.text) { error in
                    if let error: TankUtility.Error = error {
                        self.handle(error: error)
                    } else {
                        self.usernameTextField.isEditing = false
                        self.passwordTextField.isEditing = false
                        self.delegate?.viewDidAuthorize()
                    }
                    //try? WCSession.available?.updateApplicationContext(TankUtility.context)
                }
            default:
                usernameTextField.isEditing = true
            }
        }
    }
    
    // MARK: KeyboardDelegate
    func keyboardWillChange(to keyboard: Keyboard, duration: TimeInterval) {
        let height: CGFloat = view.bounds.size.height - (keyboard.frame.size.height / 1.4)
        UIView.animate(withDuration: duration) {
            self.contentView.frame.origin.y = (height - self.contentView.frame.size.height) / 2.0
        }
    }
    
    func keyboardDidChange(_ keyboard: Keyboard) {
        
    }
}
