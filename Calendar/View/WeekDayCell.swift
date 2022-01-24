//
//  WeekDayCell.swift
//  Calendar
//
//  Created by C Chan on 16/1/2022.
//

import Foundation
import UIKit

class WeekDayCell: UICollectionViewCell {

    @IBOutlet weak var dayOfWeekLabel : PaddingLabel!
    @IBOutlet weak var dateLabel : PaddingLabel!
    var rollingWeekNumber: Int = -1
    
    func initDateLabel(){
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.appColor(.surface)?.cgColor
        dateLabel.textColor = UIColor.appColor(.tertiary)
        dateLabel.backgroundColor = UIColor.appColor(.background)
        dateLabel.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 12)
        dateLabel.text = ""
        dateLabel.padding(3, 3, 3, 3)
        dayOfWeekLabel.text = ""
        dayOfWeekLabel.backgroundColor = UIColor.appColor(.primary)
        dayOfWeekLabel.textColor = UIColor.appColor(.onPrimary)
        dayOfWeekLabel.font.withSize(UIFont.appFontSize(.innerCollectionViewHeader) ?? 8)
        dayOfWeekLabel.padding(3, 3, 3, 3)
        rollingWeekNumber = -1
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
    }
    
}
