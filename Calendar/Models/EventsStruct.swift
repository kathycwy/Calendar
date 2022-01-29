//
//  EventsStruct.swift
//  Calendar
//
//  Created by Wingyin Chan on 20.01.22.
//
//  A struct for storing all constants that used for events creating/editing

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
    
    // event repeating options
    static let repeatNever: String = "Never"
    static let repeatEveryDay: String = "Every Day"
    static let repeatEveryWeek: String = "Every Week"
    static let repeatEveryMonth: String = "Every Month"
    static let repeatEveryYear: String = "Every Year"
    static let endRepeatNever: String = "Never"
    static let endRepeatOnDate: String = "On Date"
    static let endRepeatAfterCertainTimes: String = "After Certain Times"
}
