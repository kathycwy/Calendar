//
//  NSAttributedStringExtension.swift
//  Calendar
//
//  Created by C Chan on 29/1/2022.
//

import Foundation
import UIKit

extension NSMutableAttributedString {

    public func getRangeOfString(textToFind:String)->NSRange{
        let foundRange = self.mutableString.range(of: textToFind)
        
        return foundRange
    }
}
