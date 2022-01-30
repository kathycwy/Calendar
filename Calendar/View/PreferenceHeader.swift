//
//  PreferenceHeader.swift
//  Calendar
//
//  Created by C Chan on 27/1/2022.
//
//  A cell class used for showing the setting item in preference view

import UIKit

class PreferenceHeader: UIView {
    
    // MARK: - Init
    
    func initHeader(section: Int) {
        backgroundColor = UIColor.appColor(.primary)
        
        let headerLabel: UILabel = {
            let label = UILabel()
            label.font = label.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 16)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = UIColor.appColor(.onPrimary)
            return label
        }()
        
        switch section {
        case 0:
            headerLabel.text = "App Icon"
            addSubview(headerLabel)
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            headerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            break
        case 1:
            headerLabel.text = "User Interface Settings"
            addSubview(headerLabel)
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            headerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            break
        /*
        case 2:
            headerLabel.text = "Notification Settings"
            addSubview(headerLabel)
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            headerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            break
         */
        case 2:
            headerLabel.text = "Calendar Setting"
            addSubview(headerLabel)
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            headerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            break
        default:
            break
        }
    }
    
}
