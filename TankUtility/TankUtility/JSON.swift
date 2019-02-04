import Foundation

struct JSON {
    private(set) var value: Any
}

extension JSON: Decodable {
    
    // MARK: Decodable
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Key> = try decoder.container(keyedBy: Key.self)
        if let devices: [String] = try? container.decode([String].self, forKey: .devices) {
            value = devices
        } else if let device: Device = try? container.decode(Device.self, forKey: .device) {
            value = device
        } else if let token: Token = try? container.decode(Token.self, forKey: .token) {
            value = token
        } else {
            throw TankUtility.Error.notAcceptable
        }
    }
    
    private enum Key: CodingKey {
        case devices, device, token
    }
}
