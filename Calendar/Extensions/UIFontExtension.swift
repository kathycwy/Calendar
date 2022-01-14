import UIKit

enum FontType : String{
    case innerCollectionViewCell
    case innerCollectionViewHeader
    case collectionViewCell
    case collectionViewHeader
}

struct AppFontSize {
    static let normalInnerCollectionViewCell = 11
    static let normalInnerCollectionViewHeader = 12
    static let normalCollectionViewCell = 17
    static let normalCollectionViewHeader = 17
    
    static func get(name:String) -> Int {
        let normal:String = Constants.FontSize.normal
        
        switch name {
            case normal + "-innerCollectionViewCell": return normalInnerCollectionViewCell
            case normal + "-innerCollectionViewHeader": return normalInnerCollectionViewHeader
            case normal + "-collectionViewCell": return normalCollectionViewCell
            case normal + "-collectionViewHeader": return normalCollectionViewHeader
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
