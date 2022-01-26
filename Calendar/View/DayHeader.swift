//
//  DayHeader.swift
//  Calendar
//
//  Created by Aparna Joshi on 26/01/22.
//

import Foundation
import UIKit

class DayHeader : UITableViewHeaderFooterView {
    let dayLabel = UILabel()
    let dowLabel = UILabel()
    let prevButton = UIButton()
    let nextButton = UIButton()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dowLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.textColor = UIColor.appColor(.onPrimary)
        dowLabel.textColor = UIColor.appColor(.onPrimary)
        dayLabel.font.withSize(UIFont.appFontSize(.collectionViewHeader) ?? 15)
        dowLabel.font.withSize(UIFont.appFontSize(.collectionViewHeader) ?? 15)

        contentView.addSubview(dayLabel)
        contentView.addSubview(dowLabel)
        contentView.backgroundColor = UIColor.appColor(.primary)

        NSLayoutConstraint.activate([
            dayLabel.heightAnchor.constraint(equalToConstant: 30),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 10),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        
            dowLabel.heightAnchor.constraint(equalToConstant: 30),
            dowLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: 10),
            dowLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
