//
//  Preferences.swift
//  Calendar
//
//  Created by C Chan on 27/1/2022.
//

import Foundation

class Preferences {
   var colourTheme = true, fontSize = true, notification = true
}

enum PrefRowIdentifier : String {
    case colourTheme = "Colour Theme"
    case fontSize = "Font Size"
    case notification = "Notification"
}
