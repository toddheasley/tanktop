import UIKit

protocol PageBarDelegate {
    func pageDidChange(bar: PageBar)
    func pageBarDidDeauthorize()
}

class PageBar: UIView {
    var delegate: PageBarDelegate?
    
    var numberOfPages: Int {
        set {
            pageControl.numberOfPages = newValue
        }
        get {
            return pageControl.numberOfPages
        }
    }
    
    var currentPage: Int {
        set {
            pageControl.currentPage = newValue
        }
        get {
            return pageControl.currentPage
        }
    }
    
    @objc func handlePage(_ sender: AnyObject?) {
        delegate?.pageDidChange(bar: self)
    }
    
    @objc func handleDeauthorize(_ sender: AnyObject?) {
        delegate?.pageBarDidDeauthorize()
    }
    
    private let pageControl: UIPageControl = UIPageControl()
    private let deauthorizeControl: DeauthorizeControl = DeauthorizeControl()
    
    // MARK: UIView
    override var intrinsicContentSize: CGSize {
        return pageControl.intrinsicContentSize
    }
    
    override var alpha: CGFloat {
        set {
            pageControl.alpha = newValue
        }
        get {
            return pageControl.alpha
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pageControl.frame.size.width = bounds.size.width - (pageControl.frame.origin.x * 2.0)
        pageControl.frame.size.height = bounds.size.height - pageControl.frame.origin.y
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .darkGray
        pageControl.hidesForSinglePage = true
        pageControl.addTarget(self, action: #selector(handlePage(_:)), for: .valueChanged)
        pageControl.frame.origin.x = 44.0
        pageControl.frame.origin.y = 1.0
        addSubview(pageControl)
        
        deauthorizeControl.addTarget(self, action: #selector(handleDeauthorize(_:)), for: .touchUpInside)
        deauthorizeControl.frame.size = CGSize(width: 38.0, height: 44.0)
        addSubview(deauthorizeControl)
        
        super.alpha = 1.0
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
