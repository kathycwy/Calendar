//
//  DayCell.swift
//  Calendar
//
//  Created by Aparna Joshi on 25/01/22.
//

import UIKit

class DayCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var topTimeLabel: UILabel!
    @IBOutlet weak var bottomTimeLabel: UILabel!
    @IBOutlet weak var separatorLine: UIView!
    
    // MARK: - Init

    var topTime: String = "" {
        didSet {
            topTimeLabel.text = topTime
        }
    }
    var bottomTime: String = "" {
        didSet {
            bottomTimeLabel.text = bottomTime
        }
    }
    
    func initCell() {
        selectionStyle = .none

        self.topTimeLabel.textColor = UIColor.appColor(.tertiary)
        self.topTimeLabel.textAlignment = .right
        self.topTimeLabel.font = topTimeLabel.font.withSize(UIFont.appFontSize(.innerCollectionViewHeader) ?? 11)
        self.bottomTimeLabel.textColor = UIColor.appColor(.tertiary)
        self.bottomTimeLabel.textAlignment = .right
        self.bottomTimeLabel.font = bottomTimeLabel.font.withSize(UIFont.appFontSize(.innerCollectionViewHeader) ?? 11)
        self.separatorLine.backgroundColor = UIColor.appColor(.tertiary)

        self.bottomTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.topTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
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
            ])
    }
}
