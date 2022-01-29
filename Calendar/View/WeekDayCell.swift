//
//  WeekDayCell.swift
//  Calendar
//
//  Created by C Chan on 16/1/2022.
//

import Foundation
import UIKit

class WeekDayCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var dayOfWeekLabel : PaddingLabel!
    @IBOutlet weak var dateLabel : PaddingLabel!
    @IBOutlet weak var taskLabel : PaddingLabel!
    var rollingWeekNumber: Int = -1
    
    // MARK: - Init

    override func prepareForReuse() {
        initDateLabel()
    }
    
    func initDateLabel(){
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.appColor(.surface)?.cgColor
        dateLabel.textColor = UIColor.appColor(.tertiary)
        dateLabel.backgroundColor = UIColor.appColor(.background)
        dateLabel.font.withSize(UIFont.appFontSize(.collectionViewHeader) ?? 12)
        dateLabel.text = ""
        dateLabel.padding(3, 3, 3, 3)
        dayOfWeekLabel.text = ""
        dayOfWeekLabel.backgroundColor = UIColor.appColor(.primary)
        dayOfWeekLabel.textColor = UIColor.appColor(.onPrimary)
        dayOfWeekLabel.font.withSize(UIFont.appFontSize(.innerCollectionViewHeader) ?? 8)
        dayOfWeekLabel.padding(3, 3, 3, 3)
        rollingWeekNumber = -1
        taskLabel.backgroundColor = UIColor.appColor(.background)
        taskLabel.text = ""
    }
    
    func initMonthLabel(){
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.appColor(.surface)?.cgColor
        dateLabel.textColor = UIColor.appColor(.onSurface)
        dateLabel.font.withSize(UIFont.appFontSize(.collectionViewHeader) ?? 12)
        dateLabel.backgroundColor = UIColor.appColor(.background)
        dateLabel.text = ""
        dateLabel.padding(3, 3, 3, 3)
        dayOfWeekLabel.text = ""
        dayOfWeekLabel.backgroundColor = UIColor.appColor(.primary)
        dayOfWeekLabel.textColor = UIColor.appColor(.onPrimary)
        dayOfWeekLabel.font.withSize(UIFont.appFontSize(.innerCollectionViewHeader) ?? 8)
        dayOfWeekLabel.padding(3, 3, 3, 3)
        rollingWeekNumber = -1
        taskLabel.backgroundColor = UIColor.appColor(.background)
        taskLabel.text = ""
    }
    
    // MARK: - Helper functions

    // Call this function if there are events on this day
    func setTaskIndicator(numberOfTasks: Int = 10){
        taskLabel.text = String(numberOfTasks)
        taskLabel.textColor = UIColor.appColor(.surface)
        taskLabel.layer.masksToBounds = true
        taskLabel.backgroundColor = UIColor.appColor(.onSurface)
        taskLabel.layer.cornerRadius = taskLabel.frame.width/2
        taskLabel.font = taskLabel.font.withSize(UIFont.appFontSize(.innerCollectionViewCell) ?? 8)
        
    }
    
}
