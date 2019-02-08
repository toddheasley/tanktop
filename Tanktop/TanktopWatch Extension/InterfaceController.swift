import WatchKit
import TankUtility

class InterfaceController: WKInterfaceController {
    func refresh() {
        TankUtility.device { device, error in
            
        }
    }
    
    // MARK: WKInterfaceController
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
}
