import UIKit

class AuthorizeControl: UIControl {
    var isAuthorized: Bool = false {
        didSet {
            guard isAuthorized != oldValue else {
                return
            }
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let label: UILabel = UILabel()
    
    // MARK: UIControl
    override var description: String {
        return "Tanktop \(isAuthorized ? "has" : "needs") permission to access your Tank Utility account"
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
        label.font = .preferredFont(forTextStyle: .body)
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = round(label.font.pointSize * 0.25)
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: description.replacingOccurrences(of: "permission ", with: "permission\n"))
        attributedText.setAttributes([
            .font: UIFont.systemFont(ofSize: label.font.pointSize, weight: .semibold),
            .paragraphStyle: paragraphStyle
        ], range: NSRange(location: 0, length: isAuthorized ? 22 : 24))
        attributedText.setAttributes([
            .foregroundColor: tintColor.withAlphaComponent(isHighlighted ? 0.4 : 1.0) as Any
        ], range: NSRange(location: isAuthorized ? 38 : 40, length: 12))
        label.attributedText = attributedText
        return CGSize(width: bounds.size.width, height: label.sizeThatFits(CGSize(width: bounds.size.width, height: 414.0)).height + (paragraphStyle.lineSpacing * 2.0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame.origin.x = 3.0
        label.frame.size.width = bounds.size.width - (label.frame.origin.x * 2.0)
        label.frame.size.height = intrinsicContentSize.height
        
        accessibilityLabel = description
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.isUserInteractionEnabled = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        addSubview(label)
        
        accessibilityTraits = .link
        accessibilityHint = "Tank Utility website"
        isAccessibilityElement = true
    }
}
