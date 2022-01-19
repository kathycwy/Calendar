import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var monthContainerView: UIView!
    @IBOutlet weak var yearContainerView: UIView!
    @IBOutlet weak var weekContainerView: UIView!
    @IBOutlet weak var calendarViewSegmentedControl: UISegmentedControl!
    
    var freshLaunch: Bool = true
    var weekViewController: WeekViewController!
    var monthViewController: MonthViewController!
    var yearViewController: YearViewController!
    
    let calendarHelper = CalendarHelper()
    private var calendarYears: [CalendarYear] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weekContainerView.alpha = 0.0
        monthContainerView.alpha = 1.0
        yearContainerView.alpha = 0.0
    }
    
    @IBAction func didChangeIndex(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            weekContainerView.alpha = 0.0
            monthContainerView.alpha = 0.0
            yearContainerView.alpha = 0.0
        case 1:
            weekContainerView.alpha = 1.0
            monthContainerView.alpha = 0.0
            yearContainerView.alpha = 0.0
        case 2:
            weekContainerView.alpha = 0.0
            monthContainerView.alpha = 1.0
            yearContainerView.alpha = 0.0
        case 3:
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
            //self.monthViewController = (segue.destination as! MonthViewController)
            //self.monthViewController.reloadCalendar()
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
    
    
}
