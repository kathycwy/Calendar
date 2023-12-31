//
//  CalendarTabBarController.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//
//  To control the functionalities of the tab bar

import UIKit

class CalendarTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Properties
    
    var freshLaunch:Bool = true
    var monthViewController: MonthViewController!
    var yearViewController: YearViewController!
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    // To remove the "back" text of the back button
    override func viewWillAppear(_ animated: Bool) {
         if freshLaunch == true {
             freshLaunch = false
             self.selectedIndex = 1
         }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!

        // Ask all the calendar view to scroll to today's date
        if selectedIndex == 0{
           NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollToToday"), object: nil)
           return false
        }
        return true
   }
    
    // MARK: - Helper functions
    
    func reloadUI() {
        self.view.setNeedsDisplay()
        for objects in self.view.subviews {
            if let object = objects as? UIButton {
                object.setNeedsDisplay()
            }
            if let object = objects as? UILabel {
                object.setNeedsDisplay()
            }
            if let object = objects as? UIView {
                object.setNeedsDisplay()
            }
        }
        DispatchQueue.main.async { [weak self] in
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = .appColor(.navigationBackground)
            self?.tabBar.backgroundColor = .appColor(.navigationBackground)
            self?.tabBar.barTintColor = .appColor(.navigationBackground)
            self?.tabBar.tintColor = .appColor(.navigationTitle)
            self?.tabBar.standardAppearance = tabBarAppearance
            self?.tabBar.scrollEdgeAppearance = tabBarAppearance
            self?.tabBar.isTranslucent = false
        }
        
    }
    
    @objc func reloadUI(_ notification: Notification) {
        reloadUI()
    }
}
