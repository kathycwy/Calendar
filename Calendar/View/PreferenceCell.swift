//
//  PreferenceCell.swift
//  Calendar
//
//  Created by C Chan on 27/1/2022.
//

import UIKit
import SwiftUI

class PreferenceCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var label: PaddingLabel!
    @IBOutlet weak var prefSegControl: UISegmentedControl!
    @IBOutlet weak var prefSwitch: UISwitch!
    var myIndexPath = IndexPath(row: 0, section: 0)
    
    // MARK: - Init
    
    func initCell(indexPath: IndexPath) {
        self.label.padding(3, 3, 10, 3)
        self.label.text = ""
        self.label.font = label.font.withSize(UIFont.appFontSize(.collectionViewCell) ?? 16)
        self.label.textColor = UIColor.appColor(.primary)
        self.prefSwitch.isHidden = true
        self.prefSegControl.isHidden = true
        self.myIndexPath = indexPath
        self.prefSwitch.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        self.prefSegControl.addTarget(self, action: #selector(handelSegAction), for: .valueChanged)
        
        switch(indexPath.section)
        {
        case 1:
            switch(indexPath.row)
            {
            case 0:
                // Colour theme
                self.initColourTheme()
                break
            case 1:
                // Dark Mode
                self.initDarkMode()
                break
            case 2:
                // Font Size
                self.initFontSize()
                break
            default:
               break
            }
            break
        case 2:
            switch(indexPath.row)
            {
            case 0:
                // Notification
                self.initNotification()
                break
            default:
               break
            }
            break
        default:
           break
        }
    }
    
    func initColourTheme() {
        self.label.text = "Colour Theme"
        self.prefSwitch.isHidden = true
        self.prefSegControl.isHidden = false
        self.prefSegControl.setTitle(Constants.ColourThemes.teal, forSegmentAt: 0)
        self.prefSegControl.setTitle(Constants.ColourThemes.orange, forSegmentAt: 1)
        self.prefSegControl.setTitle(Constants.ColourThemes.blue, forSegmentAt: 2)
        let choice = UserDefaults.standard.string(forKey: Constants.UserDefaults.ColourTheme)
        for i in 0 ... self.prefSegControl.numberOfSegments - 1 {
            if self.prefSegControl.titleForSegment(at: i) == choice {
                self.prefSegControl.selectedSegmentIndex = i
                break
            }
        }
    }
    
    func initDarkMode() {
        self.label.text = "Dark Mode"
        self.prefSwitch.isHidden = false
        self.prefSwitch.isOn = false
        self.prefSegControl.isHidden = true
    }
    
    func initFontSize() {
        self.label.text = "Font Size"
        self.prefSwitch.isHidden = true
        self.prefSegControl.isHidden = false
        self.prefSegControl.setTitle(Constants.FontSize.large, forSegmentAt: 0)
        self.prefSegControl.setTitle(Constants.FontSize.normal, forSegmentAt: 1)
        self.prefSegControl.setTitle(Constants.FontSize.small, forSegmentAt: 2)
        let choice = UserDefaults.standard.string(forKey: Constants.UserDefaults.FontSize)
        for i in 0 ... self.prefSegControl.numberOfSegments - 1 {
            if self.prefSegControl.titleForSegment(at: i) == choice {
                self.prefSegControl.selectedSegmentIndex = i
                break
            }
        }
        
    }
    
    func initNotification() {
        self.label.text = "Notification"
        self.prefSwitch.isHidden = false
        self.prefSwitch.isOn = false
        self.prefSegControl.isHidden = true
    }
    
    // MARK: - Selectors
    
    @objc func handleSwitchAction(sender: UISwitch) {
        if sender.isOn {
            
        }
    }
    @objc func handelSegAction(sender: UISegmentedControl) {
        let value = sender.titleForSegment(at: sender.selectedSegmentIndex)
        switch(myIndexPath.section)
        {
        case 1:
            switch(myIndexPath.row)
            {
            case 0:
                // Colour theme
                UserDefaults.standard.set(value, forKey: Constants.UserDefaults.ColourTheme)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadUI"), object: nil)
                self.window?.tintColor = UIColor.appColor(.primary)
                ThemeHelper.applyTheme()
                break
            case 2:
                // Font Size
                UserDefaults.standard.set(value, forKey: Constants.UserDefaults.FontSize)
                break
            default:
               break
            }
            break
        default:
           break
        }
    }
    
}

