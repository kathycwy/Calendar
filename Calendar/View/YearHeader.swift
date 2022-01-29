//
//  YearHeader.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//
//  A header class used for showing the year in Year View

import Foundation
import UIKit

class YearHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    @IBOutlet weak var yearLabel : UILabel!
    
    // MARK: - Init

    override func prepareForReuse() {
        super.prepareForReuse()
        yearLabel.text = ""
        yearLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        yearLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        yearLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        yearLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }

}
