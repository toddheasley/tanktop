import UIKit
import TankUtility

extension UIColor {
    static func status(device: Device?) -> UIColor {
        let alpha: CGFloat = 0.75
        guard let device: Device = device,
            let reading: Reading = device.lastReading,
            reading.tank > device.alert.threshold else {
            return UIColor.red.withAlphaComponent(alpha)
        }
        guard reading.tank - device.alert.threshold > 0.15 else {
            return UIColor.yellow.withAlphaComponent(alpha)
        }
        return UIColor.green.withAlphaComponent(alpha)
    }
}
