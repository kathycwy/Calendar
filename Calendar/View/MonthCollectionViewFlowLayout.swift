//
//  CalendarViewController.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import UIKit

class MonthCollectionViewFlowLayout : UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {

    var itemsPerRow: CGFloat = 7
    var rowPerSection: CGFloat = 6
    var invalidatesAll = false
    var bounds: CGRect?
    let minimumCellHeight: CGFloat = 50
    internal var parentLoadNextBatch: (() -> Void)!
    internal var parentLoadPrevBatch: (() -> Void)!

    override init() {
        super.init()
        self.configLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configLayout()
    }

    func configLayout() {
        itemSize = CGSize(width: 30, height: 80)
        headerReferenceSize = CGSize(width: 0, height: 60)
        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("only flow layout is supported")
        }
        
        let paddingSpace = flow.sectionInset.left + flow.sectionInset.right + (minimumInteritemSpacing * itemsPerRow)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = max((collectionView.frame.height - flow.headerReferenceSize.height) / rowPerSection, minimumCellHeight)

        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
 
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.section == collectionView.numberOfSections - 6 {
            if indexPath.row == 0 {
                parentLoadNextBatch()
            }
        }
        /*
        else if indexPath.section == 0 {
            if indexPath.row == 1 {
                parentLoadPrevBatch()
            }
        }
        */
    }

    
    
}
