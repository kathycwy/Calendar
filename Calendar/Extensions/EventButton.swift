//
//  EventButton.swift
//  Calendar
//
//  Created by C Chan on 30/1/2022.
//
//  A UIButton with event properties for day view

import UIKit
import CoreData

class EventButton: UIButton {
    var event: NSManagedObject? = nil
    var displayedStartDate: Date? = nil
    var displayedEndDate: Date? = nil
}
