import UIKit
import TankUtility

class MainController: UIViewController {
    func open(device id: String? = nil) {
        print("*** device: \(id ?? "nil")")
    }
    
    private let pageController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
