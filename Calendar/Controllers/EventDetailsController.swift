//
//  EventDetailsController.swift
//  Calendar
//
//  Created by Wingyin Chan on 17.01.22.
//

import UIKit
import CoreData

class EventDetailsController: UIViewController {
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var place: UILabel!
    @IBOutlet weak var remarks: UILabel!
    
    var rowIndex: Int?
    var eventID: NSManagedObjectID?
    var event: NSManagedObject?
    var fetchedEvents: [NSManagedObject] = []
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, HH:mm"
    
        eventTitle.text = String(event!.value(forKeyPath: "title") as? String ?? "")
        startDate.text = formatter.string(from: event!.value(forKeyPath: "startDate") as? Date ?? Date.now)
        endDate.text = formatter.string(from: event!.value(forKeyPath: "endDate") as? Date ?? Date.now)
        place.text = String(event!.value(forKeyPath: "place") as? String ?? "")
        remarks.text = String(event!.value(forKeyPath: "remarks") as? String ?? "")
        
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "editButtonTapped", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "editButtonTapped") {
            let destinationVC = segue.destination as! EditEventController
            destinationVC.event = self.event
        }
    }
        
        
    @IBAction func deleteEvent(_ sender: UIButton) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Events")
        
        do {
            // fetch the entitiy
            fetchedEvents = try managedContext.fetch(fetchRequest)
            print("print(fetchedEvents[0])")
            print(fetchedEvents[0])
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        managedContext.undoManager!.registerUndo(withTarget: self) { target in
            //simply save the hohle table view. A bit uniffcient but simple
            self.fetchedEvents = target.fetchedEvents
        }
        // delete it from Core data
        managedContext.delete(fetchedEvents[self.rowIndex!])
        // delete it from the arrays
        fetchedEvents.remove(at: rowIndex!)
        
        // finally save the current state of Core data
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        // go back to previous controller
        navigationController?.popViewController(animated: true)
    }
}
