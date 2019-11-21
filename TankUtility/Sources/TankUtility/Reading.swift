import Foundation

public struct Reading {
    public let tank: Double
    public let temperature: Measurement<UnitTemperature>
    public let date: Date
}

extension Reading: Codable {
    
    // MARK: Codable
    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<Key> = encoder.container(keyedBy: Key.self)
        try container.encode(tank * 100.0, forKey: .tank)
        try container.encode(temperature.value, forKey: .temperature)
        try container.encode(date.timeIntervalSince1970 * 1000.0, forKey: .time)
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        tank = min(max((try container.decode(Double.self, forKey: .tank) * 0.01), 0.0), 1.0)
        temperature = Measurement(value: try container.decode(Double.self, forKey: .temperature), unit: .fahrenheit)
        date = Date(timeIntervalSince1970: try container.decode(TimeInterval.self, forKey: .time) * 0.001)
    }
    
    private enum Key: String, CodingKey {
        case tank, temperature, time
    }
}
