//
//  EventListController.swift
//  Calendar
//
//  Created by Wingyin Chan on 16.01.22.
//
//  To control the functionalities of the event list page

import UIKit
import CoreData

class EventListController: UITableViewController, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var eventFilterButton: UIBarButtonItem!
    
    // MARK: - Properties
    
    var events: [NSManagedObject] = []
    var filteredEvents: [NSManagedObject] = []
    let rowHeight: CGFloat = 80.0
    var selectedRow: Int?
    var savedSearchText: String? = ""
    var filterCalendarName: String = "All"
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = rowHeight
        self.tableView.estimatedRowHeight = rowHeight

        searchBar.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchEvents()
        
        let eventFilterClosure = { (action: UIAction) in
            self.filterCalendarName = action.title
            if action.title != "All" {
                self.filteredEvents = self.getEventsByCalendar(events: self.events, name: action.title)
            } else {
                self.fetchEvents()
            }
            if self.savedSearchText != "" {
                self.filteredEvents = self.getEventsFromSearch(events: self.filteredEvents, searchText: self.savedSearchText!)
            }
            self.tableView.reloadData()
        }
        
        eventFilterButton.menu = UIMenu(children: [
            UIAction(title: "All", handler: eventFilterClosure),
            UIAction(title: Constants.CalendarConstants.calendarNone, handler: eventFilterClosure),
            UIAction(title: Constants.CalendarConstants.calendarPersonal, image: Constants.CalendarConstants.personalDot, handler: eventFilterClosure),
            UIAction(title: Constants.CalendarConstants.calendarSchool, image: Constants.CalendarConstants.schoolDot, handler: eventFilterClosure),
            UIAction(title: Constants.CalendarConstants.calendarWork, image: Constants.CalendarConstants.workDot, handler: eventFilterClosure)
          ])
        
        self.tableView.reloadData()
    }
    
    // MARK: - response to Cancel button in search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.searchTextField.text = ""
        savedSearchText = ""
        filteredEvents = events
        filterCalendarName = "All"
        self.tableView.reloadData()
    }
    
    //MARK: -  search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.savedSearchText = searchText
        self.filteredEvents = getEventsByCalendar(events: events, name: filterCalendarName)
        if searchText != "" {
            self.filteredEvents = getEventsFromSearch(events: filteredEvents, searchText: searchText)
        }
        
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
    
    func getEventsFromSearch(events: [NSManagedObject], searchText: String) -> [NSManagedObject] {
        var eventsFromSearch: [NSManagedObject] = []
        for event in events {
            let event_title = event.value(forKeyPath: "title") as! String

            if event_title.lowercased().contains(searchText.lowercased()) {
                eventsFromSearch.append(event)
            }
        }
        return eventsFromSearch
    }
    
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
    
    func getEventsByCalendar(events: [NSManagedObject], name: String) -> [NSManagedObject] {
        var eventsPerCalendar: [NSManagedObject] = []
        if name != "All" {
            for event in events {
                if event.value(forKeyPath: Constants.EventsAttribute.calendarAttribute) as! String == name {
                        eventsPerCalendar.append(event)
                }
            }
        } else {
            eventsPerCalendar = self.events
        }
        
        return eventsPerCalendar
    }
    
    func fetchEvents(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.EventsAttribute.entityName)
        let sort = NSSortDescriptor(key:Constants.EventsAttribute.startDateAttribute, ascending: true)
        let sort2 = NSSortDescriptor(key:Constants.EventsAttribute.allDayAttribute, ascending: false)
        fetchRequest.sortDescriptors = [sort, sort2]
        
        do {
            // fetch the entitiy
            events = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        filteredEvents = events
    }

    func getCalendarColor(name: String) -> UIColor {
        return UIColor.appColor(name) ?? .clear
    }
    
    //MARK: - Standard Tableview methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = filteredEvents[indexPath.row]
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
        
        // set labels in cell 
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
