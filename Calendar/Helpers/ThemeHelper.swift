//
//  ThemeHelper.swift
//  Calendar
//
//  Created by C Chan on 28/1/2022.
//

import Foundation
import UIKit

class ThemeHelper {
    
    static func applyTheme() {
        if #available(iOS 13.0, *) {
            if UserDefaults.standard.bool(forKey: Constants.UserDefaults.DarkMode) {
                UIApplication.shared.connectedScenes.forEach { (scene: UIScene) in
                    (scene.delegate as? SceneDelegate)?.window?.overrideUserInterfaceStyle = .dark
                }
                UIApplication.shared.delegate?.window??.overrideUserInterfaceStyle = .dark
                UIWindow.appearance().overrideUserInterfaceStyle = .dark
            } else {
                UIApplication.shared.connectedScenes.forEach { (scene: UIScene) in
                    (scene.delegate as? SceneDelegate)?.window?.overrideUserInterfaceStyle = .light
                }
                UIApplication.shared.delegate?.window??.overrideUserInterfaceStyle = .light
                UIWindow.appearance().overrideUserInterfaceStyle = .light
            }
            let navigationBarAppearance = UINavigationBarAppearance()
                       
            navigationBarAppearance.backgroundColor = .appColor(.navigationBackground)
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.appColor(.navigationTitle)!]
            navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.appColor(.navigationTitle)!]
            
            UINavigationBar.appearance().backgroundColor = .appColor(.navigationBackground)
            UINavigationBar.appearance().barTintColor = .appColor(.navigationBackground)
            UIBarButtonItem.appearance().tintColor = .appColor(.surface)
            UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.appColor(.surface)!], for: .selected)
            UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.appColor(.onSurface)!], for: .normal)
            
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactScrollEdgeAppearance = navigationBarAppearance
            UINavigationBar.appearance().isTranslucent = true
            
            UITabBar.appearance().isTranslucent = false
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = .appColor(.navigationBackground)
            UITabBar.appearance().barTintColor = .appColor(.navigationBackground)
            UITabBar.appearance().backgroundColor = .appColor(.navigationBackground)
            UITabBar.appearance().tintColor = .appColor(.navigationTitle)
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            
        }
        else {
            // Fallback on earlier versions
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().barTintColor = .appColor(.navigationBackground)
            UINavigationBar.appearance().tintColor = .appColor(.navigationTitle)
            UITabBar.appearance().tintColor = .appColor(.navigationTitle)
        }
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .appColor(.onSurface)
        UISegmentedControl.appearance().backgroundColor = .appColor(.surface)
        UISegmentedControl.appearance().tintColor = .appColor(.surface)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.appColor(.surface)!], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.appColor(.onSurface)!], for: .normal)
        UIButton.appearance().tintColor = UIColor.appColor(.navigationTitle)!
        UISwitch.appearance().onTintColor = .appColor(.navigationTitle)
        UIRefreshControl.appearance().tintColor = .appColor(.navigationTitle)
        UIToolbar.appearance().tintColor = .appColor(.navigationTitle)
        
        UILabel.appearance().textColor = .appColor(.primary)
        UITableViewCell.appearance().backgroundColor = .appColor(.background)
        UITableViewHeaderFooterView.appearance().tintColor = .appColor(.primary)
        LightPaddingLabel.appearance().textColor = .appColor(.onPrimary)
        FieldUILabel.appearance().textColor = .appColor(.secondary)

        let popoverBarAppearance = UINavigationBar.appearance(whenContainedInInstancesOf: [UIPopoverPresentationController.self])
        popoverBarAppearance.tintColor = .appColor(.navigationTitle)
        popoverBarAppearance.barTintColor = nil
        popoverBarAppearance.barStyle = .default
        
    }
}
