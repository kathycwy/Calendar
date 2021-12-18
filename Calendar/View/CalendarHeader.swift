//
//  CalendarHeader.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import Foundation
import UIKit

class CalendarHeader: UICollectionReusableView {
    @IBOutlet weak var monthLabel : UILabel!
    @IBOutlet weak var nextMonthButton : UIButton!
    @IBOutlet weak var prevMonthButton : UIButton!
    
/*
    static let identifier = "calendarHeader"

    static func register(with collectionView: UICollectionView) {
        collectionView.register(CalendarHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: identifier)
    }

    static func dequeue(from collectionView: UICollectionView, at indexPath: IndexPath, forDate date: Date) -> CalendarHeader {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath) as? CalendarHeader ?? CalendarHeader()

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")

        header.monthLabel.text = dateFormatter.string(from: date)

        return header
    }
 */
}
