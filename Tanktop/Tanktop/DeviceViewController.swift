import UIKit
import TankUtility

class DeviceViewController: UIViewController, UIScrollViewDelegate {
    var device: Device? {
        set {
            deviceView.device = newValue
        }
        get {
            return deviceView.device
        }
    }
    
    @objc func handleRefresh(_ control: RefreshControl? = nil) {
        TankUtility.device(id: device?.id ?? "") { device, finished, error in
            if finished {
                control?.endRefreshing()
            }
            self.deviceView.device = device ?? self.device
        }
    }
    
    required init(device: Device? = nil) {
        super.init(nibName: nil, bundle: nil)
        deviceView.device = device
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView: UIScrollView = UIScrollView()
    private let deviceView: DeviceView = DeviceView()
    private let refreshControl: RefreshControl = RefreshControl()
    
    // MARK: UIViewController
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        refreshControl.frame.size.height = view.safeAreaInsets.top
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        scrollView.contentInsetAdjustmentBehavior = .never
        #if !targetEnvironment(macCatalyst)
        scrollView.alwaysBounceVertical = true
        #endif
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.frame = view.bounds
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        #if targetEnvironment(macCatalyst)
        deviceView.contentInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 37.0, right: 8.0)
        #else
        deviceView.contentInset = UIEdgeInsets(top: 16.0, left: 8.0, bottom: 37.0, right: 8.0)
        #endif
        deviceView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        deviceView.frame = view.bounds
        scrollView.addSubview(deviceView)
        
        #if !targetEnvironment(macCatalyst)
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.autoresizingMask = [.flexibleWidth]
        refreshControl.frame.size.width = view.bounds.size.width
        view.addSubview(refreshControl)
        #endif
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshControl.contentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshControl.beginRefreshing(force: false)
    }
}
