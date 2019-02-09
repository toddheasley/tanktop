import UIKit
import TankUtility

extension UIColor {
    static func status(device: Device?) -> UIColor {
        guard let device: Device = device,
            let reading: Reading = device.lastReading,
            reading.tank > device.alert.threshold else {
            return UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 0.8)
        }
        guard reading.tank - device.alert.threshold > 0.15 else {
            return UIColor(displayP3Red: 1.0, green: 1.0, blue: 0.25, alpha: 0.9)
        }
        return UIColor(displayP3Red: 0.25, green: 1.0, blue: 0.25, alpha: 0.8)
    }
}
