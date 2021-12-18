//
//  CalendarCell.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import Foundation
import UIKit

class CalendarCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel : UILabel!
/*
    static let reuseIdentifier = "calendarCell"

    static func register(with collectionView: UICollectionView) {
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    static func dequeue(from collectionView: UICollectionView, at indexPath: IndexPath, forDay day: Int) -> CalendarCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CalendarCell ?? CalendarCell()

        cell.dateLabel.text = String(format: "%02d", day)

        return cell
    }
 */
}
