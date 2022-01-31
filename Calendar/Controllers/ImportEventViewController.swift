//
//  ImportEventViewController.swift
//  Calendar
//
//  Created by Fengwu Lu on 31.01.22.
//

import UIKit
import EventKit
import EventKitUI
import CoreData

class ImportEventViewController: UIViewController {

    let eventStore = EKEventStore()
    let calendar = Calendar.autoupdatingCurrent
    var isAccessAuthorized = false
    var events:[EKEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAuthorizationStatus()
        let container = NSPersistentCloudKitContainer(name: "Calendar")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    
    @IBAction func importForAWeek(_ sender: Any) {
        let weekFromNow = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: weekFromNow!, calendars: nil)
         events = eventStore.events(matching: predicate)
        saveEventsToCoreData(events: events)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ImportForAMonth(_ sender: Any) {
        let monthFromNow = Calendar.current.date(byAdding: .day, value: 30, to: Date())
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: monthFromNow!, calendars: nil)
         events = eventStore.events(matching: predicate)
        saveEventsToCoreData(events: events)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func importForAYear(_ sender: Any) {
        let yearFromNow = Calendar.current.date(byAdding: .day, value: 365, to: Date())
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: yearFromNow!, calendars: nil)
         events = eventStore.events(matching: predicate)
        saveEventsToCoreData(events: events)
        navigationController?.popViewController(animated: true)
    }
    
    
    
    func saveEventsToCoreData(events:[EKEvent]){
        if events.count != 0{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Constants.EventsAttribute.entityName, in: managedContext)!
        let event:EKEvent?
        var eventsInContainer:[NSManagedObject] = []
        var eventInContainer: NSManagedObject?
            
            
        for event in events {
            var isDuplicate = false
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.EventsAttribute.entityName)
            let title = event.title
            let startDate = event.startDate
            let endDate = event.endDate
            do {
                // fetch the entitiy
                eventsInContainer = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            for eventInContainer in eventsInContainer {
                if eventInContainer.value(forKeyPath: Constants.EventsAttribute.titleAttribute) as? String == title, eventInContainer.value(forKeyPath: Constants.EventsAttribute.startDateAttribute) as? Date == startDate,eventInContainer.value(forKeyPath: Constants.EventsAttribute.endDateAttribute) as? Date == endDate{
//                    Do nothing when the new Event is considered as a duplicate event
                    isDuplicate = true
                    break
                }
            }
            
            if isDuplicate == false{
                let newEventInContext = NSManagedObject(entity: entity, insertInto: managedContext)
                newEventInContext.setValue(title, forKeyPath: Constants.EventsAttribute.titleAttribute)
                            newEventInContext.setValue(startDate, forKeyPath: Constants.EventsAttribute.startDateAttribute)
                            newEventInContext.setValue(endDate, forKeyPath: Constants.EventsAttribute.endDateAttribute)
                
            }
            
        }
        
        
        do {
            try managedContext.save()

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
            
        }else{
            
        }
    }
    
    func requestAccess() {
            eventStore.requestAccess(to: .event) { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        // load events from user's calendar
                    }
                }else{
                    self.showAlert(title: "Access denied", description: "Failed to get access to user's calendar")
                }
            }
    }
    func checkAuthorizationStatus() {
        let status = EKEventStore.authorizationStatus(for: .event)

        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            requestAccess()
        case EKAuthorizationStatus.authorized:
            isAccessAuthorized = true
            break;
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            self.showAlert(title: "Access denied", description: "Failed to get access to user's calendar")
        @unknown default:
            showAlert(title: "Unknown Error!", description: "Please try to update your application and try it again!")
            break;
        }
    }
    
    func showAlert(title: String, description: String){
         let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: goToSettings(alert:)))
         alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
         self.present(alert, animated: true)
     }
     
     
     func goToSettings(alert: UIAlertAction!){
         let url = URL(string: UIApplication.openSettingsURLString)!
         UIApplication.shared.open(url) { _ in print("succeed")
         }
     }
    
  
    func loadEventsForCostum(){
        let weekFromNow = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: weekFromNow!, calendars: nil)
         events = eventStore.events(matching: predicate)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
