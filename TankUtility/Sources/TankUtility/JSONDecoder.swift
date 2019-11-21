import Foundation

extension JSONDecoder {
    convenience init(device id: String?) {
        self.init()
        userInfo[.id] = id
    }
}

extension Decoder {
    var id: String? {
        return userInfo[.id] as? String
    }
}

extension CodingUserInfoKey {
    fileprivate static let id: CodingUserInfoKey = CodingUserInfoKey(rawValue: "id")!
}
