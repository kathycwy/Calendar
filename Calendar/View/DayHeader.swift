//
//  DayHeader.swift
//  Calendar
//
//  Created by Aparna Joshi on 26/01/22.
//

import Foundation
import UIKit

class DayHeader : UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    let dayLabel = LightPaddingLabel()
    let dowLabel = LightPaddingLabel()
    
    // MARK: - Init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureContents()
    }
    
    func configureContents() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dowLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.textColor = UIColor.appColor(.onPrimary)
        dowLabel.textColor = UIColor.appColor(.onPrimary)
        dayLabel.font.withSize(UIFont.appFontSize(.collectionViewHeader) ?? 15)
        dowLabel.font.withSize(UIFont.appFontSize(.collectionViewHeader) ?? 15)
        dayLabel.font = UIFont.boldSystemFont(ofSize: dayLabel.font.pointSize)
        dayLabel.padding(3, 3, 3, 3)
        dowLabel.padding(3, 3, 3, 3)
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(dowLabel)
        contentView.backgroundColor = UIColor.appColor(.primary)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 60),
            dayLabel.heightAnchor.constraint(equalToConstant: 20),
            dayLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 0),
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        
            dowLabel.heightAnchor.constraint(equalToConstant: 20),
            dowLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 5),
            dowLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}
