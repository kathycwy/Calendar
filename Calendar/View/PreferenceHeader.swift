import UIKit

class PreferenceHeader: UIView {
    
    // MARK: - Properties

    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "ironman")
        return iv
    }()
     
    let colourThemeLabel: UILabel = {
        let label = UILabel()
        label.text = "User Interface Settings"
        label.font = label.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.appColor(.onPrimary)
        return label
    }()
    
    let fontSizeLabel: UILabel = {
        let label = UILabel()
        label.text = "Notification Settings"
        label.font = label.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 16)
        //label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.appColor(.onPrimary)
        return label
    }()
    
    // MARK: - Init
    
    func initHeader(section: Int) {
        backgroundColor = UIColor.appColor(.primary)
        switch section {
        case 0:
            let profileImageDimension: CGFloat = 60
            
            addSubview(profileImageView)
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
            profileImageView.layer.cornerRadius = profileImageDimension / 2
            break
        case 1:
            addSubview(colourThemeLabel)
            colourThemeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            colourThemeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            break
        case 2:
            addSubview(fontSizeLabel)
            fontSizeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            fontSizeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            break
        default:
            break
        }
    }
    
}
