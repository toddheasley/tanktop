import UIKit
import TankUtility

class MainController: UIViewController {
    func open(device id: String? = nil) {
        print("*** device: \(id ?? "nil")")
    }
    
    private let deviceView: DeviceView = DeviceView()
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let decoder: JSONDecoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey(rawValue: "id")!] = "54ff69057492666782350667"
        
        deviceView.device = try? decoder.decode(Device.self, from: data)
        deviceView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        deviceView.frame = view.bounds
        deviceView.isAlertLevelHidden = false
        view.addSubview(deviceView)
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
