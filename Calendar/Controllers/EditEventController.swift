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
    
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
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
    
    var event: NSManagedObject?
    var fetchedEvents: [NSManagedObject] = []
    var calendarOption: String = "None"
    var remindOption: String = ""
    var initialRemindOption: String = ""
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        endDateField.minimumDate = startDateField.date
        pageTitleLabel.textColor = .appColor(.navigationTitle)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc fileprivate func willEnterForeground() {
        self.changeRemindButton()
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
        
        let remindButtonClosure = { (action: UIAction) in
            self.remindOption = action.title
        }
        
        //if notifications are not authorized, disable the menu and treat as regular button
        self.changeRemindButton()
        
        var arrMenu:[UIAction] = [
            UIAction(title: EventsStruct.remindNever, handler: remindButtonClosure),
            UIAction(title: EventsStruct.remindOnDate, handler: remindButtonClosure),
            UIAction(title: EventsStruct.remind5Min, handler: remindButtonClosure),
            UIAction(title: EventsStruct.remind10Min, handler: remindButtonClosure),
            UIAction(title: EventsStruct.remind15Min, handler: remindButtonClosure),
            UIAction(title: EventsStruct.remind30Min, handler: remindButtonClosure),
            UIAction(title: EventsStruct.remind1Hr, handler: remindButtonClosure),
            UIAction(title: EventsStruct.remind2Hr, handler: remindButtonClosure),
            UIAction(title: EventsStruct.remind1Day, handler: remindButtonClosure),
            UIAction(title: EventsStruct.remind2Day, handler: remindButtonClosure),
            UIAction(title: EventsStruct.remind1Wk, handler: remindButtonClosure),
          ]
        switch self.initialRemindOption {
        case EventsStruct.remindNever:
            arrMenu[0] = UIAction(title: EventsStruct.remindNever, state: .on, handler: remindButtonClosure)
        case EventsStruct.remindOnDate:
            arrMenu[1] = UIAction(title: EventsStruct.remindOnDate, state: .on, handler: remindButtonClosure)
        case EventsStruct.remind5Min:
            arrMenu[2] = UIAction(title: EventsStruct.remind5Min, state: .on, handler: remindButtonClosure)
        case EventsStruct.remind10Min:
            arrMenu[3] = UIAction(title: EventsStruct.remind10Min, state: .on, handler: remindButtonClosure)
        case EventsStruct.remind15Min:
            arrMenu[4] = UIAction(title: EventsStruct.remind15Min, state: .on, handler: remindButtonClosure)
        case EventsStruct.remind30Min:
            arrMenu[5] = UIAction(title: EventsStruct.remind30Min, state: .on, handler: remindButtonClosure)
        case EventsStruct.remind1Hr:
            arrMenu[6] = UIAction(title: EventsStruct.remind1Hr, state: .on, handler: remindButtonClosure)
        case EventsStruct.remind2Hr:
            arrMenu[7] = UIAction(title: EventsStruct.remind2Hr, state: .on, handler: remindButtonClosure)
        case EventsStruct.remind1Day:
            arrMenu[8] = UIAction(title: EventsStruct.remind1Day, state: .on, handler: remindButtonClosure)
        case EventsStruct.remind2Day:
            arrMenu[9] = UIAction(title: EventsStruct.remind2Day, state: .on, handler: remindButtonClosure)
        case EventsStruct.remind1Wk:
            arrMenu[10] = UIAction(title: EventsStruct.remind1Wk, state: .on, handler: remindButtonClosure)
        default:
            arrMenu[0] = UIAction(title: EventsStruct.remindNever, state: .on, handler: remindButtonClosure)
        }
        remindButton.menu = UIMenu(children: arrMenu)
    }
    
    func changeRemindButton() {
        self.appDelegate?.checkAuthorization {  (isEnabled) in
            if (isEnabled == false) {
                self.remindButton.showsMenuAsPrimaryAction = false
            } else {
                self.remindButton.showsMenuAsPrimaryAction = true
            }
        }
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
    
    func calcRemindTime (startDate: Date, remindOption: String) -> Date {
        
        var result = startDate
        let localStartDate = startDate
                
        switch remindOption {
        case EventsStruct.remindOnDate:
            return result
        case EventsStruct.remind5Min:
            result = Calendar.current.date(byAdding: .minute, value: -5, to: localStartDate)! as Date
        case EventsStruct.remind10Min:
            result = Calendar.current.date(byAdding: .minute, value: -10, to: localStartDate)! as Date
        case EventsStruct.remind15Min:
            result = Calendar.current.date(byAdding: .minute, value: -15, to: localStartDate)! as Date
        case EventsStruct.remind30Min:
            result = Calendar.current.date(byAdding: .minute, value: -30, to: localStartDate)! as Date
        case EventsStruct.remind1Hr:
            result = Calendar.current.date(byAdding: .hour, value: -1, to: localStartDate)! as Date
        case EventsStruct.remind2Hr:
            result = Calendar.current.date(byAdding: .hour, value: -2, to: localStartDate)! as Date
        case EventsStruct.remind1Day:
            result = Calendar.current.date(byAdding: .day, value: -1, to: localStartDate)! as Date
        case EventsStruct.remind2Day:
            result = Calendar.current.date(byAdding: .day, value: -2, to: localStartDate)! as Date
        case EventsStruct.remind1Wk:
            result = Calendar.current.date(byAdding: .day, value: -7, to: localStartDate)! as Date
        default:
            return result
        }
        return result
    }
    
    @IBAction func remindButtonPressed(_ sender: Any) {
        let isNotificationEnabled = UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert)
        if isNotificationEnabled == false {
            self.remindButton.showsMenuAsPrimaryAction = false
            let alert = UIAlertController(title: "Enable Notifications?", message: "To use reminders, you must enable notifications in your settings", preferredStyle: .alert)
            let goToSettings = UIAlertAction(title: "Settings", style: .default) {(_) in
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
                else {
                    return
                }
                if (UIApplication.shared.canOpenURL(settingsURL)) {
                    UIApplication.shared.open(settingsURL) { (_) in }
                }
            }
            alert.addAction(goToSettings)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(_) in }))
            self.present(alert, animated: true)
        }
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
            var remindOption = self.remindOption
            //Handles case when notifications are disabled after selecting an option
            let isNotificationEnabled = UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert)
            if isNotificationEnabled == false {
                remindOption = EventsStruct.remindNever
            }
            
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
            updatingEvent.setValue(remindOption, forKeyPath: Constants.EventsAttribute.remindOptionAttribute)
            let remindTime = calcRemindTime(startDate: startDate, remindOption: remindOption)
            let notificationID = String(self.event!.value(forKeyPath: Constants.EventsAttribute.notificationIDAttribute) as? String ?? "")
            //update the existing or create a new notification
            if remindOption != EventsStruct.remindNever {
                self.appDelegate?.scheduleNotification(eventTitle: title!, remindDate: remindTime, remindOption: remindOption, notID: notificationID)
            }
            //the notification was initially set but changed to never, delete the notification
            else if self.initialRemindOption != EventsStruct.remindNever && remindOption == EventsStruct.remindNever {
                self.appDelegate?.deleteNotification(notID: notificationID)
            }

            try managedContext.save()
            
        } catch let error as NSError {
            print("\n\nCould not save. \(error), \(error.userInfo)\n\n")
        }
        
        // go back to previous controller
        navigationController?.popViewController(animated: true)
        
    }
    
}
