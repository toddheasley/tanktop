import Foundation

extension URL {
    static var token: URL {
        return URL(string: "\(base)/getToken")!
    }
    
    static func devices(token: String, device id: String? = nil) -> URL {
        return URL(string: "\(base)/devices\(!(id ?? "").isEmpty ? "/\(id!)" : "")?token=\(token)")!
    }
    
    private static let base: URL = URL(string: "https://data.tankutility.com/api")!
}
