//
//  CalendarViewController.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import UIKit

class WeekCollectionViewFlowLayout : UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate  {
    
    var itemsPerRow: CGFloat = 8
    var rowPerSection: CGFloat = 1
    let minimumCellHeight: CGFloat = 50
    let minimumInnerCellHeight: CGFloat = 10
    let minimumheaderHeight: CGFloat = 40
    var headerHeight: CGFloat = 40
    var isLoaded = false
    internal var parentLoadNextBatch: (() -> Void)!
    internal var parentLoadPrevBatch: (() -> Void)!
    internal var setSelectedCell: ((_ indexPath: IndexPath) -> Void)!
    
    private var isInsertingCellsToTop: Bool = false
    private var contentSizeWhenInsertingToTop: CGSize?
    
    init(isAsInnerCollectionView: Bool){
        super.init()
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
        itemSize = CGSize(width: 30, height: 80)
        headerReferenceSize = CGSize(width: 0, height: 0)
        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
        self.scrollDirection = .horizontal
    }
    
    func setLoaded(isLoaded: Bool){
        self.isLoaded = isLoaded
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
        let heightPerItem = max((collectionView.frame.height - paddingSpace) / rowPerSection, minimumCellHeight)
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
        
        if indexPath.section == collectionView.numberOfSections - 1 {
            if indexPath.row == 0 {
                parentLoadNextBatch()
            }
        }
        /*
        else if isLoaded && indexPath.section == 0 {
            if indexPath.row == 1 {
                contentSizeWhenInsertingToTop = collectionViewContentSize
                parentLoadPrevBatch()
                isInsertingCellsToTop = true
            }
        }
         */
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.setSelectedCell(indexPath)
    }
    
}
