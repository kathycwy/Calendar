//
//  DateExtension.swift
//  Calendar
//
//  Created by C Chan on 29/1/2022.
//
//  To add new or override functions in class

import UIKit

extension Date {
    public var removeTimeStamp : Date? {
       guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
        return nil
       }
       return date
   }
}
