//
//  MonthCell.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//
//  A cell class used for showing the dates in Year View

import Foundation
import UIKit
import SwiftUI

class YearCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var monthCollectionView : UICollectionView!
    
    var calendarMonths: [CalendarMonth] = []
    
    lazy var collectionViewDataSource : MonthCollectionViewDataSource = {
        let dataSource = MonthCollectionViewDataSource(calendarMonths: self.calendarMonths, selectedDate: Date(), isAsInnerCollectionView: true)
        return dataSource
    }()
    
    lazy var collectionViewFlowLayout : MonthCollectionViewFlowLayout = {
        let layout = MonthCollectionViewFlowLayout(isAsInnerCollectionView: true)
        return layout
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        initCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
     
        self.isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //self.activateCell(calendarMonths: [])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initGestureRecognizer()
    }
    
    func initGestureRecognizer(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.monthCollectionView.isUserInteractionEnabled = true
        self.monthCollectionView.addGestureRecognizer(tap)
    }
    
    func initCell() {
        self.monthCollectionView.isScrollEnabled = false
        self.monthCollectionView.layoutIfNeeded()
        self.monthCollectionView.dataSource = self.collectionViewDataSource
        self.monthCollectionView.delegate = self.collectionViewFlowLayout
    }
    
    // MARK: - Actions

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if let indexPath = self.monthCollectionView?.indexPathForItem(at: sender.location(in: self.monthCollectionView)) {
            /*
            let prevIndexPath = self.collectionViewDataSource.getSelectedCell()
            if prevIndexPath != nil {
                self.monthCollectionView.cellForItem(at: prevIndexPath!)!.layer.borderWidth = 0
                self.monthCollectionView.cellForItem(at: prevIndexPath!)!.isSelected = false
            }
            self.monthCollectionView.cellForItem(at: indexPath)!.layer.borderColor = UIColor.appColor(.primary)?.cgColor
            self.monthCollectionView.cellForItem(at: indexPath)!.layer.borderWidth = 2
            self.monthCollectionView.cellForItem(at: indexPath)!.isSelected = true
            self.collectionViewDataSource.setSelectedCell(indexPath: indexPath)
             */
            let cell: MonthCell = self.monthCollectionView.cellForItem(at: indexPath) as! MonthCell
            NotificationCenter.default.post(name: Notification.Name(rawValue: "switchSegment"),
                                            object: nil,
                                            userInfo: ["date": cell.cellDate as Any, "view":"m"])
        }
    }
    
    // MARK: Helper functions
    
    func activateCell(calendarMonths: [CalendarMonth]){
        initCell()
        self.calendarMonths = self.collectionViewDataSource.getInitCalendar(calendarMonths: calendarMonths)
        self.monthCollectionView.reloadData()
    }

}
