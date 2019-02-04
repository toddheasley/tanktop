import Foundation

public struct Device {
    public enum Fuel: String, CaseIterable, CustomStringConvertible, Decodable {
        case propane, oil
        
        // MARK: CustomStringConvertible
        public var description: String {
            return "\(rawValue)"
        }
    }
    
    public enum Orientation: String, CaseIterable, CustomStringConvertible, Decodable {
        case horizontal, vertical
        
        // MARK: CustomStringConvertible
        public var description: String {
            return "\(rawValue)"
        }
    }
    
    public internal(set) var id: String = "0"
    public private(set) var name: String
    public private(set) var address: String
    public private(set) var fuel: Fuel
    public private(set) var orientation: Orientation
    public private(set) var capacity: Measurement<UnitVolume>
    public private(set) var lastReading: Reading?
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
}

extension Device: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        name = try container.decode(String.self, forKey: .name)
        address = try container.decode(String.self, forKey: .address)
        fuel = .propane
        orientation = .vertical
        fuel = try container.decode(Fuel.self, forKey: .fuelType)
        orientation = try container.decode(Orientation.self, forKey: .orientation)
        capacity = Measurement(value: try container.decode(Double.self, forKey: .capacity), unit: .gallons)
        lastReading = try? container.decode(Reading.self, forKey: .lastReading)
    }
    
    private enum Key: CodingKey {
        case name, address, fuelType, orientation, capacity, lastReading
    }
}
