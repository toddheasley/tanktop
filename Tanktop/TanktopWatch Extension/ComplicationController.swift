import ClockKit
import TankUtility

class ComplicationController: NSObject, CLKComplicationDataSource {
    static var device: Device? {
        didSet {
            for complication in CLKComplicationServer.sharedInstance().activeComplications ?? [] {
                CLKComplicationServer.sharedInstance().reloadTimeline(for: complication)
            }
        }
    }
    
    // MARK: CLKComplicationDataSource
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        handler(complication.template())
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        guard let template: CLKComplicationTemplate = complication.template(device: ComplicationController.device) else {
            handler(nil)
            return
        }
        handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
    }
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([])
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
}
