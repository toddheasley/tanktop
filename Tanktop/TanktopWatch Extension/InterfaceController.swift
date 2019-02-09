import WatchKit
import TankUtility

class InterfaceController: WKInterfaceController {
    @IBOutlet var group: WKInterfaceGroup?
    @IBOutlet var errorGroup: WKInterfaceGroup?
    @IBOutlet var deviceGroup: WKInterfaceGroup?
    @IBOutlet var tankGroup: WKInterfaceGroup?
    @IBOutlet var nameLabel: WKInterfaceLabel?
    
    func refresh() {
        TankUtility.device { device, error in
            self.errorGroup?.setHidden(error == nil)
            self.animate(withDuration: 0.5) {
                self.deviceGroup?.setRelativeHeight(0.1 + CGFloat(device?.lastReading?.tank ?? 0.0) * 0.9, withAdjustment: 0.0)
                self.tankGroup?.setBackgroundColor(UIColor.status(device: device))
            }
            self.nameLabel?.setText(device?.name)
            self.setTitle(String(percent: device?.lastReading?.tank))
        }
    }
}
