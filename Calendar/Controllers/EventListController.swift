//
//  EventListController.swift
//  Calendar
//
//  Created by Wingyin Chan on 16.01.22.
//

import UIKit
import CoreData

class EventCell: UITableViewCell {
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var startDateLable: UILabel!
    @IBOutlet weak var endDateLable: UILabel!
}

class EventListController: UITableViewController {
    
    var events: [NSManagedObject] = []
    
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
    }

    //MARK: - Table view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateView()
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
        let sort = NSSortDescriptor(key:EventsStruct.startDateAttribute, ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
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

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EventsStruct.entityName)
        let sort = NSSortDescriptor(key:EventsStruct.startDateAttribute, ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            // fetch the entitiy
            events = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func getEventsByWeek(dates: [CalendarDay]) {
        
    }

    //MARK: - Standard Tableview methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    // MARK:  init the Cell with data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myEventCell", for: indexPath) as! EventCell
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, HH:mm"
        
        cell.titleLable.text = event.value(forKeyPath: EventsStruct.titleAttribute) as? String
        cell.startDateLable.text = formatter.string(from: event.value(forKeyPath: EventsStruct.startDateAttribute) as! Date)
        cell.endDateLable.text = formatter.string(from: event.value(forKeyPath: EventsStruct.endDateAttribute) as! Date)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        self.performSegue(withIdentifier: "eventCellTapped", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "eventCellTapped") {
            let destinationVC = segue.destination as! EventDetailsController
            
            if selectedRow != nil {
                destinationVC.rowIndex = self.selectedRow
                destinationVC.event = self.events[self.selectedRow!]
                destinationVC.eventID = self.events[self.selectedRow!].objectID
            }
        }
        
    }
}
