//
//  TableViewCell.swift
//  Calendar
//
//  Created by Samuel Kwong on 25.01.22.
//
//  A cell class used for showing the function name and icon in the Nav bar

import UIKit

class TableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet var label: UILabel!
    @IBOutlet var icon: UIImageView!
    
    // MARK: - Init

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
