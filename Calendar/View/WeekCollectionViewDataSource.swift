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
    private var selectedDate: Date = Date()

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
    
    func loadDisplayWeek(newSelectedDate: Date) -> [CalendarWeek]{
        self.selectedDate = newSelectedDate
        self.displayWeeks = self.calendarHelper.genCalendarWeek(selectedDate: self.selectedDate)
        return displayWeeks
    }
    
    // Contrusting the cells of the collection view - Showing dates
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as? WeekDayCell else {
            return UICollectionViewCell()
        }
        
        if self.displayWeeks.count > 0 {
            if indexPath.item == 0 {
                cell.initMonthLabel()
                cell.dateLabel.text = self.calendarHelper.monthStringShort(monthNum: self.displayWeeks[indexPath.section].month)
                cell.dayOfWeekLabel.text = String(self.displayWeeks[indexPath.section].year)
            }
            else {
                cell.initDateLabel()
                
                var isSunday: Bool = false
                if (self.displayWeeks.count > 0) {
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
                            if self.selectedDate == calendarRange[indexPath.row - 1].date {
                                cell.layer.borderColor = UIColor.appColor(.onSurface)?.cgColor
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
    
    func setSelectedCell(newSelectedDate: Date) {
        self.selectedDate = newSelectedDate
    }
    
}
