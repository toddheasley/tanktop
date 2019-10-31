import UIKit
import TankUtility

class MainViewController: UIViewController {
    func open(device id: String? = nil) {
        print("*** open: \(id ?? "nil")")
    }
    
    func refresh() {
        TankUtility.devices { devices, error in
            guard !self.handle(error: error),
                let devices: [Device] = devices else {
                return
            }
            self.devices = devices
        }
    }
    
    func reset() {
        devices = []
    }
    
    private var devices: [Device] = [] {
        didSet {
            print("*** \(devices)")
        }
    }
    
    private let control: UIControl = UIControl()
    
    @objc func handleControl(_ control: UIControl?) {
        present(AuthorizeViewController(), animated: true, completion: nil)
    }
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        control.addTarget(self, action: #selector(handleControl(_:)), for: .touchUpInside)
        control.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        control.frame = view.bounds
        view.addSubview(control)
    }
}
