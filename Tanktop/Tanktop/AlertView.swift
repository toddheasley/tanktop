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
            alertControl.threshold = alert?.threshold
            
            accessibilityLabel = "Alert when tank level is below"
            accessibilityValue = String(percent: alert?.threshold)
            isAccessibilityElement = !isHidden
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
        setNeedsLayout()
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
        
        guard let alert: Alert = alert else {
            return
        }
        delegate?.alertDidChange(alert)
    }
    
    private let alertControl: AlertControl = AlertControl()
    
    // MARK: UIView
    override func accessibilityIncrement() {
        guard var alert: Alert = alert else {
            return
        }
        alert.threshold = (Double(lround(alert.threshold * 20.0)) / 20.0) + 0.05
        delegate?.alertDidChange(alert)
    }
    
    override func accessibilityDecrement() {
        guard var alert: Alert = alert else {
            return
        }
        alert.threshold = (Double(lround(alert.threshold * 20.0)) / 20.0) - 0.05
        delegate?.alertDidChange(alert)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        alert?.threshold = Double(lround((alert?.threshold ?? 0.0) * 100.0)) / 100.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alertControl.addTarget(self, action: #selector(handleDrag(_:event:)), for: .touchDragInside)
        alertControl.addTarget(self, action: #selector(handleDragEnd), for: .touchUpInside)
        alertControl.addTarget(self, action: #selector(handleDragEnd), for: .touchDragExit)
        alertControl.autoresizingMask = [.flexibleWidth]
        alertControl.frame.size.width = bounds.size.width
        addSubview(alertControl)
        
        accessibilityTraits = .adjustable
    }
}

fileprivate class AlertControl: UIControl {
    var threshold: Double? {
        didSet {
            label.text = String(percent: threshold)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let separator: UIView = UIView()
    private let dragIndicator: UIView = UIView()
    private let label: UILabel = UILabel()
    
    // MARK: UIControl
    override var isHighlighted: Bool {
        didSet {
            label.isHidden = !isHighlighted
        }
    }
    
    override var intrinsicContentSize: CGSize {
        #if targetEnvironment(macCatalyst)
        return CGSize(width: -1.0, height: 132.0)
        #else
        return CGSize(width: -1.0, height: 44.0)
        #endif
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
        
        dragIndicator.frame.origin.y = (separator.frame.origin.y + separator.frame.size.height) + 8.0
        
        label.frame.origin.x = 6.0
        label.frame.size.width = bounds.size.width - (label.frame.origin.x * 2.0)
        label.frame.origin.y = separator.frame.origin.y - label.frame.size.height
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        separator.isUserInteractionEnabled = false
        separator.backgroundColor = .systemRed
        separator.autoresizingMask = [.flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin]
        separator.frame.size.width = bounds.size.width
        separator.frame.size.height = 3.0
        separator.frame.origin.y = (bounds.size.height - separator.frame.size.height) / 2.0
        addSubview(separator)
        
        dragIndicator.isUserInteractionEnabled = false
        dragIndicator.backgroundColor = UIColor.gray.withAlphaComponent(0.38)
        dragIndicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        dragIndicator.frame.size.width = 68.0
        dragIndicator.frame.size.height = 5.0
        dragIndicator.frame.origin.x = (bounds.size.width - dragIndicator.frame.size.width) / 2.0
        dragIndicator.layer.cornerCurve = .continuous
        dragIndicator.layer.cornerRadius = dragIndicator.frame.size.height / 2.0
        addSubview(dragIndicator)
        
        label.isUserInteractionEnabled = false
        label.font = .monospacedDigitSystemFont(ofSize: 32.0, weight: .semibold)
        label.textColor = .systemRed
        label.textAlignment = .right
        label.frame.size.height = 37.0
        label.isHidden = true
        addSubview(label)
    }
}
