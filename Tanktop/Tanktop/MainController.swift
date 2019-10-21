import UIKit
import TankUtility

class MainController: UIViewController {
    func open(device id: String? = nil) {
        print("*** device: \(id ?? "nil")")
    }
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
