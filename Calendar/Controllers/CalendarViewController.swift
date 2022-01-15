import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var monthContainerView: UIView!
    @IBOutlet weak var yearContainerView: UIView!
    @IBOutlet weak var weekContainerView: UIView!
    @IBOutlet weak var calendarViewSegmentedControl: UISegmentedControl!
    
    var monthViewController: MonthViewController!
    var yearViewController: YearViewController!
    
    let calendarHelper = CalendarHelper()
    private var calendarYears: [CalendarYear] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.calendarYears = setCalendar()
        //yearContainerView.reloadCalendar(calendarYears: self.calendarYears)
        
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
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (self.calendarViewSegmentedControl.selectedSegmentIndex)
        {
              case 0:
              {
                    UIView1 *view1 = (UIView1 *)segue.destinationViewController;
                    // do other customization if needed
                    break;
              }
              case 1:
              {
                    UIView2 *view2 = (UIView2 *)segue.destinationViewController;
                    // do other customization if needed
                    break;
              }
              default:
                   break;
        }
        // get a reference to the embedded PageViewController on load
        if let vc = segue.destination as? MonthViewController,
            segue.identifier == "infoViewEmbedSegue" {
            self.infos = vc
            // if you already have your data object
            self.infos.otherUser = theDataDict
        }

        if let vc = segue.destination as? YearViewController,
            segue.identifier == "feedViewEmbedSegue" {
            self.feeds = vc
            // if you already have your data object
            self.feeds.otherUser = theDataDict
        }
        // etc

    }
     */
    
}
