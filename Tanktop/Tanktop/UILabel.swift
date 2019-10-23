import UIKit

extension UILabel {
    static func empty(text: String) -> UILabel {
        let label: UILabel = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 72.0, weight: .semibold)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        label.text = text.uppercased()
        return label
    }
}
