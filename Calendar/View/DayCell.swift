//
//  DayCell.swift
//  Calendar
//
//  Created by Aparna Joshi on 25/01/22.
//

import UIKit

class DayCell: UITableViewCell
{
    @IBOutlet weak var timeLabel: PaddingLabel!
    @IBOutlet weak var event: PaddingLabel!
    @IBOutlet weak var moreEvents: PaddingLabel!
    @IBOutlet weak var eventView: UIView!
    
    func initCell(indexPath: IndexPath) {
        self.timeLabel.padding(5, 5, 5, 5)
        self.timeLabel.text = ""
        self.timeLabel.font = timeLabel.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 16)
        self.timeLabel.textColor = UIColor.appColor(.onSurface)
        self.event.padding(5, 5, 5, 5)
        self.event.textColor = UIColor.appColor(.onSurface)
        self.event.text = ""
        self.event.font = event.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 16)
        self.event.textColor = UIColor.appColor(.onSurface)
        self.moreEvents.padding(5, 5, 5, 5)
        self.moreEvents.text = ""
        self.moreEvents.font = moreEvents.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 16)
        self.moreEvents.textColor = UIColor.appColor(.onSurface)
        self.event.layer.borderColor = UIColor.appColor(.onSurface)?.cgColor
        self.event.layer.borderWidth = 1
        self.event.backgroundColor = UIColor.appColor(.onSurface)?.withAlphaComponent(0.2)
    }
        
        
}
