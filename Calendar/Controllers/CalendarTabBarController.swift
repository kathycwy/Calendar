import UIKit

class CalendarTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var freshLaunch:Bool = true
    var monthViewController: MonthViewController!
    var yearViewController: YearViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
         if freshLaunch == true {
             freshLaunch = false
             self.selectedIndex = 1
         }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!

       if selectedIndex == 0{
           //Do any thing.
           NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollToToday"), object: nil)
           return false
       }
       return true
   }
    
    func reloadUI() {
        self.view.setNeedsDisplay()
        for objects in self.view.subviews {
            if let object = objects as? UIButton {
                object.setNeedsDisplay()
            }
            if let object = objects as? UILabel {
                object.setNeedsDisplay()
            }
            if let object = objects as? UIView {
                object.setNeedsDisplay()
            }
        }
        DispatchQueue.main.async { [weak self] in
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = .appColor(.navigationBackground)
            self?.tabBar.backgroundColor = .appColor(.navigationBackground)
            self?.tabBar.barTintColor = .appColor(.navigationBackground)
            self?.tabBar.tintColor = .appColor(.navigationTitle)
            self?.tabBar.standardAppearance = tabBarAppearance
            self?.tabBar.scrollEdgeAppearance = tabBarAppearance
            self?.tabBar.isTranslucent = false
        }
        
    }
    
    @objc func reloadUI(_ notification: Notification) {
        reloadUI()
    }
}
