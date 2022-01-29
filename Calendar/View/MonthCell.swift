//
//  MonthCell.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import Foundation
import UIKit

class MonthCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var dateLabel : PaddingLabel!
    @IBOutlet weak var taskLabel : PaddingLabel!
    @IBOutlet weak var weekLabel : UILabel!
    @IBOutlet weak var isSelectedLabel : UILabel!
    var cellDate: Date? = nil
    
    // MARK: - Init

    override func prepareForReuse() {
        super.prepareForReuse()
        initLabel()
    }
    
    func initLabel(){
        dateLabel.textColor = UIColor.appColor(.onSurface)
        dateLabel.backgroundColor = UIColor.appColor(.background)
        weekLabel.textColor = nil
        dateLabel.text = ""
        weekLabel.text = ""
        dateLabel.padding(10, 10, 10, 10)
        self.cellDate = nil
        layer.borderWidth = 0
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
        taskLabel.font = taskLabel.font.withSize(UIFont.appFontSize(.innerCollectionViewHeader) ?? 8)
        
    }
    
}
