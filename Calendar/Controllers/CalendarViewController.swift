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
    
    let calendarHelper = CalendarHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCollectionView()
        //self.initSwipeSetting()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollToToday()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.reloadData()
    }
    
    private func initCollectionView(){
        self.collectionView.dataSource = self.collectionViewDataSource
        self.collectionView.delegate = self.collectionViewFlowLayout
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        //self.collectionView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 10.0, *) {self.collectionView.isPrefetchingEnabled = false}
        
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
    
    func scrollToToday(){
        let year = calendarHelper.getYear(for:selectedDate)
        let month = calendarHelper.getMonth(for:selectedDate)
        self.calendarMonths = self.collectionViewDataSource.getCalendarMonths()
        let idx = self.calendarMonths.firstIndex(where: {$0.month == month && $0.year == year})!
        //let indexPath = IndexPath(item: 30, section: idx)
        //self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
        
        if let attributes = self.collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: idx)) {
            var offsetY = attributes.frame.origin.y - self.collectionView.contentInset.top
            if #available(iOS 11.0, *) {
                offsetY -= self.collectionView.safeAreaInsets.top
            }
            self.collectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false) // or animated: false
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

