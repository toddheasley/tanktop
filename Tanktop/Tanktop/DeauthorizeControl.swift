import UIKit

class DeauthorizeControl: UIControl {
    private let imageView: UIImageView = UIImageView()
    
    // MARK: UIControl
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 26.0, height: 26.0)
    }
    
    override var isHighlighted: Bool {
        set {
            super.isHighlighted = newValue
            imageView.tintColor = isHighlighted ? tintColor : .darkGray
        }
        get {
            return super.isHighlighted
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Deauthorize")
        imageView.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleLeftMargin]
        imageView.frame.size = intrinsicContentSize
        imageView.frame.origin.x = (bounds.size.width - imageView.frame.size.width) / 2.0
        imageView.frame.origin.y = (bounds.size.height - imageView.frame.size.height) / 2.0
        addSubview(imageView)
        
        isHighlighted = false
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
