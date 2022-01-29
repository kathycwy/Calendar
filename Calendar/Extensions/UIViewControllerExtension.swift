//
//  UIViewControllerExtension.swift
//  Calendar
//
//  Created by C Chan on 27/1/2022.
//

import Foundation
import UIKit

class CalendarUIViewController: UIViewController {
    
    // MARK: - Properties
    
    var selectedDate: Date = Date()
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUI(_:)), name: Notification.Name(rawValue: "reloadUI"), object: nil)
    }
    
    func reloadUI() {
        self.view.setNeedsDisplay()
        for objects in self.view.subviews {
            if let object = objects as? UIButton {
                object.setNeedsDisplay()
            }
            if let object = objects as? UILabel {
                object.setNeedsDisplay()
            }
            if let object = objects as? UITableView {
                object.setNeedsDisplay()
                for c in object.visibleCells {
                    c.setNeedsDisplay()
                }
            }
            if let object = objects as? UICollectionView {
                object.reloadData()
            }
            
            if let object = objects as? UIView {
                object.setNeedsDisplay()
            }
        }
        scrollToDate(date: selectedDate)
    }
    
    func scrollToDate(date: Date?, animated: Bool = true){
    }
    
    @objc func reloadUI(_ notification: Notification) {
        reloadUI()
    }
}
