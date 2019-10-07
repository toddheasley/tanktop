import Foundation

public struct Device {
    public enum Fuel: String, CaseIterable, CustomStringConvertible, Codable {
        case propane, oil
        
        // MARK: CustomStringConvertible
        public var description: String {
            return rawValue
        }
    }
    
    public enum Orientation: String, CaseIterable, CustomStringConvertible, Codable {
        case horizontal, vertical
        
        // MARK: CustomStringConvertible
        public var description: String {
            return rawValue
        }
    }
    
    public let id: String
    public let name: String
    public let address: String
    public let fuel: Fuel
    public let orientation: Orientation
    public let capacity: Measurement<UnitVolume>
    public let lastReading: Reading?
}

extension Device {
    public var isAlerting: Bool {
        return alert.isEnabled && (lastReading?.tank ?? 1.0) < alert.threshold
    }
    
    public var alert: Alert {
        set {
            UserDefaults.shared.alerts[id] = newValue
        }
        get {
            return UserDefaults.shared.alerts[id] ?? Alert()
        }
    }
    
    public var isPrimary: Bool {
        set {
            UserDefaults.shared.primary = id
        }
        get {
            return id == UserDefaults.shared.primary
        }
    }
}

extension Device: Codable {
    
    // MARK: Codable
    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<Key> = encoder.container(keyedBy: Key.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(address, forKey: .address)
        try container.encode(fuel, forKey: .fuelType)
        try container.encode(orientation, forKey: .orientation)
        try container.encode(capacity.value, forKey: .capacity)
        try container.encodeIfPresent(lastReading, forKey: .lastReading)
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        guard let id: String = (try? container.decode(String.self, forKey: .id)) ?? decoder.id, !id.isEmpty else {
            throw TankUtility.Error.notFound
        }
        self.id = id
        name = try container.decode(String.self, forKey: .name)
        address = try container.decode(String.self, forKey: .address)
        fuel = (try? container.decode(Fuel.self, forKey: .fuelType)) ?? .propane
        orientation = (try? container.decode(Orientation.self, forKey: .orientation)) ?? .vertical
        capacity = Measurement(value: try container.decode(Double.self, forKey: .capacity), unit: .gallons)
        lastReading = try? container.decode(Reading.self, forKey: .lastReading)
    }
    
    private enum Key: CodingKey {
        case id, name, address, fuelType, orientation, capacity, lastReading
    }
}
