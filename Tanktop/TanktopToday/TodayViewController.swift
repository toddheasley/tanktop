import UIKit
import NotificationCenter
import TankUtility

class TodayViewController: UIViewController, NCWidgetProviding {
    @objc func handleOpen() {
        extensionContext?.open(.app(device: device?.id), completionHandler: nil)
    }
    
    private var device: Device? {
        set {
            deviceView.device = newValue
        }
        get {
            return deviceView.device
        }
    }
    
    private let errorView: ErrorView = ErrorView()
    private let deviceView: DeviceView = DeviceView()
    private let openControl: UIControl = UIControl()
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TankUtility.appGroup = "group.toddheasley.tanktop"
        
        errorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        errorView.frame = view.bounds
        errorView.isHidden = true
        view.addSubview(errorView)
        
        deviceView.contentSize = .compact
        deviceView.contentInset.top = 4.0
        deviceView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        deviceView.frame = view.bounds
        view.addSubview(deviceView)
        
        openControl.addTarget(self, action: #selector(handleOpen), for: .touchUpInside)
        openControl.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        openControl.frame = view.bounds
        view.addSubview(openControl)
    }
    
    // MARK: NCWidgetProviding
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        errorView.isHidden = true
        TankUtility.device { device, error in
            guard let device: Device = device else {
                self.errorView.isHidden = false
                return
            }
            self.device = device
        }
    }
}
