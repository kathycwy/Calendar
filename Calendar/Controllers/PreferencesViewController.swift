//
//  PreferencesViewController.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//
//  To control the functionalities of the perference page

import UIKit

class PreferencesViewController: CalendarUIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    var preferenceHeader: PreferenceHeader!
    let appIconHelper = AppIconHelper()

    lazy var tableViewDataSource: PreferencesDataSource = {
        let tableView = PreferencesDataSource()
        return tableView
    }()
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTableView()
    }
    
    func initTableView() {
        tableView.delegate = tableViewDataSource
        tableView.dataSource = tableViewDataSource
        
        tableView.frame = view.frame
        if #available(iOS 11, *) {
            if #available(iOS 15, *) {
                tableView.sectionHeaderTopPadding = 0
                tableView.contentInset = UIEdgeInsets(top: -80, left: 0, bottom: 0, right: 0)
            }
            else{
                tableView.contentInsetAdjustmentBehavior = .never
            }
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        let frame = CGRect(x: 0, y: 80, width: view.frame.width, height: 100)
        preferenceHeader = PreferenceHeader(frame: frame)
        tableView.tableHeaderView = preferenceHeader
        titleView.backgroundColor = .appColor(.onPrimary)
        titleLabel.textColor = .appColor(.primary)
        titleLabel.font = titleLabel.font.withSize((UIFont.appFontSize(.collectionViewHeader) ?? 17) + 5 )
    }
    
    // MARK: - Helper Functions
    
    override func reloadUI() {
        super.reloadUI()
        tableView.tableHeaderView = preferenceHeader
        tableView.tableFooterView = UIView()
        titleView.backgroundColor = .appColor(.onPrimary)
        titleLabel.font = titleLabel.font.withSize(UIFont.appFontSize(.collectionViewHeader) ?? 17)
        titleLabel.textColor = .appColor(.primary)
        self.tableView.reloadData()
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .appColor(.navigationBackground)
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.appColor(.navigationTitle)!]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.appColor(.navigationTitle)!]
                   
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.navigationTitle)!]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.appColor(.navigationTitle)!]
        
        self.navigationController?.navigationBar.backgroundColor = .appColor(.navigationBackground)
        self.navigationController?.navigationBar.barTintColor = .appColor(.navigationBackground)
        UIBarButtonItem.appearance().tintColor = .appColor(.surface)
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.appColor(.surface)!], for: .selected)
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.appColor(.onSurface)!], for: .normal)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.compactScrollEdgeAppearance = navigationBarAppearance
        
        self.tabBarController?.tabBar.isTranslucent = false
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .appColor(.navigationBackground)
        self.tabBarController?.tabBar.barTintColor = .appColor(.navigationBackground)
        self.tabBarController?.tabBar.backgroundColor = .appColor(.navigationBackground)
        self.tabBarController?.tabBar.tintColor = .appColor(.navigationTitle)
        self.tabBarController?.tabBar.standardAppearance = tabBarAppearance
        self.tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppearance
        
        for view in self.navigationController?.navigationBar.subviews ?? [] {
            let subviews = view.subviews
            for objects in subviews {
                if let object = objects as? UIImageView {
                    object.tintColor = UIColor.appColor(.navigationTitle)
                    object.image = object.image?.tinted(with: UIColor.appColor(.navigationTitle)!)
                }
            }
        }
        
    }
}

