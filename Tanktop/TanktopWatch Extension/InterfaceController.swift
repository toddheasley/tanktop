import WatchKit
import TankUtility

class InterfaceController: WKInterfaceController {
    var device: Device? {
        didSet {
            errorGroup?.setHidden(device != nil)
            animate(withDuration: 0.5) {
                self.deviceGroup?.setRelativeHeight(0.1 + CGFloat(self.device?.lastReading?.tank ?? 0.0) * 0.9, withAdjustment: 0.0)
                self.tankGroup?.setBackgroundColor(UIColor.status(device: self.device))
            }
            nameLabel?.setText(device?.name)
            setTitle(String(percent: device?.lastReading?.tank))
        }
    }
    
    @IBOutlet var group: WKInterfaceGroup?
    @IBOutlet var errorGroup: WKInterfaceGroup?
    @IBOutlet var deviceGroup: WKInterfaceGroup?
    @IBOutlet var tankGroup: WKInterfaceGroup?
    @IBOutlet var nameLabel: WKInterfaceLabel?
}
