//
//  MonthCell.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import Foundation
import UIKit

class MonthCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel : PaddingLabel!
    @IBOutlet weak var weekLabel : UILabel!
    @IBOutlet weak var isSelectedLabel : UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initLabel()
    }
    
    func initLabel(){
        dateLabel.textColor = UIColor.appColor(.onSurface)
        dateLabel.backgroundColor = UIColor.appColor(.background)
        weekLabel.textColor = nil
        dateLabel.text = ""
        weekLabel.text = ""
        dateLabel.padding(15, 15, 15, 15)
    }
/*
    static let reuseIdentifier = "monthCell"

    static func register(with collectionView: UICollectionView) {
        collectionView.register(MonthCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    static func dequeue(from collectionView: UICollectionView, at indexPath: IndexPath, forDay day: Int) -> MonthCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MonthCell ?? MonthCell()

        cell.dateLabel.text = String(format: "%02d", day)

        return cell
    }
 */
}
