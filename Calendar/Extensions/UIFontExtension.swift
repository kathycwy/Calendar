//
//  UIFontExtension.swift
//  Calendar
//
//  Created by C Chan on 16/1/2022.
//
//  To add new or override functions in class

import UIKit

enum FontType : String{
    case innerCollectionViewCell
    case innerCollectionViewHeader
    case tableViewCellInfo
    case collectionViewCell
    case collectionViewHeader
}

struct AppFontSize {
    
    // MARK: - Properties
    
    static let smallInnerCollectionViewCell = 10
    static let smallInnerCollectionViewHeader = 11
    static let smallTableViewCellInfo = 11
    static let smallCollectionViewCell = 13
    static let smallCollectionViewHeader = 14
    static let normalInnerCollectionViewCell = 11
    static let normalInnerCollectionViewHeader = 12
    static let normalTableViewCellInfo = 14
    static let normalCollectionViewCell = 17
    static let normalCollectionViewHeader = 17
    static let largeInnerCollectionViewCell = 11
    static let largeInnerCollectionViewHeader = 15
    static let largeTableViewCellInfo = 17
    static let largeCollectionViewCell = 21
    static let largeCollectionViewHeader = 21
    
    static func get(name:String) -> Int {
        let normal:String = Constants.FontSize.normal
        let large:String = Constants.FontSize.large
        let small:String = Constants.FontSize.small
        
        switch name {
            case normal + "-innerCollectionViewCell": return normalInnerCollectionViewCell
            case normal + "-innerCollectionViewHeader": return normalInnerCollectionViewHeader
            case normal + "-tableViewCellInfo": return normalTableViewCellInfo
            case normal + "-collectionViewCell": return normalCollectionViewCell
            case normal + "-collectionViewHeader": return normalCollectionViewHeader
            
            case large + "-innerCollectionViewCell": return largeInnerCollectionViewCell
            case large + "-innerCollectionViewHeader": return largeInnerCollectionViewHeader
            case large + "-tableViewCellInfo": return largeTableViewCellInfo
            case large + "-collectionViewCell": return largeCollectionViewCell
            case large + "-collectionViewHeader": return largeCollectionViewHeader
            
            case small + "-innerCollectionViewCell": return smallInnerCollectionViewCell
            case small + "-innerCollectionViewHeader": return smallInnerCollectionViewHeader
            case small + "-tableViewCellInfo": return smallTableViewCellInfo
            case small + "-collectionViewCell": return smallCollectionViewCell
            case small + "-collectionViewHeader": return smallCollectionViewHeader
            default: fatalError("Wrong property name")
        }
    }
}

extension UIFontDescriptor.AttributeName {
  static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    static func appFontSize(_ name: FontType) -> CGFloat? {
        let fontSize = UserDefaults.standard.string(forKey: Constants.UserDefaults.FontSize) ?? Constants.FontSize.normal
        let font = fontSize + "-" + name.rawValue
        return CGFloat(AppFontSize.get(name: font))
    }
}

extension UILabel {
    @objc var substituteFontSize : CGFloat {
        get {
            return self.font.pointSize
        }
        set {
            self.font = UIFont(name: UIFont.systemFont(ofSize: 17).fontName, size: newValue)
        }
    }
}

extension UITextView {
    @objc var substituteFontSize : CGFloat {
        get {
            return self.font?.pointSize ?? 16
        }
        set {
            self.font = UIFont(name: self.font?.fontName ?? UIFont.systemFont(ofSize: 17).fontName, size: newValue)
        }
    }
}

extension UITextField {
    @objc var substituteFontSize : CGFloat {
        get {
            return self.font?.pointSize ?? 16
        }
        set {
            self.font = UIFont(name: self.font?.fontName ?? UIFont.systemFont(ofSize: 17).fontName, size: newValue)
        }
    }
}
