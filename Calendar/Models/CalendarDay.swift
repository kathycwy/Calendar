//
//  CalendarDay.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import Foundation

struct CalendarDay {
    let date: Date?
    let dayString: String
    let displayIndex: Int
    let weekNumber: Int?
    let isSelected: Bool
    let isDate: Bool
    let dayOfWeek: Int?
    let month: Int
    
    init(date: Date? = nil,
         dayString: String,
         displayIndex: Int,
         weekNumber: Int? = nil,
         isSelected: Bool = false,
         isDate: Bool,
         dayOfWeek: Int? = nil,
         month: Int
        ) {
        self.date = date
        self.dayString = dayString
        self.displayIndex = displayIndex
        self.weekNumber = weekNumber
        self.isSelected = isSelected
        self.isDate = isDate
        self.dayOfWeek = dayOfWeek
        self.month = month
    }
    
}

