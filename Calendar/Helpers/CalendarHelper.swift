//
//  CalendarHelper.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import Foundation

struct CalendarHelper {
    var calendar = Calendar.current
    
    func nextMonth(date: Date) -> Date{
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func previousMonth(date: Date) -> Date{
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func addMonth(date: Date, n: Int) -> Date{
        return calendar.date(byAdding: .month, value: n, to: date)!
    }
    
    func monthStringFull(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func monthStringSingle(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        return dateFormatter.string(from: date)
    }
    
    func yearString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    func numOfDatesInMonth(date: Date) -> Int{
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func dayOfMonth(date: Date) -> Int{
        let components = calendar.dateComponents([.day], from: date)
        return components.day! //ex. 22
    }
    
    func firstDayOfMonth(date: Date) -> Date{
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(date: Date) -> Int{
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
    
    func weekOfYear(date: Date) -> Int{
        let components = calendar.dateComponents([.weekOfYear], from: date)
        return components.weekOfYear!
    }
    
    func todayDateString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "D"
        return dateFormatter.string(from: date)
    }
    
    func dayBefore(date: Date) -> Date {
        return Calendar.current.date(byAdding: DateComponents(day: -1), to: date)!
    }
    
    func getCalendarDays(withStartDate startDate: Date, startDOW: Int) -> [CalendarDay] {
        let month = getCalendarMonthWithoutDay(for: startDate, startDOW: startDOW)
        let endDate = self.getLastDayOfMonth(year: month.year, month: month.month)
        let displayIndexBuffer: Int = startDOW == 1 ? month.firstDayOfWeek : ((month.firstDayOfWeek == 7 ? 0 : month.firstDayOfWeek))

        var result: [CalendarDay] = []
        var firstWeekNumber: Int = weekOfYear(date: month.firstDayOfMonth)
        
        if displayIndexBuffer > 0{
            for i in 0 ... displayIndexBuffer - 1 {
                result.append(CalendarDay(
                    dayString: "",
                    displayIndex: i,
                    weekNumber: (i%7==0) ? firstWeekNumber : nil,
                    isDate: false)
                )
            }
        }
        
        calendar.enumerateDates(startingAfter: dayBefore(date: startDate),
                                matching: DateComponents(hour: 0, minute: 0, second:0),
                                matchingPolicy: .nextTime) { (date, _, stop) in
                                    guard let date = date, date <= endDate else {
                                        stop = true
                                        return
                                    }
            let displayIdx = self.getDay(for: date) + displayIndexBuffer
            result.append( CalendarDay(
                date: date,
                dayString: String(self.getDay(for: date)),
                displayIndex: displayIdx,
                weekNumber: (displayIdx % 7==1) ? weekOfYear(date: date) : nil,
                isSelected: false,
                isDate: true,
                dayOfWeek: weekDay(date:date))
            )
        }
        
        return result
    }
    
    func getCalendarMonthWithoutDay(for date: Date, startDOW: Int) -> CalendarMonth{
        return self.getCalendarMonthWithoutDay(year: self.getYear(for: date), month: self.getMonth(for: date), startDOW: startDOW)
    }
    
    func getCalendarMonthWithoutDay(year: Int, month: Int, startDOW: Int) -> CalendarMonth{
        let firstDay = self.getFirstDayOfMonth(year: year, month: month)
        let month = CalendarMonth(
            month: month,
            year: year,
            numOfDatesInMonth: self.numOfDatesInMonth(date: firstDay),
            firstDayOfMonth: firstDay,
            LastDayOfMonth: self.getLastDayOfMonth(year: year, month: month),
            firstDayOfWeek: self.weekDay(date: firstDay),
            calendarDays: []
        )
        return month
    }
    
    func getCalendarMonth(year: Int, month: Int, startDOW: Int) -> CalendarMonth{
        let firstDay = self.getFirstDayOfMonth(year: year, month: month)
        let month = CalendarMonth(
            month: month,
            year: year,
            numOfDatesInMonth: self.numOfDatesInMonth(date: firstDay),
            firstDayOfMonth: firstDay,
            LastDayOfMonth: self.getLastDayOfMonth(year: year, month: month),
            firstDayOfWeek: self.weekDay(date: firstDay),
            calendarDays: self.getCalendarDays(withStartDate: firstDay, startDOW: 7)
            
        )
        return month
    }

    func getDaysInMonth(for date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)!.count
    }

    func getDay(for date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date).day!
    }

    func getMonth(for date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date).month!
    }
    
    func getYear(for date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date).year!
    }

    func getFirstDayOfMonth(year: Int, month: Int) -> Date {
        return Calendar.current.date(from: DateComponents(year: year, month: month))!
    }
    
    func getLastDayOfMonth(year: Int, month: Int) -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.getFirstDayOfMonth(year: year, month: month))!
    }
    
    func getCurrentDatetime()-> Date {
        var now = Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now)
        nowComponents.hour = Calendar.current.component(.hour, from: now)
        nowComponents.minute = Calendar.current.component(.minute, from: now)
        nowComponents.second = Calendar.current.component(.second, from: now)
        nowComponents.timeZone = NSTimeZone.local
        now = calendar.date(from: nowComponents)!
        return now as Date
    }
    
    func getCurrentDate()-> Date {
        var now = Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now)
        now = calendar.date(from: nowComponents)!
        return now as Date
    }
}

