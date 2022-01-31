//
//  SearchTableViewController.swift
//  Calendar
//
//  Created by Samuel Kwong on 25.01.22.
//
//  To control the functionalities of the search event page

import UIKit
import CoreData

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var events: [NSManagedObject] = []
    let rowHeight: CGFloat = 80.0
    var selectedRow: Int? = 0
    var savedSearchText: String? = ""
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = rowHeight
        self.tableView.estimatedRowHeight = rowHeight

        searchBar.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        events = getEventsFromSearch(searchText: savedSearchText!)
        self.tableView.reloadData()
    }
    

    // MARK: - Helper Functions

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        savedSearchText = searchText
        if searchText == "" {
            events = []
        } else {
            events = getEventsFromSearch(searchText: searchText)
        }
        self.tableView.reloadData()
    }

    func getEventsFromSearch(searchText: String) -> [NSManagedObject] {
        fetchEvents()
        var eventsFromSearch: [NSManagedObject] = []
        for event in events {
            let event_title = event.value(forKeyPath: "title") as! String

            if event_title.lowercased().contains(searchText.lowercased()) {
                eventsFromSearch.append(event)
            }
        }
        return eventsFromSearch
    }
    
    func fetchEvents(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Events")
        
        do {
            // fetch the entitiy
            events = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Standard Tableview methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let event = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchEventCell", for: indexPath) as! EventCell
        
        cell.initCell(indexPath: indexPath)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, HH:mm"

        // Set text
        let eventTitle: String = event.value(forKeyPath: Constants.EventsAttribute.titleAttribute) as? String ?? " "
        let eventType: String = event.value(forKeyPath: Constants.EventsAttribute.classTypeAttribute) as? String ?? " "
        let text = ((eventType == " ") ? "" : ("\n" + eventType))
        
        let attributedText = NSMutableAttributedString(string: eventTitle)
        attributedText.addAttribute(.foregroundColor,
                                    value: UIColor.appColor(.onSurface) as Any,
                                    range: attributedText.getRangeOfString(textToFind: eventTitle))
        attributedText.addAttribute(.font,
                                    value: UIFont.boldSystemFont(ofSize: UIFont.appFontSize(.collectionViewCell) ?? 11),
                                    range: attributedText.getRangeOfString(textToFind: eventTitle))
        
        let attributedText2 = NSMutableAttributedString(string: text)
        attributedText2.addAttribute(.foregroundColor,
                                    value: UIColor.appColor(.secondary) as Any,
                                    range: attributedText2.getRangeOfString(textToFind: text))
        attributedText2.addAttribute(.font,
                                    value: UIFont.systemFont(ofSize: UIFont.appFontSize(.tableViewCellInfo) ?? 11),
                                    range: attributedText2.getRangeOfString(textToFind: text))
        
        attributedText.append(attributedText2)
        
        cell.colorBar.backgroundColor = EventListController().getCalendarColor(name: event.value(forKeyPath: Constants.EventsAttribute.calendarAttribute) as? String ?? "None")
        cell.titleLabel.attributedText = attributedText
        cell.startDateLabel.text = formatter.string(from: event.value(forKeyPath: "startDate") as! Date)
        cell.endDateLabel.text = formatter.string(from: event.value(forKeyPath: "endDate") as! Date)
        cell.startDateLabel.font = cell.startDateLabel.font.withSize(UIFont.appFontSize(.innerCollectionViewHeader) ?? 10)
        cell.endDateLabel.font = cell.startDateLabel.font.withSize(UIFont.appFontSize(.innerCollectionViewHeader) ?? 10)
        
        if eventType == Constants.ClassTypes.classAssignment {
            cell.startDateLabel.text = ""
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        self.performSegue(withIdentifier: "searchEventCellTapped", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "searchEventCellTapped") {
            let destinationVC = segue.destination as! EventDetailsController

            if selectedRow != nil {
                destinationVC.event = self.events[self.selectedRow!]
                destinationVC.eventID = self.events[self.selectedRow!].objectID
            }
        }
    }

}
