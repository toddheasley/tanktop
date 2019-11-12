import UIKit

class DeauthorizeControl: UIControl {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let label: UILabel = UILabel()
    
    // MARK: UIControl
    override var description: String {
        return "Revoke access"
    }
    
    override var isHighlighted: Bool {
        didSet {
            guard isHighlighted != oldValue else {
                return
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.size.width, height: label.sizeThatFits(CGSize(width: bounds.size.width, height: 414.0)).height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.textColor = tintColor.withAlphaComponent(isHighlighted ? 0.4 : 1.0)
        label.frame.origin.x = 3.0
        label.frame.size.width = bounds.size.width - (label.frame.origin.x * 2.0)
        label.frame.size.height = max(bounds.size.height, intrinsicContentSize.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.isUserInteractionEnabled = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .body)
        label.text = description
        label.numberOfLines = 0
        addSubview(label)
        
        accessibilityTraits = .button
        accessibilityLabel = description
        isAccessibilityElement = true
    }
}
