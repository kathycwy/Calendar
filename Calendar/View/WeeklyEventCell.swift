//
//  WeeklyEventCell.swift
//  Calendar
//
//  Created by Aparna Joshi on 25/01/22.
//

import UIKit

class WeeklyEventCell: UITableViewCell
{
    
    @IBOutlet weak var eventEndDate: PaddingLabel!
    @IBOutlet weak var eventStartDate: PaddingLabel!
    @IBOutlet weak var eventTitle: PaddingLabel!
    
    func initCell(indexPath: IndexPath) {
        if (indexPath.row % 2 == 0) {
            self.backgroundColor = UIColor.appColor(.surface)
        }
        else {
            self.backgroundColor = UIColor.appColor(.navigationBackground)
        }
        
        self.eventTitle.sizeToFit()
        self.eventTitle.padding(5, 5, 5, 5)
        self.eventTitle.text = ""
        self.eventTitle.font = eventTitle.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 16)
        self.eventTitle.textColor = UIColor.appColor(.onSurface)
        self.eventEndDate.padding(5, 5, 5, 5)
        self.eventEndDate.textColor = UIColor.appColor(.onSurface)
        self.eventEndDate.text = ""
        self.eventEndDate.font = eventEndDate.font.withSize(UIFont.appFontSize(.innerCollectionViewHeader) ?? 13)
        self.eventEndDate.textColor = UIColor.appColor(.onSurface)
        self.eventEndDate.sizeToFit()
        self.eventStartDate.padding(5, 5, 5, 5)
        self.eventStartDate.text = ""
        self.eventStartDate.font = eventStartDate.font.withSize(UIFont.appFontSize(.innerCollectionViewHeader) ?? 13)
        self.eventStartDate.textColor = UIColor.appColor(.onSurface)
        self.eventStartDate.sizeToFit()
        
        if (indexPath.row % 2 == 0) {
            self.backgroundColor = UIColor.appColor(.surface)
        }
        else {
            self.backgroundColor = UIColor.appColor(.navigationBackground)
        }
    }
        
        
}
