//
//  EditEventController.swift
//  Calendar
//
//  Created by Wingyin Chan on 17.01.22.
//
//  To control the functionalities of the edit event page

import UIKit
import CoreData
import SwiftUI
import MapKit
import CoreLocation

class EditEventController: CalendarUIViewController {
    
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var allDaySwitch: UISwitch!
    @IBOutlet weak var startDateField: UIDatePicker!
    @IBOutlet weak var endDateField: UIDatePicker!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var onetapGesture: UITapGestureRecognizer!
    @IBOutlet weak var remindButton: UIButton!
    
    // MARK: - Properties
    
    var event: NSManagedObject?
    var fetchedEvents: [NSManagedObject] = []
    var calendarOption: String = "None"
    var remindOption: String = ""
    var initialRemindOption: String = ""
    
    let manager = CLLocationManager()
    let selectedLocation = MKPointAnnotation()
    var eventLocation:CLLocationCoordinate2D?
    var annotationAdded = false
    var locationAdded = false
    var userLocationEnabled = false
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable save button at the beginnig
        saveButton.isEnabled = false
        [titleField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
        
        // set appropriate date in start/end date pickers
        startDateField.minimumDate = Date.now
        endDateField.minimumDate = startDateField.date
        
        pageTitleLabel.textColor = .appColor(.navigationTitle)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: enable save button when title is not empty
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let title = titleField.text, !title.isEmpty
        else {
            saveButton.isEnabled = false
            return
        }
        saveButton.isEnabled = true
    }
    
    // MARK: Location Service Functions
    
    @IBAction func tapToSelect(_ sender: Any) {
       //        If there is already a pin dropped, remove the previous pin
        if annotationAdded{
           mapView.removeAnnotation(selectedLocation)
        }


        let location = onetapGesture.location(in: mapView)
        let locationInMap = mapView.convert(location, toCoordinateFrom: mapView)
        selectedLocation.coordinate = locationInMap
        mapView.addAnnotation(selectedLocation)
        annotationAdded = true
    }
    
    @IBAction func recenterToUsersLocation(_ sender: Any) {
        zoomInUsersLocation()
    }
        
    @IBAction func saveLocationCoordinate(_ sender: Any) {
       
        if annotationAdded {
             eventLocation = selectedLocation.coordinate
            locationAdded = true
        }else{
            if userLocationEnabled{
                eventLocation = manager.location?.coordinate
                locationAdded = true
            } else{
                showAlert(title: "Set Location Failed", description: "No Location is selected in the Map")
            }
        }
    }
    
