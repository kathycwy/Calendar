//
//  CalendarViewControllerExtension.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import UIKit

class CalendarCollectionViewDataSource : NSObject, UICollectionViewDataSource {

    private var calendarRange: [CalendarDay] = []
    private var calendarMonth: CalendarMonth?
    private var calendarHelper: CalendarHelper = CalendarHelper()
    private var startDOW: Int = 7
    private let numOfCells: Int = 42
    private let numOfMonths: Int = 1

    init(selectedDate: Date){
        super.init()
        self.refreshCalendar(selectedDate: selectedDate)
    }

    // Number of months shown
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numOfMonths
    }

    // Number of days shown in a particular month
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfCells
    }
    
    func refreshCalendar(selectedDate: Date){
        let year = Calendar.current.component(.year, from:selectedDate)
        let month = Calendar.current.component(.month, from:selectedDate)
        let startDate = calendarHelper.getFirstDayOfMonth(year: year, month: month)
        calendarMonth = calendarHelper.getCalendarMonth(year: year, month: month)
        calendarRange = calendarHelper.getCalendarDays(withStartDate: startDate, startDOW: startDOW)
    }
    
    // Contrusting the header of the collection view - Showing Month
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as? CalendarHeader else{
                    return UICollectionReusableView()
                }
                // Set header to month
            header.monthLabel.text = calendarHelper.monthStringFull(date: calendarMonth!.firstDayOfMonth)
                
                return header
            default:
                fatalError("Invalid element type")
        }
    }
    
    // Contrusting the cells of the collection view - Showing dates
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = indexPath.item + 1
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as? CalendarCell else {
            return UICollectionViewCell()
        }
        
        var displayStr: String = ""
        var i: Int = 0
        if calendarRange[0].displayIndex >= day{
            while (i < calendarMonth!.numOfDatesInMonth && displayStr == ""){
                if calendarRange[i].displayIndex == day{
                    displayStr = String(calendarRange[i].dayString)
                }
                i += 1
            }
        }
        cell.dateLabel.text = displayStr

        return cell
    }
}
