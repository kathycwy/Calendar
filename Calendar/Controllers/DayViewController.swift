//
//  DayViewController.swift
//  Calendar
//
//  Created by C Chan on 22/1/2022.
//

import UIKit
import SwiftUI
import CoreData

class DayViewController: UIViewController, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var hourTableView: UITableView!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var dowLabel: UILabel!
    
    var selectedDay: Date = Date()
    var calendarDays: [CalendarDay] = []
    var hours = [Int]()
    
    let calendarHelper = CalendarHelper()
    
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
                              animations: { self.hourTableView.reloadData() })
            
            
        }
        else if sender.direction == .right {
            self.selectedDay = self.calendarHelper.addDay(date: self.selectedDay, n: 1)
            UIView.transition(with: self.hourTableView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { self.hourTableView.reloadData() })
        }
    }
    
    func setDayView() {
        hourTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hours.count
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell", for: indexPath) as! DayCell
        
        let hour = hours[indexPath.row]
        
        cell.timeLabel.text = formatHour(hour: hour)
        let events = EventListController().getEventsByDateAndTime(date: self.selectedDay, hour: hour)
                setEvents(cell, events)
        return cell
        
    }
    
    func setEvents(_ cell: DayCell, _ events: [NSManagedObject])
        {
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
        
        
        func setMoreEvents(_ cell: DayCell, _ count: Int)
        {
            cell.moreEvents.isHidden = false
            cell.moreEvents.text = String(count) + " More Events"
        }
        
        func setEvent(_ cell: DayCell, _ event: NSManagedObject)
        {
            cell.event.isHidden = false
            cell.event.text = event.value(forKeyPath: "title") as? String
        }
        
        func hideAll(_ cell: DayCell)
        {
            cell.event.isHidden = true
            cell.moreEvents.isHidden = true
        }
    
    func formatHour(hour: Int) -> String {
        return String(format: "%02d:%02d", hour, 0)
    }
    
    func scrollToToday(){
        self.selectedDay = self.calendarHelper.getCurrentDate()
        self.hourTableView.reloadData()
    }
    
    func scrollToDate(date: Date){
        self.selectedDay = date
        self.hourTableView.reloadData()
    }
    
    @objc func scrollToToday(_ notification: Notification) {
        scrollToToday()
    }
    
    @objc func scrollToDate(_ notification: Notification) {
       if let selectedDate = (notification.userInfo?["date"] ?? nil) as? Date{
           self.scrollToDate(date: selectedDate)
       }
    }
    
}

