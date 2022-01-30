//
//  FieldUILabel.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//
//  A UILabel with padding values and smaller size

import UIKit

class FieldUILabel: PaddingLabel {
    
    // MARK: - Init

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        font = font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 15)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        font = font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 15)
    }
    
}
