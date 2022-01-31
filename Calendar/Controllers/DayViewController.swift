//
//  DayViewController.swift
//  Calendar
//
//  Created by C Chan on 22/1/2022.
//
//  To control the functionalities of Day View

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
         for hour in -1 ... 23 {
             hours.append(hour)
         }
    }
    
    // Create gesture for swipping to different dates
    func initGestureRecognizer(){
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.hourTableView.addGestureRecognizer(leftSwipe)
        self.hourTableView.addGestureRecognizer(rightSwipe)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set the event to be shown in event detail to the event buttons
        if segue.identifier == "dayToEventDetailSegue" {
            let destinationVC = segue.destination as! EventDetailsController
            
            if let event = selectedEvent {
                destinationVC.event = event
                destinationVC.eventID = event.objectID
            }
        }
    }
    
    // MARK: - Actions

    // Swipe to change day
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
        if sender.event != nil {
            self.selectedEvent = sender.event
            self.performSegue(withIdentifier: "dayToEventDetailSegue", sender: self)
        }
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

    // Main function to be called for redrawing the event table view
    func setDayView(scroll: Bool = true) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setLastSelectedDate"), object: nil, userInfo: ["date": self.calendarHelper.removeTimeStamp(fromDate: self.selectedDay) as Any])
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
        return hours.count + 2
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
        
        // Set up labels
        if indexPath.row == 0 {
            cell.bottomTimeLabel.text = "All-day"
        }
        
        if indexPath.row == 1 {
            cell.topTimeLabel.text = "All-day"
        }
        
        if indexPath.row > 1 {
            cell.topTimeLabel.text = String(indexPath.row - 2) + ":00"
        }
        
        if indexPath.row > 0 && indexPath.row < hours.count + 1 {
            cell.bottomTimeLabel.text = String(indexPath.row - 1) + ":00"
        }
        
        if indexPath.row > 0 && indexPath.row < hours.count + 1 {
            let events = EventListController().getEventsByStartDateAndTime(date: self.selectedDay, hour: hours[indexPath.row - 1])
            // Insert the event
            self.insertEvents(indexPath: indexPath, events: events)
            
            // Check if needs to show the "NOW" line
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYYMMDD"
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "YYYYMMDDHH"
            let curTime = self.calendarHelper.getCurrentDatetime()
            if (formatter.string(from: self.selectedDay) + String(hours[indexPath.row - 1]) ==
                formatter2.string(from: curTime)) {
                
                self.insertTodayLine(indexPath: indexPath, curTime: curTime)
            }
        }
        
        // Hide the now line and bottom line
        if (indexPath.row == 0 || indexPath.row == hours.count + 1) {
            cell.separatorLine.isHidden = true
        }
        
        return cell
    }
    
    // Insert a line to current time for today
    func insertTodayLine(indexPath: IndexPath, curTime: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        let minutes = CGFloat((formatter.string(from: curTime) as NSString).floatValue)
        let offsetY = rowHeight * (minutes / 60)
        let rectCellTable = hourTableView.rectForRow(at: indexPath)
        let rectCellView = view.convert(rectCellTable, to: hourTableView.superview)
        let x_loc = 60
        let tag = 9999
        
        if let oldButton = view.viewWithTag(tag) as! EventButton? {
            oldButton.removeFromSuperview()
        }
        
        // Calculate the position of for the line
        let frame = CGRect(x: CGFloat(x_loc), y: rectCellView.origin.y + offsetY, width: rectCellView.width, height: 1)
        
        // Create the button as a line
        let eventButton: EventButton = {
            let eventButton = EventButton()
            eventButton.frame = frame
            eventButton.backgroundColor = UIColor.red
            eventButton.tag = tag
            return eventButton
        }()
        
        hourTableView.addSubview(eventButton)
        viewTags.append(tag)
        
        // Create a button as a time label
        formatter.dateFormat = "HH:mm"
        let text = formatter.string(from: curTime)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.foregroundColor,
                                    value: UIColor.red,
                                    range: attributedText.getRangeOfString(textToFind: text))
        attributedText.addAttribute(.font,
                                    value: UIFont.boldSystemFont(ofSize: (UIFont.appFontSize(.innerCollectionViewHeader) ?? 11) - 1),
                                    range: attributedText.getRangeOfString(textToFind: text))
        
        let eventButton2: EventButton = {
            let eventButton = EventButton()
            eventButton.frame = CGRect(x: CGFloat(15), y: rectCellView.origin.y + offsetY, width: 50, height: 1)
            eventButton.backgroundColor = .clear
            eventButton.layer.borderWidth = 0
            eventButton.tag = tag + 1
            eventButton.setAttributedTitle(attributedText, for: .normal)
            return eventButton
        }()
        
        hourTableView.addSubview(eventButton2)
        viewTags.append(tag + 1)
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
                            // Calculate the position of the event
                            if (event.value(forKeyPath: Constants.EventsAttribute.allDayAttribute) as? Bool ?? false) {
                              // All day event
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
        
        // Event info
        let eventTitle: String = event.value(forKeyPath: Constants.EventsAttribute.titleAttribute) as? String ?? " "
        let eventType: String = event.value(forKeyPath: Constants.EventsAttribute.classTypeAttribute) as? String ?? " "
        var eventDate: String = ""
        if (event.value(forKeyPath: Constants.EventsAttribute.allDayAttribute) as? Bool ?? false == false) {
            eventDate = start + " - " + end
        }
        if eventType == Constants.ClassTypes.classAssignment {
            eventDate = start
        }
        let text = ((eventDate == "") ? "" : ("\n" + eventDate)) + ((eventType == " ") ? "" : ("\n" + eventType))
        var eventColour: UIColor? = nil
        if let attr = event.value(forKeyPath: Constants.EventsAttribute.calendarAttribute) {
            if let str = attr as? String {
                switch str {
                case Constants.TagConstants.tagRed:
                    eventColour = UIColor.appColor(Constants.TagConstants.tagRed)
                    break
                case Constants.TagConstants.tagOrange:
                    eventColour = UIColor.appColor(Constants.TagConstants.tagOrange)
                    break
                case Constants.TagConstants.tagGreen:
                    eventColour = UIColor.appColor(Constants.TagConstants.tagGreen)
                    break
                case Constants.TagConstants.tagBlue:
                    eventColour = UIColor.appColor(Constants.TagConstants.tagBlue)
                    break
                case Constants.TagConstants.tagPurple:
                    eventColour = UIColor.appColor(Constants.TagConstants.tagPurple)
                    break
                default:
                    break
                }
            }
        }
        let attributedText = NSMutableAttributedString(string: eventTitle)
        attributedText.addAttribute(.font,
                                    value: UIFont.boldSystemFont(ofSize: (UIFont.appFontSize(.collectionViewCell) ?? 11) - 2),
                                    range: attributedText.getRangeOfString(textToFind: eventTitle))
        
        let attributedText2 = NSMutableAttributedString(string: text)
        attributedText2.addAttribute(.font,
                                    value: UIFont.systemFont(ofSize: UIFont.appFontSize(.innerCollectionViewHeader) ?? 11),
                                    range: attributedText2.getRangeOfString(textToFind: eventDate))
        attributedText2.addAttribute(.font,
                                    value: UIFont.systemFont(ofSize: UIFont.appFontSize(.innerCollectionViewHeader) ?? 11),
                                    range: attributedText2.getRangeOfString(textToFind: eventType))
        
        attributedText.append(attributedText2)
        attributedText.addAttribute(.foregroundColor,
                                    value: eventDate == "" ? UIColor.white : (eventColour ?? UIColor.appColor(.onPrimary)) as Any,
                                    range: attributedText.getRangeOfString(textToFind: eventTitle + text))
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
            eventButton.backgroundColor = eventDate == "" ? eventColour?.withAlphaComponent(0.5) ?? UIColor.red.withAlphaComponent(0.5) : eventColour?.withAlphaComponent(0.3) ?? .appColor(.primary)?.withAlphaComponent(0.6)
            eventButton.titleLabel?.numberOfLines = 0
            eventButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            eventButton.setAttributedTitle(attributedText, for: .normal)
            eventButton.layer.cornerRadius = 2
            eventButton.tag = tag
            eventButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            eventButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
            eventButton.addTarget(self, action: #selector(self.eventButtonClicked(_:)), for: .touchUpInside)
            eventButton.layer.borderWidth = 2.0
            eventButton.layer.borderColor = eventButton.backgroundColor?.cgColor
            eventButton.titleEdgeInsets.left = 0.5
            return eventButton
        }()
        
        hourTableView.addSubview(eventButton)
        viewTags.append(tag)
    }
}

