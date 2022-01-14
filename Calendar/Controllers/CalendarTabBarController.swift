import UIKit

class CalendarTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var freshLaunch = true
    @IBOutlet weak var monthContainerView: UIView!
    @IBOutlet weak var yearContainerView: UIView!
    
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
    
    @IBAction func didChangeIndex(_ sender: UISegmentedControl) {
        var param = [String:Int?]()
        param["SelectedIndex"] = sender.selectedSegmentIndex
        NotificationCenter.default.post(name: Notification.Name(rawValue: "switchCalendarView"), object: nil, userInfo: param as [AnyHashable : Any])
    }
}
