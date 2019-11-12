import UIKit
import SafariServices
import TankUtility

class AuthorizeViewController: UIViewController, AuthorizeViewDelegate {
    required init(error: TankUtility.Error? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        authorizeView.delegate = self
        authorizeView.error = error
        
        isModalInPresentation = !authorizeView.isAuthorized
        modalPresentationStyle = .formSheet
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let authorizeView: AuthorizeView = AuthorizeView()
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        authorizeView.contentInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        authorizeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        authorizeView.frame = view.bounds
        view.addSubview(authorizeView)
    }
    
    // MARK: AuthorizeViewDelegate
    func authorizeView(_ view: AuthorizeView, didOpen url: URL) {
        present(SFSafariViewController(url: url), animated: true, completion: nil)
    }
    
    func authorizeViewDidAuthorize(_ view: AuthorizeView) {
        isModalInPresentation = !view.isAuthorized
        if view.isAuthorized {
            mainViewController?.refresh()
            dismiss(animated: true, completion: nil)
        } else {
            mainViewController?.reset()
        }
    }
    
    func authorizeViewDidDismiss(_view: AuthorizeView) {
        dismiss(animated: true, completion: nil)
    }
}
