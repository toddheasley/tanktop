import WatchKit
import TankUtility

class InterfaceController: WKInterfaceController {
    @IBOutlet var emptyLabel: WKInterfaceLabel!
    @IBOutlet var tankGroup: WKInterfaceGroup!
    @IBOutlet var tankLabel: WKInterfaceLabel!
    @IBOutlet var nameLabel: WKInterfaceLabel!
    @IBOutlet var temperatureLabel: WKInterfaceLabel!
    @IBOutlet var dateLabel: WKInterfaceLabel!
    
    var device: Device? {
        didSet {
            emptyLabel.setHidden(device != nil)
            animate(withDuration: 0.5) {
                self.tankGroup.setBackgroundColor(.deviceStatus(self.device))
                self.tankGroup.setRelativeHeight(CGFloat(self.device?.lastReading?.tank ?? 0.0), withAdjustment: 0.0)
            }
            tankLabel.setText(String(percent: device?.lastReading?.tank))
            nameLabel.setText(device?.name)
            temperatureLabel.setText(String(temperature: device?.lastReading?.temperature))
            dateLabel.setText(String(date: device?.lastReading?.date)?.uppercased())
        }
    }
}
