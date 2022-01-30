//
//  DayViewController.swift
//  Calendar
//
//  Created by C Chan on 22/1/2022.
//

import UIKit
import SwiftUI
import CoreData

class DayViewController: CalendarUIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var hourTableView: UITableView!
    
    var selectedDay: Date = Date()
    var calendarDays: [CalendarDay] = []
    var hours = [Int]()
    let rowHeight: CGFloat = 70.0
    var viewTags: [Int] = []
    var selectedEvent: NSManagedObject? = nil
    
    let calendarHelper = CalendarHelper()
    var nRef = 1
    
    // MARK: - Init

    override func loadView() {
        super.loadView()
        
        hourTableView.rowHeight = rowHeight
        hourTableView.estimatedRowHeight = rowHeight
        hourTableView.separatorStyle = .none
        
        // As buffer region for scrolling
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: rowHeight)
        hourTableView.tableFooterView = footerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hourTableView.register(DayHeader.self, forHeaderFooterViewReuseIdentifier: "dayHeader")
        initTime()
        initGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDayView()
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToToday(_:)), name: Notification.Name(rawValue: "scrollToToday"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToDate(_:)), name: Notification.Name(rawValue: "scrollToDate"), object: nil)
    }
    
    func initTime() {
         for hour in 0 ... 23 {
             hours.append(hour)
         }
    }
    
    func initGestureRecognizer(){
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.hourTableView.addGestureRecognizer(leftSwipe)
        self.hourTableView.addGestureRecognizer(rightSwipe)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "dayToEventDetailSegue") {
            let destinationVC = segue.destination as! EventDetailsController
            
            if let event = selectedEvent {
                destinationVC.event = event
                destinationVC.eventID = event.objectID
            }
        }
    }
    
    // MARK: - Actions

    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .left {
            self.selectedDay = self.calendarHelper.addDay(date: self.selectedDay, n: 1)
            UIView.transition(with: self.hourTableView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { self.setDayView() })
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollToDate"), object: nil, userInfo: ["date": self.selectedDay as Any])
            
        }
        else if sender.direction == .right {
            self.selectedDay = self.calendarHelper.addDay(date: self.selectedDay, n: -1)
            UIView.transition(with: self.hourTableView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { self.setDayView() })
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollToDate"), object: nil, userInfo: ["date": self.selectedDay as Any])
        }
    }
    
    @objc func eventButtonClicked(_ sender: EventButton) {
        self.selectedEvent = sender.event
        self.performSegue(withIdentifier: "dayToEventDetailSegue", sender: self)
    }
    
    // MARK: - Helper functions

    func formatHour(hour: Int) -> String {
        return String(format: "%02d:%02d", hour, 0)
    }
    
    func scrollToToday(){
        self.selectedDay = self.calendarHelper.getCurrentDate()
        self.setDayView()
    }
    
    func scrollToDate(date: Date){
        self.selectedDay = date
        self.setDayView()
    }
    
    @objc func scrollToToday(_ notification: Notification) {
        scrollToToday()
    }
    
    @objc func scrollToDate(_ notification: Notification) {
       if let selectedDate = (notification.userInfo?["date"] ?? nil) as? Date{
           self.scrollToDate(date: selectedDate)
       }
    }
    
    override func reloadUI() {
        super.reloadUI()
        self.setDayView(scroll: false)
        self.hourTableView.headerView(forSection: 0)?.contentView.backgroundColor = .appColor(.primary)
    }

    func setDayView(scroll: Bool = true) {
        // Remove all eventButtons
        for tag in viewTags {
            if let oldButton = view.viewWithTag(tag) as! EventButton? {
                oldButton.removeFromSuperview()
            }
        }
        
        // Init and reload
        viewTags = []
        hourTableView.reloadData()
        
        /*if scroll {
            if !self.hourTableView.visibleCells.isEmpty {
                self.hourTableView.scrollToRow(at: IndexPath(item: 8, section: 0), at: .top, animated: false)
            }
        }*/
    }
    
    // MARK: - Standard Tableview methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hours.count + 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.hourTableView.dequeueReusableHeaderFooterView(withIdentifier: "dayHeader") as! DayHeader
        header.dayLabel.text = self.calendarHelper.dateStringFull(date: self.selectedDay)
        header.dowLabel.text = self.calendarHelper.weekDayAsString(date: self.selectedDay)
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell", for: indexPath) as! DayCell
        cell.initCell()
        
        // Set up label
        if indexPath.row > 0 {
            cell.topTimeLabel.text = String(indexPath.row - 1) + ":00"
        }
        cell.bottomTimeLabel.text = String(indexPath.row) + ":00"
        
        // Shift label otherwise cannot shown properly
        if indexPath.row == hours.count {
            let rect: CGRect = cell.bottomTimeLabel.frame
            cell.bottomTimeLabel.frame = rect.offsetBy(dx: 0, dy: -4)
        }
        
        if indexPath.row > 0 {
            let events = EventListController().getEventsByStartDateAndTime(date: self.selectedDay, hour: hours[indexPath.row - 1])
            self.insertEvents(indexPath: indexPath, events: events)
        }
        
        return cell
    }
    
    func insertEvents(indexPath: IndexPath, events: [NSManagedObject]) {
        let totalEvent = events.count
        let fullWidth = hourTableView.frame.width - 120
        let buffer = 10
        
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        
        var index = 0
        
        if let startDateTime = self.calendarHelper.getStartOfDayTime(date: self.selectedDay) {
            if let endDateTime = self.calendarHelper.getEndOfDayTime(date: self.selectedDay) {
                for event in events {
                    if let startDate = event.value(forKeyPath: "startDate") as? Date {
                        if let endDate = event.value(forKeyPath: "endDate") as? Date {
                            // All day event
                            if (event.value(forKeyPath: Constants.EventsAttribute.allDayAttribute) as? Bool ?? true) {
                              let cellWidth = (fullWidth - CGFloat(buffer * (totalEvent - 1))) / CGFloat(totalEvent)
                              let height = rowHeight
                              let offsetY = CGFloat(rowHeight * -1)
                              let offsetX = (cellWidth * CGFloat(index)) + CGFloat(buffer * index)
                              insertEvent(indexPath: indexPath, offsetX: offsetX, offsetY: offsetY, width: cellWidth, height: height, event: event, startDate: max(startDateTime, startDate), endDate: min(endDateTime, endDate), index: index)
                            }
                            else {
                              let elapsedTime = min(endDateTime, endDate).timeIntervalSince(max(startDateTime, startDate))
                              
                              let minutes = CGFloat((formatter.string(from: max(startDateTime, startDate)) as NSString).floatValue)
                              
                              let cellWidth = (fullWidth - CGFloat(buffer * (totalEvent - 1))) / CGFloat(totalEvent)
                              let height = max(rowHeight / 3600 * elapsedTime, 30)
                              let offsetY = rowHeight * (minutes / 60)
                              let offsetX = (cellWidth * CGFloat(index)) + CGFloat(buffer * index)
                              insertEvent(indexPath: indexPath, offsetX: offsetX, offsetY: offsetY, width: cellWidth, height: height, event: event, startDate: max(startDateTime, startDate), endDate: min(endDateTime, endDate), index: index)
                            }
                        }
                    }
                    index = index + 1
                }
            }
        }
    }
    
    func insertEvent(indexPath: IndexPath, offsetX: CGFloat, offsetY: CGFloat, width: CGFloat, height: CGFloat, event: NSManagedObject, startDate: Date, endDate: Date, index: Int)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        let start = formatter.string(from: startDate)
        let end = formatter.string(from: endDate)
        
        let eventTitle: String = event.value(forKeyPath: "title") as? String ?? " "
        let eventLoc: String = event.value(forKeyPath: "location") as? String ?? " "
        let eventDate: String = start + " - " + end
        let text = eventTitle + "\n" + eventDate + "\n" + eventLoc
        var eventColour: UIColor? = nil
        if let attr = event.value(forKeyPath: Constants.EventsAttribute.calendarAttribute) {
            if let str = attr as? String {
                switch str {
                case Constants.CalendarConstants.calendarPersonal:
                    eventColour = UIColor.appColor(Constants.CalendarConstants.calendarPersonal)
                    break
                case Constants.CalendarConstants.calendarSchool:
                    eventColour = UIColor.appColor(Constants.CalendarConstants.calendarSchool)
                    break
                case Constants.CalendarConstants.calendarWork:
                    eventColour = UIColor.appColor(Constants.CalendarConstants.calendarWork)
                    break
                default:
                    break
                }
            }
        }
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.foregroundColor,
                                    value: eventColour ?? UIColor.appColor(.onPrimary) as Any,
                                    range: attributedText.getRangeOfString(textToFind: text))
        attributedText.addAttribute(.font,
                                    value: UIFont.boldSystemFont(ofSize: (UIFont.appFontSize(.collectionViewCell) ?? 11) - 2),
                                    range: attributedText.getRangeOfString(textToFind: eventTitle))
        attributedText.addAttribute(.font,
                                    value: UIFont.systemFont(ofSize: UIFont.appFontSize(.innerCollectionViewHeader) ?? 11),
                                    range: attributedText.getRangeOfString(textToFind: eventDate))
        attributedText.addAttribute(.font,
                                    value: UIFont.systemFont(ofSize: UIFont.appFontSize(.innerCollectionViewHeader) ?? 11),
                                    range: attributedText.getRangeOfString(textToFind: eventLoc))
        
        let x_loc = 80
        let rectCellTable = hourTableView.rectForRow(at: indexPath)
        let rectCellView = view.convert(rectCellTable, to: hourTableView.superview)
        
        let tag = indexPath.row * 100 + index
        
        if let oldButton = view.viewWithTag(tag) as! EventButton? {
            oldButton.removeFromSuperview()
        }

        let frame = CGRect(x: CGFloat(x_loc) + offsetX, y: rectCellView.origin.y + offsetY, width: width, height: height)
        
        let eventButton: EventButton = {
            let eventButton = EventButton()
            eventButton.event = event
            eventButton.displayedStartDate = startDate
            eventButton.displayedEndDate = endDate
            eventButton.frame = frame
            eventButton.backgroundColor = eventColour?.withAlphaComponent(0.3) ?? .appColor(.primary)?.withAlphaComponent(0.6)
            eventButton.titleLabel?.numberOfLines = 0
            eventButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            eventButton.setAttributedTitle(attributedText, for: .normal)
            eventButton.layer.cornerRadius = 2
            eventButton.tag = tag
            eventButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            eventButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
            eventButton.addTarget(self, action: #selector(self.eventButtonClicked(_:)), for: .touchUpInside)
            return eventButton
        }()
        
        hourTableView.addSubview(eventButton)
        viewTags.append(tag)
    }
}

