//
//  ViewController.swift
//  Calendar
//
//  Created by C Chan on 17/12/2021.
//

import UIKit

private let reuseIdentifier = "preferenceCell"

class PreferencesViewController: CalendarUIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    var preferenceHeader: PreferenceHeader!
    var prefValues: [PrefRowIdentifier: Bool] = [:]
    let appIconHelper = AppIconHelper()
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: " ", style: .plain, target: nil, action: nil)

    }

    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
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
        tableView.tableFooterView = UIView()
        titleView.backgroundColor = .appColor(.onPrimary)
        titleLabel.textColor = .appColor(.primary)
        titleLabel.font = titleLabel.font.withSize((UIFont.appFontSize(.collectionViewHeader) ?? 17) + 5 )
    }
    
    func configureUI() {
        configureTableView()
    }
    
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

extension PreferencesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 3
        case 2: return 1
        case 3: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PreferenceHeader()
        view.initHeader(section: section)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PreferenceCell
        
        cell.initCell(indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            var height:CGFloat = CGFloat()
        if indexPath.section == 0 {
                height = 100
            }
            else {
                height = 60
            }
            return height
        }
    
}

