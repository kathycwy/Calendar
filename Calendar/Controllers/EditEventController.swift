//
//  EditEventController.swift
//  Calendar
//
//  Created by Wingyin Chan on 17.01.22.
//

import UIKit
import CoreData
import SwiftUI

class EditEventController: CalendarUIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var allDaySwitch: UISwitch!
    @IBOutlet weak var startDateField: UIDatePicker!
    @IBOutlet weak var endDateField: UIDatePicker!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var remindButton: UIButton!
    
    var eventID: NSManagedObjectID?
    var event: NSManagedObject?
    var fetchedEvents: [NSManagedObject] = []
    var calendarOption: String = "None"
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        endDateField.minimumDate = startDateField.date
        pageTitleLabel.textColor = .appColor(.navigationTitle)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        titleField.text = String(event!.value(forKeyPath: Constants.EventsAttribute.titleAttribute) as? String ?? "")
        allDaySwitch.setOn(event!.value(forKeyPath: Constants.EventsAttribute.allDayAttribute) as? Bool ?? true, animated: false)
        startDateField.date =  event!.value(forKeyPath: Constants.EventsAttribute.startDateAttribute) as? Date ?? Date.now
        endDateField.date = event!.value(forKeyPath: Constants.EventsAttribute.endDateAttribute) as? Date ?? Date.now
        if allDaySwitch.isOn {
            startDateField.datePickerMode = .date
            endDateField.datePickerMode = .date
        } else {
            startDateField.datePickerMode = .dateAndTime
            endDateField.datePickerMode = .dateAndTime
        }
        locationField.text = String(event!.value(forKeyPath: Constants.EventsAttribute.locationAttribute) as? String ?? "")
        
        let calendarButtonClosure = { (action: UIAction) in
            self.calendarOption = action.title
            let color = EventListController().getCalendarColor(name: self.calendarOption)
            self.calendarButton.setImage(UIImage(systemName: "circle.fill")!.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        }
        
        let calendarOption = String(event!.value(forKeyPath: Constants.EventsAttribute.calendarAttribute) as? String ?? "None")
                  
        calendarButton.menu = UIMenu(children: [
            UIAction(title: Constants.CalendarConstants.calendarNone, state: calendarOptionState(option: Constants.CalendarConstants.calendarNone, selectedOption: calendarOption), handler: calendarButtonClosure),
            UIAction(title: Constants.CalendarConstants.calendarPersonal, image: Constants.CalendarConstants.personalDot, state: calendarOptionState(option: Constants.CalendarConstants.calendarPersonal, selectedOption: calendarOption), handler: calendarButtonClosure),
            UIAction(title: Constants.CalendarConstants.calendarSchool, image: Constants.CalendarConstants.schoolDot, state: calendarOptionState(option: Constants.CalendarConstants.calendarSchool, selectedOption: calendarOption), handler: calendarButtonClosure),
            UIAction(title: Constants.CalendarConstants.calendarWork, image: Constants.CalendarConstants.workDot, state: calendarOptionState(option: Constants.CalendarConstants.calendarWork, selectedOption: calendarOption), handler: calendarButtonClosure)
          ])
        
        let color = EventListController().getCalendarColor(name: calendarOption)
        calendarButton.setImage(UIImage(systemName: "circle.fill")!.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        calendarButton.titleLabel?.textColor = .black

        
        urlField.text = String(event!.value(forKeyPath: Constants.EventsAttribute.urlAttribute) as? String ?? "")
        notesField.text = String(event!.value(forKeyPath: Constants.EventsAttribute.notesAttribute) as? String ?? "")
        
    }
    
    func calendarOptionState(option: String, selectedOption: String) -> UIMenuElement.State {
        if option == selectedOption {
            return .on
        } else {
            return .off
        }
    }
    
    // MARK: - Actions
    
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
            let calendarOption = self.calendarOption
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
            
            updatingEvent.setValue(title, forKeyPath: Constants.EventsAttribute.titleAttribute)
            updatingEvent.setValue(allDaySwitchState, forKeyPath: Constants.EventsAttribute.allDayAttribute)
            updatingEvent.setValue(startDate, forKeyPath: Constants.EventsAttribute.startDateAttribute)
            updatingEvent.setValue(endDate, forKeyPath: Constants.EventsAttribute.endDateAttribute)
            updatingEvent.setValue(place, forKeyPath: Constants.EventsAttribute.locationAttribute)
            updatingEvent.setValue(calendarOption, forKeyPath: Constants.EventsAttribute.calendarAttribute)
            updatingEvent.setValue(url, forKeyPath: Constants.EventsAttribute.urlAttribute)
            updatingEvent.setValue(notes, forKeyPath: Constants.EventsAttribute.notesAttribute)

            try managedContext.save()
            
        } catch let error as NSError {
            print("\n\nCould not save. \(error), \(error.userInfo)\n\n")
        }
        
        // go back to previous controller
        navigationController?.popViewController(animated: true)
        
    }
    
}
