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
        initTime()
        setDayView()
        initGestureRecognizer()
        hourTableView.register(DayHeader.self, forHeaderFooterViewReuseIdentifier: "dayHeader")
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
    
    func reloadCalendar(calendarYears: [CalendarYear]) {
        self.calendarDays.removeAll(keepingCapacity: false)
        self.calendarDays = self.getInitCalendar(calendarYears: calendarYears)
        hourTableView.reloadData()
    }
    
    func getInitCalendar(calendarYears: [CalendarYear]) -> [CalendarDay] {
        var calDays: [CalendarDay] = []
        
        if calendarYears.count ==  0{
            let year = Calendar.current.component(.year, from: Date())
            for tempYear in 1970 ... year {
                for tempMonth in 1 ... 12 {
                    let monthDays: [CalendarDay] = calendarHelper.getCalendarDays(
                        withStartDate: calendarHelper.getFirstDayOfMonth(year: tempYear, month: tempMonth),
                        withBuffer: false)
                    calDays.append(contentsOf: monthDays)
                }
            }
        }
        else {
            for calYear in calendarYears {
                for calMonth in calYear.calendarMonths {
                    calDays.append(contentsOf: calMonth.calendarDays.filter({$0.isDate == true}) )
                }
            }
        }
        return calDays
    }
    
    func getExtendedCalendarDays(numberOfMonths: Int) -> [CalendarDay] {
        var calDays: [CalendarDay] = []
        if numberOfMonths > 0 {
            let lastCalDay = (self.calendarDays.last?.date)!
            for i in 1 ... numberOfMonths {
                let tempDate = calendarHelper.addMonth(date: lastCalDay, n: i)
                let tempYear = calendarHelper.getYear(for: tempDate)
                let tempMonth = calendarHelper.getMonth(for: tempDate)
                    let monthDays: [CalendarDay] = calendarHelper.getCalendarDays(
                        withStartDate: calendarHelper.getFirstDayOfMonth(year: tempYear, month: tempMonth),
                        withBuffer: false)
                    calDays.append(contentsOf: monthDays)
            }
        }
        return calDays
    }
    
    
    func setDayView() {
//        dayLabel.text = CalendarHelper().monthDayString(date: selectedDay)
//        dowLabel.text = CalendarHelper().weekDayAsString(date: selectedDay)
        hourTableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hours.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.hourTableView.dequeueReusableHeaderFooterView(withIdentifier: "dayHeader") as! DayHeader
        //header.dayLabel.text = self.calendarHelper.dateStringShort(date: self.calendarDays[section].date!)
        //header.dowLabel.text = self.calendarHelper.dayOfWeekString(date: self.calendarDays[section].date!)
        header.dayLabel.text = self.calendarHelper.dateStringShort(date: self.selectedDay)
        header.dowLabel.text = self.calendarHelper.dayOfWeekString(date: self.selectedDay)

       return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell", for: indexPath) as! DayCell
        
        let hour = hours[indexPath.row]
        
        cell.timeLabel.text = formatHour(hour: hour)
        let  currentDate = CalendarHelper().getCurrentDate() // DONOT DO THIS, WE NEED TO SET DATES
        let events = EventListController().getEventsByDateAndTime(date: currentDate, hour: hour)
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
    
    
}

