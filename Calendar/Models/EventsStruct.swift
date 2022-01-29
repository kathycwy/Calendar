//
//  EventsStruct.swift
//  Calendar
//
//  Created by Wingyin Chan on 20.01.22.
//

struct EventsStruct {
    
    // this struct stores the constants that used for events creating/editing
    
    // entity and attribute names in CoreData
    static let entityName: String = "Events"
    static let allDayAttribute: String = "allDay"
    static let titleAttribute: String = "title"
    static let startDateAttribute: String = "startDate"
    static let repeatOptionAttribute: String = "repeatOption"
    static let endRepeatOptionAttribute: String = "endRepeatOption"
    static let endRepeatDateAttribute: String = "endRepeatDate"
    static let endDateAttribute: String = "endDate"
    static let locationAttribute: String = "location"
    static let urlAttribute: String = "url"
    static let notesAttribute: String = "notes"
    static let remindOptionAttribute: String = "remindOption"
    
    // event repeating options
    static let repeatNever: String = "Never"
    static let repeatEveryDay: String = "Every Day"
    static let repeatEveryWeek: String = "Every Week"
    static let repeatEveryMonth: String = "Every Month"
    static let repeatEveryYear: String = "Every Year"
    static let endRepeatNever: String = "Never"
    static let endRepeatOnDate: String = "On Date"
    static let endRepeatAfterCertainTimes: String = "After Certain Times"
    
    // event reminding options
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
