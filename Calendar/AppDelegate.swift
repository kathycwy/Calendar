//
//  AppDelegate.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialise user setting variables
        UserDefaults.standard.register(
            defaults: [
                "ColourTheme": Constants.ColourThemes.teal,
                "FontSize": UIFont.systemFontSize,
                "DisplayWeekNumber": true
            ]
        )
        // Initialise colour theme
        if #available(iOS 13.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
                       
            navigationBarAppearance.backgroundColor = .appColor(.navigationBackground)
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.appColor(.navigationTitle)!]
            navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.appColor(.navigationTitle)!]
            
            UINavigationBar.appearance().backgroundColor = .appColor(.navigationBackground)
            UINavigationBar.appearance().barTintColor = .appColor(.navigationBackground)
            UIBarButtonItem.appearance().tintColor = .appColor(.primary)
            UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.appColor(.onPrimary)!], for: .selected)
            UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.appColor(.primary)!], for: .normal)
            
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = .appColor(.navigationBackground)
            UITabBar.appearance().barTintColor = .appColor(.navigationBackground)
            UITabBar.appearance().tintColor = .appColor(.navigationTitle)
            UITabBar.appearance().standardAppearance = tabBarAppearance
            
        }
        else {
            // Fallback on earlier versions
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().barTintColor = .appColor(.navigationBackground)
            UINavigationBar.appearance().tintColor = .appColor(.navigationTitle)
            UITabBar.appearance().tintColor = .appColor(.navigationTitle)
        }
        UISegmentedControl.appearance().selectedSegmentTintColor = .appColor(.primary)
        UISegmentedControl.appearance().backgroundColor = .appColor(.onPrimary)
        UISegmentedControl.appearance().tintColor = .appColor(.onPrimary)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.appColor(.onPrimary)!], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.appColor(.primary)!], for: .normal)
        UIButton.appearance().tintColor = UIColor.appColor(.primary)!
        UISwitch.appearance().onTintColor = .appColor(.navigationTitle)
        UIRefreshControl.appearance().tintColor = .appColor(.navigationTitle)
        UIToolbar.appearance().tintColor = .appColor(.navigationTitle)
        

        let popoverBarAppearance = UINavigationBar.appearance(whenContainedInInstancesOf: [UIPopoverPresentationController.self])
        popoverBarAppearance.tintColor = .appColor(.navigationTitle)
        popoverBarAppearance.barTintColor = nil
        popoverBarAppearance.barStyle = .default
        
        return true
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

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Calendar")
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

