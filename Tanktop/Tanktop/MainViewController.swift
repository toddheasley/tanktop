import UIKit
import TankUtility

class MainViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, PageBarDelegate {
    @IBAction func toggleAuthorizeView() {
        if let presentedViewController: UIViewController = presentedViewController {
            guard !presentedViewController.isModalInPresentation else {
                return
            }
            dismiss(animated: true, completion: nil)
        } else {
            present(AuthorizeViewController(), animated: true, completion: nil)
        }
    }
    
    @IBAction func refresh() {
        TankUtility.devices { devices, error in
            guard !self.handle(error: error),
                let devices: [Device] = devices else {
                return
            }
            self.devices = devices
        }
    }
    
    func open(device id: String? = nil) {
        
    }
    
    func reset() {
        devices = []
    }
    
    private let emptyLabel: UILabel = .empty(text: "No devices")
    private let pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    private let pageBar: PageBar = PageBar()
    
    private var devices: [Device] = [] {
        didSet {
            pageBar.numberOfPages = devices.count
            if let index: Int = index {
                if let deviceViewController: DeviceViewController = pageViewController.viewControllers?.first as? DeviceViewController, deviceViewController.device == devices[index] {
                    deviceViewController.device = devices[index]
                } else {
                    pageViewController.setViewControllers([
                        DeviceViewController(device: devices[index])
                    ], direction: .forward, animated: false, completion: nil)
                }
                pageBar.currentPage = index
            } else {
                pageViewController.setViewControllers([
                    UIViewController()
                ], direction: .reverse, animated: false, completion: nil)
            }
        }
    }
    
    private var index: Int? {
        for (index, device) in devices.enumerated() {
            guard device.isCurrent else {
                continue
            }
            return index
        }
        return !devices.isEmpty ? 0 : nil
    }
    
    // MARK: UIViewController
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emptyLabel.frame.size.width = round(view.bounds.size.width * 0.8)
        emptyLabel.frame.origin.x = (view.bounds.size.width - emptyLabel.frame.size.width) / 2.0
        
        pageBar.frame.origin.y = view.bounds.size.height - (pageBar.frame.size.height + view.safeAreaInsets.bottom)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        emptyLabel.isUserInteractionEnabled = false
        emptyLabel.autoresizingMask = [.flexibleHeight]
        emptyLabel.frame.size.height = view.bounds.size.height
        view.addSubview(emptyLabel)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.willMove(toParent: self)
        addChild(pageViewController)
        pageViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pageViewController.view.frame = view.bounds
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageBar.delegate = self
        pageBar.autoresizingMask = [.flexibleWidth]
        pageBar.frame.size.width = view.bounds.size.width
        pageBar.frame.size.height = pageBar.intrinsicContentSize.height
        view.addSubview(pageBar)
    }
    
    // MARK: UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index: Int = index, index > 0 else {
            return nil
        }
        return DeviceViewController(device: devices[index - 1])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index: Int = index, index + 1 < devices.count else {
            return nil
        }
        return DeviceViewController(device: devices[index + 1])
    }
    
    // MARK: UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard var device: Device = (pageViewController.viewControllers?.first as? DeviceViewController)?.device else {
            return
        }
        device.isCurrent = true        
        pageBar.currentPage = index ?? 0
    }
    
    // MARK: PageBarDelegate
    func pageDidChange(bar: PageBar) {
        guard let index: Int = index, bar.currentPage != index else {
            return
        }
        var device: Device = devices[bar.currentPage]
        pageViewController.setViewControllers([DeviceViewController(device: devices[bar.currentPage])], direction: bar.currentPage < index ? .reverse : .forward, animated: true) { _ in
            device.isCurrent = true
        }
    }
    
    func pageAccessoryDidOpen() {
        toggleAuthorizeView()
    }
}
