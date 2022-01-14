//
//  ViewController.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import UIKit
import SwiftUI

class YearViewController: UIViewController, UITabBarDelegate {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var calendarYears: [CalendarYear] = []
    var selectedDate = Date()
    private var displayDates = [String]()
    private let loadingBatchSize: Int = 3
    private let nextBatchCalendarMonthSize: Int = 6
    private var isScrolled = false
    
    let calendarHelper = CalendarHelper()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initCollectionView()
        self.initView()
        self.reloadCalendar()
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToToday(_:)), name: Notification.Name(rawValue: "scrollToToday"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isScrolled && self.collectionView.visibleCells.count > 0 {
            isScrolled = true
            self.scrollToToday(animated: false)
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
    
    lazy var collectionViewFlowLayout : YearCollectionViewFlowLayout = {
        let layout = YearCollectionViewFlowLayout()
        layout.parentLoadNextBatch = loadNextBatch
        return layout
    }()

    lazy var collectionViewDataSource: YearCollectionViewDataSource = {
        let collectionView = YearCollectionViewDataSource(calendarYears: calendarYears, selectedDate: selectedDate)
        return collectionView
    }()
    
    func loadNextBatch(){
        
        self.calendarYears = self.collectionViewDataSource.getExtendedCalendarYears(numberOfYears: loadingBatchSize)
        self.collectionView.reloadData()
        
        let reminingBatchCount = Int(ceil(Double((nextBatchCalendarMonthSize - loadingBatchSize) / loadingBatchSize)))
        if reminingBatchCount > 0{
            for _ in 1 ... reminingBatchCount{
                self.calendarYears = self.collectionViewDataSource.getExtendedCalendarYears(numberOfYears: loadingBatchSize)
            }
        }
    }
    
    func reloadCalendar() {
        self.calendarYears = self.collectionViewDataSource.getInitCalendar(calendarYears: calendarYears, selectedDate: selectedDate)
        self.collectionView.reloadData()
    }
    
    func scrollToToday(animated: Bool = true){
        let year = calendarHelper.getYear(for:selectedDate)
        self.calendarYears = self.collectionViewDataSource.getCalendarYears()

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
    }
    
    @objc func scrollToToday(_ notification: Notification) {
        scrollToToday()
    }
}

