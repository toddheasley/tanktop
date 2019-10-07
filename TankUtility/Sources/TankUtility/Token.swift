import Foundation

struct Token {
    static var current: Token? {
        guard let cached: Token = cached, Date().timeIntervalSince(cached.date) < 82800.0  else {
            return nil
        }
        return cached
    }
    
    let date: Date = Date()
    private static var cached: Token?
    private let value: String
}

extension Token: CustomStringConvertible {
    
    // MARK: CustomStringConvertible
    var description: String {
        return value
    }
}

extension Token: Decodable {
    
    // MARK: Decodable
    init(from decoder: Decoder) throws {
        let container: SingleValueDecodingContainer = try decoder.singleValueContainer()
        value = try container.decode(String.self)
        Token.cached = self
    }
}
