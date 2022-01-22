import UIKit

class CalendarViewController: UIViewController {
    @IBOutlet weak var dayContainerView: UIView!
    @IBOutlet weak var monthContainerView: UIView!
    @IBOutlet weak var yearContainerView: UIView!
    @IBOutlet weak var weekContainerView: UIView!
    @IBOutlet weak var calendarViewSegmentedControl: UISegmentedControl!
    
    var freshLaunch: Bool = true
    var dayViewController: DayViewController!
    var weekViewController: WeekViewController!
    var monthViewController: MonthViewController!
    var yearViewController: YearViewController!
    
    let calendarHelper = CalendarHelper()
    private var calendarYears: [CalendarYear] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayContainerView.alpha = 0.0
        weekContainerView.alpha = 0.0
        monthContainerView.alpha = 1.0
        yearContainerView.alpha = 0.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(switchSegment(_:)), name: Notification.Name(rawValue: "switchSegment"), object: nil)
    }
    
    @IBAction func didChangeIndex(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            dayContainerView.alpha = 1.0
            weekContainerView.alpha = 0.0
            monthContainerView.alpha = 0.0
            yearContainerView.alpha = 0.0
        case 1:
            dayContainerView.alpha = 0.0
            weekContainerView.alpha = 1.0
            monthContainerView.alpha = 0.0
            yearContainerView.alpha = 0.0
        case 2:
            dayContainerView.alpha = 0.0
            weekContainerView.alpha = 0.0
            monthContainerView.alpha = 1.0
            yearContainerView.alpha = 0.0
        case 3:
            dayContainerView.alpha = 0.0
            weekContainerView.alpha = 0.0
            monthContainerView.alpha = 0.0
            yearContainerView.alpha = 1.0
        default:
            break
        }
    }
    
    func setCalendar(calendarYears: [CalendarYear] = []) -> [CalendarYear] {
        self.calendarYears.removeAll(keepingCapacity: false)
        if calendarYears.count == 0 {
            let year = Calendar.current.component(.year, from: Date()) + 10
            for tempYear in 1970 ... year {
                let calYear = calendarHelper.getCalendarYear(year: tempYear)
                self.calendarYears.append(calYear)
            }
        }
        else {
            self.calendarYears = calendarYears
        }
        return self.calendarYears
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if freshLaunch == true {
            freshLaunch = false
            self.calendarYears = setCalendar()
        }
        switch (segue.identifier)
        {
        case "DayViewSegue":
            self.dayViewController = (segue.destination as! DayViewController)
            //self.dayViewController.reloadCalendar()
            break
        case "WeekViewSegue":
            self.weekViewController = (segue.destination as! WeekViewController)
            self.weekViewController.reloadCalendar(calendarYears: self.calendarYears)
            break
        case "MonthViewSegue":
            self.monthViewController = (segue.destination as! MonthViewController)
            self.monthViewController.reloadCalendar(calendarYears: self.calendarYears)
            break
        case "YearViewSegue":
            self.yearViewController = (segue.destination as! YearViewController)
            self.yearViewController.reloadCalendar(calendarYears: self.calendarYears)
            break
        default:
           break
        }

    }
    
    @objc func switchSegment(_ notification: Notification) {
        let selectedDate: Date? = (notification.userInfo?["date"] ?? nil) as? Date
        let switchToView: String? = notification.userInfo?["view"] as? String
        switch (switchToView)
        {
        case "d":
            self.calendarViewSegmentedControl.selectedSegmentIndex = 0
            break
        case "w":
            self.calendarViewSegmentedControl.selectedSegmentIndex = 1
            break
        case "m":
            self.monthViewController.scrollToDate(date: selectedDate)
            self.calendarViewSegmentedControl.selectedSegmentIndex = 2
            break
        case "y":
            self.calendarViewSegmentedControl.selectedSegmentIndex = 3
            break
        default:
           break
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollToDate"), object: nil, userInfo: ["date": selectedDate])
        self.calendarViewSegmentedControl.sendActions(for: UIControl.Event.valueChanged)
        
    }
    
    
}
