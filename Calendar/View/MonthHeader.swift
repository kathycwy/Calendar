//
//  MonthHeader.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import Foundation
import UIKit

class MonthHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    @IBOutlet weak var monthLabel : UILabel!
    @IBOutlet weak var nextMonthButton : UIButton!
    @IBOutlet weak var prevMonthButton : UIButton!
    
    // MARK: - Init

    override func prepareForReuse() {
        super.prepareForReuse()
        monthLabel.text = ""
        monthLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        monthLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        monthLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        monthLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundColor = UIColor.appColor(.primary)
        monthLabel.textColor = UIColor.appColor(.onPrimary)
    }

}
