//
//  WeekEventHeader.swift
//  Calendar
//
//  Created by C Chan on 27/1/2022.
//
//  A cell class used for showing the header of calendar type

import UIKit

class WeekEventHeader: UIView {
    
    // MARK: - Init
    
    let filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(" ", for: .normal)
        button.setImage(UIImage(systemName:"slider.horizontal.3")?.tinted(with: .appColor(.onPrimary) ?? .white), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.tintColor = .appColor(.onPrimary)
        button.showsMenuAsPrimaryAction = true
        button.isContextMenuInteractionEnabled = true
        return button
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.appColor(.onPrimary)
        return label
    }()
    
    func initHeader(section: Int) {
        backgroundColor = UIColor.appColor(.primary)
        
        switch section {
        case 0:
            headerLabel.text = "Weekly Event"
            addSubview(headerLabel)
            addSubview(filterButton)
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            headerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            filterButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            filterButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            filterButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            break
        default:
            break
        }
    }
    
}
