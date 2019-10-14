import UIKit

class RefreshControl: UIControl {
    var contentOffset: CGPoint = .zero {
        didSet {
            let offset: CGFloat = max((0.0 - contentOffset.y) * 0.5, 0.0)
            contentView.frame.size.height = max(bounds.size.height + offset, isRefreshing ? bounds.size.height + progressView.intrinsicContentSize.height : 0.0)
            
            progressView.isHidden = !progressView.isWaiting && contentView.frame.size.height < (bounds.size.height + 4.0)
            progressView.progress = min(offset * 0.02, 1.0)
            
            //(UIApplication.shared.delegate?.window??.rootViewController as? MainViewController)?.pageBar.alpha = progressView.isWaiting ? 0.0 : 1.0 - (progressView.progress * 2.5)
        }
    }
    
    private(set) var isRefreshing: Bool = false
    
    func beginRefreshing(force: Bool = true) {
        guard !isRefreshing, force || progressView.progress == 1.0 else {
            return
        }
        isRefreshing = true
        progressView.isWaiting = true
        sendActions(for: .valueChanged)
    }
    
    func endRefreshing() {
        isRefreshing = false
        UIView.animate(withDuration: 0.25, animations: {
            self.contentOffset.y = 0.0
        }, completion: { _ in
            self.progressView.isWaiting = false
            self.contentOffset.y = self.contentOffset.y
        })
    }
    
    private let contentView: UIView = UIView()
    private let progressView: RefreshProgressView = RefreshProgressView()
    
    // MARK: UIControl
    override var intrinsicContentSize: CGSize {
        return progressView.intrinsicContentSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        progressView.frame.size.width = bounds.size.width
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.autoresizingMask = [.flexibleHeight]
        contentView.frame.size = bounds.size
        addSubview(contentView)
        
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.frame.size.width = bounds.size.width
        progressView.frame.origin.y = bounds.size.height - progressView.frame.size.height
        progressView.isHidden = true
        contentView.addSubview(progressView)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class RefreshProgressView: UIView {
    var progress: CGFloat{
        set {
            guard !isWaiting else {
                return
            }
            progressView.frame.size.width = intrinsicContentSize.width  * newValue
        }
        get {
            return min(max(progressView.frame.size.width / contentView.frame.size.width, 0.0), 1.0)
        }
    }
    
    var isWaiting: Bool = false {
        didSet {
            progress = max(progress, 0.0)
            isWaiting ? waitingView.startAnimating() : waitingView.stopAnimating()
            waitingView.isHidden = !isWaiting
        }
    }
    
    private let contentView: UIView = UIView()
    private let progressView: UIView = UIView()
    private let waitingView: UIImageView = UIImageView()
    
    // MARK: UIView
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 108.0, height: 46.0)
    }
    
    override var frame: CGRect {
        set {
            super.frame = CGRect(x: newValue.origin.x, y: newValue.origin.y, width: max(newValue.size.width, intrinsicContentSize.width), height: intrinsicContentSize.height)
        }
        get {
            return super.frame
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .lightGray
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 3.0
        contentView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        contentView.frame.size.width = intrinsicContentSize.width
        contentView.frame.size.height = 6.0
        contentView.frame.origin.y = (bounds.size.height - contentView.frame.size.height) / 2.0
        addSubview(contentView)
        
        progressView.backgroundColor = tintColor
        progressView.frame.size.height = contentView.bounds.size.height
        contentView.addSubview(progressView)
        
        waitingView.contentMode = .scaleAspectFill
        waitingView.tintColor = .white
        waitingView.animationDuration = 0.15
        waitingView.animationImages = [
            UIImage(named: "Progress1")!,
            UIImage(named: "Progress2")!,
            UIImage(named: "Progress3")!
        ]
        waitingView.frame = contentView.bounds
        waitingView.alpha = 0.5
        waitingView.isHidden = true
        contentView.addSubview(waitingView)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
