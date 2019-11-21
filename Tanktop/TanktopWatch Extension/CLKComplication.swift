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
            let template: CLKComplicationTemplateGraphicCircularClosedGaugeText = CLKComplicationTemplateGraphicCircularClosedGaugeText()
            template.gaugeProvider = CLKSimpleGaugeProvider(style: .ring, gaugeColor: .deviceStatus(device), fillFraction: Float(reading.tank))
            template.centerTextProvider = CLKSimpleTextProvider(text: String(percent: reading.tank, symbol: false) ?? "")
            return template
        case .graphicBezel:
            guard let circularTemplate: CLKComplicationTemplateGraphicCircular = self.template(device: device, family: .graphicCircular) as? CLKComplicationTemplateGraphicCircular else {
                return nil
            }
            let template: CLKComplicationTemplateGraphicBezelCircularText = CLKComplicationTemplateGraphicBezelCircularText()
            template.circularTemplate = circularTemplate
            template.textProvider = CLKSimpleTextProvider(text: device.name)
            return template
        case .graphicCorner:
            let template: CLKComplicationTemplateGraphicCornerGaugeText = CLKComplicationTemplateGraphicCornerGaugeText()
            template.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .deviceStatus(device), fillFraction: Float(reading.tank))
            template.outerTextProvider = CLKSimpleTextProvider(text: String(percent: reading.tank) ?? "")
            return template
        default:
            return nil
        }
    }
}
