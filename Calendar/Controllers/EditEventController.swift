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
    @IBOutlet weak var allDaySwitch: UISwitch!
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
        endDateField.minimumDate = startDateField.date
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        titleField.text = String(event!.value(forKeyPath: EventsStruct.titleAttribute) as? String ?? "")
        allDaySwitch.setOn(event!.value(forKeyPath: EventsStruct.allDayAttribute) as? Bool ?? true, animated: false)
        startDateField.date =  event!.value(forKeyPath: EventsStruct.startDateAttribute) as? Date ?? Date.now
        endDateField.date = event!.value(forKeyPath: EventsStruct.endDateAttribute) as? Date ?? Date.now
        if allDaySwitch.isOn {
            startDateField.datePickerMode = .date
            endDateField.datePickerMode = .date
        } else {
            startDateField.datePickerMode = .dateAndTime
            endDateField.datePickerMode = .dateAndTime
        }
        locationField.text = String(event!.value(forKeyPath: EventsStruct.locationAttribute) as? String ?? "")
        urlField.text = String(event!.value(forKeyPath: EventsStruct.urlAttribute) as? String ?? "")
        notesField.text = String(event!.value(forKeyPath: EventsStruct.notesAttribute) as? String ?? "")
        
    }
    
    @IBAction func switchAllDayDatePicker (_ sender: UISwitch) {
        if allDaySwitch.isOn {
            startDateField.datePickerMode = .date
            endDateField.datePickerMode = .date
        } else {
            startDateField.datePickerMode = .dateAndTime
            endDateField.datePickerMode = .dateAndTime
        }
    }
    
    @IBAction func updateEndDatePicker (_ sender: UIDatePicker) {
        endDateField.minimumDate = startDateField.date
    }
    
    @IBAction func updateEvent(_ sender: Any) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        do {

            let updatingEvent = try managedContext.existingObject(with: self.event!.objectID)
            
            let title = titleField.text
            let allDaySwitchState = allDaySwitch.isOn
            var startDate = startDateField.date
            var endDate = endDateField.date
            let place = locationField.text
            let url = urlField.text
            let notes = notesField.text

            // set all-day event to 00:00 - 23:59
            if allDaySwitchState {
                let formatter = DateFormatter()
                formatter.dateFormat = "d MMM y"
                
                let calender = Calendar.current
                let startDateComponents = calender.dateComponents([.year, .month, .day], from: startDate)
                var endDateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute], from: endDate)
                endDateComponents.hour = 23
                endDateComponents.minute = 59
                
                startDate = calender.date(from: startDateComponents) ?? startDate
                endDate = calender.date(from: endDateComponents) ?? endDate
            }
            
            updatingEvent.setValue(title, forKeyPath: EventsStruct.titleAttribute)
            updatingEvent.setValue(allDaySwitchState, forKeyPath: EventsStruct.allDayAttribute)
            updatingEvent.setValue(startDate, forKeyPath: EventsStruct.startDateAttribute)
            updatingEvent.setValue(endDate, forKeyPath: EventsStruct.endDateAttribute)
            updatingEvent.setValue(place, forKeyPath: EventsStruct.locationAttribute)
            updatingEvent.setValue(url, forKeyPath: EventsStruct.urlAttribute)
            updatingEvent.setValue(notes, forKeyPath: EventsStruct.notesAttribute)

            try managedContext.save()
            
        } catch let error as NSError {
            print("\n\nCould not save. \(error), \(error.userInfo)\n\n")
        }
        
        // go back to previous controller
        navigationController?.popViewController(animated: true)
        
    }
    
}
