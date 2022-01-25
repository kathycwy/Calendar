//
//  DayHeader.swift
//  Calendar
//
//  Created by Aparna Joshi on 25/01/22.
//

import Foundation
import UIKit

class DayHeader: UICollectionReusableView {
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var dowLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = ""
        dowLabel.text = ""
    }
}
