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
    
    @IBOutlet weak var hourTableView: UITableView!
    
    var selectedDay: Date = Date()
    var calendarDays: [CalendarDay] = []
    var hours = [Int]()
    let rowHeight: CGFloat = 80.0
    var viewTags: [Int] = []
    
    let calendarHelper = CalendarHelper()
    var nRef = 1
    
    
    override func loadView() {
        super.loadView()
        
        hourTableView.rowHeight = rowHeight
        hourTableView.estimatedRowHeight = rowHeight

        hourTableView.separatorStyle = .none

        // to allow scrolling below the last cell
        hourTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))

        hourTableView.register(TimeCell.self, forCellReuseIdentifier: "timeCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hourTableView.register(DayHeader.self, forHeaderFooterViewReuseIdentifier: "dayHeader")
        initTime()
        setDayView()
        initGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .left {
            self.selectedDay = self.calendarHelper.addDay(date: self.selectedDay, n: -1)
            UIView.transition(with: self.hourTableView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { self.setDayView() })
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollToDate"), object: nil, userInfo: ["date": self.selectedDay as Any])
            
        }
        else if sender.direction == .right {
            self.selectedDay = self.calendarHelper.addDay(date: self.selectedDay, n: 1)
            UIView.transition(with: self.hourTableView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { self.setDayView() })
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollToDate"), object: nil, userInfo: ["date": self.selectedDay as Any])
        }
        
    }
    
    func setDayView() {
        for tag in viewTags {
            if let z = view.viewWithTag(tag) as! UIButton? {
                z.removeFromSuperview()
            }
        }
        viewTags = []
        hourTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hours.count
    }
    
    /*
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell", for: indexPath) as! DayCell
        cell.initCell(indexPath: indexPath)
        
        let hour = hours[indexPath.row]
        cell.timeLabel.text = formatHour(hour: hour)
        let events = EventListController().getEventsByDateAndTime(date: self.selectedDay, hour: hour)
        setEvents(cell, events)
        return cell
        
    }
     */
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.hourTableView.dequeueReusableHeaderFooterView(withIdentifier: "dayHeader") as! DayHeader
        header.dayLabel.text = self.calendarHelper.dateStringFull(date: self.selectedDay)
        header.dowLabel.text = self.calendarHelper.weekDayAsString(date: self.selectedDay)
        /*if (self.calendarHelper.weekDay(date: self.selectedDay) == 0) {
            header.dowLabel.textColor = UIColor.red
        }
        else {
            header.dowLabel.textColor = UIColor.appColor(.onPrimary)
        }*/
       return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath) as! TimeCell
        if indexPath.row > 0 {
            cell.topTime = "\(indexPath.row):00"
        } else {
            cell.topTime = ""
        }
        cell.bottomTime = "\(indexPath.row + 1):00"
        
        
        if indexPath.row > 0 {
            let events = EventListController().getEventsByStartDateAndTime(date: self.selectedDay, hour: hours[indexPath.row])
            add_events(indexPath: indexPath, events: events)
        }
        //add_event(indexPath: indexPath, nRef: 1, offset: 0, height: 100)
        //add_event(indexPath: indexPath, nRef: 2, offset: 0, height: 100)
        
        return cell
    }
    
    func add_events(indexPath: IndexPath, events: [NSManagedObject]) {
        let total_event = events.count
        let full_width = hourTableView.frame.width - 120
        let buffer = 10
        
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        
        var index = 0
        for event in events {
            if let startDate = event.value(forKeyPath: "startDate") as? Date {
                if let endDate = event.value(forKeyPath: "endDate") as? Date {
                    let elapsedTime = endDate.timeIntervalSince(startDate)
                    
                    let minutes = CGFloat((formatter.string(from: startDate) as NSString).floatValue)
                    
                    let cellWidth = (full_width - CGFloat(buffer * (total_event - 1))) / CGFloat(total_event)
                    let height = max(rowHeight / 3600 * elapsedTime, 30)
                    let offsetY = rowHeight * (minutes / 60)
                    let offsetX = (cellWidth * CGFloat(index)) + CGFloat(buffer * index)
                    add_event(indexPath: indexPath, nRef: indexPath.row, offsetX: offsetX, offsetY: offsetY, width: cellWidth, height: height, event: event, startDate: startDate, endDate: endDate, index: index)
                }
            }
            index = index + 1
        }
    }
    
    func add_event(indexPath: IndexPath, nRef: Int, offsetX: CGFloat, offsetY: CGFloat, width: CGFloat, height: CGFloat, event: NSManagedObject, startDate: Date, endDate: Date, index: Int)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        let start = formatter.string(from: startDate)
        let end = formatter.string(from: endDate)
        
        let eventTitle: String = event.value(forKeyPath: "title") as? String ?? " "
        let eventLoc: String = event.value(forKeyPath: "location") as? String ?? " "
        let eventDate: String = start + " - " + end
        
        let row = indexPath.row
        let rectOfCellInTableViewCoordinates = hourTableView.rectForRow(at: indexPath)
        let rectOfCellInSuperviewCoordinates = view.convert(rectOfCellInTableViewCoordinates, to: hourTableView.superview)
        print("\(row) \(rectOfCellInSuperviewCoordinates.origin.x) \(rectOfCellInSuperviewCoordinates.origin.y)")
        
        let tag = nRef * 100 + index
        if row == nRef {
            if let z = view.viewWithTag(tag) as! UIButton?{
                print("z found")
                z.removeFromSuperview()
            }

            let x_loc = 80
            let frame = CGRect(x: CGFloat(x_loc) + offsetX, y: rectOfCellInSuperviewCoordinates.origin.y + offsetY, width: width, height: height)
            let eventButton = UIButton(frame: frame)

            eventButton.backgroundColor = .appColor(.primary)?.withAlphaComponent(0.5)
            
            
            let text = eventTitle + "\n" + eventDate + "\n" + eventLoc
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(.foregroundColor,
                                        value: UIColor.appColor(.onPrimary),
                                        range: attributedText.getRangeOfString(textToFind: text))
            attributedText.addAttribute(.font,
                                        value: UIFont.boldSystemFont(ofSize: UIFont.appFontSize(.collectionViewCell) ?? 11),
                                        range: attributedText.getRangeOfString(textToFind: eventTitle))
            attributedText.addAttribute(.font,
                                        value: UIFont.systemFont(ofSize: UIFont.appFontSize(.innerCollectionViewHeader) ?? 11),
                                        range: attributedText.getRangeOfString(textToFind: eventDate))
            attributedText.addAttribute(.font,
                                        value: UIFont.systemFont(ofSize: UIFont.appFontSize(.innerCollectionViewHeader) ?? 11),
                                        range: attributedText.getRangeOfString(textToFind: eventLoc))
            
            eventButton.setAttributedTitle(attributedText, for: .normal)
            //eventButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping
            eventButton.layer.cornerRadius = 2
            eventButton.tag = tag
            eventButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
            eventButton.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            hourTableView.addSubview(eventButton)
            viewTags.append(tag)
        }
    }

    
    func setEvents(_ cell: DayCell, _ events: [NSManagedObject]) {
            hideAll(cell)
            switch events.count
            {
            case 1:
                setEvent(cell, events[0])
            
            case let count where count > 1:
                setEvent(cell, events[0])
                setMoreEvents(cell, events.count - 1)
            default:
                break
            }
        }
        
        
    func setMoreEvents(_ cell: DayCell, _ count: Int) {
        cell.moreEvents.isHidden = false
        cell.moreEvents.text = String(count) + " More Events"
    }
    
    func setEvent(_ cell: DayCell, _ event: NSManagedObject) {
        cell.event.isHidden = false
        cell.event.text = event.value(forKeyPath: "title") as? String
    }
    
    func hideAll(_ cell: DayCell) {
        cell.event.isHidden = true
        cell.moreEvents.isHidden = true
    }
    
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
        self.setDayView()
        self.hourTableView.headerView(forSection: 0)?.contentView.backgroundColor = .appColor(.primary)
    }
}

