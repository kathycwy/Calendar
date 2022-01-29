//
//  WeeklyEventCell.swift
//  Calendar
//
//  Created by Wingyin Chan on 29.01.22.
//
//  A cell class used for showing the events in Week View, Search View and Event List View

import UIKit

class EventCell: UITableViewCell {
    
    // MARK: - Properties
    
    IBOutlet weak var colorBar: UIView!
    IBOutlet weak var endDateLabel: PaddingLabel!
    IBOutlet weak var startDateLabel: PaddingLabel!
    IBOutlet weak var titleLabel: PaddingLabel!
    
    // MARK: - Init

    func initCell(indexPath: IndexPath) {
        if (indexPath.row % 2 == 0) {
            self.backgroundColor = UIColor.appColor(.surface)
        }
        else {
            self.backgroundColor = UIColor.appColor(.navigationBackground)?.withAlphaComponent(0.6)
        }
        
        self.colorBar.backgroundColor = .clear
        self.colorBar.isHidden = false
        
        self.titleLabel.sizeToFit()
        self.titleLabel.padding(5, 5, 5, 5)
        self.titleLabel.text = ""
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.titleLabel.font = titleLabel.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 16)
        self.titleLabel.textColor = UIColor.appColor(.onSurface)
        
        self.endDateLabel.padding(5, 5, 5, 5)
        self.endDateLabel.textColor = UIColor.appColor(.onSurface)
        self.endDateLabel.text = ""
        self.endDateLabel.font = endDateLabel.font.withSize(UIFont.appFontSize(.tableViewCellInfo) ?? 13)
        self.endDateLabel.textColor = UIColor.appColor(.navigationTitle)
        self.endDateLabel.sizeToFit()
        
        self.startDateLabel.padding(5, 5, 5, 5)
        self.startDateLabel.text = ""
        self.startDateLabel.font = startDateLabel.font.withSize(UIFont.appFontSize(.tableViewCellInfo) ?? 13)
        self.startDateLabel.textColor = UIColor.appColor(.navigationTitle)
        self.startDateLabel.sizeToFit()
        
    }
        
        
}
