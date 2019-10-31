import UIKit
import TankUtility

class DeviceView: UIView {
    var device: Device? {
        didSet {
            nameLabel.text = device?.name
            readingLabel.text = String(percent: device?.lastReading?.tank)
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    var contentInset: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let emptyLabel: UILabel = .empty(text: "No device")
    private let tankView: UIView = UIView()
    private let contentView: UIView = UIView()
    private let nameLabel: UILabel = UILabel()
    private let readingLabel: UILabel = UILabel()
    
    // MARK: UIView
    override var description: String {
        if let device: Device = device {
            guard let reading: String = readingLabel.text, !reading.isEmpty else {
                return "\(device.name); no device reading"
            }
            return "\(device.name); device reading: \(reading)"
        } else {
            return emptyLabel.text!
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        emptyLabel.frame.size.width = round(bounds.size.width * 0.8)
        emptyLabel.frame.origin.x = (bounds.size.width - emptyLabel.frame.size.width) / 2.0
        emptyLabel.isHidden = device != nil
        
        tankView.backgroundColor = .deviceStatus(self.device)
        tankView.frame.size.height = bounds.size.height
        tankView.frame.origin.y = self.bounds.size.height - (CGFloat(self.device?.lastReading?.tank ?? 0.0) * self.bounds.size.height)
        
        tankView.backgroundColor = .deviceStatus(self.device)
        tankView.frame.size.height = bounds.size.height
        tankView.frame.origin.y = (bounds.size.height - (CGFloat(self.device?.lastReading?.tank ?? 0.0) * bounds.size.height))
        
        contentView.frame.size.width = bounds.size.width - (contentInset.left + contentInset.right)
        contentView.frame.size.height = bounds.size.height - (contentInset.top + contentInset.bottom)
        contentView.frame.origin.x = contentInset.left
        contentView.frame.origin.y = contentInset.top
        contentView.isHidden = device == nil
        
        let pointSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize
        
        nameLabel.font = .systemFont(ofSize: pointSize, weight: .regular)
        readingLabel.font = .systemFont(ofSize: pointSize, weight: .semibold)
        if let reading: String = readingLabel.text, !reading.isEmpty {
            readingLabel.frame.size.width = readingLabel.sizeThatFits(contentView.bounds.size).width + 44.0
            nameLabel.frame.size.width = min(nameLabel.sizeThatFits(contentView.bounds.size).width, contentView.bounds.size.width - readingLabel.frame.size.width)
            nameLabel.frame.origin.x = (contentView.bounds.size.width - (nameLabel.frame.size.width + readingLabel.frame.size.width)) / 2.0
            readingLabel.frame.origin.x = nameLabel.frame.origin.x + nameLabel.frame.size.width
        } else {
            nameLabel.frame.size.width = contentView.bounds.size.width
            nameLabel.frame.origin.x = 0.0
        }
        
        accessibilityLabel = accessibilityLabel ?? description
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emptyLabel.autoresizingMask = [.flexibleHeight]
        emptyLabel.frame.size.height = bounds.size.height
        addSubview(emptyLabel)
        
        tankView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        tankView.frame.size.width = bounds.size.width
        tankView.frame.origin.y = bounds.size.height
        tankView.alpha = 0.8
        addSubview(tankView)
        
        addSubview(contentView)
        
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.font = .preferredFont(forTextStyle: .subheadline)
        nameLabel.textAlignment = .center
        nameLabel.autoresizingMask = [.flexibleHeight]
        nameLabel.frame.size.height = contentView.bounds.size.height
        contentView.addSubview(nameLabel)
        
        readingLabel.adjustsFontForContentSizeCategory = true
        readingLabel.font = .preferredFont(forTextStyle: .headline)
        readingLabel.textAlignment = .center
        readingLabel.autoresizingMask = [.flexibleHeight]
        readingLabel.frame.size.height = contentView.bounds.size.height
        contentView.addSubview(readingLabel)
        
        accessibilityTraits = .summaryElement
        isAccessibilityElement = true
    }
}
