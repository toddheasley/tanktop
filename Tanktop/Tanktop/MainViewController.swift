import UIKit
import TankUtility

class MainViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, PageBarDelegate, AuthorizeViewDelegate {
    func open(device id: String? = nil) {
        guard let id: String = id, devices.contains(id) else {
            return
        }
        current = id
        viewDidAuthorize()
    }
    
    let pageBar: PageBar = PageBar()
    private let pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private var current: String?
    
    private var devices: [String] = [] {
        didSet {
            pageBar.numberOfPages = devices.count
            if let index: Int = index {
                pageViewController.setViewControllers([DeviceViewController(id: devices[index])], direction: .forward, animated: false, completion: nil)
                pageBar.currentPage = index
            } else {
                pageViewController.setViewControllers([EmptyViewController()], direction: .reverse, animated: false, completion: nil)
            }
        }
    }
    
    private var index: Int? {
        for (index, device) in devices.enumerated() {
            guard device == current else {
                continue
            }
            return index
        }
        current = devices.first
        return current != nil ? 0 : nil
    }
    
    // MARK: UIViewController
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewDidAuthorize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pageBar.frame.origin.y = view.safeAreaInsets.top
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.willMove(toParent: self)
        addChild(pageViewController)
        pageViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pageViewController.view.frame = view.bounds
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageBar.autoresizingMask = [.flexibleWidth]
        pageBar.frame.size.width = view.bounds.size.width
        pageBar.frame.size.height = 44.0
        pageBar.delegate = self
        view.addSubview(pageBar)
    }
    
    // MARK: UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index: Int = index, index - 1 >= 0 else {
            return nil
        }
        return DeviceViewController(id: devices[index - 1])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index: Int = index, index + 1 < devices.count else {
            return nil
        }
        return DeviceViewController(id: devices[index + 1])
    }
    
    // MARK: UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        current = (pageViewController.viewControllers?.first as? DeviceViewController)?.id
        pageBar.currentPage = index ?? 0
    }
    
    // MARK: PageBarDelegate
    func pageDidChange(bar: PageBar) {
        guard let index: Int = index, bar.currentPage != index else {
                return
        }
        current = devices[bar.currentPage]
        pageViewController.setViewControllers([DeviceViewController(id: current!)], direction: bar.currentPage < index ? .reverse : .forward, animated: true, completion: nil)
    }
    
    func pageBarDidDeauthorize() {
        TankUtility.deauthorize()
        self.present(AuthorizeViewController(delegate: self), animated: true) {
            self.devices = []
        }
    }
    
    // MARK: AuthorizeViewDelegate
    func viewDidAuthorize() {
        guard presentedViewController == nil else {
            dismiss(animated: true, completion: nil)
            return
        }
        TankUtility.devices { devices, error in
            guard let error: TankUtility.Error = error else {
                self.devices = devices
                return
            }
            switch error {
            case .unauthorized:
                self.present(AuthorizeViewController(delegate: self), animated: true) {
                    self.devices = []
                }
            default:
                self.devices = []
                self.pageViewController.setViewControllers([ErrorViewController()], direction: .reverse, animated: false, completion: nil)
            }
        }
    }
}
