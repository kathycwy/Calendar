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
    @IBOutlet weak var placeLable: UILabel!
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
    
    func getEventsByDate(currentDate: Date) -> [NSManagedObject] {
        fetchEvents()
        var eventsPerDate: [NSManagedObject] = []
        for event in events {
            let event_start_date = event.value(forKeyPath: "startDate") as! Date
            let event_end_date = event.value(forKeyPath: "endDate") as! Date
            
            let fallsBetween = (event_start_date.removeTimeStamp! ... event_end_date.removeTimeStamp!).contains(currentDate)
            if fallsBetween {
                eventsPerDate.append(event)
            }
        }
        return eventsPerDate
    }
    
    func updateView(){
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myEventCell", for: indexPath) as! EventCell
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, HH:mm"
        
        cell.titleLable.text = event.value(forKeyPath: "title") as? String
        cell.startDateLable.text = formatter.string(from: event.value(forKeyPath: "startDate") as! Date)
        cell.endDateLable.text = formatter.string(from: event.value(forKeyPath: "endDate") as! Date)
//        cell.placeLable.text = event.value(forKeyPath: "place") as? String
        
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

extension Date {
    public var removeTimeStamp : Date? {
       guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
        return nil
       }
       return date
   }
}
