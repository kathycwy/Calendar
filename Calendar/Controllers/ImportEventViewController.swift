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
        loadEventsForWeek()
    }
    
    func saveEventsToCoreData(events:[EKEvent]){
        if events.count != 0{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Constants.EventsAttribute.entityName, in: managedContext)!
        let event:EKEvent?
        for event in events {
            let newEventInContext = NSManagedObject(entity: entity, insertInto: managedContext)
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.EventsAttribute.entityName)
            let title = event.title
            let startDate = event.startDate
            let endDate = event.endDate
            newEventInContext.setValue(title, forKeyPath: Constants.EventsAttribute.titleAttribute)
            newEventInContext.setValue(startDate, forKeyPath: Constants.EventsAttribute.startDateAttribute)
            newEventInContext.setValue(endDate, forKeyPath: Constants.EventsAttribute.endDateAttribute)
            
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
    
    func loadEventsForWeek(){
        let weekFromNow = Calendar.current.date(byAdding: .day, value: 30, to: Date())
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: weekFromNow!, calendars: nil)
         events = eventStore.events(matching: predicate)
        saveEventsToCoreData(events: events)
    }
    func loadEventsForMonth(){
        let weekFromNow = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: weekFromNow!, calendars: nil)
         events = eventStore.events(matching: predicate)
    }
    func loadEventsForYear(){
        let weekFromNow = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        let predicate = eventStore.predicateForEvents(withStart: Date(), end: weekFromNow!, calendars: nil)
         events = eventStore.events(matching: predicate)
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
