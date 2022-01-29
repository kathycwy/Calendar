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
            /*case 0:
             let profileImageView: UIImageView = {
                 let iv = UIImageView()
                 iv.contentMode = .scaleAspectFill
                 iv.clipsToBounds = true
                 iv.translatesAutoresizingMaskIntoConstraints = false
                 iv.image = UIImage(named: "ironman")
                 return iv
             }()
            let profileImageDimension: CGFloat = 60
            
            addSubview(profileImageView)
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
            profileImageView.layer.cornerRadius = profileImageDimension / 2
             break
                */
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
        case 2:
            headerLabel.text = "Notification Settings"
            addSubview(headerLabel)
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            headerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            break
        case 3:
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
