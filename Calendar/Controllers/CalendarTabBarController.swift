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
}
