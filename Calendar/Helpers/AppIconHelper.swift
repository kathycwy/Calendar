//
//  AppIconHelper.swift
//  Calendar
//
//  Created by C Chan on 28/1/2022.
//
//  A helper class for updating the app icon

import Foundation
import UIKit


extension Bundle {
    public var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
}

class AppIconHelper {
    
    // MARK: - Properties
    
    let application = UIApplication.shared
    
    enum AppIcon: String {
        case AppIconPrimary
        case AppIconR
    }
    
    func changeAppIcon(appIcon: AppIcon) {
        let appIconValue: String? = appIcon == .AppIconPrimary ? nil : appIcon.rawValue
        application.setAlternateIconName(appIconValue)
    }
}
