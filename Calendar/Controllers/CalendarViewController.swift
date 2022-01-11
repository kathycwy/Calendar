//
//  ViewController.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import UIKit
import SwiftUI

class CalendarViewController: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dowStackView: UIStackView!
    
    private var calendarMonths: [CalendarMonth] = []
    var selectedDate = Date()
    private var dowCount: Int = 7
    private var startDOW: Int = 7
    private var displayDates = [String]()
    private let nextBatchCalendarMonthSize: Int = 2
    private var isScrolled = false
    
    let calendarHelper = CalendarHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.initSwipeSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initCollectionView()
        self.reloadCalendar()
        //self.view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isScrolled && self.collectionView.visibleCells.count > 0 {
            isScrolled = true
            self.scrollToToday(animated: false)
        }
    }
    
    
    private func initCollectionView(){
        self.collectionView.dataSource = self.collectionViewDataSource
        self.collectionView.delegate = self.collectionViewFlowLayout
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        //self.collectionView.contentInsetAdjustmentBehavior = .never
        //if #available(iOS 10.0, *) {self.collectionView.isPrefetchingEnabled = false}
        
    }
    
    
    /*
    func initSwipeSetting(){
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        leftSwipe.direction = .up
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .left {
            var frame = collectionView.frame
            frame.origin.x -= collectionView.frame.width
            UIView.animate(withDuration: 0.6){
                self.collectionView.frame = frame
            }
            selectedDate = calendarHelper.nextMonth(date: selectedDate)
        } else if sender.direction == .right {
            var frame = collectionView.frame
            frame.origin.x += collectionView.frame.width
            UIView.animate(withDuration: 0.6){
                self.collectionView.frame = frame
            }
            selectedDate = calendarHelper.previousMonth(date: selectedDate)
        }
        reloadCalendar()
        self.collectionView.reloadData()
    }
     */
    
    lazy var collectionViewFlowLayout : CalendarCollectionViewFlowLayout = {
        let layout = CalendarCollectionViewFlowLayout()
        layout.parentLoadNextBatch = loadNextBatch
        layout.parentLoadPrevBatch = loadPrevBatch
        return layout
    }()

    lazy var collectionViewDataSource: CalendarCollectionViewDataSource = {
        let collectionView = CalendarCollectionViewDataSource(calendarMonths: calendarMonths, selectedDate: selectedDate)
        return collectionView
    }()
    
    func loadNextBatch(){
        self.calendarMonths = self.collectionViewDataSource.getExtendedCalendarMonths(numberOfMonths: nextBatchCalendarMonthSize)
        self.collectionView.reloadData()
    }
    
    func loadPrevBatch(){
        let indexPath = IndexPath(item: 15, section: nextBatchCalendarMonthSize)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: false)
        self.calendarMonths = self.collectionViewDataSource.getExtendedCalendarMonths(numberOfMonths: nextBatchCalendarMonthSize * -1)
        self.collectionView.reloadData()
    }
    
    func reloadCalendar() {
        self.calendarMonths = self.collectionViewDataSource.getInitCalendar(calendarMonths: calendarMonths, selectedDate: selectedDate)
        self.collectionView.reloadData()
    }
    
    func scrollToToday(animated: Bool = true){
        let year = calendarHelper.getYear(for:selectedDate)
        let month = calendarHelper.getMonth(for:selectedDate)
        self.calendarMonths = self.collectionViewDataSource.getCalendarMonths()
        let idx = self.calendarMonths.firstIndex(where: {$0.month == month && $0.year == year})!
        
        if let attributes = self.collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: idx)) {
            var offsetY = attributes.frame.origin.y - self.collectionView.contentInset.top
            if #available(iOS 11.0, *) {
                offsetY -= self.collectionView.safeAreaInsets.top
            }
            self.collectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: animated) // or animated: false
        }
    }
    /*
    @IBAction func prevMonth(_ sender: Any) {
        selectedDate = calendarHelper.previousMonth(date: selectedDate)
        reloadCalendar()
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = calendarHelper.nextMonth(date: selectedDate)
        reloadCalendar()
    }
     */
    @IBAction func todayButton(_ sender: Any) {
        scrollToToday()
    }

}

