import UIKit
import TankUtility

class ReadingView: UIView {
    var reading: Reading? {
        didSet {
            tankLabel.text = String(percent: reading?.tank)
            temperatureLabel.text = String(temperature: reading?.temperature) ?? "NO READING"
            dateLabel.text = String(date: reading?.date)?.uppercased()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    private let tankLabel: UILabel = UILabel()
    private let temperatureLabel: UILabel = UILabel()
    private let dateLabel: UILabel = UILabel()
    
    // MARK: UIView
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: temperatureLabel.frame.origin.y + temperatureLabel.frame.size.height + tankLabel.frame.origin.y)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tankLabel.font = .monospacedDigitSystemFont(ofSize: 64.0, weight: .semibold)
        tankLabel.autoresizingMask = [.flexibleWidth]
        tankLabel.frame.size.width = bounds.size.width
        tankLabel.frame.size.height = tankLabel.font.pointSize
        tankLabel.frame.origin.y = 12.0
        addSubview(tankLabel)
        
        dateLabel.font = .systemFont(ofSize: 11.0)
        dateLabel.autoresizingMask = [.flexibleWidth]
        dateLabel.frame.size.width = bounds.size.width
        dateLabel.frame.size.height = 16.0
        dateLabel.frame.origin.y = tankLabel.frame.origin.y + tankLabel.frame.size.height
        addSubview(dateLabel)
        
        temperatureLabel.font = .systemFont(ofSize: 28.0, weight: .semibold)
        temperatureLabel.autoresizingMask = [.flexibleWidth]
        temperatureLabel.frame.size.width = bounds.size.width
        temperatureLabel.frame.size.height = 39.0
        temperatureLabel.frame.origin.y = dateLabel.frame.origin.y + dateLabel.frame.size.height
        addSubview(temperatureLabel)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
