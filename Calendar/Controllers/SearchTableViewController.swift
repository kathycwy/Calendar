//
//  SearchTableViewController.swift
//  Calendar
//
//  Created by Samuel Kwong on 25.01.22.
//

import UIKit
import CoreData

class SearchEventCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
}

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var events: [NSManagedObject] = []
    var selectedRow: Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension

        searchBar.delegate = self
    }

    //MARK: - Table view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
    
    //MARK: - Standard Tableview methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let event = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchEventCell", for: indexPath) as! SearchEventCell
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, HH:mm"

        cell.titleLabel.text = event.value(forKeyPath: "title") as? String
        cell.startDateLabel.text = formatter.string(from: event.value(forKeyPath: "startDate") as! Date)
        cell.endDateLabel.text = formatter.string(from: event.value(forKeyPath: "endDate") as! Date)
        
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
