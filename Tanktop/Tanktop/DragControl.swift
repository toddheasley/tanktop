import UIKit
import TankUtility

class DragControl: UIControl {
    var threshold: Double? {
        didSet {
            label.text = String(percent: threshold)
        }
    }
    
    private let dragIndicator: UIView = UIView()
    private let separator: UIView = UIView()
    private let label: UILabel = UILabel()
    
    // MARK: UIControl
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 68.0, height: 5.0)
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
        
        dragIndicator.frame.origin.x = (bounds.size.width - dragIndicator.frame.size.width) / 2.0
        dragIndicator.frame.origin.y = (bounds.size.height - dragIndicator.frame.size.height) / 2.0
        
        separator.frame.origin.y = dragIndicator.frame.origin.y - 11.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dragIndicator.backgroundColor = UIColor.darkGray.withAlphaComponent(0.35)
        dragIndicator.isUserInteractionEnabled = false
        dragIndicator.layer.cornerRadius = intrinsicContentSize.height / 2.0
        dragIndicator.frame.size = intrinsicContentSize
        addSubview(dragIndicator)
        
        separator.backgroundColor = .red
        separator.isUserInteractionEnabled = false
        separator.autoresizingMask = [.flexibleWidth]
        separator.frame.size.width = bounds.size.width
        separator.frame.size.height = 3.0
        addSubview(separator)
        
        label.font = .monospacedDigitSystemFont(ofSize: 17.0, weight: .semibold)
        label.textColor = .red
        label.textAlignment = .right
        label.isUserInteractionEnabled = false
        label.autoresizingMask = [.flexibleLeftMargin]
        label.frame.size.width = 96.0
        label.frame.size.height = 32.0
        label.frame.origin.x = bounds.size.width - (label.frame.size.width + 6.0)
        label.isHidden = true
        addSubview(label)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
