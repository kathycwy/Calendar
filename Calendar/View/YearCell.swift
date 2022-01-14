//
//  MonthCell.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import Foundation
import UIKit
import SwiftUI

class YearCell: UICollectionViewCell {
    @IBOutlet weak var monthCollectionView : UICollectionView!
    
    var calendarMonths: [CalendarMonth] = []
    
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
    }
    
    func initCell() {
        self.monthCollectionView.isScrollEnabled = false
        self.monthCollectionView.layoutIfNeeded()
        self.monthCollectionView.dataSource = self.collectionViewDataSource
        self.monthCollectionView.delegate = self.collectionViewFlowLayout
    }
    
    func activateCell(calendarMonths: [CalendarMonth]){
        initCell()
        self.calendarMonths = self.collectionViewDataSource.getInitCalendar(calendarMonths: calendarMonths)
        self.monthCollectionView.reloadData()
    }
    
    lazy var collectionViewDataSource : MonthCollectionViewDataSource = {
        let dataSource = MonthCollectionViewDataSource(calendarMonths: self.calendarMonths, selectedDate: Date(), isAsInnerCollectionView: true)
        return dataSource
    }()
    
    lazy var collectionViewFlowLayout : MonthCollectionViewFlowLayout = {
        let layout = MonthCollectionViewFlowLayout(isAsInnerCollectionView: true)
        return layout
    }()

}
