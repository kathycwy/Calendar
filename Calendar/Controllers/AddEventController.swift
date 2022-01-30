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

final class AddEventController: CalendarUIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var savedEventId : String = ""
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // MARK: - Properties

    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet private var titleField: UITextField!
    @IBOutlet private var allDaySwitch: UISwitch!
    @IBOutlet private var startDateField: UIDatePicker!
    @IBOutlet private var endDateField: UIDatePicker!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var endRepeatStack: UIStackView!
    @IBOutlet weak var endRepeatDatePicker: UIDatePicker!
    @IBOutlet weak var endRepeatAfterCertainTimesButton: UIButton!
    @IBOutlet weak var endRepeatButton: UIButton!
    @IBOutlet private var locationField: UITextField!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet private var urlField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet private var notesField: UITextField!
    @IBOutlet weak var remindButton: UIButton!
    
    
    var managedObjectContext: NSManagedObjectContext?
    var events: NSManagedObject?
    var fetchedEvents: [NSManagedObject] = []
    var repeatOption: String = ""
    var endRepeatOption: String = ""
    var endRepeatDate: Date?
    var calendarOption: String = "None"
    var remindOption: String = ""
    var selectedRow = 0
    var rowHeight = 80

    // MARK: - Init
    
    func initUI(){
        pageTitleLabel.textColor = .appColor(.navigationTitle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDateField.minimumDate = Date.now
        endDateField.minimumDate = startDateField.date
        endRepeatDatePicker.minimumDate = endDateField.date
        endRepeatStack.isHidden = true
        endRepeatDatePicker.isHidden = true
        endRepeatAfterCertainTimesButton.isHidden = true
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: " ", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc fileprivate func willEnterForeground() {
        self.changeRemindButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // responding to End Repeat button
        let repeatButtonClosure = { (action: UIAction) in
            self.repeatOption = action.title
            if self.repeatOption != Constants.RepeatOptions.repeatNever {
                self.endRepeatStack.isHidden = false
            } else {
                self.endRepeatStack.isHidden = true
            }
        }
        repeatButton.menu = UIMenu(children: [
            UIAction(title: Constants.RepeatOptions.repeatNever, state: .on, handler: repeatButtonClosure),
            UIAction(title: Constants.RepeatOptions.repeatEveryDay, handler: repeatButtonClosure),
            UIAction(title: Constants.RepeatOptions.repeatEveryWeek, handler: repeatButtonClosure),
            UIAction(title: Constants.RepeatOptions.repeatEveryMonth, handler: repeatButtonClosure),
            UIAction(title: Constants.RepeatOptions.repeatEveryYear, handler: repeatButtonClosure)
          ])
        
        let endRepeatClosure = { (action: UIAction) in
            self.endRepeatOption = action.title
            if action.title == Constants.RepeatOptions.endRepeatNever {
                self.endRepeatDatePicker.isHidden = true
                self.endRepeatOption = action.title
            } else {
                self.endRepeatDatePicker.isHidden = false
                if action.title == Constants.RepeatOptions.endRepeatOnDate {
                    self.endRepeatDatePicker.isHidden = false
                    self.endRepeatAfterCertainTimesButton.isHidden = true
                } else {
                    self.endRepeatDatePicker.isHidden = true
                    self.endRepeatAfterCertainTimesButton.isHidden = false
                }
            }
        }
        
        endRepeatButton.menu = UIMenu(children: [
            UIAction(title: Constants.RepeatOptions.endRepeatNever, state: .on, handler: endRepeatClosure),
            UIAction(title: Constants.RepeatOptions.endRepeatOnDate, handler: endRepeatClosure),
            UIAction(title: Constants.RepeatOptions.endRepeatAfterCertainTimes, handler: endRepeatClosure)
          ])
        
        let calendarButtonClosure = { (action: UIAction) in
            self.calendarOption = action.title
            let color = EventListController().getCalendarColor(name: self.calendarOption)
            self.calendarButton.setImage(UIImage(systemName: "circle.fill")!.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        }
        
        calendarButton.menu = UIMenu(children: [
            UIAction(title: Constants.CalendarConstants.calendarNone, state: .on, handler: calendarButtonClosure),
            UIAction(title: Constants.CalendarConstants.calendarPersonal, image: Constants.CalendarConstants.personalDot, handler: calendarButtonClosure),
            UIAction(title: Constants.CalendarConstants.calendarSchool, image: Constants.CalendarConstants.schoolDot, handler: calendarButtonClosure),
            UIAction(title: Constants.CalendarConstants.calendarWork, image: Constants.CalendarConstants.workDot, handler: calendarButtonClosure)
          ])
        
        let remindButtonClosure = { (action: UIAction) in
            self.remindOption = action.title
        }
        
        //if notifications are not authorized, disable the menu and treat as regular button
        self.changeRemindButton()
        
        remindButton.menu = UIMenu(children: [
            UIAction(title: Constants.RemindOptions.remindNever, state: .on, handler: remindButtonClosure),
            UIAction(title: Constants.RemindOptions.remindOnDate, handler: remindButtonClosure),
            UIAction(title: Constants.RemindOptions.remind5Min, handler: remindButtonClosure),
            UIAction(title: Constants.RemindOptions.remind10Min, handler: remindButtonClosure),
            UIAction(title: Constants.RemindOptions.remind15Min, handler: remindButtonClosure),
            UIAction(title: Constants.RemindOptions.remind30Min, handler: remindButtonClosure),
            UIAction(title: Constants.RemindOptions.remind1Hr, handler: remindButtonClosure),
            UIAction(title: Constants.RemindOptions.remind2Hr, handler: remindButtonClosure),
            UIAction(title: Constants.RemindOptions.remind1Day, handler: remindButtonClosure),
            UIAction(title: Constants.RemindOptions.remind2Day, handler: remindButtonClosure),
            UIAction(title: Constants.RemindOptions.remind1Wk, handler: remindButtonClosure),
          ])

    }
    
    func changeRemindButton() {
        self.appDelegate?.checkAuthorization {  (isEnabled) in
            if (isEnabled == false) {
                DispatchQueue.main.async {
                    self.remindButton.showsMenuAsPrimaryAction = false
                }
            } else {
                DispatchQueue.main.async {
                    self.remindButton.showsMenuAsPrimaryAction = true
                }
            }
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
        endRepeatDatePicker.minimumDate = endDateField.date
    }
    
    @IBAction func updateEndRepeatDatePicker(_ sender: Any) {
        endRepeatDatePicker.minimumDate = endDateField.date
    }
    
    
    @IBAction func popUpEndEventTimesPicker(_ sender: Any) {
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 4)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.height / 4))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select repeating times", message: nil, preferredStyle: .actionSheet)
        
        alert.popoverPresentationController?.sourceView = endRepeatAfterCertainTimesButton
        alert.popoverPresentationController?.sourceRect = endRepeatAfterCertainTimesButton.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            self.endRepeatAfterCertainTimesButton.setTitle("After " + String(self.selectedRow + 1) + " Time(s)", for: .normal)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Standard PickerView methods
    
    func numberOfComponents(in endRepeatIntPicker: UIPickerView) -> Int {
        return 1
    }
     
    func pickerView(_ endRepeatIntPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
     
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?  {
        return String(row + 1)
    }
    
    func appendRepeatEventDates (startDate: Date, endDate: Date, repeatOption: String, endRepeatOption: String, endRepeatDate: Date) -> [[Date]] {
        
        var result = [[Date]]()
        
        var localStartDate = startDate
        var localEndDate = endDate
        var localEndRepeatDate = endRepeatDate
        
        // if End Repeat == "Never", the event will be repeated for 100 years
        let currentDate = Date()
        var dateComponent = DateComponents()
        var hundredYearsDateComponent = DateComponents()
        hundredYearsDateComponent.year = 100
        
        if endRepeatOption == Constants.RepeatOptions.endRepeatNever {
            localEndRepeatDate = Calendar.current.date(byAdding: hundredYearsDateComponent, to: localEndRepeatDate)! as Date
        }
                
        switch repeatOption {
        case Constants.RepeatOptions.repeatEveryDay:
            if endRepeatOption == Constants.RepeatOptions.endRepeatAfterCertainTimes {
                dateComponent.day = selectedRow
                localEndRepeatDate = Calendar.current.date(byAdding: dateComponent, to: localStartDate)! as Date
            }
            dateComponent.day = 1
            while localStartDate < localEndRepeatDate {
                localStartDate = Calendar.current.date(byAdding: dateComponent, to: localStartDate)! as Date
                localEndDate = Calendar.current.date(byAdding: dateComponent, to: localEndDate)! as Date
                result.append([localStartDate, localEndDate])
            }
        case Constants.RepeatOptions.repeatEveryWeek:
            if endRepeatOption == Constants.RepeatOptions.endRepeatAfterCertainTimes {
                dateComponent.day = selectedRow * 7
                localEndRepeatDate = Calendar.current.date(byAdding: dateComponent, to: localStartDate)! as Date
            }
            dateComponent.day = 7
            while localStartDate < localEndRepeatDate {
                localStartDate = Calendar.current.date(byAdding: dateComponent, to: localStartDate)! as Date
                localEndDate = Calendar.current.date(byAdding: dateComponent, to: localEndDate)! as Date
                result.append([localStartDate, localEndDate])
            }
        case Constants.RepeatOptions.repeatEveryMonth:
            if endRepeatOption == Constants.RepeatOptions.endRepeatAfterCertainTimes {
                dateComponent.month = selectedRow
                localEndRepeatDate = Calendar.current.date(byAdding: dateComponent, to: localStartDate)! as Date
            }
            dateComponent.month = 1
            while localStartDate < localEndRepeatDate {
                localStartDate = Calendar.current.date(byAdding: dateComponent, to: localStartDate)! as Date
                localEndDate = Calendar.current.date(byAdding: dateComponent, to: localEndDate)! as Date
                result.append([localStartDate, localEndDate])
            }
        case Constants.RepeatOptions.repeatEveryYear:
            if endRepeatOption == Constants.RepeatOptions.endRepeatAfterCertainTimes {
                dateComponent.year = selectedRow
                localEndRepeatDate = Calendar.current.date(byAdding: dateComponent, to: localStartDate)! as Date
            }
            dateComponent.year = 1
            while localStartDate < localEndRepeatDate {
                localStartDate = Calendar.current.date(byAdding: dateComponent, to: localStartDate)! as Date
                localEndDate = Calendar.current.date(byAdding: dateComponent, to: localEndDate)! as Date
                result.append([localStartDate, localEndDate])
            }
        default:
            return result
        }
        return result
    }
    
    func calcRemindTime (startDate: Date, remindOption: String) -> Date {
        
        var result = startDate
        let localStartDate = startDate
                
        switch remindOption {
        case Constants.RemindOptions.remindOnDate:
            return result
        case Constants.RemindOptions.remind5Min:
            result = Calendar.current.date(byAdding: .minute, value: -5, to: localStartDate)! as Date
        case Constants.RemindOptions.remind10Min:
            result = Calendar.current.date(byAdding: .minute, value: -10, to: localStartDate)! as Date
        case Constants.RemindOptions.remind15Min:
            result = Calendar.current.date(byAdding: .minute, value: -15, to: localStartDate)! as Date
        case Constants.RemindOptions.remind30Min:
            result = Calendar.current.date(byAdding: .minute, value: -30, to: localStartDate)! as Date
        case Constants.RemindOptions.remind1Hr:
            result = Calendar.current.date(byAdding: .hour, value: -1, to: localStartDate)! as Date
        case Constants.RemindOptions.remind2Hr:
            result = Calendar.current.date(byAdding: .hour, value: -2, to: localStartDate)! as Date
        case Constants.RemindOptions.remind1Day:
            result = Calendar.current.date(byAdding: .day, value: -1, to: localStartDate)! as Date
        case Constants.RemindOptions.remind2Day:
            result = Calendar.current.date(byAdding: .day, value: -2, to: localStartDate)! as Date
        case Constants.RemindOptions.remind1Wk:
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
    
    // MARK: - CoreData
    
    @IBAction func addEvent(_ sender: Any) {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: Constants.EventsAttribute.entityName, in: managedContext)!

        let title = titleField.text
        let allDaySwitchState = allDaySwitch.isOn
        var startDate = startDateField.date
        var endDate = endDateField.date
        let repeatOption = self.repeatOption
        let endRepeatOption = self.endRepeatOption
        let endRepeatDate = endRepeatDatePicker.date
        let location = locationField.text
        let calendarOption = self.calendarOption
        let url = urlField.text
        let notes = notesField.text
        var remindOption = self.remindOption
        //Handles case when notifications are disabled after selecting an option
        let isNotificationEnabled = UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert)
        if isNotificationEnabled == false {
            remindOption = Constants.RemindOptions.remindNever
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
        
        var repeatEventDates = [[startDate, endDate]]
        if repeatOption != "Never" {
            repeatEventDates.append(contentsOf: appendRepeatEventDates(startDate: startDate, endDate: endDate, repeatOption: repeatOption, endRepeatOption: endRepeatOption, endRepeatDate: endRepeatDate))
        }

        for repeatEventDate in repeatEventDates {
            let event = NSManagedObject(entity: entity, insertInto: managedContext)
            let notificationID = UUID().uuidString
            event.setValue(title, forKeyPath: Constants.EventsAttribute.titleAttribute)
            event.setValue(allDaySwitchState, forKeyPath: Constants.EventsAttribute.allDayAttribute)
            event.setValue(repeatEventDate[0], forKeyPath: Constants.EventsAttribute.startDateAttribute)
            event.setValue(repeatEventDate[1], forKeyPath: Constants.EventsAttribute.endDateAttribute)
            event.setValue(repeatOption, forKeyPath: Constants.EventsAttribute.repeatOptionAttribute)
            event.setValue(endRepeatOption, forKeyPath: Constants.EventsAttribute.endRepeatOptionAttribute)
            event.setValue(endRepeatDate, forKeyPath: Constants.EventsAttribute.endRepeatDateAttribute)
            event.setValue(location, forKeyPath: Constants.EventsAttribute.locationAttribute)
            event.setValue(calendarOption, forKeyPath: Constants.EventsAttribute.calendarAttribute)
            event.setValue(url, forKeyPath: Constants.EventsAttribute.urlAttribute)
            event.setValue(notes, forKeyPath: Constants.EventsAttribute.notesAttribute)
            event.setValue(remindOption, forKeyPath: Constants.EventsAttribute.remindOptionAttribute)
            event.setValue(notificationID, forKeyPath: Constants.EventsAttribute.notificationIDAttribute)
            let remindTime = calcRemindTime(startDate: repeatEventDate[0], remindOption: remindOption)
            if remindOption != Constants.RemindOptions.remindNever {
                self.appDelegate?.scheduleNotification(eventTitle: title!, remindDate: remindTime, remindOption: remindOption, notID: notificationID)
            }
            
            do {
                try managedContext.save()

            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        // go back to previous controller
        navigationController?.popViewController(animated: true)

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
