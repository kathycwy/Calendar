//
//  ViewController.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import UIKit
import SwiftUI
import CoreData

class WeeklyEventCell: UITableViewCell {
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventStartDate: UILabel!
    @IBOutlet weak var eventEndDate: UILabel!
}

class WeekViewController: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    private var calendarWeeks: [CalendarWeek] = []
    private var displayWeeks: [CalendarWeek] = []
    private var isLoaded = false
    private var isScrolled = false
    private var todayIndexPath: IndexPath? = nil
    private var selectedDate: Date = Date()
    private var selectedCurrentDate: Date = Date()
    private var selectedIndexPath: IndexPath? = nil
    private var allEvents: [NSManagedObject] = []
    var selectedRow: Int? = 0
    
    let calendarHelper = CalendarHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCollectionView()
        self.initTableView()
        self.initView()
        self.initGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(scrollToToday(_:)), name: Notification.Name(rawValue: "scrollToToday"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToDate(_:)), name: Notification.Name(rawValue: "scrollToDate"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if isScrolled && self.collectionView.visibleCells.count > 0 {
            self.collectionView.collectionViewLayout.invalidateLayout()
            //self.scrollToDate(date: self.selectedDate)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isScrolled && self.collectionView.visibleCells.count > 0 {
            //self.scrollToToday(animated: false)
            self.isLoaded = true
            self.collectionViewFlowLayout.setLoaded(isLoaded: self.isLoaded)
        }
        self.scrollToToday(animated: false)
    }
    
    private func initView(){
        self.view.tintColor = UIColor.appColor(.primary)
    }
    
    private func initCollectionView(){
        self.collectionView.isPrefetchingEnabled = true
        self.collectionView.dataSource = self.collectionViewDataSource
        self.collectionView.delegate = self.collectionViewFlowLayout
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.alwaysBounceVertical = false
        self.collectionView.backgroundColor = UIColor.appColor(.background)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.isPagingEnabled = false
        //self.collectionView.contentInsetAdjustmentBehavior = .never
        //if #available(iOS 10.0, *) {self.collectionView.isPrefetchingEnabled = false}
        self.collectionView.isScrollEnabled = false
    }
    
    private func initTableView(){
        self.tableView.isPrefetchingEnabled = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor.appColor(.background)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func initGestureRecognizer(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.collectionView.addGestureRecognizer(tap)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.collectionView.addGestureRecognizer(leftSwipe)
        self.collectionView.addGestureRecognizer(rightSwipe)
         
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            if indexPath.item > 0 {
                //self.setSelectedCell(indexPath: indexPath)
                let calendarDay = self.collectionViewDataSource.getCalendarDayByIndexPath(indexPath: indexPath)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollToDate"), object: nil, userInfo: ["date": calendarDay?.date as Any])
            }
        }
    }
        
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .left {
            let contentOffsetX = collectionView.contentOffset.x + collectionView.frame.width - collectionViewFlowLayout.minimumInteritemSpacing
            UIView.animate(withDuration: 0.6){
                let newOffset = CGPoint(x: contentOffsetX, y: self.collectionView.contentOffset.y)
                self.collectionView.setContentOffset(newOffset, animated: true)
            }
            
        } else if sender.direction == .right {
            let contentOffsetX = collectionView.contentOffset.x - collectionView.frame.width + collectionViewFlowLayout.minimumInteritemSpacing
            UIView.animate(withDuration: 0.6){
                let newOffset = CGPoint(x: contentOffsetX, y: self.collectionView.contentOffset.y)
                self.collectionView.setContentOffset(newOffset, animated: true)
            }
        }
    }
     
    
    lazy var collectionViewFlowLayout : WeekCollectionViewFlowLayout = {
        let layout = WeekCollectionViewFlowLayout()
        layout.parentLoadNextBatch = loadNextBatch
        layout.setSelectedCell = setSelectedCell
        layout.parentLoadPrevBatch = loadPrevBatch
        return layout
    }()

    lazy var collectionViewDataSource: WeekCollectionViewDataSource = {
        let collectionView = WeekCollectionViewDataSource(calendarWeeks: self.calendarWeeks)
        return collectionView
    }()
    
    func calculateIndexPathsToReload(from newcalendarMonths: [CalendarMonth]) -> [IndexPath] {
        let startIndex = self.calendarWeeks.count - newcalendarMonths.count
        let endIndex = startIndex + newcalendarMonths.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
//
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x:0, y:0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    func loadNextBatch(){
        self.displayWeeks = self.collectionViewDataSource.getDisplayWeeks()
        let lastCalendarWeeks = self.displayWeeks.count
        
        self.displayWeeks = self.collectionViewDataSource.getExtendedDisplayWeeks(numberOfWeeks: 1)
        
        var indexSet:[Int] = []
        var paths = [IndexPath]()
        for week in lastCalendarWeeks ..< self.displayWeeks.count {
            indexSet.append(week)
            for day in 0 ..< self.displayWeeks[week].calendarDays.count {
                let indexPath = IndexPath(row: day, section: week)
                paths.append(indexPath)
            }
        }
        collectionView.performBatchUpdates({ () -> Void in
            self.collectionView.insertSections(IndexSet(indexSet))
            self.collectionView.insertItems(at: paths)
        }, completion:nil)
        
    }
    
    func loadPrevBatch(){
        self.displayWeeks = self.collectionViewDataSource.getDisplayWeeks()
        let lastCalendarWeeks = self.displayWeeks.count
        
        self.displayWeeks = self.collectionViewDataSource.getExtendedDisplayWeeks(numberOfWeeks: -1)
        
        var indexSet:[Int] = []
        var paths = [IndexPath]()
        for week in 0 ..< self.displayWeeks.count - lastCalendarWeeks {
            indexSet.append(week)
            for day in 0 ..< self.displayWeeks[week].calendarDays.count {
                let indexPath = IndexPath(row: day, section: week)
                paths.append(indexPath)
            }
        }
        collectionView.performBatchUpdates({ () -> Void in
            self.collectionView.insertSections(IndexSet(indexSet))
            self.collectionView.insertItems(at: paths)
        }, completion:nil)
        
    }
    
    func setSelectedCell(indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        
        if let prevIndexPath = self.collectionViewDataSource.getSelectedIndexPath() {
            self.collectionView.cellForItem(at: prevIndexPath)?.layer.borderColor = UIColor.appColor(.surface)?.cgColor
            self.collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.appColor(.onSurface)?.cgColor
        }
        self.displayWeeks = self.collectionViewDataSource.getDisplayWeeks()
        let rollingWeekNumber = self.displayWeeks[indexPath.section].rollingWeekNumber
        if let date = self.displayWeeks[indexPath.section].calendarDays[indexPath.item - 1].date{
            if let cell: WeekDayCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: indexPath.section)) as? WeekDayCell{
                cell.dayOfWeekLabel.text = String(self.calendarHelper.getYear(for: date))
                cell.dateLabel.text = self.calendarHelper.monthStringShort(date: date)
            }
        }
        
        self.collectionViewDataSource.setSelectedCell(item: indexPath.item, rollingWeekNumber: rollingWeekNumber)
        
        if let section = self.displayWeeks.first(where: {$0.rollingWeekNumber == rollingWeekNumber}) {
            if let selectedDateToSet = section.calendarDays[indexPath.item - 1].date {
                self.selectedCurrentDate = selectedDateToSet
            }
        }
        
        tableView.reloadData()
    }
    
    func reloadCalendar(calendarYears: [CalendarYear]) {
        self.calendarWeeks = self.collectionViewDataSource.getInitCalendar(calendarYears: calendarYears)
    }
    
    func scrollToToday(animated: Bool = true){
        self.displayWeeks = self.collectionViewDataSource.getDisplayWeeks()
        if todayIndexPath == nil {
            todayIndexPath = self.collectionViewDataSource.getSelectedIndexPath()
        }
        self.scrollToDate(date: self.calendarHelper.getCurrentDate(), indexPath: todayIndexPath, animated: animated)
    }
    
    func scrollToDate(date: Date?, indexPath: IndexPath! = nil, animated: Bool = true){
        var newSelectedIP: IndexPath! = indexPath
        if newSelectedIP == nil{
            if date != nil {
                self.selectedDate = date!
            }
            let year = calendarHelper.getYear(for: self.selectedDate)
            let month = calendarHelper.getMonth(for: self.selectedDate)
            let weekNumber = calendarHelper.weekOfYear(date: self.selectedDate)
            self.displayWeeks = self.collectionViewDataSource.getDisplayWeeks()
            
            var idx = self.displayWeeks.firstIndex(
                where: {($0.month == month || $0.toMonth == month) &&
                    ($0.year == year || $0.toYear == year) &&
                    $0.weekNumber == weekNumber &&
                    $0.calendarDays.contains(where: {$0.date == self.selectedDate})
                }) ?? -1
            
            while idx == -1 {
                // Extend and load the date
                self.loadNextBatch()
                idx = self.displayWeeks.firstIndex(
                    where: {($0.month == month || $0.toMonth == month) &&
                        ($0.year == year || $0.toYear == year) &&
                        $0.weekNumber == weekNumber &&
                        $0.calendarDays.contains(where: {$0.date == self.selectedDate})
                    }) ?? -1
            }
            let item = self.displayWeeks[idx].calendarDays.firstIndex(where: {$0.date == self.selectedDate}) ?? 0
            newSelectedIP = IndexPath(item: item + 1, section: idx)
        }
        self.setSelectedCell(indexPath: newSelectedIP)
        
        if let attributes = self.collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: newSelectedIP.section)) {
            var offsetY = attributes.frame.origin.y - self.collectionView.contentInset.top
            var offsetX = attributes.frame.origin.x - self.collectionView.contentInset.left
            if #available(iOS 11.0, *) {
                offsetY -= self.collectionView.safeAreaInsets.top
                offsetX -= self.collectionView.safeAreaInsets.left
            }
            self.collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated) // or animated: false
            isScrolled = true
        }
        else {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: newSelectedIP.section), at: [.top, .left], animated: animated)
            isScrolled = true
        }
    }
    
    // Number of months shown
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventListController().getEventsByDate(currentDate: self.selectedCurrentDate).count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let event = EventListController().getEventsByDate(currentDate: self.selectedCurrentDate)[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myWeeklyEventCell", for: indexPath) as! WeeklyEventCell
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, HH:mm"

        cell.eventTitle.text = event.value(forKeyPath: "title") as? String
        cell.eventStartDate.text = formatter.string(from: event.value(forKeyPath: "startDate") as! Date)
        cell.eventEndDate.text = formatter.string(from: event.value(forKeyPath: "endDate") as! Date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        self.performSegue(withIdentifier: "weeklyEventCellTapped", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "weeklyEventCellTapped") {
            let destinationVC = segue.destination as! EventDetailsController

            if selectedRow != nil {
                destinationVC.rowIndex = self.selectedRow
                destinationVC.event = self.allEvents[self.selectedRow!]
                destinationVC.eventID = self.allEvents[self.selectedRow!].objectID
            }
        }
    }

    /*
    @IBAction func prevMonth(_ sender: Any) {
        selectedDate = calendarHelper.previousMonth(date: selectedDate)
        reloadCalendar()
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = calendarHelper.nextMonth(date: selectedDate)
        reloadCalendar()
    }
     */
    @objc func scrollToToday(_ notification: Notification) {
        scrollToToday()
    }
    
    @objc func scrollToDate(_ notification: Notification) {
       if let selectedDate = (notification.userInfo?["date"] ?? nil) as? Date{
           if self.calendarHelper.getYear(for: selectedDate) >= 1970{
               self.scrollToDate(date: selectedDate, animated: false)
           }
       }
    }
}
