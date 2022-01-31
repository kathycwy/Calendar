//
//  AppDelegate.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import UIKit
import CoreData
import UserNotifications
import CloudKit
import Foundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 3)
        // Initialise user setting variables
        UserDefaults.standard.register(
            defaults: [
                Constants.UserDefaults.ColourTheme: Constants.ColourThemes.teal,
                Constants.UserDefaults.FontSize: Constants.FontSize.normal,
                Constants.UserDefaults.DisplayWeekNumber: true,
                Constants.UserDefaults.StartDayOfWeek: 7
            ]
        )
        
        if !UserDefaults.exists(key: Constants.UserDefaults.DarkMode) {
            UserDefaults.standard.set(false, forKey: "DarkMode")
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    UserDefaults.standard.set(true, forKey: "DarkMode")
                }
            }
        }
        
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .sound]) {
            (permissionGranted, error) in
            if (!permissionGranted) {
                print("Permission Denied")
            }
        }
        
        // Initialise colour theme
        ThemeHelper.applyTheme()
        
        return true
    }
    
    func checkAuthorization(checkNotificationStatus isEnabled : ((Bool)->())? = nil){
        notificationCenter.getNotificationSettings { (setttings) in
            switch setttings.authorizationStatus {
                case .authorized:
                    isEnabled?(true)
                case .denied:
                    isEnabled?(false)
                case .notDetermined:
                    isEnabled?(false)
                default:
                    isEnabled?(false)
            }
        }
    }
    
    func scheduleNotification(eventTitle: String, remindDate: Date, remindOption: String, notID: String) {
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = eventTitle
        content.body = formatMessage(remindOption: remindOption)
        
        let dateCompRemind = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: remindDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompRemind, repeats: false)
        let request = UNNotificationRequest(identifier: notID, content: content, trigger: trigger)
        
        self.notificationCenter.add(request) { (error) in
            if (error != nil) {
                print("Error " + error.debugDescription)
                return
            }
        }
    }
    
    func deleteNotification(notID: String) {
        self.notificationCenter.getPendingNotificationRequests { (notificationRequests) in
           var identifiers: [String] = []
           for notification:UNNotificationRequest in notificationRequests {
               if notification.identifier == notID {
                  identifiers.append(notification.identifier)
               }
           }
        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    func formatMessage(remindOption: String) -> String {
        var message = ""
        switch remindOption {
        case Constants.RemindOptions.remindOnDate:
            message = "Starting Now"
        case Constants.RemindOptions.remind5Min:
            message = "Starting in 5 Minutes"
        case Constants.RemindOptions.remind10Min:
            message = "Starting in 10 Minutes"
        case Constants.RemindOptions.remind15Min:
            message = "Starting in 15 Minutes"
        case Constants.RemindOptions.remind30Min:
            message = "Starting in 30 Minutes"
        case Constants.RemindOptions.remind1Hr:
            message = "Starting in 1 Hour"
        case Constants.RemindOptions.remind2Hr:
            message = "Starting in 2 Hours"
        case Constants.RemindOptions.remind1Day:
            message = "Starting in 1 Day"
        case Constants.RemindOptions.remind2Day:
            message = "Starting in 2 Days"
        case Constants.RemindOptions.remind1Wk:
            message = "Starting in 1 Week"
        default:
            return message
        }
        return message
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Here we actually handle the notification
        print("Notification received with identifier \(notification.request.identifier)")
        // So we call the completionHandler telling that the notification should display a banner and play the notification sound - this will happen while the app is in foreground
        completionHandler([.banner, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
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
        return container
    }()
    

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

