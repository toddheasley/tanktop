import UIKit
import NotificationCenter
import TankUtility

class TodayViewController: UIViewController, NCWidgetProviding {
    @objc func handleOpen() {
        extensionContext?.open(.app(device: nil), completionHandler: nil)
    }
    
    private let deviceView: DeviceView = DeviceView()
    private let openControl: UIControl = UIControl()
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TankUtility.appGroup = "group.toddheasley.tanktop"
        
        let decoder: JSONDecoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey(rawValue: "id")!] = "54ff69057492666782350667"
        
        deviceView.device = try? decoder.decode(Device.self, from: data)
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
        completionHandler(.noData)
    }
}

private let data: Data = """
{
    "name": "Sample Device",
    "address": "6 Dane St., Somerville, MA 02143, USA",
    "fuelType": "propane",
    "orientation": "vertical",
    "capacity": 100,
    "lastReading": {
        "tank": 77,
        "temperature": 72.12,
        "time": 1444338760345,
    }
}
""".data(using: .utf8)!
