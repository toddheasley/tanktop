import UIKit

class ErrorViewController: UIViewController {
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = ErrorView()
        view.backgroundColor = .white
    }
}

class ErrorView: UIView {
    private let imageView: UIImageView = UIImageView()
    
    // MARK: UIView
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 120.0, height: 120.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Error")
        imageView.tintColor = .red
        imageView.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleLeftMargin]
        imageView.frame.size = intrinsicContentSize
        imageView.frame.origin.x = (bounds.size.width - imageView.frame.size.width) / 2.0
        imageView.frame.origin.y = (bounds.size.height - imageView.frame.size.height) / 2.0
        addSubview(imageView)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
