import Foundation

public struct Alert {
    public var isEnabled: Bool
    
    public var threshold: Double {
        didSet {
            guard !Alert.range.contains(threshold) else {
                return
            }
            threshold = min(max(threshold, Alert.range.lowerBound), Alert.range.upperBound)
        }
    }
    
    public init(threshold: Double = 0.25, isEnabled: Bool = true) {
        self.threshold = min(max(threshold, Alert.range.lowerBound), Alert.range.upperBound)
        self.isEnabled = isEnabled
    }
    
    public static let range: ClosedRange<Double> = 0.1...0.9
}

extension Alert: Codable {
    
}
