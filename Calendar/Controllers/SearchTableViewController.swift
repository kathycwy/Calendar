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
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension

        searchBar.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    //MARK: - Table view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateView()
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //events = []
        //if searchText == "" {
            
        //} else {
            
        //}
        //self.tableView.reloadData()
    }

    func getEvents() -> [NSManagedObject] {
        fetchEvents()
        return events
    }
    
    func updateView(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EventsStruct.entityName)
        
        do {
            // fetch the entitiy
            events = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
    
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
    // MARK:  init the Cell with data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchEventCell", for: indexPath) as! SearchEventCell
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, HH:mm"
        
        cell.titleLabel.text = event.value(forKeyPath: EventsStruct.titleAttribute) as? String
        cell.startDateLabel.text = formatter.string(from: event.value(forKeyPath: EventsStruct.startDateAttribute) as! Date)
        cell.endDateLabel.text = formatter.string(from: event.value(forKeyPath: EventsStruct.endDateAttribute) as! Date)
        
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
                destinationVC.rowIndex = self.selectedRow
                destinationVC.event = self.events[self.selectedRow!]
                destinationVC.eventID = self.events[self.selectedRow!].objectID
            }
        }
        
    }

}
