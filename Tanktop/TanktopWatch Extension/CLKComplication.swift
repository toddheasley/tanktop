import ClockKit
import TankUtility

extension CLKComplication {
    func template(device: Device? = .template, family: CLKComplicationFamily? = nil) -> CLKComplicationTemplate? {
        guard let device: Device = device,
            let _: Reading = device.lastReading else {
            return nil
        }
        switch family ?? self.family {
        default:
            return nil
        }
    }
}
