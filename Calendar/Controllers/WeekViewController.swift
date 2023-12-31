//
//  WeekViewController.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//
//  To control the functionalities of Week View

import UIKit
import SwiftUI
import CoreData

class WeekViewController: CalendarUIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    private var displayWeeks: [CalendarWeek] = []
    private var isLoaded = false
    private var isScrolled = false
    //private var selectedDate: Date = Date()
//    private var allEvents: [NSManagedObject] = []
    var selectedRow: Int? = 0
    let rowHeight: CGFloat = 80.0
    
    let calendarHelper = CalendarHelper()
    
    lazy var collectionViewFlowLayout : WeekCollectionViewFlowLayout = {
        let layout = WeekCollectionViewFlowLayout()
        //layout.parentLoadNextBatch = loadNextBatch
        //layout.setSelectedCell = setSelectedCell
        //layout.parentLoadPrevBatch = loadPrevBatch
        return layout
    }()

    lazy var collectionViewDataSource: WeekCollectionViewDataSource = {
        let collectionView = WeekCollectionViewDataSource(calendarWeeks: self.displayWeeks)
        return collectionView
    }()
    
    // MARK: - Init

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let events = EventListController().getEventsByDate(currentDate: self.selectedDate)
        
        if (segue.identifier == "weeklyEventCellTapped") {
            let destinationVC = segue.destination as! EventDetailsController

            if selectedRow != nil {
                destinationVC.event = events[self.selectedRow!]
                destinationVC.eventID = events[self.selectedRow!].objectID
            }
        }
        
        if segue.identifier == "weekToEventListSegue" {
            let destinationVC = segue.destination as! EventListController
            destinationVC.eventStartDate = self.displayWeeks[0].calendarDays.first?.date
            destinationVC.eventEndDate = self.displayWeeks[0].calendarDays.last?.date
            destinationVC.isForWeekView = true
        }
    }
    
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
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()
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
        self.tableView.rowHeight = rowHeight
        self.tableView.estimatedRowHeight = rowHeight
    }
    
    // Create gesture for swipping to different dates
    func initGestureRecognizer(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.collectionView.addGestureRecognizer(tap)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.collectionView.addGestureRecognizer(leftSwipe)
        self.collectionView.addGestureRecognizer(rightSwipe)
        
        let leftDaySwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleDaySwipe(_:)))
        let rightDaySwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleDaySwipe(_:)))
        leftDaySwipe.direction = .left
        rightDaySwipe.direction = .right
        self.tableView.addGestureRecognizer(leftDaySwipe)
        self.tableView.addGestureRecognizer(rightDaySwipe)
         
    }
    
    // MARK: - Actions
    
    // Tap to change the selected date or show the event list for the week
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            if indexPath.item > 0 {
                self.selectedDate = self.displayWeeks[0].calendarDays[indexPath.item - 1].date!
                NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollToDate"), object: nil, userInfo: ["date": self.selectedDate as Any])
                NotificationCenter.default.post(name: Notification.Name(rawValue: "setLastSelectedDate"), object: nil, userInfo: ["date": self.calendarHelper.removeTimeStamp(fromDate: self.selectedDate) as Any])
                self.setSelectedCell()
            }
            else {
                self.performSegue(withIdentifier: "weekToEventListSegue", sender: self)
            }
        }
    }
    
    // Swipe to change week
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .left {
            self.selectedDate = self.calendarHelper.addDay(date: self.selectedDate, n: 7)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "setLastSelectedDate"), object: nil, userInfo: ["date": self.calendarHelper.removeTimeStamp(fromDate: self.selectedDate) as Any])
            
            UIView.transition(with: self.view,
                              duration: 0.3,
                              options: .transitionCurlUp,
                              animations: {
                self.reloadCalendar(newSelectedDate: self.selectedDate) })
            
        } else if sender.direction == .right {
            self.selectedDate = self.calendarHelper.addDay(date: self.selectedDate, n: -7)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "setLastSelectedDate"), object: nil, userInfo: ["date": self.calendarHelper.removeTimeStamp(fromDate: self.selectedDate) as Any])
            
            UIView.transition(with: self.view,
                              duration: 0.3,
                              options: .transitionCurlDown,
                              animations: {
                self.reloadCalendar(newSelectedDate: self.selectedDate) })
        }
    }
    
    // Swipe to change day
    @objc func handleDaySwipe(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .left {
            self.selectedDate = self.calendarHelper.addDay(date: self.selectedDate, n: 1)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "setLastSelectedDate"), object: nil, userInfo: ["date": self.calendarHelper.removeTimeStamp(fromDate: self.selectedDate) as Any])
            
            UIView.transition(with: self.view,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                self.reloadCalendar(newSelectedDate: self.selectedDate) })
            
        } else if sender.direction == .right {
            self.selectedDate = self.calendarHelper.addDay(date: self.selectedDate, n: -1)
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "setLastSelectedDate"), object: nil, userInfo: ["date": self.calendarHelper.removeTimeStamp(fromDate: self.selectedDate) as Any])
            
            UIView.transition(with: self.view,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                self.reloadCalendar(newSelectedDate: self.selectedDate) })
        }
    }
    
    // MARK: - Helper functions
    
    // Move the selected cell border
    func setSelectedCell() {
        if self.isLoaded {
            for indexPath in self.collectionView.indexPathsForVisibleItems {
                self.collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.appColor(.surface)?.cgColor
            }
            
            if let idx = self.displayWeeks[0].calendarDays.firstIndex(where: {$0.date == self.selectedDate}) {
                self.collectionView.cellForItem(at: IndexPath(row:idx+1, section:0))?.layer.borderColor = UIColor.appColor(.onSurface)?.cgColor
                self.collectionViewDataSource.setSelectedCell(newSelectedDate: self.selectedDate)
                self.collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
            }
            self.tableView.reloadData()
        }
    }
    
    func reloadCalendar(newSelectedDate: Date) {
        self.selectedDate = newSelectedDate
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setLastSelectedDate"), object: nil, userInfo: ["date": self.calendarHelper.removeTimeStamp(fromDate: self.selectedDate) as Any])
        self.displayWeeks = self.collectionViewDataSource.loadDisplayWeek(newSelectedDate: self.selectedDate)
        if isScrolled {
            self.collectionView.reloadData()
            self.tableView.reloadData()
        }
        isScrolled = true
    }
    
    func scrollToToday(animated: Bool = true) {
        self.scrollToDate(date: self.calendarHelper.getCurrentDate(), animated: animated)
        self.isLoaded = true
    }
    
    override func scrollToDate(date: Date?, animated: Bool = true) {
        let idx = self.displayWeeks[0].calendarDays.firstIndex(
            where: {($0.date == date!)
            }) ?? -1
        
        if idx == -1 {
            if animated {
                if self.selectedDate > date! {
                    UIView.transition(with: self.view,
                                      duration: 0.3,
                                      options: .transitionCurlDown,
                                      animations: {
                        self.reloadCalendar(newSelectedDate: date!) })
                }
                else{
                    UIView.transition(with: self.view,
                                      duration: 0.3,
                                      options: .transitionCurlUp,
                                      animations: {
                        self.reloadCalendar(newSelectedDate: date!) })
                }
            }
            else{
                self.reloadCalendar(newSelectedDate: date!)
            }
        }
        else {
            self.selectedDate = date!
            self.setSelectedCell()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "setLastSelectedDate"), object: nil, userInfo: ["date": self.calendarHelper.removeTimeStamp(fromDate: self.selectedDate) as Any])
        }
    }
    
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
    
    // MARK: - Standard Tableview methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventListController().getEventsByDate(currentDate: self.selectedDate).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let event = EventListController().getEventsByDate(currentDate: self.selectedDate, sortedByAllDay: true)[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myWeeklyEventCell", for: indexPath) as! EventCell
        
        cell.initCell(indexPath: indexPath)
        
        
        // Set text
        let eventTitle: String = event.value(forKeyPath: Constants.EventsAttribute.titleAttribute) as? String ?? " "
        let eventType: String = event.value(forKeyPath: Constants.EventsAttribute.classTypeAttribute) as? String ?? " "
        let text = ((eventType == " ") ? "" : ("\n" + eventType))
        
        let attributedText = NSMutableAttributedString(string: eventTitle)
        attributedText.addAttribute(.foregroundColor,
                                    value: UIColor.appColor(.onSurface) as Any,
                                    range: attributedText.getRangeOfString(textToFind: eventTitle))
        attributedText.addAttribute(.font,
                                    value: UIFont.boldSystemFont(ofSize: UIFont.appFontSize(.collectionViewCell) ?? 11),
                                    range: attributedText.getRangeOfString(textToFind: eventTitle))
        
        let attributedText2 = NSMutableAttributedString(string: text)
        attributedText2.addAttribute(.foregroundColor,
                                    value: UIColor.appColor(.secondary) as Any,
                                    range: attributedText2.getRangeOfString(textToFind: text))
        attributedText2.addAttribute(.font,
                                    value: UIFont.systemFont(ofSize: UIFont.appFontSize(.tableViewCellInfo) ?? 11),
                                    range: attributedText2.getRangeOfString(textToFind: text))
        
        attributedText.append(attributedText2)
        
        cell.colorBar.backgroundColor = EventListController().getCalendarColor(name: event.value(forKeyPath: Constants.EventsAttribute.calendarAttribute) as? String ?? "None")
        cell.titleLabel.attributedText = attributedText
        
        if (event.value(forKeyPath: Constants.EventsAttribute.allDayAttribute) as? Bool ?? false == false) {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYYMMDD"
            if let fromDate = event.value(forKeyPath: "startDate") as? Date {
                if let toDate = event.value(forKeyPath: "endDate") as? Date {
                    if formatter.string(from: fromDate) == formatter.string(from: toDate) {
                        formatter.dateFormat = "HH:mm"
                    }
                    else {
                        formatter.dateFormat = "d MMM y, HH:mm"
                    }
                }
            }
        cell.startDateLabel.text = formatter.string(from: event.value(forKeyPath: "startDate") as! Date)
        cell.endDateLabel.text = formatter.string(from: event.value(forKeyPath: "endDate") as! Date)
        }
        else{
            cell.startDateLabel.text = "All-Day"
            cell.startDateLabel.textColor = .white
            cell.endDateLabel.text = ""
            
            cell.titleLabel.textColor = .white
            if (indexPath.row % 2 == 0) {
                cell.backgroundColor = UIColor.red.withAlphaComponent(0.5)
            }
            else {
                cell.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            }
        }
        if eventType == Constants.ClassTypes.classAssignment {
            cell.startDateLabel.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        self.performSegue(withIdentifier: "weeklyEventCellTapped", sender: self)
    }
}
