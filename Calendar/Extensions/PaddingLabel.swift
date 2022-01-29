//
//  PaddingLabel.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//
//  A UILabel with padding values

import UIKit

class PaddingLabel: UILabel {
    
    // MARK: - Properties
    
    var insets = UIEdgeInsets.zero
    
    // MARK: - Helper functions

    func padding(_ top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width + left + right, height: self.frame.height + top + bottom)
        insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += insets.top + insets.bottom
            contentSize.width += insets.left + insets.right
            return contentSize
        }
    }
}
