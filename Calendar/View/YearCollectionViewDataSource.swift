//
//  CalendarViewControllerExtension.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import UIKit

class YearCollectionViewDataSource : NSObject, UICollectionViewDataSource {

    private var calendarYears: [CalendarYear] = []
    private var calendarHelper: CalendarHelper = CalendarHelper()
    private let numOfCells: Int = 12
    private let defNumOfYears: Int = 50
    private let defNumOfCells: Int = 12
    private var selectedIndexPath: IndexPath? = nil
    private var selectedInnerIndexPath: IndexPath? = nil

    // Number of years shown
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if calendarYears.count == 0{
            return defNumOfYears
        }
        return calendarYears.count
    }

    // Number of months shown in a particular year
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if calendarYears.count == 0{
            return defNumOfCells
        }
        return calendarYears[section].calendarMonths.count
    }
    
    func getCalendarYears() -> [CalendarYear]{
        return self.calendarYears
    }
    
    func getInitCalendar(calendarYears: [CalendarYear], selectedDate: Date) -> [CalendarYear] {
        if calendarYears.count == 0{
            self.calendarYears.removeAll(keepingCapacity: false)
            let year = Calendar.current.component(.year, from:selectedDate) + 10
            for tempYear in 1970 ... year {
                let calYear = calendarHelper.getCalendarYear(year: tempYear)
                self.calendarYears.append(calYear)
            }
        }
        else{
            self.calendarYears = calendarYears
        }
        return self.calendarYears
    }
    
    func getSelectedInnerCell() -> IndexPath? {
        return self.selectedInnerIndexPath
    }
    
    func getExtendedCalendarYears(numberOfYears: Int) -> [CalendarYear] {
        if numberOfYears > 0 {
            let lastCalYear = self.calendarYears.last
            for i in 1 ... numberOfYears {
                let tempDate = calendarHelper.addMonth(date: calendarHelper.getFirstDayOfMonth(year: lastCalYear!.year, month: 2), n: 12 * i)
                let tempYear = Calendar.current.component(.year, from:tempDate)
                let calYear = calendarHelper.getCalendarYear(year: tempYear)
                self.calendarYears.append(calYear)
            }
        }
        return self.calendarYears
    }
    
    // Contrusting the header of the collection view - Showing Year
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: "yearHeaderView",
                    for: indexPath) as? YearHeader else{
                    return UICollectionReusableView()
                }
            if self.calendarYears.count > 0 {
                // Set header to year
                header.backgroundColor = UIColor.appColor(.primary)
                header.yearLabel.text = String(calendarYears[indexPath.section].year)
                header.yearLabel.textColor = UIColor.appColor(.onPrimary)
            }
            return header
        default:
            fatalError("Invalid element type")
        }
    }
    
    // Contrusting the cells of the collection view - Showing months
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "yearCell", for: indexPath) as? YearCell else {
            return UICollectionViewCell()
        }
        if self.calendarYears.count > 0 {
            var tempMonth: [CalendarMonth] = []
            tempMonth.append(self.calendarYears[indexPath.section].calendarMonths[indexPath.row])
            cell.activateCell(calendarMonths: tempMonth)
            cell.contentView.backgroundColor = .none
        }
        
        return cell
    }
    
}
