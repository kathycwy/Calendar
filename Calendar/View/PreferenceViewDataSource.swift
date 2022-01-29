//
//  PreferenceViewDataSource.swift
//  Calendar
//
//  Created by C Chan on 29/1/2022.
//

import UIKit

class PreferencesDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Standard Tableview methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 3
        case 2: return 1
        case 3: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PreferenceHeader()
        view.initHeader(section: section)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "preferenceCell", for: indexPath) as! PreferenceCell
        
        cell.initCell(indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            var height:CGFloat = CGFloat()
        if indexPath.section == 0 {
                height = 100
            }
            else {
                height = 60
            }
            return height
        }
    
}
