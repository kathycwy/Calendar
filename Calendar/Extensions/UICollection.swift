//
//  UICollection.swift
//  Calendar
//
//  Created by C Chan on 26/1/2022.
//

import Foundation

extension Collection {

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
