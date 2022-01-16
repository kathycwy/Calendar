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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Table view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateView()
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
        cell.placeLable.text = event.value(forKeyPath: "place") as? String
        
        return cell
    }
}
