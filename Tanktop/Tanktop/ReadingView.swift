import UIKit
import TankUtility

class ReadingView: UIView {
    var reading: Reading? {
        didSet {
            tankLabel.text = String(percent: reading?.tank)
            temperatureLabel.text = String(temperature: reading?.temperature)
            dateLabel.text = String(date: reading?.date)?.uppercased()
            
            accessibilityLabel = description
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let contentView: UIView = UIView()
    private let emptyLabel: UILabel = .empty(text: "No device reading")
    private let tankLabel: UILabel = UILabel()
    private let temperatureLabel: UILabel = UILabel()
    private let dateLabel: UILabel = UILabel()
    
    // MARK: UIView
    override var description: String {
        if let reading: Reading = reading,
            let tank: String = String(percent: reading.tank),
            let temperature: String = String(temperature: reading.temperature),
            let date: String = String(date: reading.date) {
            return "Device reading: \(tank); \(date); \(temperature)"
        } else {
            return emptyLabel.text!
        }
    }
    
    override var intrinsicContentSize: CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        return contentView.bounds.size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tankLabel.font = .monospacedDigitSystemFont(ofSize: 72.0, weight: .medium)
        tankLabel.frame.size.height = tankLabel.sizeThatFits(contentView.bounds.size).height
        
        dateLabel.font = .systemFont(ofSize: 16.0, weight: .regular)
        dateLabel.frame.size.height = dateLabel.sizeThatFits(contentView.bounds.size).height
        dateLabel.frame.origin.y = tankLabel.frame.size.height
        
        temperatureLabel.font = .monospacedDigitSystemFont(ofSize: round(tankLabel.font.pointSize / 2.0), weight: .medium)
        temperatureLabel.frame.size.height = temperatureLabel.sizeThatFits(contentView.bounds.size).height + 13.0
        temperatureLabel.frame.origin.y = dateLabel.frame.size.height + dateLabel.frame.origin.y
        
        emptyLabel.frame.size.width = round(bounds.size.width * 0.8)
        emptyLabel.frame.size.height = emptyLabel.sizeThatFits(contentView.bounds.size).height + 16.0
        emptyLabel.frame.origin.x = (contentView.bounds.size.width - emptyLabel.frame.size.width) / 2.0
        emptyLabel.isHidden = reading != nil
        
        contentView.frame.size.height = max(temperatureLabel.frame.size.height + temperatureLabel.frame.origin.y, emptyLabel.frame.size.height)
        contentView.frame.origin.x = (bounds.size.width - contentView.frame.size.width) / 2.0
        contentView.frame.origin.y = (bounds.size.height - contentView.frame.size.height) / 2.0
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.autoresizingMask = [.flexibleWidth]
        contentView.frame.size.width = bounds.size.width
        addSubview(contentView)
        
        contentView.addSubview(emptyLabel)
        
        tankLabel.adjustsFontSizeToFitWidth = true
        tankLabel.textAlignment = .center
        tankLabel.autoresizingMask = [.flexibleWidth]
        tankLabel.frame.size.width = bounds.size.width
        contentView.addSubview(tankLabel)
        
        temperatureLabel.adjustsFontSizeToFitWidth = true
        temperatureLabel.textAlignment = .center
        temperatureLabel.autoresizingMask = [.flexibleWidth]
        temperatureLabel.frame.size.width = bounds.size.width
        contentView.addSubview(temperatureLabel)
        
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.textAlignment = .center
        dateLabel.autoresizingMask = [.flexibleWidth]
        dateLabel.frame.size.width = bounds.size.width
        contentView.addSubview(dateLabel)
        
        accessibilityTraits = .summaryElement
        isAccessibilityElement = true
    }
}
