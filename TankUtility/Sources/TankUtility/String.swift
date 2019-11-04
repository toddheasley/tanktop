import Foundation

extension String {
    public init?(percent: Double?, symbol: Bool = true) {
        guard let percent: Double = percent,
            let string: String = String.numberFormatter.string(from: NSNumber(value: percent)) else {
            return nil
        }
        self = string.replacingOccurrences(of: symbol ? "" : String.numberFormatter.percentSymbol, with: "")
    }
    
    private static let numberFormatter: NumberFormatter = .numberFormatter(style: .percent)
}

extension String {
    public init?(capacity: Measurement<UnitVolume>?) {
        guard let capacity: Measurement<UnitVolume> = capacity else {
            return nil
        }
        self = "\(String.measurementFormatter.string(from: capacity))"
    }
    
    public init?(temperature: Measurement<UnitTemperature>?) {
        guard let temperature: Measurement<UnitTemperature> = temperature else {
            return nil
        }
        self = "\(String.measurementFormatter.string(from: temperature))"
    }
    
    private static let measurementFormatter: MeasurementFormatter = .measurementFormatter
}

extension String {
    public init?(date: Date?) {
        guard let date: Date = date else {
            return nil
        }
        self = "\(String.dateFormatter.string(from: date)) \(String.timeFormatter.string(from: date))"
    }
    
    private static let dateFormatter: DateFormatter = .dateFormatter
    private static let timeFormatter: DateFormatter = .timeFormatter
}

extension NumberFormatter {
    fileprivate static func numberFormatter(style: NumberFormatter.Style) -> NumberFormatter {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = style
        return numberFormatter
    }
}

extension MeasurementFormatter {
    fileprivate static var measurementFormatter: MeasurementFormatter {
        let measurementFormatter: MeasurementFormatter = MeasurementFormatter()
        measurementFormatter.numberFormatter = .numberFormatter(style: .none)
        return measurementFormatter
    }
}

extension DateFormatter {
    fileprivate static var dateFormatter: DateFormatter {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }
    
    fileprivate static var timeFormatter: DateFormatter {
        let timeFormatter: DateFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        return timeFormatter
    }
}
