//
//  DayCell.swift
//  Calendar
//
//  Created by Aparna Joshi on 25/01/22.
//

import UIKit

class DayCell: UITableViewCell
{
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var event: UILabel!
    @IBOutlet weak var moreEvents: UILabel!
    
    func initCell(indexPath: IndexPath) {
        self.timeLabel.text = ""
        self.timeLabel.font = timeLabel.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 16)
        self.event.textColor = UIColor.appColor(.primary)
        self.event.text = ""
        self.event.font = event.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 16)
        self.event.textColor = UIColor.appColor(.primary)
        self.moreEvents.text = ""
        self.moreEvents.font = moreEvents.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 16)
        self.moreEvents.textColor = UIColor.appColor(.primary)
    }
        
        
}
