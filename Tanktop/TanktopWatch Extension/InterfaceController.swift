import WatchKit
import TankUtility

class InterfaceController: WKInterfaceController {
    @IBOutlet var emptyLabel: WKInterfaceLabel!
    
    var device: Device? {
        didSet {
            emptyLabel.setHidden(device != nil)
        }
    }
}
