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
    @IBOutlet weak var placeField: UITextField!
    @IBOutlet weak var remarksField: UITextField!
    
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
    
        titleField.text = String(event!.value(forKeyPath: "title") as? String ?? "")
        startDateField.date =  event!.value(forKeyPath: "startDate") as? Date ?? Date.now
        endDateField.date = event!.value(forKeyPath: "endDate") as? Date ?? Date.now
        placeField.text = String(event!.value(forKeyPath: "place") as? String ?? "")
        remarksField.text = String(event!.value(forKeyPath: "remarks") as? String ?? "")
        
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
            let place = placeField.text
            let remarks = remarksField.text

            updatingEvent.setValue(title, forKeyPath: "title")
            updatingEvent.setValue(startDate, forKeyPath: "startDate")
            updatingEvent.setValue(endDate, forKeyPath: "endDate")
            updatingEvent.setValue(place, forKeyPath: "place")
            updatingEvent.setValue(remarks, forKeyPath: "remarks")

            try managedContext.save()
            
        } catch let error as NSError {
            print("\n\nCould not save. \(error), \(error.userInfo)\n\n")
        }
        
        // go back to previous controller
        navigationController?.popViewController(animated: true)
        
    }
    
}
