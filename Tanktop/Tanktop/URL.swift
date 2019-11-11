import Foundation

extension URL {
    static var help: URL {
        return URL(string: "https://support.tankutility.com/hc/en-us")!
    }
    
    static func app(device id: String? = nil) -> URL {
        return URL(string: "tanktop://\(id ?? "")")!
    }
}
