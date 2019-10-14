import UIKit

class AuthorizeControl: UIControl {
    private let label: UILabel = UILabel()
    
    // MARK: UIControl
    override var isHighlighted: Bool {
        set {
            super.isHighlighted = newValue
            
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5.0
            let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: "Tanktop needs permission\nto access your Tank Utility account")
            attributedText.setAttributes([
                .font: UIFont.systemFont(ofSize: label.font.pointSize, weight: .semibold),
                .paragraphStyle: paragraphStyle
            ], range: NSRange(location: 0, length: 24))
            attributedText.setAttributes([
                .foregroundColor: tintColor.withAlphaComponent(isHighlighted ? 0.25 : 1.0) as Any
            ], range: NSRange(location: 40, length: 12))
            label.attributedText = attributedText
        }
        get {
            return super.isHighlighted
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0.0, height: 54.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.frame = bounds
        label.textColor = .darkGray
        label.numberOfLines = 0
        addSubview(label)
        
        isHighlighted = false
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
