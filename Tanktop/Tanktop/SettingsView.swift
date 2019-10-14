import UIKit
import UserNotifications
import WatchConnectivity
import TankUtility

class SettingsView: UIView {
    var device: Device? {
        didSet {
            primaryCell.toggle.isOn = device != nil ? (device?.id == TankUtility.primary) : false
            primaryCell.toggle.isEnabled = device != nil
            alertCell.label.text = "Alert Below \(String(percent: device?.alert.threshold ?? Alert().threshold)!)"
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    switch settings.authorizationStatus {
                    case .authorized, .provisional:
                        self.alertCell.toggle.setOn(self.device?.alert.isEnabled ?? false, animated: true)
                        self.alertCell.toggle.isEnabled = self.primaryCell.toggle.isEnabled
                    case .notDetermined:
                        self.alertCell.toggle.setOn(false, animated: true)
                        self.alertCell.toggle.isEnabled = self.primaryCell.toggle.isEnabled
                    default:
                        self.alertCell.toggle.setOn(false, animated: true)
                        self.alertCell.toggle.isEnabled = false
                    }
                }
            }
        }
    }
    
    var contentOffset: CGPoint = .zero {
        didSet {
            guard let _: Device = device else {
                return
            }
            bounceView.frame.origin.y = min((0.0 - contentOffset.y) * 0.5, 0.0)
            if isOpen, contentOffset.y < -2.0 {
                toggle(open: false, animated: true)
            } else if !isOpen, contentOffset.y > 61.0 {
                toggle(open: true, animated: true)
            }
        }
    }
    
    private(set) var isOpen: Bool = false
    
    func toggle(open: Bool, animated: Bool = false) {
        isOpen = open
        device = device ?? nil
        UIView.animate(withDuration: animated ? 0.2 : 0.0) {
            self.effectView.frame.origin.y = open ? 0.0 : self.bounds.size.height
        }
    }
    
    @objc func handleToggle(_ sender: AnyObject?) {
        switch sender as? UISwitch {
        case primaryCell.toggle:
            TankUtility.primary = primaryCell.toggle.isOn ? device?.id : nil
            try? WCSession.available?.updateApplicationContext(TankUtility.context)
        case alertCell.toggle:
            guard alertCell.toggle.isOn else {
                device?.alert.isEnabled = false
                return
            }
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { granted, error in
                DispatchQueue.main.async {
                    self.device?.alert.isEnabled = granted
                }
            }
        default:
            break
        }
    }
    
    private let bounceView: UIView = UIView()
    private let effectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    private let primaryCell: SettingsCell = SettingsCell()
    private let alertCell: SettingsCell = SettingsCell()
    
    // MARK: UIView
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: 126.0)
    }
    
    override var frame: CGRect {
        set {
            super.frame = CGRect(x: newValue.origin.x, y: newValue.origin.y, width: newValue.size.width, height: max(newValue.size.height, intrinsicContentSize.height))
        }
        get {
            return super.frame
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return isOpen ? super.hitTest(point, with: event) : nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        toggle(open: isOpen)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bounceView.autoresizingMask = [.flexibleWidth]
        bounceView.frame.size.width = bounds.size.width
        bounceView.frame.size.height = intrinsicContentSize.height
        addSubview(bounceView)
        
        effectView.autoresizingMask = [.flexibleWidth]
        effectView.frame.size.width = bounds.size.width
        effectView.frame.size.height = intrinsicContentSize.height * 2.0
        bounceView.addSubview(effectView)
        
        primaryCell.label.text = "Show in Today View"
        primaryCell.toggle.addTarget(self, action: #selector(handleToggle(_:)), for: .valueChanged)
        primaryCell.autoresizingMask = [.flexibleWidth]
        primaryCell.frame.size.width = effectView.bounds.size.width
        primaryCell.frame.size.height = primaryCell.intrinsicContentSize.height
        primaryCell.frame.origin.y = 7.0
        effectView.contentView.addSubview(primaryCell)
        
        alertCell.toggle.addTarget(self, action: #selector(handleToggle(_:)), for: .valueChanged)
        alertCell.autoresizingMask = [.flexibleWidth]
        alertCell.frame.size.width = effectView.bounds.size.width
        alertCell.frame.size.height = alertCell.intrinsicContentSize.height
        alertCell.frame.origin.y = primaryCell.frame.size.height + (primaryCell.frame.origin.y * 2.0)
        effectView.contentView.addSubview(alertCell)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class SettingsCell: UIView {
    let toggle: UISwitch = UISwitch()
    let label: UILabel = UILabel()
    
    // MARK: UIView
    override var intrinsicContentSize: CGSize {
        return CGSize(width: toggle.intrinsicContentSize.width, height: 34.0)
    }
    
    override var frame: CGRect {
        set {
            super.frame = CGRect(x: newValue.origin.x, y: newValue.origin.y, width: newValue.size.width, height: intrinsicContentSize.height)
        }
        get {
            return super.frame
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame.size.width = bounds.size.width - (label.frame.origin.x + toggle.frame.origin.x)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        toggle.tintColor = UIColor.lightGray.withAlphaComponent(0.5)
        toggle.onTintColor = tintColor
        toggle.frame.origin.x = 7.0
        toggle.frame.origin.y = (bounds.size.height - toggle.frame.size.height) / 2.0
        addSubview(toggle)
        
        label.textColor = .darkGray
        label.frame.size.height = toggle.frame.size.height
        label.frame.origin.x = toggle.frame.size.width  + (toggle.frame.origin.x * 3.0)
        label.frame.origin.y = toggle.frame.origin.y
        addSubview(label)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
