//
//  EventDetailsController.swift
//  Calendar
//
//  Created by Wingyin Chan on 17.01.22.
//

import UIKit
import CoreData
import SwiftUI
import EventKit
import EventKitUI

class EventDetailsController: CalendarUIViewController {
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // MARK: - Properties
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var allDayLabel: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var calendar: UILabel!
    @IBOutlet weak var calendarDot: UIImageView!
    @IBOutlet weak var url: UITextView!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var remindTime: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    var eventID: NSManagedObjectID?
    var event: NSManagedObject?
    var fetchedEvents: [NSManagedObject] = []
    var savedEventId : String = ""
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "d MMM y, HH:mm"
        
        let dateOnlyFormatter = DateFormatter()
        dateOnlyFormatter.dateFormat = "d MMM y"
        
        // set event url to the corresponding textView
        let urlString = String(event!.value(forKeyPath: Constants.EventsAttribute.urlAttribute) as? String ?? "")
        if let eventURL = URL(string: urlString){
            let attributedUrlString = NSAttributedString(string: urlString, attributes:[NSAttributedString.Key.link: eventURL])
            url.attributedText = attributedUrlString
        } else {
            url.attributedText = NSAttributedString(string: "No URL is added")
        }

        url.textAlignment = NSTextAlignment.right
        url.isUserInteractionEnabled = true
        url.isEditable = false
        
        // set remaining event details to corresponding labels
        eventTitle.text = String(event!.value(forKeyPath: Constants.EventsAttribute.titleAttribute) as? String ?? "")
        if (event!.value(forKeyPath: Constants.EventsAttribute.allDayAttribute) as? Bool ?? true) {
            allDayLabel.isHidden = false
            allDayLabel.text = "All-day event"
            startDate.text = dateOnlyFormatter.string(from: event!.value(forKeyPath: Constants.EventsAttribute.startDateAttribute) as? Date ?? Date.now)
            endDate.text = dateOnlyFormatter.string(from: event!.value(forKeyPath: Constants.EventsAttribute.endDateAttribute) as? Date ?? Date.now)
        } else {
            allDayLabel.isHidden = true
            startDate.text = dateTimeFormatter.string(from: event!.value(forKeyPath: Constants.EventsAttribute.startDateAttribute) as? Date ?? Date.now)
            endDate.text = dateTimeFormatter.string(from: event!.value(forKeyPath: Constants.EventsAttribute.endDateAttribute) as? Date ?? Date.now)
        }
        location.text = String(event!.value(forKeyPath: Constants.EventsAttribute.locationAttribute) as? String ?? "")
        calendar.text = String(event!.value(forKeyPath: Constants.EventsAttribute.calendarAttribute) as? String ?? "No calendar assigned")
        if (calendar.text == "No calendar assigned" || calendar.text == "None") {
            calendarDot.isHidden = true
        } else {
            calendarDot.isHidden = false
        }
        let color = EventListController().getCalendarColor(name: calendar.text ?? "None")
        calendarDot.tintColor = color
        notes.text = String(event!.value(forKeyPath: Constants.EventsAttribute.notesAttribute) as? String ?? "")
        remindTime.text = String(event!.value(forKeyPath: Constants.EventsAttribute.remindOptionAttribute) as? String ?? "")
        
        let iCalButtonClosure = { (action: UIAction) in
            self.saveToICal()
        }
        
        let copyDetailsClosure = { (action: UIAction) in
            self.performSegue(withIdentifier: "copyDetailsButtonTapped", sender: self)
        }
                          
        shareButton.menu = UIMenu(children: [
            UIAction(title: "Share to iCalendar", handler: iCalButtonClosure),
            UIAction(title: "Copy event details", handler: copyDetailsClosure)
          ])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "editButtonTapped") {
            let destinationVC = segue.destination as! EditEventController
            destinationVC.event = self.event
            destinationVC.initialRemindOption = remindTime.text!
        }
        
        if (segue.identifier == "copyDetailsButtonTapped") {
            let destinationVC = segue.destination as! CopyDetailsController
            destinationVC.event = self.event
        }
    }
    
    // MARK: - Actions
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "editButtonTapped", sender: self)
    }
        
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        let dialogMessage = UIAlertController(title: "Are you sure you want to delete this event?", message: nil, preferredStyle: .actionSheet)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "Delete Event", style: .destructive, handler: { (action) -> Void in
            self.deleteEvent()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func deleteEvent() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.EventsAttribute.entityName)
        let sort = NSSortDescriptor(key:Constants.EventsAttribute.startDateAttribute, ascending: true)
        fetchRequest.sortDescriptors = [sort]

        do {
            // fetch the entitiy
            fetchedEvents = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        managedContext.undoManager!.registerUndo(withTarget: self) { target in
            //simply save the hohle table view. A bit uniffcient but simple
            self.fetchedEvents = target.fetchedEvents
        }
        // Delete the notification associated with the event
        let notificationID = String(self.event!.value(forKeyPath: Constants.EventsAttribute.notificationIDAttribute) as? String ?? "")
        self.appDelegate?.deleteNotification(notID: notificationID)
        // Find the index of the event that is to be deleted from the array
        let index = fetchedEvents.firstIndex(where: {$0.objectID  == eventID})!
        // delete it from Core data
        managedContext.delete(fetchedEvents[index])
        // delete it from the arrays
        fetchedEvents.remove(at: index)

        // finally save the current state of Core data
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

        // go back to previous controller
        navigationController?.popViewController(animated: true)
    }
    
    ////////////// Share to iCalendar
    
    func createEvent(eventStore: EKEventStore, title: String, startDate: Date, endDate: Date, isAllDay: Bool) {
        let event = EKEvent(eventStore: eventStore)

        event.title = title
        event.startDate = startDate as Date
        event.endDate = endDate as Date
        event.calendar = eventStore.defaultCalendarForNewEvents
        event.isAllDay = isAllDay
        do {
            try eventStore.save(event, span: .thisEvent)
            savedEventId = event.eventIdentifier
        } catch let error as NSError {
            print("Could not create event. \(error), \(error.userInfo)")
        }
    }
    
    func saveToICal() {
        let eventStore = EKEventStore()

        let title = String(event!.value(forKeyPath: Constants.EventsAttribute.titleAttribute) as? String ?? "")
        let startDate = event!.value(forKeyPath: Constants.EventsAttribute.startDateAttribute) as? Date ?? Date.now
        let endDate = event!.value(forKeyPath: Constants.EventsAttribute.endDateAttribute) as? Date ?? Date.now
        let isAllDay = event!.value(forKeyPath: Constants.EventsAttribute.allDayAttribute) as? Bool ?? false

        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                self.createEvent(eventStore: eventStore, title: title , startDate: startDate, endDate: endDate, isAllDay: isAllDay)
            })
        } else {
            createEvent(eventStore: eventStore, title: title, startDate: startDate, endDate: endDate, isAllDay: isAllDay)
        }
        
        let dialogMessage = UIAlertController(title: "Event added to iCalendar", message: nil, preferredStyle: .alert)
        
        // Create Close button with action handlder
        let close = UIAlertAction(title: "Close", style: .cancel) { (action) -> Void in
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(close)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    
}
