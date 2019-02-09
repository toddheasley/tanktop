import UIKit
import WatchConnectivity
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
    
    var contentInset: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 6.0, bottom: 0.0, right: 6.0) {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    var contentSize: UIUserInterfaceSizeClass = .regular {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    @objc func handleDrag(_ sender: UIControl?, event: UIEvent) {
        guard let sender: DragControl = sender as? DragControl,
            let touch: UITouch = event.touches(for: sender)?.first else {
            return
        }
        let delta: CGFloat = touch.location(in: sender).y - touch.previousLocation(in: sender).y
        guard delta != 0.0 else {
            return
        }
        let y: CGFloat = contentInset.top + safeAreaInsets.top
        let height: CGFloat = bounds.size.height - (y + contentInset.bottom + safeAreaInsets.bottom)
        
        device?.alert.threshold = Double(1.0 - ((sender.frame.origin.y + delta - y) / height))
        try? WCSession.available?.updateApplicationContext(TankUtility.context)
    }
    
    private let tankView: UIView = UIView()
    private let contentView: UIView = UIView()
    private let nameLabel: UILabel = UILabel()
    private let addressLabel: UILabel = UILabel()
    private let readingView: ReadingView = ReadingView()
    private let dragControl: DragControl = DragControl()
    
    // MARK: UIView
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let y: CGFloat = contentInset.top + safeAreaInsets.top
        let height: CGFloat = bounds.size.height - (y + contentInset.bottom + safeAreaInsets.bottom)
        
        tankView.frame.size.height = bounds.size.height
        UIView.animate(withDuration: 0.75) {
            self.tankView.backgroundColor = .status(device: self.device)
            self.tankView.frame.origin.y = (height - (CGFloat(self.device?.lastReading?.tank ?? 0.0) * height)) + y
        }
        
        contentView.frame.origin.y = contentInset.top + safeAreaInsets.top
        contentView.frame.size.width = bounds.size.width - (contentInset.left + contentInset.right)
        contentView.frame.size.height = bounds.size.height - (contentView.frame.origin.y + contentInset.bottom + safeAreaInsets.bottom)
        contentView.frame.origin.x = contentInset.left
        
        nameLabel.frame.size.width = contentView.bounds.size.width
        nameLabel.frame.size.height = nameLabel.intrinsicContentSize.height
        addressLabel.frame.size.width = contentView.bounds.size.width
        switch contentSize {
        case .compact:
            nameLabel.font = .systemFont(ofSize: 16.0, weight: .semibold)
            addressLabel.frame.size.height = 0.0
            addressLabel.frame.origin.y = 2.0
        default:
            nameLabel.font = .systemFont(ofSize: nameLabel.font.pointSize, weight: .semibold)
            addressLabel.frame.size.height = addressLabel.sizeThatFits(contentView.bounds.size).height
            addressLabel.frame.origin.y = nameLabel.frame.origin.y + nameLabel.frame.size.height + 3.0
        }
        
        readingView.frame.size.width = contentView.bounds.size.width
        readingView.frame.size.height = readingView.intrinsicContentSize.height
        readingView.frame.origin.y = addressLabel.frame.origin.y + addressLabel.frame.size.height + 6.0
        
        dragControl.isEnabled = contentSize != .compact
        dragControl.frame.origin.y = (height - (CGFloat(device?.alert.threshold ?? 0.0) * height)) + y
        dragControl.threshold = device?.alert.threshold
        dragControl.isHidden = !dragControl.isEnabled || device == nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tankView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        tankView.frame.size.width = bounds.size.width
        tankView.frame.origin.y = bounds.size.height
        addSubview(tankView)
        
        addSubview(contentView)
        
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.numberOfLines = 1
        contentView.addSubview(nameLabel)
        
        addressLabel.lineBreakMode = .byTruncatingTail
        addressLabel.numberOfLines = 3
        contentView.addSubview(addressLabel)
        
        contentView.addSubview(readingView)
        
        dragControl.addTarget(self, action: #selector(handleDrag(_:event:)), for: .touchDragInside)
        dragControl.autoresizingMask = [.flexibleWidth]
        dragControl.frame.size.width = bounds.size.width
        dragControl.frame.size.height = 26.0
        dragControl.isHidden = true
        addSubview(dragControl)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
