//
//  CalendarViewControllerExtension.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import UIKit

class MonthCollectionViewDataSource : NSObject, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    

    //private var calendarRange: [CalendarDay] = []
    private var isAsInnerCollectionView: Bool = false
    private var calendarMonths: [CalendarMonth] = []
    private var calendarHelper: CalendarHelper = CalendarHelper()
    private let numOfCells: Int = 42 // 7 cols * 6 rows
    private let defNumOfMonths: Int = 12
    private let defNumOfCells: Int = 42
    private var selectedIndexPath: IndexPath? = nil
    private var eventsPerDate: [NSObject]? = nil

    init(calendarMonths: [CalendarMonth], selectedDate: Date, isAsInnerCollectionView: Bool = false){
        super.init()
        self.isAsInnerCollectionView = isAsInnerCollectionView
        if isAsInnerCollectionView {
            self.calendarMonths = calendarMonths
        }
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
    
    func getInitCalendar(calendarYears: [CalendarYear]) -> [CalendarMonth] {
        if isAsInnerCollectionView == false {
            self.calendarMonths.removeAll(keepingCapacity: false)
        }
        for calendarYear in calendarYears {
            self.calendarMonths.append(contentsOf: calendarYear.calendarMonths)
        }
        return self.calendarMonths
    }
    
    func getInitCalendar(calendarMonths: [CalendarMonth], selectedDate: Date = Date()) -> [CalendarMonth] {
        if isAsInnerCollectionView == false {
            self.calendarMonths.removeAll(keepingCapacity: false)
        }
        if calendarMonths.count == 0{
            let year = Calendar.current.component(.year, from:selectedDate)
            for tempYear in 1970 ... year {
                for tempMonth in 1 ... 12 {
                    let calMonth = calendarHelper.getCalendarMonth(year: tempYear, month: tempMonth)
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
                let calMonth = calendarHelper.getCalendarMonth(year: tempYear, month: tempMonth)
                self.calendarMonths.append(calMonth)
            }
        }
        else{
            let lastCalMonth = self.calendarMonths.first
            for i in stride(from: -1, to: numberOfMonths, by: -1){
                let tempDate = calendarHelper.addMonth(date: lastCalMonth!.firstDayOfMonth, n: i)
                let tempYear = Calendar.current.component(.year, from:tempDate)
                let tempMonth = Calendar.current.component(.month, from:tempDate)
                let calMonth = calendarHelper.getCalendarMonth(year: tempYear, month: tempMonth)
                self.calendarMonths.insert(calMonth, at: 0)
            }
        }
        return self.calendarMonths
    }
    
    func getSelectedIndexPath() -> IndexPath?{
        return self.selectedIndexPath
    }
    
    func getIndexPathBySelectedDate(date: Date) -> IndexPath?{
        let year = self.calendarHelper.getYear(for: date)
        let month = self.calendarHelper.getMonth(for: date)
        if let section = self.calendarMonths.firstIndex(where: {$0.year == year && $0.month == month}) {
            if let item = self.calendarMonths[section].calendarDays.firstIndex(where: {$0.date == date}) {
                self.selectedIndexPath = IndexPath(row: item, section: section)
            }
        }
        return self.selectedIndexPath
    }
    
    func setSelectedIndexPath(indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    // Contrusting the header of the collection view - Showing Month
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: "headerView",
                    for: indexPath) as? MonthHeader else{
                    return UICollectionReusableView()
                }
            // Set header to month
            var fontsize: CGFloat = 0.0
            if (isAsInnerCollectionView) {
                headerView.backgroundColor = UIColor.appColor(.surface)
                headerView.monthLabel.textColor = UIColor.appColor(.onSurface)
                fontsize = UIFont.appFontSize(.innerCollectionViewHeader) ?? 10
            }
            else {
                headerView.backgroundColor = UIColor.appColor(.primary)
                headerView.monthLabel.textColor = UIColor.appColor(.onPrimary)
                fontsize = UIFont.appFontSize(.collectionViewHeader) ?? 17
                
            }
            headerView.monthLabel.text = calendarHelper.monthStringFull(date: calendarMonths[indexPath.section].firstDayOfMonth)
            headerView.monthLabel.font = headerView.monthLabel.font.withSize(fontsize)
            //headerView.monthLabel.center.x = headerView.center.x
            
            return headerView
        default:
            fatalError("Invalid element type")
        }
    }
    
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        // Get the view for the first header
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

        // Use this view to calculate the optimal size based on the collection view's width
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required, // Width is fixed
                                                  verticalFittingPriority: .fittingSizeLevel) // Height can be as large as needed
    }
     */

    
    // Contrusting the cells of the collection view - Showing dates
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthCell", for: indexPath) as? MonthCell else {
            return UICollectionViewCell()
        }
        
        cell.initLabel()
        
        if (calendarMonths.count > 0) {
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
            
            DispatchQueue.main.async { [self] in
                cell.cellDate = calendarRange[indexPath.row].date
                cell.dateLabel.text = displayStr
                cell.weekLabel.text = isDisplayWeekNumber && !self.isAsInnerCollectionView ? displayWeekNum : ""
                
                if let currentDate = cell.cellDate {
                    self.eventsPerDate = EventListController().getEventsByDate(currentDate: currentDate)
                }
                
                if let eventsForToday = self.eventsPerDate {
                    if !eventsForToday.isEmpty {
                        cell.setTaskIndicator()
                    }
                }
                
                
                //cell.weekLabel.text = String(indexPath.row)
                if isSunday {
                    cell.dateLabel.textColor = UIColor.red
                }
                else {
                    cell.dateLabel.textColor = UIColor.appColor(.primary)
                }
                    
                if calendarRange[indexPath.row].date == self.calendarHelper.getCurrentDate(){
                    //cell.layer.borderColor = UIColor.appColor(.primary)?.cgColor
                    //cell.layer.borderWidth = 2
                    cell.dateLabel.layer.cornerRadius = cell.dateLabel.frame.width/2
                    cell.dateLabel.layer.masksToBounds = true
                    cell.dateLabel.backgroundColor = UIColor.appColor(.primary)
                    cell.dateLabel.textColor = UIColor.appColor(.onPrimary)
                    if self.selectedIndexPath == nil {
                        self.selectedIndexPath = indexPath
                    }
                }
                if indexPath == self.selectedIndexPath{
                    cell.layer.borderColor = UIColor.appColor(.primary)?.cgColor
                    cell.layer.borderWidth = 2
                }
                let fontsize: CGFloat = self.isAsInnerCollectionView ? UIFont.appFontSize(.innerCollectionViewHeader)! : UIFont.appFontSize(.collectionViewHeader)!
                cell.dateLabel.font = cell.dateLabel.font.withSize(fontsize)
            }
            
        }
        return cell
    }
    
    
    func collectionView (_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if !calendarMonths.indices.contains(indexPath.section) {
                let fetchCount = calendarMonths.count - indexPath.section - 1
                self.calendarMonths = self.getExtendedCalendarMonths(numberOfMonths: fetchCount)
            }
        }
    }
    /*
    func collectionView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
          if let loader = operations[indexPath] {
            loader.cancel()
            operations[indexPath] = nil
        }
      }
    }
     */
}
