import UIKit
import TankUtility

class DragControl: UIControl {
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
    override var frame: CGRect {
        set {
            super.frame = CGRect(x: newValue.origin.x, y: newValue.origin.y, width: newValue.size.width, height: intrinsicContentSize.height)
        }
        get {
            return super.frame
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: 44.0)
    }
    
    override var isHighlighted: Bool {
        didSet {
            label.isHidden = !isHighlighted
        }
    }
    
    override var isEnabled: Bool {
        set {
            super.isEnabled = newValue
            dragIndicator.isHidden = !newValue
        }
        get {
            return super.isEnabled
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame.size.width = bounds.size.width - 16.0
        label.frame.origin.x = (bounds.size.width - label.frame.size.width) / 2.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dragIndicator.backgroundColor = .tertiaryLabel
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
}
