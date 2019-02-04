import Foundation

public struct Reading {
    public private(set) var tank: Double
    public private(set) var temperature: Measurement<UnitTemperature>
    public private(set) var date: Date
}

extension Reading: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        tank = min(max((try container.decode(Double.self, forKey: .tank) / 100.0), 0.0), 1.0)
        temperature = Measurement(value: try container.decode(Double.self, forKey: .temperature), unit: .fahrenheit)
        date = Date(timeIntervalSince1970: try container.decode(TimeInterval.self, forKey: .time) * 0.001)
    }
    
    private enum Key: String, CodingKey {
        case tank, temperature, time, iso = "time_iso"
    }
}
