//
//  CalendarMonth.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import Foundation

struct CalendarWeek {
    let month: Int
    var toMonth: Int
    let year: Int
    var toYear: Int
    let weekNumber: Int
    let rollingWeekNumber: Int
    var calendarDays: [CalendarDay]
    
    init(month: Int,
         toMonth: Int? = nil,
         year: Int,
         toYear: Int? = nil,
         weekNumber: Int,
         rollingWeekNumber: Int,
         calendarDays: [CalendarDay] = []
        ) {
        self.month = month
        self.toMonth = toMonth ?? month
        self.year = year
        self.toYear = toYear ?? year
        self.weekNumber = weekNumber
        self.rollingWeekNumber = rollingWeekNumber
        self.calendarDays = calendarDays
    }
    
    mutating func addDays(calendarDays: [CalendarDay]) {
        if calendarDays.count > 0 {
            self.calendarDays.append(contentsOf: calendarDays)
            self.toMonth = calendarDays.last?.month ?? self.toMonth
            self.toYear = Calendar.current.dateComponents([.year], from: (calendarDays.last?.date)!).year ?? self.toYear
        }
    }
}

