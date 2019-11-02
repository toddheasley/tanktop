import UIKit

class PageAccessoryControl: UIControl {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView: UIImageView = UIImageView(image: UIImage(systemName: "ellipsis.circle"))
    
    // MARK: UIControl
    override var description: String {
        return ""
    }
    
    override var isHighlighted: Bool {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.alpha = isHighlighted ? 0.4 : 1.0
        imageView.frame.size.width = min(bounds.size.width, imageView.frame.size.height)
        imageView.frame.origin.x = (bounds.size.width - imageView.frame.size.width) / 2.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.tertiaryLabel.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        imageView.autoresizingMask = [.flexibleHeight]
        imageView.frame.size.height = bounds.size.height
        addSubview(imageView)
        
        accessibilityLabel = description
        accessibilityTraits = .button
        isAccessibilityElement = true
    }
}

