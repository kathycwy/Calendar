//
//  CalendarMonth.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//
//  A struct for storing all constant values

import UIKit

struct Constants {

    static let appName: String = "Calendar"
    
    struct UserDefaults {
        static let ColourTheme = "ColourTheme"
        static let FontSize = "FontSize"
        static let DarkMode = "DarkMode"
        static let DisplayWeekNumber = "DisplayWeekNumber"
        static let StartDayOfWeek = "StartDayOfWeek"
    }
    
    struct ColourThemes {
        static let teal = "Teal"
        static let orange = "Orange"
        static let blue = "Blue"
    }
    
    struct FontSize{
        static let large = "Large"
        static let normal = "Normal"
        static let small = "Small"
    }

}
