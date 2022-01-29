//
//  UserDefaultsExtension.swift
//  Calendar
//
//  Created by C Chan on 28/1/2022.
//

import Foundation

extension UserDefaults {

    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

}
