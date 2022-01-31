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
        static let locationCoordinateLatitudeAttribute: String = "locationCoordinateLatitude"
        static let locationCoordinateLongitudeAttribute: String = "locationCoordinateLongitude"
        static let classTypeAttribute: String = "classType"
        static let instructorAttribute: String = "instructor"

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
    
    // names of the default calendars
    struct TagConstants {
        static let tagNone: String = "None"
        static let tagRed: String = "Red"
        static let tagOrange: String = "Orange"
        static let tagGreen: String = "Green"
        static let tagBlue: String = "Blue"
        static let tagPurple: String = "Purple"
        
        static let tagRedColor: UIColor = UIColor.appColor(tagRed) ?? .clear
        static let tagOrangeColor: UIColor = UIColor.appColor(tagOrange) ?? .clear
        static let tagGreenColor: UIColor = UIColor.appColor(tagGreen) ?? .clear
        static let tagBlueColor: UIColor = UIColor.appColor(tagBlue) ?? .clear
        static let tagPurpleColor: UIColor = UIColor.appColor(tagPurple) ?? .clear
        
        static let tagRedDot: UIImage = UIImage(systemName: "circle.fill")!.withTintColor(tagRedColor, renderingMode: .alwaysOriginal)
        static let tagOrangeDot: UIImage = UIImage(systemName: "circle.fill")!.withTintColor(tagOrangeColor, renderingMode: .alwaysOriginal)
        static let tagGreenDot: UIImage = UIImage(systemName: "circle.fill")!.withTintColor(tagGreenColor, renderingMode: .alwaysOriginal)
        static let tagBlueDot: UIImage = UIImage(systemName: "circle.fill")!.withTintColor(tagBlueColor, renderingMode: .alwaysOriginal)
        static let tagPurpleDot: UIImage = UIImage(systemName: "circle.fill")!.withTintColor(tagPurpleColor, renderingMode: .alwaysOriginal)
        
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
    
    // class types
    struct ClassTypes {
        static let classLecture: String = "Lecture"
        static let classLab: String = "Lab"
        static let classSeminar: String = "Seminar"
        static let classAssignment: String = "Assignment"
        static let classOther: String = "Other"
    }

}
