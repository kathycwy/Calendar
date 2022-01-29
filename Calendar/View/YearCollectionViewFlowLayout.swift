//
//  YearCollectionViewFlowLayout.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//
//  A Delegate extension class for YearViewController

import UIKit

class YearCollectionViewFlowLayout : UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var itemsPerRow: CGFloat = 3
    var rowPerSection: CGFloat = 4
    let defaultCellHeight: CGFloat = 200
    let minimumCellWidth: CGFloat = 120
    let minimumCellHeight: CGFloat = 200
    internal var parentLoadNextBatch: (() -> Void)!
    internal var parentLoadPrevBatch: (() -> Void)!
    
    // MARK: - Init

    override init() {
        super.init()
        self.configLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configLayout()
    }

    func configLayout() {
        itemSize = CGSize(width: minimumCellHeight, height: minimumCellHeight)
        headerReferenceSize = CGSize(width: 0, height: 50)
        minimumLineSpacing = 10
        minimumInteritemSpacing = 5
    }
    
    // MARK: - Standard CollectionView methods
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        /*
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("only flow layout is supported")
        }
        
        var paddingSpace = flow.sectionInset.left + flow.sectionInset.right + (minimumInteritemSpacing * itemsPerRow)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        paddingSpace = flow.sectionInset.top + flow.sectionInset.bottom + (minimumLineSpacing * rowPerSection)
        let heightPerItem = max((collectionView.frame.height - paddingSpace) / rowPerSection, minimumCellHeight)
         return CGSize(width: widthPerItem, height: heightPerItem)
         */
        return CGSize(width: minimumCellWidth, height: minimumCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
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
