//
//  EventListController.swift
//  Calendar
//
//  Created by Wingyin Chan on 16.01.22.
//

import UIKit
import CoreData

class EventListController: UITableViewController {
    
    // MARK: - Properties
    
    var events: [NSManagedObject] = []
    let rowHeight: CGFloat = 80.0
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = rowHeight
        self.tableView.estimatedRowHeight = rowHeight
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Init

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchEvents()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "eventCellTapped") {
            let destinationVC = segue.destination as! EventDetailsController
            
            if selectedRow != nil {
                destinationVC.event = self.events[self.selectedRow!]
                destinationVC.eventID = self.events[self.selectedRow!].objectID
            }
        }
    }
    
    // MARK: - Helper functions
    
    func getEventsByStartDateAndTime(date: Date, hour: Int) -> [NSManagedObject] {
        fetchEvents()
        var eventsPerHour = [NSManagedObject]()
        for event in events
        {
            let event_start_date = event.value(forKeyPath: Constants.EventsAttribute.startDateAttribute) as! Date
            let event_end_date = event.value(forKeyPath: Constants.EventsAttribute.endDateAttribute) as! Date
            let fallsBetween = (event_start_date.removeTimeStamp! ... event_end_date.removeTimeStamp!).contains(date.removeTimeStamp!)
            if fallsBetween
            {
                var eventStartHour = CalendarHelper().hourFromDate(date: event_start_date)
                if event_start_date.removeTimeStamp != date.removeTimeStamp {
                    eventStartHour = 0
                }
      
                if  eventStartHour >= hour && eventStartHour < hour + 1
                {
                    var eventStartHour = CalendarHelper().hourFromDate(date: event_start_date)
                    if event_start_date.removeTimeStamp != date.removeTimeStamp {
                        eventStartHour = 0
                    }
          
                    if  eventStartHour >= hour && eventStartHour < hour + 1
                    {
                        eventsPerHour.append(event)
                    }
                }
            }
        }
        return eventsPerHour
    }
    
    func getEventsByDateAndTime(date: Date, hour: Int) -> [NSManagedObject] {
        fetchEvents()
        var eventsPerHour = [NSManagedObject]()
        for event in events
        {
            let event_start_date = event.value(forKeyPath: Constants.EventsAttribute.startDateAttribute) as! Date
            let event_end_date = event.value(forKeyPath: Constants.EventsAttribute.endDateAttribute) as! Date
            let fallsBetween = (event_start_date.removeTimeStamp! ... event_end_date.removeTimeStamp!).contains(date.removeTimeStamp!)
            if fallsBetween
            {
                var eventStartHour = CalendarHelper().hourFromDate(date: event_start_date)
                if event_start_date.removeTimeStamp != date.removeTimeStamp {
                    eventStartHour = 0
                }
                
                var eventEndHour = CalendarHelper().hourFromDate(date: event_end_date)
                if event_end_date.removeTimeStamp != date.removeTimeStamp {
                    eventEndHour = 23
                }
      
                if  hour >= eventStartHour && hour <= eventEndHour
                {
                    eventsPerHour.append(event)
                }
            }
        }
        return eventsPerHour
    }
    
    func getEventsByDate(currentDate: Date) -> [NSManagedObject] {
        fetchEvents()
        var eventsPerDate: [NSManagedObject] = []
        for event in events {
            let event_start_date = event.value(forKeyPath: Constants.EventsAttribute.startDateAttribute) as! Date
            let event_end_date = event.value(forKeyPath: Constants.EventsAttribute.endDateAttribute) as! Date
            
            if event_start_date <= event_end_date {
                let fallsBetween = (event_start_date.removeTimeStamp! ... event_end_date.removeTimeStamp!).contains(currentDate)
                if fallsBetween {
                    eventsPerDate.append(event)
                }
            }
        }
        return eventsPerDate
    }
    
    func updateView(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.EventsAttribute.entityName)
        let sort = NSSortDescriptor(key:Constants.EventsAttribute.startDateAttribute, ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            // fetch the entitiy
            events = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
    
    }
    
    func fetchEvents(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.EventsAttribute.entityName)
        let sort = NSSortDescriptor(key:Constants.EventsAttribute.startDateAttribute, ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            // fetch the entitiy
            events = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func getCalendarColor(name: String) -> UIColor {
        switch name {
        case Constants.CalendarConstants.calendarPersonal:
            return Constants.CalendarConstants.personalColor
        case Constants.CalendarConstants.calendarSchool:
            return Constants.CalendarConstants.schoolColor
        case Constants.CalendarConstants.calendarWork:
            return Constants.CalendarConstants.workColor
        default:
            return .clear
        }
    }
    
    //MARK: - Standard Tableview methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myEventCell", for: indexPath) as! EventCell
        cell.initCell(indexPath: indexPath)
        
        // Set text
        let eventTitle: String = event.value(forKeyPath: Constants.EventsAttribute.titleAttribute) as? String ?? " "
        let eventLoc: String = event.value(forKeyPath: Constants.EventsAttribute.locationAttribute) as? String ?? " "
        let text = eventTitle + "\n" + eventLoc
        
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.foregroundColor,
                                    value: UIColor.appColor(.onSurface) as Any,
                                    range: attributedText.getRangeOfString(textToFind: text))
        attributedText.addAttribute(.font,
                                    value: UIFont.boldSystemFont(ofSize: UIFont.appFontSize(.collectionViewCell) ?? 11),
                                    range: attributedText.getRangeOfString(textToFind: eventTitle))
        attributedText.addAttribute(.foregroundColor,
                                    value: UIColor.appColor(.secondary) as Any,
                                    range: attributedText.getRangeOfString(textToFind: eventLoc))
        attributedText.addAttribute(.font,
                                    value: UIFont.systemFont(ofSize: UIFont.appFontSize(.tableViewCellInfo) ?? 11),
                                    range: attributedText.getRangeOfString(textToFind: eventLoc))
        
        let fullFormatter = DateFormatter()
        fullFormatter.dateFormat = "d MMM y, HH:mm"
        
        let allDayFormatter = DateFormatter()
        allDayFormatter.dateFormat = "d MMM y"
        
        var startDateString: String, endDateString: String
        
        if event.value(forKeyPath: Constants.EventsAttribute.allDayAttribute) as? Bool ?? false {
            startDateString = allDayFormatter.string(from: event.value(forKeyPath: Constants.EventsAttribute.startDateAttribute) as! Date) + " All-day"
            endDateString = allDayFormatter.string(from: event.value(forKeyPath: Constants.EventsAttribute.endDateAttribute) as! Date) + " All-day"
        } else {
            startDateString = fullFormatter.string(from: event.value(forKeyPath: Constants.EventsAttribute.startDateAttribute) as! Date)
            endDateString = fullFormatter.string(from: event.value(forKeyPath: Constants.EventsAttribute.endDateAttribute) as! Date)
        }
        
        cell.colorBar.backgroundColor = getCalendarColor(name: event.value(forKeyPath: Constants.EventsAttribute.calendarAttribute) as? String ?? "None")
        cell.titleLabel.attributedText = attributedText
        cell.startDateLabel.text = startDateString
        cell.endDateLabel.text = endDateString
        cell.startDateLabel.font = cell.startDateLabel.font.withSize(UIFont.appFontSize(.innerCollectionViewHeader) ?? 10)
        cell.endDateLabel.font = cell.startDateLabel.font.withSize(UIFont.appFontSize(.innerCollectionViewHeader) ?? 10)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        self.performSegue(withIdentifier: "eventCellTapped", sender: self)
        
    }
    
}
