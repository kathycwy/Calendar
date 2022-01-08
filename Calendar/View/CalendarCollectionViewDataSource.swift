//
//  CalendarViewControllerExtension.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import UIKit

class CalendarCollectionViewDataSource : NSObject, UICollectionViewDataSource {

    //private var calendarRange: [CalendarDay] = []
    private var calendarMonths: [CalendarMonth] = []
    private var calendarHelper: CalendarHelper = CalendarHelper()
    private var startDOW: Int = 7
    private let numOfCells: Int = 42
    private let defNumOfMonths: Int = 12

    init(calendarMonths: [CalendarMonth], selectedDate: Date){
        super.init()
        _ = self.getInitCalendar(calendarMonths: calendarMonths, selectedDate: selectedDate)
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
        return numOfCells
    }
    
    func getInitCalendar(calendarMonths: [CalendarMonth], selectedDate: Date) -> [CalendarMonth] {
        let year = Calendar.current.component(.year, from:selectedDate)
        let month = Calendar.current.component(.month, from:selectedDate)
        let startDate = calendarHelper.getFirstDayOfMonth(year: year, month: month)
        if calendarMonths.count == 0{
            for i in -2 ... 2 {
                let tempDate = calendarHelper.addMonth(date: startDate, n: i)
                let tempYear = Calendar.current.component(.year, from:tempDate)
                let tempMonth = Calendar.current.component(.month, from:tempDate)
                let calMonth = calendarHelper.getCalendarMonth(year: tempYear, month: tempMonth, startDOW: self.startDOW)
                self.calendarMonths.append(calMonth)
            }
        }
        else{
            self.calendarMonths = calendarMonths
        }
        return self.calendarMonths
    }
    
    func getExtendedCalendarMonths(numberOfMonths: Int) -> [CalendarMonth] {
        if numberOfMonths < 0 {
            let lastCalMonth = self.calendarMonths.first
            for i in numberOfMonths ... -1 {
                let tempDate = calendarHelper.addMonth(date: lastCalMonth!.firstDayOfMonth, n: i)
                let tempYear = Calendar.current.component(.year, from:tempDate)
                let tempMonth = Calendar.current.component(.month, from:tempDate)
                let calMonth = calendarHelper.getCalendarMonth(year: tempYear, month: tempMonth, startDOW: self.startDOW)
                self.calendarMonths.insert(calMonth, at: 0)
            }
        }
        else{
            let lastCalMonth = self.calendarMonths.last
            for i in 1 ... numberOfMonths {
                let tempDate = calendarHelper.addMonth(date: lastCalMonth!.firstDayOfMonth, n: i)
                let tempYear = Calendar.current.component(.year, from:tempDate)
                let tempMonth = Calendar.current.component(.month, from:tempDate)
                let calMonth = calendarHelper.getCalendarMonth(year: tempYear, month: tempMonth, startDOW: self.startDOW)
                self.calendarMonths.append(calMonth)
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
            header.monthLabel.text = calendarHelper.monthStringFull(date: calendarMonths[indexPath.section].firstDayOfMonth)
                
                return header
            default:
                fatalError("Invalid element type")
        }
    }
    
    // Contrusting the cells of the collection view - Showing dates
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = indexPath.item + 1
        let calendarRange = calendarMonths[indexPath.section].calendarDays
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as? CalendarCell else {
            return UICollectionViewCell()
        }
        
        var displayStr: String = ""
        var i: Int = 0
        var isSunday = false
        if calendarRange[0].displayIndex >= day{
            while (i < calendarMonths[indexPath.section].numOfDatesInMonth && displayStr == ""){
                if calendarRange[i].displayIndex == day{
                    displayStr = String(calendarRange[i].dayString)
                    if calendarRange[i].dayOfWeek == 0 {
                        isSunday = true
                    }
                }
                i += 1
            }
        }
        DispatchQueue.main.async {
            cell.dateLabel.text = displayStr
            if isSunday{
                cell.dateLabel.textColor = UIColor.red
            }
            else{
                cell.dateLabel.textColor = UIColor.black
            }
        }
        //cell.layer.borderColor = UIColor.lightGray.cgColor
        //cell.layer.borderWidth = 0.2
        return cell
    }
}
