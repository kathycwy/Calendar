//
//  UINavigationControllerExtension.swift
//  Calendar
//
//  Created by C Chan on 30/1/2022.
//
//
//  To add new or override functions in class

import UIKit
import Foundation

extension UINavigationController {
    var previousViewController: UIViewController? {
       viewControllers.count > 1 ? viewControllers[viewControllers.count - 2] : nil
    }
}
