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
    
    private var selectedDate = Date()
    private var dowCount: Int = 7
    private var startDOW: Int = 7
    private var displayDates = [String]()
    
    private let calendarHelper = CalendarHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    private func initCollectionView(){
        self.collectionView.dataSource = self.collectionViewDataSource
        self.collectionView.delegate = self.collectionViewFlowLayout

        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    lazy var collectionViewFlowLayout : CalendarCollectionViewFlowLayout = {
        let layout = CalendarCollectionViewFlowLayout()
        return layout
    }()

    lazy var collectionViewDataSource: CalendarCollectionViewDataSource = {
        let collectionView = CalendarCollectionViewDataSource(selectedDate: selectedDate)
        return collectionView
    }()
    
    func reloadCalendar() {
        self.collectionViewDataSource.refreshCalendar(selectedDate: selectedDate)
        self.collectionView.reloadData()
    }
    
    @IBAction func prevMonth(_ sender: Any) {
        selectedDate = calendarHelper.previousMonth(date: selectedDate)
        reloadCalendar()
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = calendarHelper.nextMonth(date: selectedDate)
        reloadCalendar()
    }
}

