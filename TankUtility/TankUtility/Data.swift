import Foundation

extension Data {
    static func logo() throws -> Data {
        guard let url: URL = Bundle(for: BundleData.self).url(forResource: "TankUtility", withExtension: "png") else {
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorFileDoesNotExist, userInfo: nil)
        }
        return try Data(contentsOf: url)
    }
    
    private class BundleData: NSObject {
        
    }
}
