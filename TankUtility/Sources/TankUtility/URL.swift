import Foundation

extension URL {
    static let website: URL = URL(string: "https://www.tankutility.com")!
    static func devices(token: String, device id: String? = nil) -> URL {
        return URL(string: "\(base)/devices\(!(id ?? "").isEmpty ? "/\(id!)" : "")?token=\(token)")!
    }
    
    static var token: URL {
        return URL(string: "\(base)/getToken")!
    }
    
    private static let base: URL = URL(string: "https://data.tankutility.com/api")!
}
