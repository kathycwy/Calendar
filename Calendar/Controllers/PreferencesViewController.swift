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
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.frame = view.frame
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        preferenceHeader = PreferenceHeader(frame: frame)
        tableView.tableHeaderView = preferenceHeader
        tableView.tableFooterView = UIView()
        titleView.backgroundColor = .appColor(.onPrimary)
        titleLabel.textColor = .appColor(.primary)
        titleLabel.font = titleLabel.font.withSize(UIFont.appFontSize(.collectionViewHeader) ?? 17)
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
        super.reloadUI()
        self.tableView.reloadData()
    }

}

extension PreferencesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 0
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
}

