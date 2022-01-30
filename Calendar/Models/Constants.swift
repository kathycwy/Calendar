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
    
    // CoreData: entity and attribute names of Events
    struct EventsAttribute {
        static let entityName: String = "Events"
        static let allDayAttribute: String = "allDay"
        static let titleAttribute: String = "title"
        static let startDateAttribute: String = "startDate"
        static let repeatOptionAttribute: String = "repeatOption"
        static let endRepeatOptionAttribute: String = "endRepeatOption"
        static let endRepeatDateAttribute: String = "endRepeatDate"
        static let endDateAttribute: String = "endDate"
        static let locationAttribute: String = "location"
        static let calendarAttribute: String = "calendar"
        static let urlAttribute: String = "url"
        static let notesAttribute: String = "notes"
        static let remindOptionAttribute: String = "remindOption"
        static let notificationIDAttribute: String = "notificationID"
    }
    
    // event repeating options
    struct RepeatOptions {
        static let repeatNever: String = "Never"
        static let repeatEveryDay: String = "Every Day"
        static let repeatEveryWeek: String = "Every Week"
        static let repeatEveryMonth: String = "Every Month"
        static let repeatEveryYear: String = "Every Year"
        static let endRepeatNever: String = "Never"
        static let endRepeatOnDate: String = "On Date"
        static let endRepeatAfterCertainTimes: String = "After Certain Times"
    }
    
    // CoreData: entity and attribute names of Calendars
    struct CalendarsAttribute {
        static let entityName: String = "Calendars"
        static let nameAttribute: String = "name"
        static let colorAttribute: String = "color"
    }
    
    // names of the default calendars
    struct CalendarConstants {
        static let calendarNone: String = "None"
        static let calendarPersonal: String = "Personal"
        static let calendarSchool: String = "School"
        static let calendarWork: String = "Work"
        
        static let personalColor: UIColor = UIColor.appColor(calendarPersonal) ?? .clear
        static let schoolColor: UIColor = UIColor.appColor(calendarSchool) ?? .clear
        static let workColor: UIColor = UIColor.appColor(calendarWork) ?? .clear
        
        static let personalDot: UIImage = UIImage(systemName: "circle.fill")!.withTintColor(personalColor, renderingMode: .alwaysOriginal)
        static let schoolDot: UIImage = UIImage(systemName: "circle.fill")!.withTintColor(schoolColor, renderingMode: .alwaysOriginal)
        static let workDot: UIImage = UIImage(systemName: "circle.fill")!.withTintColor(workColor, renderingMode: .alwaysOriginal)
        
        
    }
    
    // event reminding options
    struct RemindOptions {
        static let remindNever: String = "Never"
        static let remindOnDate: String = "On Date"
        static let remind5Min: String = "5 Minutes Before"
        static let remind10Min: String = "10 Minutes Before"
        static let remind15Min: String = "15 Minutes Before"
        static let remind30Min: String = "30 Minutes Before"
        static let remind1Hr: String = "1 Hour Before"
        static let remind2Hr: String = "2 Hours Before"
        static let remind1Day: String = "1 Day Before"
        static let remind2Day: String = "2 Days Before"
        static let remind1Wk: String = "1 Week Before"
    }

}
