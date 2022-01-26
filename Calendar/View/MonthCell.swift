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
    @IBOutlet weak var taskLabel : PaddingLabel!
    @IBOutlet weak var weekLabel : UILabel!
    @IBOutlet weak var isSelectedLabel : UILabel!
    var cellDate: Date? = nil
    
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
        dateLabel.padding(10, 10, 10, 10)
        self.cellDate = nil
        layer.borderWidth = 0
        taskLabel.backgroundColor = UIColor.appColor(.background)
        taskLabel.text = ""
    }
    
    // Call this function if there are events on this day
    func setTaskIndicator(numberOfTasks: Int = 10){
        taskLabel.text = "10"//String(numberOfTasks)
        taskLabel.textColor = UIColor.appColor(.surface)
        taskLabel.layer.masksToBounds = true
        taskLabel.backgroundColor = UIColor.appColor(.onSurface)
        taskLabel.layer.cornerRadius = taskLabel.frame.width/2
        taskLabel.font = taskLabel.font.withSize(UIFont.appFontSize(.innerCollectionViewHeader) ?? 8)
        
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
