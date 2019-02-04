import Foundation

extension String {
    public init?(capacity: Measurement<UnitVolume>?) {
        guard let capacity: Measurement<UnitVolume> = capacity else {
            return nil
        }
        let formatter: MeasurementFormatter = MeasurementFormatter()
        formatter.numberFormatter = NumberFormatter()
        formatter.numberFormatter.numberStyle = .none
        self = "\(formatter.string(from: capacity))"
    }
    
    public init?(temperature: Measurement<UnitTemperature>?) {
        guard let temperature: Measurement<UnitTemperature> = temperature else {
            return nil
        }
        let formatter: MeasurementFormatter = MeasurementFormatter()
        formatter.numberFormatter = NumberFormatter()
        formatter.numberFormatter.numberStyle = .none
        self = "\(formatter.string(from: temperature))"
    }
    
    public init?(percent: Double?) {
        guard let percent: Double = percent else {
            return nil
        }
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .percent
        guard let string: String = formatter.string(from: NSNumber(value: percent)) else {
            return nil
        }
        self = "\(string)"
    }
    
    public init?(date: Date?, timeZone: TimeZone? = nil) {
        guard let date: Date = date else {
            return nil
        }
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = timeZone ?? .autoupdatingCurrent
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let string: String = formatter.string(from: date)
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        self = "\(string) \(formatter.string(from: date))"
    }
}