    func zoomInUsersLocation(){
        if let usersLocation = manager.location?.coordinate {
        let region = MKCoordinateRegion.init(center: usersLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
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
    
    func checkAuthrizationStatus(locationManager: CLLocationManager){
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            if CLLocationManager.locationServicesEnabled(){
                locationManager.requestWhenInUseAuthorization()
            }else{
                showAlert(title: "Get Location failed", description: "Locationservice is disabled, please check your device settings!")
            }
            break;
        case .restricted:
            showAlert(title: "Get Location failed", description: "Request restricted!")
            break;
        case .denied:
            showAlert(title: "Request denied!", description: "Locationrequest denied, you can change it in your device settings")
        case .authorizedAlways:
            userLocationEnabled = true
            break;
        case .authorizedWhenInUse:
            userLocationEnabled = true
            break;
        @unknown default:
            break;
        }
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
            UIAction(title: Constants.RemindOptions.remindNever, handler: remindButtonClosure),
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
          ]
        switch self.initialRemindOption {
        case Constants.RemindOptions.remindNever:
            arrMenu[0] = UIAction(title: Constants.RemindOptions.remindNever, state: .on, handler: remindButtonClosure)
        case Constants.RemindOptions.remindOnDate:
            arrMenu[1] = UIAction(title: Constants.RemindOptions.remindOnDate, state: .on, handler: remindButtonClosure)
        case Constants.RemindOptions.remind5Min:
            arrMenu[2] = UIAction(title: Constants.RemindOptions.remind5Min, state: .on, handler: remindButtonClosure)
        case Constants.RemindOptions.remind10Min:
            arrMenu[3] = UIAction(title: Constants.RemindOptions.remind10Min, state: .on, handler: remindButtonClosure)
        case Constants.RemindOptions.remind15Min:
            arrMenu[4] = UIAction(title: Constants.RemindOptions.remind15Min, state: .on, handler: remindButtonClosure)
        case Constants.RemindOptions.remind30Min:
            arrMenu[5] = UIAction(title: Constants.RemindOptions.remind30Min, state: .on, handler: remindButtonClosure)
        case Constants.RemindOptions.remind1Hr:
            arrMenu[6] = UIAction(title: Constants.RemindOptions.remind1Hr, state: .on, handler: remindButtonClosure)
        case Constants.RemindOptions.remind2Hr:
            arrMenu[7] = UIAction(title: Constants.RemindOptions.remind2Hr, state: .on, handler: remindButtonClosure)
        case Constants.RemindOptions.remind1Day:
            arrMenu[8] = UIAction(title: Constants.RemindOptions.remind1Day, state: .on, handler: remindButtonClosure)
        case Constants.RemindOptions.remind2Day:
            arrMenu[9] = UIAction(title: Constants.RemindOptions.remind2Day, state: .on, handler: remindButtonClosure)
        case Constants.RemindOptions.remind1Wk:
            arrMenu[10] = UIAction(title: Constants.RemindOptions.remind1Wk, state: .on, handler: remindButtonClosure)
        default:
            arrMenu[0] = UIAction(title: Constants.RemindOptions.remindNever, state: .on, handler: remindButtonClosure)
        }
        remindButton.menu = UIMenu(children: arrMenu)
    }
    
    // MARK: Helper functions
    
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
    
    @IBAction func updateEvent(_ sender: Any) {

        // get the CoreData context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        do {

            let updatingEvent = try managedContext.existingObject(with: self.event!.objectID)
            
            // get the inputs from users
            let title = titleField.text
            let allDaySwitchState = allDaySwitch.isOn
            var startDate = startDateField.date
            var endDate = endDateField.date
            let place = locationField.text
            let calendarOption = self.calendarOption
            let url = urlField.text
            let notes = notesField.text
            var remindOption = self.remindOption
            var location = locationField.text
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
            
            // set the value for each key in the entity
            updatingEvent.setValue(title, forKeyPath: Constants.EventsAttribute.titleAttribute)
            updatingEvent.setValue(allDaySwitchState, forKeyPath: Constants.EventsAttribute.allDayAttribute)
            updatingEvent.setValue(startDate, forKeyPath: Constants.EventsAttribute.startDateAttribute)
            updatingEvent.setValue(endDate, forKeyPath: Constants.EventsAttribute.endDateAttribute)
            updatingEvent.setValue(place, forKeyPath: Constants.EventsAttribute.locationAttribute)
            updatingEvent.setValue(calendarOption, forKeyPath: Constants.EventsAttribute.calendarAttribute)
            updatingEvent.setValue(url, forKeyPath: Constants.EventsAttribute.urlAttribute)
            updatingEvent.setValue(notes, forKeyPath: Constants.EventsAttribute.notesAttribute)
            updatingEvent.setValue(remindOption, forKeyPath: Constants.EventsAttribute.remindOptionAttribute)
            if locationAdded{
                location = "Location added"
                let locationCoordinateLatitude = eventLocation?.latitude
                let locationCoordinateLongitude = eventLocation?.longitude
                updatingEvent.setValue(location, forKeyPath: Constants.EventsAttribute.locationAttribute)
               updatingEvent.setValue(locationCoordinateLongitude, forKeyPath: Constants.EventsAttribute.locationCoordinateLongitudeAttribute)
               updatingEvent.setValue(locationCoordinateLatitude, forKeyPath: Constants.EventsAttribute.locationCoordinateLatitudeAttribute)
            }else{
                location = "Location not added"
                updatingEvent.setValue(location, forKeyPath: Constants.EventsAttribute.locationAttribute)
            }

            let remindTime = calcRemindTime(startDate: startDate, remindOption: remindOption)
            let notificationID = String(self.event!.value(forKeyPath: Constants.EventsAttribute.notificationIDAttribute) as? String ?? "")
            //update the existing or create a new notification
            if remindOption != Constants.RemindOptions.remindNever {
                self.appDelegate?.scheduleNotification(eventTitle: title!, remindDate: remindTime, remindOption: remindOption, notID: notificationID)
            }
            //the notification was initially set but changed to never, delete the notification
            else if self.initialRemindOption != Constants.RemindOptions.remindNever && remindOption == Constants.RemindOptions.remindNever {
                self.appDelegate?.deleteNotification(notID: notificationID)
            }

            // save to CoreData
            try managedContext.save()
            
        } catch let error as NSError {
            print("\n\nCould not save. \(error), \(error.userInfo)\n\n")
        }
        
        // go back to previous controller
        navigationController?.popViewController(animated: true)
        
    }
    
}
