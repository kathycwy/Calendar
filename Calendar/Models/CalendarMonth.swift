//
//  CalendarMonth.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//
//  A struct for storing essential data for Month View

import Foundation

struct CalendarMonth {
    let month: Int
    let year: Int
    let numOfDatesInMonth: Int
    let firstDayOfMonth: Date
    let LastDayOfMonth: Date
    let firstDayOfWeek: Int
    var calendarDays: [CalendarDay]
}

