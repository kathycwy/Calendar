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

        contentView.addSubview(dayLabel)
        contentView.addSubview(dowLabel)

        NSLayoutConstraint.activate([
            dayLabel.heightAnchor.constraint(equalToConstant: 30),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 10),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        
            dowLabel.heightAnchor.constraint(equalToConstant: 30),
            dowLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: 10),
            dowLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
