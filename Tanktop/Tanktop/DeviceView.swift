import UIKit
import TankUtility

class DeviceView: UIView {
    var device: Device? {
        didSet {
            nameLabel.text = device?.name
            addressLabel.text = device?.address
            readingView.reading = device?.lastReading
            
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
    
    @objc func handleDrag(_ control: DragControl?, event: UIEvent) {
        guard let control: DragControl = control,
            let touch: UITouch = event.touches(for: control)?.first else {
            return
        }
        let delta: CGFloat = touch.location(in: control).y - touch.previousLocation(in: control).y
        guard delta != 0.0 else {
            return
        }
        let y: CGFloat = contentView.frame.origin.y
        let height: CGFloat = bounds.size.height - (y + safeAreaInsets.bottom)
        device?.alert.threshold = Double(1.0 - ((control.frame.origin.y + delta - y) / height))
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let emptyLabel: UILabel = .empty(text: "No device")
    private let tankView: UIView = UIView()
    private let contentView: UIView = UIView()
    private let nameLabel: UILabel = UILabel()
    private let addressLabel: UILabel = UILabel()
    private let readingView: ReadingView = ReadingView()
    private let dragControl: DragControl = DragControl()
    
    // MARK: UIView
    override var description: String {
        if let device: Device = device,
            let reading: String = readingView.accessibilityLabel {
            return "\(device.name); \(device.address); \(reading)"
        } else {
            return emptyLabel.text!
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        emptyLabel.frame.size.width = round(bounds.size.width * 0.8)
        emptyLabel.frame.origin.x = (bounds.size.width - emptyLabel.frame.size.width) / 2.0
        emptyLabel.isHidden = device != nil
        
        let y: CGFloat = safeAreaInsets.top + contentInset.top
        let height: CGFloat = bounds.size.height - (y + safeAreaInsets.bottom + contentInset.bottom)
        let pointSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize * (bounds.size.width < 768.0 ? 1.0 : 2.0)
        
        tankView.frame.size.height = bounds.size.height
        UIView.animate(withDuration: 0.42) {
            self.tankView.backgroundColor = .deviceStatus(self.device)
            self.tankView.frame.origin.y = (height - (CGFloat(self.device?.lastReading?.tank ?? 0.0) * height)) + y
        }
        
        contentView.frame.size.width = bounds.size.width - (contentInset.left + contentInset.right)
        contentView.frame.size.height = height
        contentView.frame.origin.x = contentInset.left
        contentView.frame.origin.y = y
        contentView.isHidden = device == nil
        
        nameLabel.font = .systemFont(ofSize: pointSize, weight: .semibold)
        nameLabel.frame.size.height = nameLabel.sizeThatFits(contentView.bounds.size).height + 5.0
        nameLabel.frame.origin.y = 32.0
        
        addressLabel.font = .systemFont(ofSize: pointSize, weight: .regular)
        addressLabel.frame.size.height = addressLabel.sizeThatFits(contentView.bounds.size).height + 5.0
        addressLabel.frame.origin.y = nameLabel.frame.size.height + nameLabel.frame.origin.y
        
        readingView.frame.size.height = readingView.intrinsicContentSize.height + (nameLabel.frame.origin.y * 2.0)
        readingView.frame.origin.y = addressLabel.frame.size.height + addressLabel.frame.origin.y
        
        dragControl.frame.origin.y = (height - (CGFloat(device?.alert.threshold ?? 0.0) * height)) + y
        dragControl.threshold = device?.alert.threshold
        dragControl.isHidden = true // device == nil
        
        accessibilityLabel = accessibilityLabel ?? description
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emptyLabel.isUserInteractionEnabled = false
        emptyLabel.autoresizingMask = [.flexibleHeight]
        emptyLabel.frame.size.height = bounds.size.height
        addSubview(emptyLabel)
        
        tankView.isUserInteractionEnabled = false
        tankView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        tankView.frame.size.width = bounds.size.width
        tankView.frame.origin.y = bounds.size.height
        addSubview(tankView)
        
        contentView.isUserInteractionEnabled = false
        addSubview(contentView)
        
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.textAlignment = .center
        nameLabel.autoresizingMask = [.flexibleWidth]
        nameLabel.frame.size.width = bounds.size.width
        contentView.addSubview(nameLabel)
        
        addressLabel.adjustsFontForContentSizeCategory = true
        addressLabel.textAlignment = .center
        addressLabel.numberOfLines = 3
        addressLabel.autoresizingMask = [.flexibleWidth]
        addressLabel.frame.size.width = bounds.size.width
        contentView.addSubview(addressLabel)
        
        readingView.autoresizingMask = [.flexibleWidth]
        readingView.frame.size.width = bounds.size.width
        contentView.addSubview(readingView)
        
        dragControl.addTarget(self, action: #selector(handleDrag(_:event:)), for: .touchDragInside)
        dragControl.autoresizingMask = [.flexibleWidth]
        dragControl.frame.size.width = bounds.size.width
        addSubview(dragControl)
        
        accessibilityTraits = .summaryElement
        isAccessibilityElement = true
    }
}
