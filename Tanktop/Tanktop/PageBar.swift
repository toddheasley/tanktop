import UIKit

protocol PageBarDelegate {
    func pageDidChange(bar: PageBar)
    func pageAccessoryDidOpen()
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
    
    @objc func handlePage(_ control: UIPageControl?) {
        delegate?.pageDidChange(bar: self)
    }
    
    @objc func handleAccessory(_ control: PageAccessoryControl?) {
        delegate?.pageAccessoryDidOpen()
    }
    
    private let pageControl: UIPageControl = UIPageControl()
    private let accessoryControl: PageAccessoryControl = PageAccessoryControl()
    
    // MARK: UIView
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: 37.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pageControl.frame.size.width = bounds.size.width - (pageControl.frame.origin.x * 2.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pageControl.pageIndicatorTintColor = UIColor.tertiaryLabel.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        pageControl.currentPageIndicatorTintColor = UIColor.secondaryLabel.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
        pageControl.hidesForSinglePage = true
        pageControl.addTarget(self, action: #selector(handlePage(_:)), for: .valueChanged)
        pageControl.autoresizingMask = [.flexibleHeight]
        pageControl.frame.size.height = bounds.size.height
        pageControl.frame.origin.x = 72.0
        addSubview(pageControl)
        
        #if !targetEnvironment(macCatalyst)
        accessoryControl.addTarget(self, action: #selector(handleAccessory(_:)), for: .touchUpInside)
        accessoryControl.autoresizingMask = [.flexibleHeight]
        accessoryControl.frame.size.width = pageControl.frame.origin.x
        accessoryControl.frame.size.height = bounds.size.height
        addSubview(accessoryControl)
        #endif
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
