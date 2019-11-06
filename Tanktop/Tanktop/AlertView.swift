import UIKit
import TankUtility

protocol AlertDelegate {
    func alertDidChange(_ alert: Alert)
}

class AlertView: UIView {
    var delegate: AlertDelegate?
    
    var alert: Alert? {
        didSet {
            alertControl.isHidden = alert == nil
            alertControl.frame.origin.y = (bounds.size.height - (bounds.size.height * CGFloat(alert?.threshold ?? Alert().threshold))) - (alertControl.frame.size.height / 2.0)
            
            print("\(String(percent: alert?.threshold) ?? "nil")")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func handleDrag(_ control: AlertControl, event: UIEvent) {
        guard let touch: UITouch = event.touches(for: control)?.first else {
            return
        }
        
        let y: CGFloat = alertControl.frame.origin.y + (alertControl.frame.size.height / 2.0) + (touch.location(in: control).y - touch.previousLocation(in: control).y)
        alert?.threshold = Double((bounds.size.height - y) / bounds.size.height)
    }
    
    @objc fileprivate func handleDragEnd() {
        guard let alert: Alert = alert else {
            return
        }
        delegate?.alertDidChange(alert)
    }
    
    private let alertControl: AlertControl = AlertControl()
    
    // MARK: UIView
    override func layoutSubviews() {
        super.layoutSubviews()
        
        alert?.threshold = alert?.threshold ?? 0.0
        
        alertControl.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alertControl.addTarget(self, action: #selector(handleDrag(_:event:)), for: .touchDragInside)
        alertControl.addTarget(self, action: #selector(handleDragEnd), for: .touchUpInside)
        alertControl.autoresizingMask = [.flexibleWidth]
        alertControl.frame.size.width = bounds.size.width
        addSubview(alertControl)
    }
}

fileprivate class AlertControl: UIControl {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIControl
    override var intrinsicContentSize: CGSize {
        return CGSize(width: -1.0, height: 44.0)
    }
    
    override var frame: CGRect {
        set {
            super.frame = CGRect(x: newValue.origin.x, y: newValue.origin.y, width: newValue.size.width, height: intrinsicContentSize.height)
        }
        get {
            return super.frame
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
}

/*


    var threshold: Double? {
        didSet {
            label.text = String(percent: threshold)
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let dragIndicator: UIView = UIView()
    private let separator: UIView = UIView()
    private let label: UILabel = UILabel()
    
    // MARK: UIControl
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: 44.0)
    }
    
    override var frame: CGRect {
        set {
            super.frame = CGRect(x: newValue.origin.x, y: newValue.origin.y, width: newValue.size.width, height: intrinsicContentSize.height)
        }
        get {
            return super.frame
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            label.isHidden = !isHighlighted
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dragIndicator.isHidden = !isEnabled
        
        label.frame.size.width = bounds.size.width - 16.0
        label.frame.origin.x = (bounds.size.width - label.frame.size.width) / 2.0
        
        backgroundColor = UIColor.systemTeal.withAlphaComponent(0.5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dragIndicator.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
        dragIndicator.isUserInteractionEnabled = false
        dragIndicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        dragIndicator.frame.size.width = 68.0
        dragIndicator.frame.size.height = 5.0
        dragIndicator.frame.origin.x = (bounds.size.width - dragIndicator.frame.size.width) / 2.0
        dragIndicator.frame.origin.y = 10.0
        dragIndicator.layer.cornerRadius = dragIndicator.frame.size.height / 2.0
        addSubview(dragIndicator)
        
        separator.backgroundColor = .systemRed
        separator.isUserInteractionEnabled = false
        separator.autoresizingMask = [.flexibleWidth]
        separator.frame.size.width = bounds.size.width
        separator.frame.size.height = 2.5
        addSubview(separator)
        
        label.font = .monospacedDigitSystemFont(ofSize: label.font.pointSize, weight: .semibold)
        label.textColor = separator.backgroundColor
        label.textAlignment = .right
        label.isUserInteractionEnabled = false
        label.autoresizingMask = [.flexibleHeight]
        label.frame.size.height = bounds.size.height
        label.frame.origin.y = -6.0
        label.isHidden = true
        addSubview(label)
    }
} */
