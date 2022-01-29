//
//  UIColorExtension.swift
//  Calendar
//
//  Created by C Chan on 16/1/2022.
//
//  To add new or override functions in class

import UIKit

enum AssetsColor : String{
    case background
    case navigationBackground
    case navigationTitle
    case primary
    case onPrimary
    case secondary
    case onSecondary
    case tertiary
    case onTertiary
    case surface
    case onSurface
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        let colourTheme = UserDefaults.standard.string(forKey: Constants.UserDefaults.ColourTheme) ?? Constants.ColourThemes.teal
        let colourName = colourTheme + "-" + name.rawValue
        return UIColor(named: colourName)
    }
}
