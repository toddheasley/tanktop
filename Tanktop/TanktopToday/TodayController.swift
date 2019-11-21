import UIKit
import NotificationCenter
import TankUtility

class TodayViewController: UIViewController, NCWidgetProviding {
    @objc func handleOpen() {
        extensionContext?.open(.app(device: deviceView.device?.id), completionHandler: nil)
    }
    
    private let deviceView: DeviceView = DeviceView()
    private let openControl: UIControl = UIControl()
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TankUtility.appGroup = "group.toddheasley.tanktop"
        
        deviceView.contentInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 24.0, right: 8.0)
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
        TankUtility.device { device, _, _ in
            self.deviceView.device = device
            completionHandler(.newData)
        }
    }
}
