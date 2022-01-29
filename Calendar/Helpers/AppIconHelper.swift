//
//  AppIconHelper.swift
//  Calendar
//
//  Created by C Chan on 28/1/2022.
//

import Foundation
import UIKit

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
