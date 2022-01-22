//
//  AddEventController.swift
//  Calendar
//
//  Created by Aparna Joshi on 14/01/22.
//

import UIKit
import CoreData
import EventKit
import EventKitUI

final class AddEventController: UIViewController {

    var savedEventId : String = ""
    
    // MARK: - Properties

    @IBOutlet private var titleField: UITextField!
    @IBOutlet private var startDateField: UIDatePicker!
    @IBOutlet private var endDateField: UIDatePicker!
    @IBOutlet private var locationField: UITextField!
    @IBOutlet private var urlField: UITextField!
    @IBOutlet private var notesField: UITextField!
    // MARK: -
    var managedObjectContext: NSManagedObjectContext?
    var events: NSManagedObject?
    var fetchedEvents: [NSManagedObject] = []

    // MARK: - Actions
    
    ///////////// CoreData //////////
    @IBAction func addEvent(_ sender: Any) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: EventsStruct.entityName, in: managedContext)!

        let event = NSManagedObject(entity: entity, insertInto: managedContext)

        let title = titleField.text
        let startDate = startDateField.date
        let endDate = endDateField.date
        let location = locationField.text
        let url = urlField.text
        let notes = notesField.text

        event.setValue(title, forKeyPath: EventsStruct.titleAttribute)
        event.setValue(startDate, forKeyPath: EventsStruct.startDateAttribute)
        event.setValue(endDate, forKeyPath: EventsStruct.endDateAttribute)
        event.setValue(location, forKeyPath: EventsStruct.locationAttribute)
        event.setValue(url, forKeyPath: EventsStruct.urlAttribute)
        event.setValue(notes, forKeyPath: EventsStruct.notesAttribute)

        do {
            try managedContext.save()

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

    }
  

    
    ///////////// EventKit //////////
    
//    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
//        let event = EKEvent(eventStore: eventStore)
//
//        event.title = title
//        event.startDate = startDate as Date
//        event.endDate = endDate as Date
//        event.calendar = eventStore.defaultCalendarForNewEvents
//        do {
//            try eventStore.save(event, span: .thisEvent)
//            savedEventId = event.eventIdentifier
//        } catch {
//            print("Bad things happened")
//        }
//    }
//
//    func deleteEvent(eventStore: EKEventStore, eventIdentifier: String) {
//        let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
//        if (eventToRemove != nil) {
//            do {
//                try eventStore.remove(eventToRemove!, span: .thisEvent)
//            } catch {
//                print("Bad things happened")
//            }
//        }
//    }
//
//    @IBAction func addEvent(sender: Any) {
//        let eventStore = EKEventStore()
//
//        let title = titleField.text
//        let startDate = startDateField.date as NSDate
//        let endDate = endDateField.date as NSDate
//
//        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
//            eventStore.requestAccess(to: .event, completion: {
//                granted, error in
//                self.createEvent(eventStore: eventStore, title: title ?? "noName", startDate: startDate, endDate: endDate)
//            })
//        } else {
//            createEvent(eventStore: eventStore, title: title ?? "noName", startDate: startDate, endDate: endDate)
//        }
//        
//        // go back to previous controller
//        navigationController?.popViewController(animated: true)
//    }
//
//    @IBAction func removeEvent(sender: UIButton) {
//        let eventStore = EKEventStore()
//
//        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
//            eventStore.requestAccess(to: .event, completion: { (granted, error) -> Void in
//                self.deleteEvent(eventStore: eventStore, eventIdentifier: self.savedEventId)
//            })
//        } else {
//            deleteEvent(eventStore: eventStore, eventIdentifier: savedEventId)
//        }
//
//    }

}
