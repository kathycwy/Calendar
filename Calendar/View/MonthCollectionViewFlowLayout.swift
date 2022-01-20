//
//  CalendarViewController.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import UIKit

class MonthCollectionViewFlowLayout : UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    
    private var isAsInnerCollectionView: Bool = false
    var itemsPerRow: CGFloat = 7
    var rowPerSection: CGFloat = 6
    let minimumCellHeight: CGFloat = 50
    let minimumInnerCellHeight: CGFloat = 10
    let minimumheaderHeight: CGFloat = 40
    internal var parentLoadNextBatch: (() -> Void)!
    internal var parentLoadPrevBatch: (() -> Void)!
    var headerHeight: CGFloat = 40

    init(isAsInnerCollectionView: Bool){
        super.init()
        self.isAsInnerCollectionView = isAsInnerCollectionView
        self.configLayout()
    }
    
    override init() {
        super.init()
        self.configLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.configLayout()
    }

    func configLayout() {
        if !isAsInnerCollectionView {
            itemSize = CGSize(width: 30, height: 80)
            headerReferenceSize = CGSize(width: 0, height: 60)
            minimumLineSpacing = 1
            minimumInteritemSpacing = 1
        }
        else {
            itemSize = CGSize(width: 20, height: 20)
            //let fontsize: CGFloat = self.isAsInnerCollectionView ? UIFont.appFontSize(.innerCollectionViewHeader)! : UIFont.appFontSize(.collectionViewHeader)!
            minimumLineSpacing = 1
            minimumInteritemSpacing = 1
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("only flow layout is supported")
        }
        
        var paddingSpace = flow.sectionInset.left + flow.sectionInset.right + (minimumInteritemSpacing * itemsPerRow)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        paddingSpace = flow.sectionInset.top + flow.sectionInset.bottom + (minimumLineSpacing * rowPerSection)
        let heightPerItem = max((collectionView.frame.height - paddingSpace) / rowPerSection, isAsInnerCollectionView ? minimumInnerCellHeight : minimumCellHeight)
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    /*
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
     */
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.section == collectionView.numberOfSections - 2 {
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
