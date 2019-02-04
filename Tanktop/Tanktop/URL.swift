import Foundation

extension URL {
    static func app(device id: String? = nil) -> URL {
        return URL(string: "tanktop://\(id ?? "")")!
    }
}
