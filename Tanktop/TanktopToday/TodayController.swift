import UIKit
import NotificationCenter
import TankUtility

class TodayViewController: UIViewController, NCWidgetProviding {
    @objc func handleOpen() {
        extensionContext?.open(.app(device: nil), completionHandler: nil)
    }
    
    private let openControl: UIControl = UIControl()
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TankUtility.appGroup = "group.toddheasley.tanktop"
        
        openControl.addTarget(self, action: #selector(handleOpen), for: .touchUpInside)
        openControl.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        openControl.frame = view.bounds
        view.addSubview(openControl)
    }
    
    // MARK: NCWidgetProviding
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(.noData)
    }
}
