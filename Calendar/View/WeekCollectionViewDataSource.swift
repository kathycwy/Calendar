//
//  WeekCollectionViewDataSource.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import UIKit

class WeekCollectionViewDataSource : NSObject, UICollectionViewDataSource {
    
    
    //private var calendarRange: [CalendarDay] = []
    private var calendarWeeks: [CalendarWeek] = []
    private var displayWeeks: [CalendarWeek] = []
    private var calendarHelper: CalendarHelper = CalendarHelper()
    private let numOfCells: Int = 8
    private let defNumOfWeeks: Int = 1
    private var selectedRollingWeekNumber = 0
    private var selectedItem = 0

    init(calendarWeeks: [CalendarWeek]){
        super.init()
        self.calendarWeeks = calendarWeeks
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.displayWeeks.count
    }

    // Number of days shown in a particular month
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfCells
    }
    
    func getDisplayWeeks() -> [CalendarWeek]{
        return self.displayWeeks
    }
    
    func getCalendarWeeks() -> [CalendarWeek]{
        return self.calendarWeeks
    }
    
    func getInitCalendar(calendarYears: [CalendarYear]) -> [CalendarWeek] {
        let today: Date = self.calendarHelper.getCurrentDate()
        let curWeekNumber = self.calendarHelper.weekOfYear(date: today)
        let curYear = self.calendarHelper.getYear(for: today)
        self.selectedRollingWeekNumber = -1
        
        self.calendarWeeks.removeAll(keepingCapacity: false)
        var rollingWeekNumber = 0
        for calendarYear in calendarYears {
            for calendarMonth in calendarYear.calendarMonths {
                rollingWeekNumber = self.calendarWeeks.last?.rollingWeekNumber ?? 0
                var weeks = calendarHelper.getCalendarWeek(calendarMonth: calendarMonth, lastRollingWeekNumber: rollingWeekNumber)
                if self.calendarWeeks.last?.weekNumber == weeks.first?.weekNumber {
                    if var lastweek = self.calendarWeeks.last {
                        lastweek.addDays(calendarDays: weeks.first?.calendarDays ?? [])
                        self.calendarWeeks.indices.last.map{ self.calendarWeeks[$0] = lastweek }
                        if lastweek.rollingWeekNumber == self.selectedRollingWeekNumber {
                            self.displayWeeks = [lastweek]
                        }
                        weeks.removeFirst()
                    }
                }
                self.calendarWeeks.append(contentsOf: weeks)
                
                if curYear == calendarMonth.year && self.selectedRollingWeekNumber == -1 {
                    let curWeek = weeks.first(where: {$0.weekNumber == curWeekNumber})
                    curWeek.map { self.displayWeeks.append($0) }
                    self.selectedRollingWeekNumber = curWeek?.rollingWeekNumber ?? -1
                    self.selectedItem = 1 + (curWeek?.calendarDays.firstIndex(where: {$0.date == today}) ?? -1)
                }
            }
        }
        let prevWeek: CalendarWeek? = self.calendarWeeks[self.selectedRollingWeekNumber - 1]
        let nextWeek: CalendarWeek? = self.calendarWeeks[self.selectedRollingWeekNumber + 1]
        prevWeek.map { self.displayWeeks.insert($0, at: 0) }
        nextWeek.map { self.displayWeeks.append($0) }
        
        self.displayWeeks.removeAll()
        self.displayWeeks.append(contentsOf: self.calendarWeeks)
        return self.calendarWeeks
    }
    
    func getExtendedDisplayWeeks (numberOfWeeks: Int) -> [CalendarWeek] {
        if numberOfWeeks != 0 {
            let lastCalWeek = (self.displayWeeks.last)!
            var i = 1
            let sign = numberOfWeeks < 0 ? -1 : 1
            while i <= abs(numberOfWeeks){
                if let week = self.calendarWeeks.first(where: {$0.rollingWeekNumber == (lastCalWeek.rollingWeekNumber + i * sign )}) {
                    if numberOfWeeks < 0{
                        self.displayWeeks.insert(week, at: 0)
                    }
                    else {
                        self.displayWeeks.append(week)
                    }
                    i += 1
                }
                else{
                    if numberOfWeeks < 0 {
                        break
                    }
                    _ = getExtendedCalendarWeeks(numberOfMonths: 1)
                }
            }
        }
        return self.displayWeeks
    }
    
    func getExtendedCalendarWeeks(numberOfMonths: Int) -> [CalendarWeek] {
        if numberOfMonths > 0 {
            let lastCalDay = (self.calendarWeeks.last?.calendarDays.last?.date)!
            var rollingWeekNumber = 0
            for i in 1 ... numberOfMonths {
                let tempDate = calendarHelper.addMonth(date: lastCalDay, n: i)
                let tempYear = Calendar.current.component(.year, from:tempDate)
                let tempMonth = Calendar.current.component(.month, from:tempDate)
                let calMonth = calendarHelper.getCalendarMonth(year: tempYear, month: tempMonth)
                
                rollingWeekNumber = self.calendarWeeks.last?.rollingWeekNumber ?? 0
                var weeks = calendarHelper.getCalendarWeek(calendarMonth: calMonth, lastRollingWeekNumber: rollingWeekNumber)
                if self.calendarWeeks.last?.weekNumber == weeks.first?.weekNumber {
                    if var lastweek = self.calendarWeeks.last {
                        lastweek.addDays(calendarDays: weeks.first?.calendarDays ?? [])
                        self.calendarWeeks.indices.last.map{ self.calendarWeeks[$0] = lastweek }
                        weeks.removeFirst()
                    }
                }
                self.calendarWeeks.append(contentsOf: weeks)
            }
        }
        return self.calendarWeeks
    }
        
    // Contrusting the cells of the collection view - Showing dates
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as? WeekDayCell else {
            return UICollectionViewCell()
        }
        
        if self.displayWeeks.count > 0 {
            let curRollingWeekNumber = displayWeeks[indexPath.section].rollingWeekNumber
            
            if indexPath.item == 0 {
                cell.initMonthLabel()
                cell.dateLabel.text = self.calendarHelper.monthStringShort(monthNum: self.displayWeeks[indexPath.section].month)
                // cell.dayOfWeekLabel.text = "Week " + String(self.displayWeeks[indexPath.section].weekNumber)
                cell.dayOfWeekLabel.text = String(self.displayWeeks[indexPath.section].year)
            }
            else {
                cell.initDateLabel()
                
                var isSunday: Bool = false
                if (self.calendarWeeks.count > 0) {
                    let calendarRange = self.displayWeeks[indexPath.section].calendarDays
                    
                    // Show date
                    var displayStr: String = ""
                    if calendarRange.count < indexPath.row {
                        cell.dateLabel.text = "#"
                        cell.dayOfWeekLabel.text = "#"
                    }
                    else {
                        displayStr = String(calendarRange[indexPath.row - 1].dayString)
                        if calendarRange[indexPath.row - 1].dayOfWeek == 0 {
                            isSunday = true
                        }
                        DispatchQueue.main.async {
                            cell.dateLabel.text = displayStr
                            cell.dayOfWeekLabel.text = calendarRange[indexPath.row - 1].isDate ? self.calendarHelper.dayOfWeekString(date: calendarRange[indexPath.row - 1].date!) : ""
                            
                            if isSunday{
                                cell.dateLabel.textColor = UIColor.red
                            }
                            if calendarRange[indexPath.row - 1].date == self.calendarHelper.getCurrentDate(){
                                cell.dateLabel.layer.cornerRadius = cell.dateLabel.frame.size.width/2
                                cell.dateLabel.layer.masksToBounds = true
                                cell.dateLabel.backgroundColor = UIColor.appColor(.primary)
                                cell.dateLabel.textColor = UIColor.appColor(.onPrimary)
                            }
                            if curRollingWeekNumber == self.selectedRollingWeekNumber && indexPath.row == self.selectedItem {
                                cell.layer.borderColor = UIColor.appColor(.primary)?.cgColor
                            }
                            let fontsize: CGFloat = UIFont.appFontSize(.collectionViewHeader)!
                            cell.dateLabel.font = cell.dateLabel.font.withSize(fontsize)
                        }
                    }
                }
                
            }
        }
        return cell
    }
    
    func getSelectedIndexPath() -> IndexPath?{
        if let section = self.displayWeeks.firstIndex(where: {$0.rollingWeekNumber == selectedRollingWeekNumber}){
            return IndexPath(row: selectedItem, section: section)
        }
        else {return nil}
    }
    
    func setSelectedCell(item: Int, rollingWeekNumber: Int) {
        self.selectedRollingWeekNumber = rollingWeekNumber
        self.selectedItem = item
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as? WeekDayCell else {
            return UICollectionViewCell()
        }
        
        if self.calendarWeeks.count > 0 {
            if indexPath.item == 0 {
                cell.initMonthLabel()
                cell.dateLabel.text = String(self.calendarWeeks[indexPath.section].month)
                cell.dayOfWeekLabel.text = String(self.calendarWeeks[indexPath.section].weekNumber)
            }
            else {
                cell.initDateLabel()
                
                var isSunday: Bool = false
                if (self.calendarWeeks.count > 0) {
                    let calendarRange = self.calendarWeeks[indexPath.section].calendarDays
                    
                    // Show date
                    var displayStr: String = ""
                    displayStr = String(calendarRange[indexPath.row - 1].dayString)
                    if calendarRange[indexPath.row - 1].dayOfWeek == 0 {
                        isSunday = true
                    }
                    DispatchQueue.main.async {
                        cell.dateLabel.text = displayStr
                        cell.dayOfWeekLabel.text = calendarRange[indexPath.row - 1].isDate ? self.calendarHelper.dayOfWeekString(date: calendarRange[indexPath.row - 1].date!) : ""
                        if isSunday{
                            cell.dateLabel.textColor = UIColor.red
                        }
                        else if calendarRange[indexPath.row - 1].date == self.calendarHelper.getCurrentDate(){
                            //cell.layer.borderColor = UIColor.appColor(.primary)?.cgColor
                            //cell.layer.borderWidth = 2
                            cell.dateLabel.layer.cornerRadius = 8.0
                            cell.dateLabel.layer.masksToBounds = true
                            cell.dateLabel.backgroundColor = UIColor.appColor(.primary)
                            cell.dateLabel.textColor = UIColor.appColor(.onPrimary)
                        }
                        else{
                            cell.dateLabel.textColor = UIColor.appColor(.onSurface)
                        }
                        let fontsize: CGFloat = UIFont.appFontSize(.collectionViewHeader)!
                        cell.dateLabel.font = cell.dateLabel.font.withSize(fontsize)
                    }
                }
                
            }
        }
        return cell
    }
     */
    
}
