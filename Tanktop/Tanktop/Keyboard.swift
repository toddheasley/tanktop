import UIKit

@objc protocol KeyboardDelegate {
    @objc optional func keyboardWillChangeFrame(_ keyboard: Keyboard, duration: TimeInterval)
    @objc optional func keyboardDidChangeFrame(_ keyboard: Keyboard)
}

class Keyboard: NSObject {
    static let shared: Keyboard = Keyboard()
    private(set) var frame: CGRect = .zero
    
    var bounds: CGRect {
        return CGRect(origin: .zero, size: frame.size)
    }
    
    var height: CGFloat {
        return isHidden ? 0.0 : frame.size.height
    }
    
    var isHidden: Bool {
        guard let window: UIWindow = UIApplication.shared.windows.first else {
            return true
        }
        return frame.origin.y >= window.bounds.size.height
    }
    
    var delegate: KeyboardDelegate? {
        didSet {
            NotificationCenter.default.removeObserver(self)
            guard delegate != nil else {
                return
            }
            NotificationCenter.default.addObserver(self, selector: #selector(handleWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleDidChangeFrame(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        }
    }
    
    @objc func handleWillChangeFrame(_ notification: Notification) {
        guard let userInfo: [String: Any] = notification.userInfo as? [String: Any],
            let frame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let newFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration: TimeInterval = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? TimeInterval else {
            return
        }
        self.frame = frame
        let keyboard = Keyboard()
        keyboard.frame = newFrame
        delegate?.keyboardWillChangeFrame?(keyboard, duration: duration)
    }
    
    @objc func handleDidChangeFrame(_ notification: Notification) {
        guard let userInfo: [String: Any] = notification.userInfo as? [String: Any],
            let frame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        self.frame = frame
        delegate?.keyboardDidChangeFrame?(self)
    }
}
