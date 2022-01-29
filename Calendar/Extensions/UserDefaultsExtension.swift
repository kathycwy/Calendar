//
//  UserDefaultsExtension.swift
//  Calendar
//
//  Created by C Chan on 28/1/2022.
//
//  To add new or override functions in class

import Foundation

extension UserDefaults {

    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

}
