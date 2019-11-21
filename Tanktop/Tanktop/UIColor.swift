import UIKit
import TankUtility

extension UIColor {
    static let deviceGreen: UIColor = UIColor(displayP3Red: 0.4, green: 0.76, blue: 0.31, alpha: 0.99)
    static let deviceYellow: UIColor = UIColor(displayP3Red: 0.96, green: 0.81, blue: 0.31, alpha: 0.99)
    static let deviceRed: UIColor = UIColor(displayP3Red: 0.93, green: 0.41, blue: 0.37, alpha: 0.99)
    
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
