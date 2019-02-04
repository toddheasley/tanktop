import UIKit
import TankUtility

class DeviceViewController: UIViewController, UIScrollViewDelegate {
    private(set) var id: String!
    
    @objc func handleRefresh() {
        errorView.isHidden = true
        TankUtility.device(id: id) { device, error in
            self.refreshControl.endRefreshing()
            self.settingsView.device = device ?? self.settingsView.device
            self.deviceView.device = device ?? self.deviceView.device
            self.errorView.isHidden = error == nil
        }
    }
    
    required init(id: String) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
    }
    
    private let errorView: ErrorView = ErrorView()
    private let scrollView: UIScrollView = UIScrollView()
    private let refreshControl: RefreshControl = RefreshControl()
    private let settingsView: SettingsView = SettingsView()
    private let deviceView: DeviceView = DeviceView()
    
    // MARK: UIViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleRefresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        settingsView.toggle(open: false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        refreshControl.frame.size.height = view.safeAreaInsets.top
        
        settingsView.frame.size.height = settingsView.intrinsicContentSize.height + view.safeAreaInsets.bottom
        settingsView.frame.origin.y = view.bounds.size.height - settingsView.frame.size.height
        
        deviceView.contentInset.top = 72.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        errorView.frame = view.bounds
        errorView.isHidden = true
        view.addSubview(errorView)
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.frame = view.bounds
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.autoresizingMask = [.flexibleWidth]
        refreshControl.frame.size.width = view.bounds.size.width
        view.addSubview(refreshControl)
        
        settingsView.autoresizingMask = [.flexibleWidth]
        settingsView.frame.size.width = view.bounds.size.width
        view.addSubview(settingsView)
        
        deviceView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        deviceView.frame = scrollView.bounds
        scrollView.addSubview(deviceView)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) has not been implemented")
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshControl.contentOffset = scrollView.contentOffset
        settingsView.contentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        refreshControl.beginRefreshing(force: false)
    }
}
