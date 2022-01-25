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
    
    func addDay(date: Date, n: Int) -> Date{
        return calendar.date(byAdding: .day, value: n, to: date)!
    }
    
    func addMonth(date: Date, n: Int) -> Date{
        return calendar.date(byAdding: .month, value: n, to: date)!
    }
    
    func dayOfWeekString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: date)
    }
    
    func monthDayString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.string(from: date)
    }
    
    func monthStringShort(monthNum: Int) -> String{
        let dateFormatter = DateFormatter()
        return dateFormatter.shortMonthSymbols[monthNum - 1]
    }
    
    func monthStringShort(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
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
    
    func weekDayAsString(date: Date) -> String{
        switch weekDay(date: date) {
        case 0:
            return "Sunday"
        case 1:
            return "Monday"
        case 2:
            return "Tuesday"
        case 3:
            return "Wednesday"
        case 4:
            return "Thrusday"
        case 5:
            return "Friday"
        case 6:
            return "Saturday"
        default:
            return ""
        }
    }
    
    func hourFromDate(date: Date) -> Int {
        let components = calendar.dateComponents([.hour], from: date)
        return components.hour!
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
    
    func getCalendarDays(withStartDate startDate: Date) -> [CalendarDay] {
        let startDOW: Int = UserDefaults.standard.integer(forKey: "StartDayOfWeek")
        let month = getCalendarMonthWithoutDay(for: startDate)
        let endDate = self.getLastDayOfMonth(year: month.year, month: month.month)
        let displayIndexBuffer: Int = startDOW == 1 ? month.firstDayOfWeek : ((month.firstDayOfWeek == 7 ? 0 : month.firstDayOfWeek))

        var result: [CalendarDay] = []
        let firstWeekNumber: Int = weekOfYear(date: month.firstDayOfMonth)
        
        if displayIndexBuffer > 0{
            for i in 0 ... displayIndexBuffer - 1 {
                result.append(CalendarDay(
                    dayString: "",
                    displayIndex: i,
                    weekNumber: (i%7==0) ? firstWeekNumber : nil,
                    isDate: false,
                    month: month.month)
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
                dayOfWeek: weekDay(date:date),
                month: month.month)
            )
        }
        
        return result
    }
    
    func getCalendarWeek(calendarMonth: CalendarMonth, lastRollingWeekNumber: Int) -> [CalendarWeek]{
        var calendarWeeks: [CalendarWeek] = []
        var rollingWeekNumber = lastRollingWeekNumber
        var weekNumber: Int = 0
        var week: CalendarWeek?
        var firstElement: Bool = true
        
        for calendarDay in calendarMonth.calendarDays {
            if calendarDay.isDate {
                var days: [CalendarDay] = []
                
                // Create new week
                let curWeekNum = self.weekOfYear(date: calendarDay.date!)
                if curWeekNum != weekNumber {
                    weekNumber = curWeekNum
                    if rollingWeekNumber != 0 && firstElement {
                        let lastDay = self.addDay(date: calendarDay.date!, n: -1)
                        if self.weekOfYear(date: lastDay) != weekNumber {
                            rollingWeekNumber += 1
                        }
                    }
                    else if rollingWeekNumber == 0 && firstElement {
                        for i in 0 ... (calendarDay.dayOfWeek ?? 0 ) - 1 {
                            if let day = calendarDay.date
                            {
                                let date = addDay(date: day, n: ((calendarDay.dayOfWeek ?? 0) - i) * -1)
                                days.append(CalendarDay(
                                    date: date,
                                    dayString: String(self.getDay(for: date)),
                                    displayIndex: i,
                                    weekNumber: (i%7==0) ? calendarDay.weekNumber : nil,
                                    isSelected: false,
                                    isDate: true,
                                    dayOfWeek: weekDay(date:date),
                                    month: calendarDay.month)
                                )
                            }
                            else{
                                days.append(CalendarDay(
                                    dayString: "",
                                    displayIndex: i,
                                    weekNumber: (i%7==0) ? calendarDay.weekNumber : nil,
                                    isDate: false,
                                    month: calendarDay.month)
                                )
                            }
                        }
                    }
                    days.append(calendarDay)
                        
                    if firstElement {
                        firstElement = false
                    }
                    week.map { calendarWeeks.append($0) }
                    week = CalendarWeek(
                        month: calendarMonth.month,
                        toMonth: calendarMonth.month,
                        year: calendarMonth.year,
                        weekNumber: weekNumber,
                        rollingWeekNumber: rollingWeekNumber,
                        calendarDays: days
                    )
                    rollingWeekNumber += 1
                }
                // Add to last week
                else {
                    week?.addDays(calendarDays: [calendarDay])
                }
            }
        }
        week.map { calendarWeeks.append($0) }
        return calendarWeeks
    }
    
    func getCalendarMonthWithoutDay(for date: Date) -> CalendarMonth{
        return self.getCalendarMonthWithoutDay(year: self.getYear(for: date), month: self.getMonth(for: date))
    }
    
    func getCalendarMonthWithoutDay(year: Int, month: Int) -> CalendarMonth{
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
    
    func getCalendarMonth(year: Int, month: Int) -> CalendarMonth{
        let firstDay = self.getFirstDayOfMonth(year: year, month: month)
        let month = CalendarMonth(
            month: month,
            year: year,
            numOfDatesInMonth: self.numOfDatesInMonth(date: firstDay),
            firstDayOfMonth: firstDay,
            LastDayOfMonth: self.getLastDayOfMonth(year: year, month: month),
            firstDayOfWeek: self.weekDay(date: firstDay),
            calendarDays: self.getCalendarDays(withStartDate: firstDay)
            
        )
        return month
    }
    
    func getCalendarYear(year: Int) -> CalendarYear{
        var calendarYear = CalendarYear(year: year)
        for i in(1...12){
            calendarYear.calendarMonths.append(self.getCalendarMonth(year: year, month: i))
        }
        return calendarYear
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

