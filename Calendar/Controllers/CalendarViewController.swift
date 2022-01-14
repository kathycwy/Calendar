import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var monthContainerView: UIView!
    @IBOutlet weak var yearContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthContainerView.alpha = 1.0
        yearContainerView.alpha = 0.0
        NotificationCenter.default.addObserver(self, selector: #selector(switchCalendarView(_:)), name: Notification.Name(rawValue: "switchCalendarView"), object: nil)
    }
    
    @objc func switchCalendarView(_ notification: NSNotification){
        let param : [String:Int?] = notification.userInfo as! [String:Int?]
        let selectedIndex = param["SelectedIndex"]
        
        switch selectedIndex {
        case 0:
            monthContainerView.alpha = 0.0
            yearContainerView.alpha = 0.0
        case 1:
            monthContainerView.alpha = 0.0
            yearContainerView.alpha = 0.0
        case 2:
            monthContainerView.alpha = 1.0
            yearContainerView.alpha = 0.0
        case 3:
            monthContainerView.alpha = 0.0
            yearContainerView.alpha = 1.0
        default:
            break
        }
    }
}
