import UIKit
import TankUtility

extension UIColor {
    static let deviceGreen: UIColor = UIColor(displayP3Red: 0.25, green: 1.0, blue: 0.25, alpha: 0.8)
    static let deviceYellow: UIColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 0.25, alpha: 0.9)
    static let deviceRed: UIColor = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 0.8)
    
    static func deviceStatus(_ device: Device?) -> UIColor {
        guard let device: Device = device,
            let reading: Reading = device.lastReading,
            reading.tank > device.alert.threshold else {
            return deviceRed
        }
        guard reading.tank - device.alert.threshold > 0.15 else {
            return deviceYellow
        }
        return deviceGreen
    }
}
