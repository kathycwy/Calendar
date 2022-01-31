//
//  NSAttributedStringExtension.swift
//  Calendar
//
//  Created by C Chan on 29/1/2022.
//
//  To add new or override functions in class

import Foundation
import UIKit

extension NSMutableAttributedString {

    func getRangeOfString(textToFind:String)-> NSRange{
        let foundRange = self.mutableString.range(of: textToFind)
        
        return foundRange
    }
}
