//
//  YearViewController.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//
//  To control the functionalities of Year View


import UIKit
import SwiftUI

class YearViewController: CalendarUIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var calendarYears: [CalendarYear] = []
    //override var selectedDate = Date()
    private var displayDates = [String]()
    private let loadingBatchSize: Int = 3
    private let nextBatchCalendarMonthSize: Int = 6
    private var isScrolled = false
    var selectedIndexPath: IndexPath? = nil
    var selectedInnerIndexPath: IndexPath? = nil
    
    let calendarHelper = CalendarHelper()
    
    lazy var collectionViewFlowLayout : YearCollectionViewFlowLayout = {
        let layout = YearCollectionViewFlowLayout()
        layout.parentLoadNextBatch = loadNextBatch
        return layout
    }()

    lazy var collectionViewDataSource: YearCollectionViewDataSource = {
        let collectionView = YearCollectionViewDataSource()
        return collectionView
    }()
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCollectionView()
        self.initView()
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToToday(_:)), name: Notification.Name(rawValue: "scrollToToday"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToDate(_:)), name: Notification.Name(rawValue: "scrollToDate"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if isScrolled && self.collectionView.visibleCells.count > 0 {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if /*!isScrolled && */ self.collectionView.visibleCells.count > 0 {
            self.scrollToDate(date: self.selectedDate, animated: false)
        }
    }
    
    private func initView(){
        self.view.tintColor = UIColor.appColor(.primary)
    }
    
    private func initCollectionView(){
        self.collectionView.dataSource = self.collectionViewDataSource
        self.collectionView.delegate = self.collectionViewFlowLayout
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = UIColor.appColor(.background)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        //self.collectionView.contentInsetAdjustmentBehavior = .never
        //if #available(iOS 10.0, *) {self.collectionView.isPrefetchingEnabled = false}
    }
    
    // MARK: - Helper functions
    
    func getLabelsInView(view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let label = subview as? UILabel {
                results += [label]
            } else {
                results += getLabelsInView(view: subview)
            }
        }
        return results
    }
    
    func setSelectedCell(indexPath: IndexPath) {
        if let prevIndexPath: IndexPath = self.selectedIndexPath {
            if let prevInnerIndexPath: IndexPath = self.selectedInnerIndexPath{
                if let selectedCell: YearCell = self.collectionView.cellForItem(at: prevIndexPath) as? YearCell
                {
                    selectedCell.monthCollectionView.cellForItem(at: prevInnerIndexPath)?.layer.borderWidth = 0
                }
            }
        }
        self.selectedIndexPath = indexPath
        
        if let selectedCell: YearCell = self.collectionView.cellForItem(at: self.selectedIndexPath!) as? YearCell
        {
            self.selectedInnerIndexPath = selectedCell.collectionViewDataSource.getIndexPathBySelectedDate(date: selectedDate)
            if let innerIndexPath = self.selectedInnerIndexPath{
                selectedCell.monthCollectionView.cellForItem(at: innerIndexPath)?.layer.borderWidth = 2
                selectedCell.monthCollectionView.cellForItem(at: innerIndexPath)?.layer.borderColor = UIColor.appColor(.primary)?.cgColor
            }
        }
    }
    
    func loadNextBatch(){
        
        let lastCalendarYears = self.calendarYears.count
        
        self.calendarYears = self.collectionViewDataSource.getExtendedCalendarYears(numberOfYears: loadingBatchSize)
        
        var indexSet:[Int] = []
        var paths = [IndexPath]()
        for month in lastCalendarYears ..< self.calendarYears.count {
            indexSet.append(month)
            let indexPath = IndexPath(row: 0, section: month)
            paths.append(indexPath)
        }
        collectionView.performBatchUpdates({ () -> Void in
            self.collectionView.insertSections(IndexSet(indexSet))
            self.collectionView.insertItems(at: paths)
        }, completion:nil)
    }
    
    func reloadCalendar(calendarYears: [CalendarYear]) {
        self.calendarYears = self.collectionViewDataSource.getInitCalendar(calendarYears: calendarYears, selectedDate: selectedDate)
        //self.collectionView.reloadData()
    }
    
    func scrollToToday(animated: Bool = true){
        self.scrollToDate(date: self.calendarHelper.getCurrentDate(), animated: animated)
        
        let year = calendarHelper.getYear(for:selectedDate)
        self.calendarYears = self.collectionViewDataSource.getCalendarYears()
        if self.calendarYears.count > 0 {
            let idx = self.calendarYears.firstIndex(where: {$0.year == year})!
            /*
            if let attributes = self.collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: idx)) {
                var offsetY = attributes.frame.origin.y - self.collectionView.contentInset.top
                if #available(iOS 11.0, *) {
                    offsetY -= self.collectionView.safeAreaInsets.top
                }
                self.collectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: animated) // or animated: false
            }
             */
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: idx), at: [.top, .centeredHorizontally], animated: animated)
            isScrolled = true
        }
    }
    
    override func scrollToDate(date: Date?, animated: Bool = true){
        if date != nil {
            self.selectedDate = date!
        }
        let year = calendarHelper.getYear(for: self.selectedDate)
        let month = calendarHelper.getMonth(for: self.selectedDate)
        self.calendarYears = self.collectionViewDataSource.getCalendarYears()
        
        var idx = (self.calendarYears.firstIndex(where: {$0.year == year}) ?? -999)
        
        while idx < 0 {
            // Extend and load the date
            self.loadNextBatch()
            idx = (self.calendarYears.firstIndex(where: {$0.year == year}) ?? -999)
        }
        let newSelectedIP: IndexPath = IndexPath(item: month - 1, section: idx)
        self.setSelectedCell(indexPath: newSelectedIP)
        
        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: idx), at: [.top, .centeredHorizontally], animated: animated)
    }
    
    @objc func scrollToToday(_ notification: Notification) {
        scrollToToday()
    }
    
    @objc func scrollToDate(_ notification: Notification) {
       if let selectedDate = (notification.userInfo?["date"] ?? nil) as? Date{
           if self.calendarHelper.getYear(for: selectedDate) >= 1970{
               self.scrollToDate(date: selectedDate, animated: false)
           }
       }
    }
    
    override func reloadUI() {
        super.reloadUI()
        for c in self.collectionView.visibleCells {
            let yearCell = c as? YearCell
            yearCell?.monthCollectionView.reloadData()
        }
        self.scrollToDate(date: self.selectedDate)
    }
    
}

