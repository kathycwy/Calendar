//
//  DayCell.swift
//  Calendar
//
//  Created by Aparna Joshi on 25/01/22.
//
//  A cell class used for showing the dates in Day View

import UIKit

class DayCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var topTimeLabel: UILabel!
    @IBOutlet weak var bottomTimeLabel: UILabel!
    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var nowTime: UILabel!
    
    // MARK: - Init
    
    func initCell() {
        selectionStyle = .none

        self.topTimeLabel.text = ""
        self.topTimeLabel.textColor = UIColor.appColor(.tertiary)
        self.topTimeLabel.textAlignment = .right
        self.topTimeLabel.font = topTimeLabel.font.withSize(UIFont.appFontSize(.innerCollectionViewHeader) ?? 11)
        self.bottomTimeLabel.text = ""
        self.bottomTimeLabel.textColor = UIColor.appColor(.tertiary)
        self.bottomTimeLabel.textAlignment = .right
        self.bottomTimeLabel.font = bottomTimeLabel.font.withSize(UIFont.appFontSize(.innerCollectionViewHeader) ?? 11)
        
        self.separatorLine.backgroundColor = UIColor.appColor(.tertiary)
        self.separatorLine.isHidden = false
        
        self.nowTime.textColor = UIColor.red
        self.nowTime.isHidden = true
        self.nowTime.textAlignment = .right
        self.nowTime.font = bottomTimeLabel.font.withSize(UIFont.appFontSize(.innerCollectionViewHeader) ?? 11)

        self.bottomTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.topTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.separatorLine.translatesAutoresizingMaskIntoConstraints = false
        self.nowTime.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.bottomTimeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.bottomTimeLabel.centerYAnchor.constraint(equalTo: self.bottomAnchor),
            self.bottomTimeLabel.widthAnchor.constraint(equalToConstant: 50),
            self.topTimeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.topTimeLabel.centerYAnchor.constraint(equalTo: self.topAnchor),
            self.topTimeLabel.widthAnchor.constraint(equalToConstant: 50),
            self.separatorLine.leftAnchor.constraint(equalTo: self.bottomTimeLabel.rightAnchor, constant: 8),
            self.separatorLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.separatorLine.heightAnchor.constraint(equalToConstant: 1),
            self.separatorLine.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            
            self.nowTime.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.nowTime.widthAnchor.constraint(equalToConstant: 50),
            ])
    }
}
