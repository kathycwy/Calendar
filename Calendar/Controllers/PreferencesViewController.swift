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
    }
    
    func configureUI() {
        configureTableView()
        
        let label = PaddingLabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        label.padding(5, 5, 20, 20)
        label.text = "Preferences"
        label.textColor = .appColor(.onPrimary)
        label.font = label.font.withSize(UIFont.appFontSize(.collectionViewHeader) ?? 17)
        label.backgroundColor = .appColor(.primary)
        self.view.addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 50),
            view.topAnchor.constraint(equalTo: label.topAnchor),
            view.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: label.trailingAnchor)
            ])
    }

}

extension PreferencesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 0
        case 1: return 3
        case 2: return 1
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

