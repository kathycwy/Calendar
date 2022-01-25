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
    
    
    var hours = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTime()
        setDayView()
    }
    
     func initTime() {
         for hour in 0 ... 23 {
             hours.append(hour)
         }
    }
    
    func setDayView() {
//        dayLabel.text = CalendarHelper().monthDayString(date: selectedDate)
//        dowLabel.text = CalendarHelper().weekDayAsString(date: selectedDate)
        hourTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hours.count
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

