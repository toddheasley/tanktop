import UIKit

class EmptyViewController: UIViewController {
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = EmptyView()
        view.backgroundColor = .white
    }
}

class EmptyView: UIView {
    private let label: UILabel = UILabel()
    
    // MARK: UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 72.0, weight: .semibold)
        label.text = "NO DEVICES"
        label.textAlignment = .center
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.frame = bounds
        addSubview(label)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
