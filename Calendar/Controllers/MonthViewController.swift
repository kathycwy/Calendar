//
//  MonthViewController.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//
//  To control the functionalities of Month View

import UIKit
import SwiftUI

class MonthViewController: CalendarUIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dowStackView: UIStackView!
    
    private var tabBarReference: CalendarTabBarController!
    private var calendarMonths: [CalendarMonth] = []
    //var selectedDate = Date()
    var selectedIndexPath: IndexPath? = nil
    private var dowCount: Int = 7
    private var displayDates = [String]()
    private let loadingBatchSize: Int = 5
    private let nextBatchCalendarMonthSize: Int = 12
    private var isScrolled = false
    
    let calendarHelper = CalendarHelper()
    
    lazy var collectionViewFlowLayout : MonthCollectionViewFlowLayout = {
        let layout = MonthCollectionViewFlowLayout()
        layout.parentLoadNextBatch = loadNextBatch
        layout.parentLoadPrevBatch = loadPrevBatch
        return layout
    }()

    lazy var collectionViewDataSource: MonthCollectionViewDataSource = {
        let collectionView = MonthCollectionViewDataSource(calendarMonths: calendarMonths, selectedDate: selectedDate)
        return collectionView
    }()
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCollectionView()
        self.initView()
        self.initGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.reloadCalendar()
        //self.initSwipeSetting()
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToToday(_:)), name: Notification.Name(rawValue: "scrollToToday"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToDate(_:)), name: Notification.Name(rawValue: "scrollToDate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()
        //self.view.layoutIfNeeded()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if isScrolled && self.collectionView.visibleCells.count > 0 {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isScrolled && self.collectionView.visibleCells.count > 0 {
            self.scrollToDate(date: self.selectedDate, animated: false)
        }
    }
    
    private func initView(){
        self.view.tintColor = UIColor.appColor(.primary)
        //self.todayButton.backgroundColor = UIColor.appColor(.primary)
        self.dowStackView.backgroundColor = UIColor.appColor(.primary)
        
        let labels = getLabelsInView(view: self.dowStackView)
        for label in labels {
            label.textColor = UIColor.appColor(.onPrimary)
        }
        
    }
    
    private func initCollectionView(){
        self.collectionView.isPrefetchingEnabled = true
        self.collectionView.dataSource = self.collectionViewDataSource
        self.collectionView.prefetchDataSource = self.collectionViewDataSource
        self.collectionView.delegate = self.collectionViewFlowLayout
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = UIColor.appColor(.background)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        //self.collectionView.contentInsetAdjustmentBehavior = .never
        //if #available(iOS 10.0, *) {self.collectionView.isPrefetchingEnabled = false}
        
    }
    
    func initGestureRecognizer(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.collectionView.addGestureRecognizer(tap)
         
    }
    
    // MARK: - Actions
    
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            self.scrollToDate(date: self.selectedDate, animated: false)
        } else {
            self.scrollToDate(date: self.selectedDate, animated: false)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if let indexPath = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            if indexPath.item > 0 {
                //self.setSelectedCell(indexPath: indexPath)
                self.calendarMonths = self.collectionViewDataSource.getCalendarMonths()
                if self.calendarMonths[indexPath.section].calendarDays[indexPath.item].isDate == true {
                    if let date = self.calendarMonths[indexPath.section].calendarDays[indexPath.item].date {
                        //NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollToDate"), object: nil, userInfo: ["date": date as Any])
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "switchSegment"),
                                                       object: nil,
                                                       userInfo: ["date": date as Any, "view":"d"])
                    }
                }
            }
        }
    }

    // MARK: - Helper functions
    
    func setSelectedCell(indexPath: IndexPath) {
        self.calendarMonths = self.collectionViewDataSource.getCalendarMonths()
        if self.calendarMonths[indexPath.section].calendarDays[indexPath.item].isDate == true {
            self.selectedIndexPath = indexPath
            self.selectedDate = self.calendarMonths[indexPath.section].calendarDays[indexPath.item].date!
            if let prevIndexPath = self.collectionViewDataSource.getSelectedIndexPath(){
                self.collectionView.cellForItem(at: prevIndexPath)?.layer.borderWidth = 0
            }
            self.collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.appColor(.onSurface)?.cgColor
            self.collectionView.cellForItem(at: indexPath)?.layer.borderWidth = 2
            self.collectionViewDataSource.setSelectedIndexPath(indexPath: indexPath)
        }
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
    
    func calculateIndexPathsToReload(from newcalendarMonths: [CalendarMonth]) -> [IndexPath] {
      let startIndex = self.calendarMonths.count - newcalendarMonths.count
      let endIndex = startIndex + newcalendarMonths.count
      return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x:0, y:0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    func loadNextBatch(){
        let lastCalendarMonths = self.calendarMonths.count
        
        self.calendarMonths = self.collectionViewDataSource.getExtendedCalendarMonths(numberOfMonths: loadingBatchSize)
        
        var indexSet:[Int] = []
        var paths = [IndexPath]()
        for month in lastCalendarMonths ..< self.calendarMonths.count {
            indexSet.append(month)
            for day in 0 ..< self.calendarMonths[month].calendarDays.count {
                let indexPath = IndexPath(row: day, section: month)
                paths.append(indexPath)
            }
        }
        collectionView.performBatchUpdates({ () -> Void in
            self.collectionView.insertSections(IndexSet(indexSet))
            self.collectionView.insertItems(at: paths)
        }, completion:nil)
        /*
        let reminingBatchCount = Int(ceil(Double((nextBatchCalendarMonthSize - loadingBatchSize) / loadingBatchSize)))
        if reminingBatchCount > 0{
            for _ in 1 ... reminingBatchCount{
                self.calendarMonths = self.collectionViewDataSource.getExtendedCalendarMonths(numberOfMonths: loadingBatchSize)
            }
        }
         */
    }
    
    func loadPrevBatch(){
        let indexPath = IndexPath(item: 15, section: nextBatchCalendarMonthSize)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: false)
        self.calendarMonths = self.collectionViewDataSource.getExtendedCalendarMonths(numberOfMonths: nextBatchCalendarMonthSize * -1)
        self.collectionView.reloadData()
    }
    
    func reloadCalendar(calendarYears: [CalendarYear]) {
        self.calendarMonths = self.collectionViewDataSource.getInitCalendar(calendarYears: calendarYears)
        //self.collectionView.reloadData()
    }
    
    func scrollToToday(animated: Bool = true){
        self.scrollToDate(date: self.calendarHelper.getCurrentDate(), animated: animated)
    }
    
    override func scrollToDate(date: Date?, animated: Bool = true){
        if date != nil {
            self.selectedDate = date!
        }
        let year = calendarHelper.getYear(for: self.selectedDate)
        let month = calendarHelper.getMonth(for: self.selectedDate)
        self.calendarMonths = self.collectionViewDataSource.getCalendarMonths()
        
        var idx = self.calendarMonths.firstIndex(where: {$0.month == month && $0.year == year}) ?? -1
        
        while idx == -1 {
            // Extend and load the date
            self.loadNextBatch()
            idx = self.calendarMonths.firstIndex(where: {$0.month == month && $0.year == year}) ?? -1
        }
        let item = self.calendarMonths[idx].calendarDays.firstIndex(where: {$0.date == self.selectedDate}) ?? 0
        let newSelectedIP: IndexPath = IndexPath(item: item, section: idx)
        self.setSelectedCell(indexPath: newSelectedIP)
        
        if let attributes = self.collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: idx)) {
            var offsetY = attributes.frame.origin.y - self.collectionView.contentInset.top
            if #available(iOS 11.0, *) {
                offsetY -= self.collectionView.safeAreaInsets.top
            }
            self.collectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: animated) // or animated: false
            isScrolled = true
        }
        else {
            if isScrolled == true {
                self.collectionView.scrollToItem(at: IndexPath(item: 0, section: idx), at: [.top, .right], animated: animated)
                
            }
        }
    }
    
    @objc func scrollToToday(_ notification: Notification) {
        self.scrollToDate(date: self.calendarHelper.getCurrentDate())
    }
    
    @objc func scrollToDate(_ notification: Notification) {
       if let selectedDate = (notification.userInfo?["date"] ?? nil) as? Date{
           if self.calendarHelper.getYear(for: selectedDate) >= 1970{
               self.scrollToDate(date: selectedDate, animated: false)
           }
       }
    }
    
    override func reloadUI() {
        self.collectionView.reloadData()
        self.dowStackView.backgroundColor = .appColor(.primary)
        self.scrollToDate(date: self.selectedDate)
    }
}

