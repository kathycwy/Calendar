//
//  CalendarViewControllerExtension.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import UIKit

class MonthCollectionViewDataSource : NSObject, UICollectionViewDataSource {

    //private var calendarRange: [CalendarDay] = []
    private var calendarMonths: [CalendarMonth] = []
    private var calendarHelper: CalendarHelper = CalendarHelper()
    private var startDOW: Int = 7
    private let numOfCells: Int = 42 // 7 cols * 6 rows
    private let defNumOfMonths: Int = 12
    private let defNumOfCells: Int = 42

    init(calendarMonths: [CalendarMonth], selectedDate: Date){
        super.init()
    }

    // Number of months shown
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if calendarMonths.count == 0{
            return defNumOfMonths
        }
        return calendarMonths.count
    }

    // Number of days shown in a particular month
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if calendarMonths.count == 0{
            return defNumOfCells
        }
        return calendarMonths[section].calendarDays.count
    }
    
    func getCalendarMonths() -> [CalendarMonth]{
        return self.calendarMonths
    }
    
    func getInitCalendar(calendarMonths: [CalendarMonth], selectedDate: Date) -> [CalendarMonth] {
        self.calendarMonths.removeAll(keepingCapacity: false)
        let year = Calendar.current.component(.year, from:selectedDate)
        let month = Calendar.current.component(.month, from:selectedDate)
        let startDate = calendarHelper.getFirstDayOfMonth(year: year, month: month)
        if calendarMonths.count == 0{
            for tempYear in 1970 ... year {
                for tempMonth in 1 ... 12 {
                    let calMonth = calendarHelper.getCalendarMonth(year: tempYear, month: tempMonth, startDOW: self.startDOW)
                    self.calendarMonths.append(calMonth)
                }
            }
        }
        else{
            self.calendarMonths = calendarMonths
        }
        return self.calendarMonths
    }
    
    func getExtendedCalendarMonths(numberOfMonths: Int) -> [CalendarMonth] {
        if numberOfMonths > 0 {
            let lastCalMonth = self.calendarMonths.last
            for i in 1 ... numberOfMonths {
                let tempDate = calendarHelper.addMonth(date: lastCalMonth!.firstDayOfMonth, n: i)
                let tempYear = Calendar.current.component(.year, from:tempDate)
                let tempMonth = Calendar.current.component(.month, from:tempDate)
                let calMonth = calendarHelper.getCalendarMonth(year: tempYear, month: tempMonth, startDOW: self.startDOW)
                self.calendarMonths.append(calMonth)
            }
        }
        else{
            let lastCalMonth = self.calendarMonths.first
            for i in stride(from: -1, to: numberOfMonths, by: -1){
                let tempDate = calendarHelper.addMonth(date: lastCalMonth!.firstDayOfMonth, n: i)
                let tempYear = Calendar.current.component(.year, from:tempDate)
                let tempMonth = Calendar.current.component(.month, from:tempDate)
                let calMonth = calendarHelper.getCalendarMonth(year: tempYear, month: tempMonth, startDOW: self.startDOW)
                self.calendarMonths.insert(calMonth, at: 0)
            }
        }
        return self.calendarMonths
    }
    
    // Contrusting the header of the collection view - Showing Month
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: "headerView",
                    for: indexPath) as? CalendarHeader else{
                    return UICollectionReusableView()
                }
                // Set header to month
            header.backgroundColor = UIColor.appColor(.primary)
            header.monthLabel.text = calendarHelper.monthStringFull(date: calendarMonths[indexPath.section].firstDayOfMonth)
            header.monthLabel.textColor = UIColor.appColor(.onPrimary)
            //header.monthLabel.center.x = header.center.x
            return header
        default:
            fatalError("Invalid element type")
        }
    }
    
    // Contrusting the cells of the collection view - Showing dates
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as? CalendarCell else {
            return UICollectionViewCell()
        }
        
        cell.initLabel()
        
        let calendarRange = calendarMonths[indexPath.section].calendarDays
        
        // Show week number
        let displayWeekNum: String = calendarRange[indexPath.row].weekNumber != nil ? String(calendarRange[indexPath.row].weekNumber!) : ""
        
        // Show date
        var displayStr: String = ""
        var isSunday = false
        displayStr = String(calendarRange[indexPath.row].dayString)
        if calendarRange[indexPath.row].dayOfWeek == 0 {
            isSunday = true
        }
        
        let isDisplayWeekNumber: Bool = UserDefaults.standard.bool(forKey: "DisplayWeekNumber")
        
        DispatchQueue.main.async {
            cell.dateLabel.text = displayStr
            cell.weekLabel.text = isDisplayWeekNumber ? displayWeekNum : ""
            //cell.weekLabel.text = String(indexPath.row)
            if isSunday{
                cell.dateLabel.textColor = UIColor.red
            }
            else if calendarRange[indexPath.row].date == self.calendarHelper.getCurrentDate(){
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
        }
        
        return cell
    }
    
}
