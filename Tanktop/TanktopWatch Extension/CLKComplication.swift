import ClockKit
import TankUtility

extension CLKComplication {
    func template(device: Device? = .template, family: CLKComplicationFamily? = nil) -> CLKComplicationTemplate? {
        guard let device: Device = device,
            let reading: Reading = device.lastReading else {
            return nil
        }
        switch family ?? self.family {
        case .graphicCircular:
            return CLKComplicationTemplateGraphicCircularClosedGaugeText(gaugeProvider: CLKSimpleGaugeProvider(style: .ring, gaugeColor: .deviceStatus(device), fillFraction: Float(reading.tank)), center: CLKSimpleTextProvider(text: String(percent: reading.tank, symbol: false) ?? ""))
        case .graphicBezel:
            guard let circularTemplate: CLKComplicationTemplateGraphicCircular = self.template(device: device, family: .graphicCircular) as? CLKComplicationTemplateGraphicCircular else {
                return nil
            }
            return CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: circularTemplate, textProvider: CLKSimpleTextProvider(text: device.name))
        case .graphicCorner:
            return CLKComplicationTemplateGraphicCornerGaugeText(gaugeProvider: CLKSimpleGaugeProvider(style: .fill, gaugeColor: .deviceStatus(device), fillFraction: Float(reading.tank)), outerTextProvider: CLKSimpleTextProvider(text: String(percent: reading.tank) ?? ""))
        default:
            return nil
        }
    }
}
