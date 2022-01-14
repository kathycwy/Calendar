import UIKit

enum AssetsColor : String{
    case background
    case navigationBackground
    case navigationTitle
    case primary
    case onPrimary
    case secondary
    case onSecondary
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
