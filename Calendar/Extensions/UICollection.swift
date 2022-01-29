//
//  UICollection.swift
//  Calendar
//
//  Created by C Chan on 26/1/2022.
//
//  To add new or override functions in class

import Foundation

extension Collection {

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
