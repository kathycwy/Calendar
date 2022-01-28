import UIKit

class CalendarViewController: CalendarUIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dayContainerView: UIView!
    @IBOutlet weak var monthContainerView: UIView!
    @IBOutlet weak var yearContainerView: UIView!
    @IBOutlet weak var weekContainerView: UIView!
    @IBOutlet weak var calendarViewSegmentedControl: UISegmentedControl!
    @IBOutlet var sideMenuView: UIView!
    @IBOutlet var sideMenuTableView: UITableView!
    
    var freshLaunch: Bool = true
    var dayViewController: DayViewController!
    var weekViewController: WeekViewController!
    var monthViewController: MonthViewController!
    var yearViewController: YearViewController!
    
    let calendarHelper = CalendarHelper()
    private var calendarYears: [CalendarYear] = []
    
    var arrLabels = ["Search", "Preferences"]
    var isSideMenuOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuView.isHidden = true
        sideMenuTableView.backgroundColor = UIColor.systemGroupedBackground
        isSideMenuOpen = false
        
        self.sideMenuTableView.layer.cornerRadius = 10.0
        
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
            break
        case "WeekViewSegue":
            self.weekViewController = (segue.destination as! WeekViewController)
            //self.weekViewController.reloadCalendar(calendarYears: self.calendarYears)
            self.weekViewController.reloadCalendar(newSelectedDate: calendarHelper.getCurrentDate())
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
        NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollToDate"), object: nil, userInfo: ["date": selectedDate as Any])
        self.calendarViewSegmentedControl.sendActions(for: UIControl.Event.valueChanged)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLabels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let search:SearchTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "search") as! SearchTableViewController
            self.navigationController?.pushViewController(search, animated: true)
            break
        case 1:
            let search: PreferencesViewController = self.storyboard?.instantiateViewController(withIdentifier: "preferences") as! PreferencesViewController
            self.navigationController?.pushViewController(search, animated: true)
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.label.text = arrLabels[indexPath.row]
        cell.label.font = cell.label.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 13)
        cell.label.textColor = .appColor(.primary)
        var image = UIImage(systemName: "magnifyingglass")
        switch (indexPath.row)
        {
        case 0:
            image = UIImage(systemName: "magnifyingglass")
            break
        case 1:
            image = UIImage(systemName: "gearshape")
            break
        default:
           break
        }
        cell.icon.image = image?.tinted(with: UIColor.appColor(.primary)!)

        return cell
    }
    
    @IBAction func sideMenuButton(_ sender: Any) {
        sideMenuView.isHidden = false
        sideMenuTableView.isHidden = false
        self.view.bringSubviewToFront(sideMenuView)
        if !isSideMenuOpen {
            isSideMenuOpen = true
            sideMenuView.frame = CGRect(x: 0, y: 0, width: 0, height: 352)
            sideMenuTableView.frame = CGRect(x: 0, y: 0, width: 0, height: 352)
            UIView.animate(withDuration: 0.3) {
                self.sideMenuView.frame = CGRect(x: 0, y: 0, width: 209, height: 352)
                self.sideMenuTableView.frame = CGRect(x: 0, y: 0, width: 209, height: 352)
            }
        } else {
            sideMenuView.isHidden = true
            sideMenuTableView.isHidden = true
            isSideMenuOpen = false
            sideMenuView.frame = CGRect(x: 0, y: 0, width: 209, height: 352)
            sideMenuTableView.frame = CGRect(x: 0, y: 0, width: 209, height: 352)
            UIView.animate(withDuration: 0.3) {
                self.sideMenuView.frame = CGRect(x: 0, y: 0, width: 0, height: 352)
                self.sideMenuTableView.frame = CGRect(x: 0, y: 0, width: 0, height: 352)
            }
        }
        
    }
    
    override func reloadUI() {
        super.reloadUI()
        self.sideMenuTableView.reloadData()
    }
    
}
