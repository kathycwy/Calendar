//
//  EditEventController.swift
//  Calendar
//
//  Created by Wingyin Chan on 17.01.22.
//

import UIKit
import CoreData

class EditEventController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var startDateField: UIDatePicker!
    @IBOutlet weak var endDateField: UIDatePicker!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    
    var rowIndex: Int?
    var eventID: NSManagedObjectID?
    var event: NSManagedObject?
    var fetchedEvents: [NSManagedObject] = []
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        titleField.text = String(event!.value(forKeyPath: EventsStruct.titleAttribute) as? String ?? "")
        startDateField.date =  event!.value(forKeyPath: EventsStruct.startDateAttribute) as? Date ?? Date.now
        endDateField.date = event!.value(forKeyPath: EventsStruct.endDateAttribute) as? Date ?? Date.now
        locationField.text = String(event!.value(forKeyPath: EventsStruct.locationAttribute) as? String ?? "")
        urlField.text = String(event!.value(forKeyPath: EventsStruct.urlAttribute) as? String ?? "")
        notesField.text = String(event!.value(forKeyPath: EventsStruct.notesAttribute) as? String ?? "")
        
    }
    
    @IBAction func updateEvent(_ sender: Any) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        do {

            let updatingEvent = try managedContext.existingObject(with: self.event!.objectID)
            
            let title = titleField.text
            let startDate = startDateField.date
            let endDate = endDateField.date
            let place = locationField.text
            let url = urlField.text
            let remarks = notesField.text

            updatingEvent.setValue(title, forKeyPath: EventsStruct.titleAttribute)
            updatingEvent.setValue(startDate, forKeyPath: EventsStruct.startDateAttribute)
            updatingEvent.setValue(endDate, forKeyPath: EventsStruct.endDateAttribute)
            updatingEvent.setValue(place, forKeyPath: EventsStruct.locationAttribute)
            updatingEvent.setValue(url, forKeyPath: EventsStruct.urlAttribute)
            updatingEvent.setValue(remarks, forKeyPath: EventsStruct.notesAttribute)

            try managedContext.save()
            
        } catch let error as NSError {
            print("\n\nCould not save. \(error), \(error.userInfo)\n\n")
        }
        
        // go back to previous controller
        navigationController?.popViewController(animated: true)
        
    }
    
}
