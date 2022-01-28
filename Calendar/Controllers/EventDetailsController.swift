//
//  EventDetailsController.swift
//  Calendar
//
//  Created by Wingyin Chan on 17.01.22.
//

import UIKit
import CoreData
import SwiftUI

class EventDetailsController: CalendarUIViewController {
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var allDayLabel: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var url: UITextView!
    @IBOutlet weak var notes: UILabel!
    
    var eventID: NSManagedObjectID?
    var event: NSManagedObject?
    var fetchedEvents: [NSManagedObject] = []
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "d MMM y, HH:mm"
        
        let dateOnlyFormatter = DateFormatter()
        dateOnlyFormatter.dateFormat = "d MMM y"
        
        // set event url to the corresponding textView
        let urlString = String(event!.value(forKeyPath: EventsStruct.urlAttribute) as? String ?? "")
        if let eventURL = URL(string: urlString){
            let attributedUrlString = NSAttributedString(string: urlString, attributes:[NSAttributedString.Key.link: eventURL])
            url.attributedText = attributedUrlString
        } else {
            url.attributedText = NSAttributedString(string: "No URL is added")
        }

        url.textAlignment = NSTextAlignment.right
        url.isUserInteractionEnabled = true
        url.isEditable = false
        
        // set remaining event details to corresponding labels
        eventTitle.text = String(event!.value(forKeyPath: EventsStruct.titleAttribute) as? String ?? "")
        if (event!.value(forKeyPath: EventsStruct.allDayAttribute) as? Bool ?? true) {
            allDayLabel.isHidden = false
            allDayLabel.text = "All-day event"
            startDate.text = dateOnlyFormatter.string(from: event!.value(forKeyPath: EventsStruct.startDateAttribute) as? Date ?? Date.now)
            endDate.text = dateOnlyFormatter.string(from: event!.value(forKeyPath: EventsStruct.endDateAttribute) as? Date ?? Date.now)
        } else {
            allDayLabel.isHidden = true
            startDate.text = dateTimeFormatter.string(from: event!.value(forKeyPath: EventsStruct.startDateAttribute) as? Date ?? Date.now)
            endDate.text = dateTimeFormatter.string(from: event!.value(forKeyPath: EventsStruct.endDateAttribute) as? Date ?? Date.now)
        }
        location.text = String(event!.value(forKeyPath: EventsStruct.locationAttribute) as? String ?? "")
        notes.text = String(event!.value(forKeyPath: EventsStruct.notesAttribute) as? String ?? "")
        
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
        
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        let dialogMessage = UIAlertController(title: "Are you sure you want to delete this event?", message: nil, preferredStyle: .actionSheet)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "Delete Event", style: .destructive, handler: { (action) -> Void in
            self.deleteEvent()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func deleteEvent() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EventsStruct.entityName)
        let sort = NSSortDescriptor(key:EventsStruct.startDateAttribute, ascending: true)
        fetchRequest.sortDescriptors = [sort]

        do {
            // fetch the entitiy
            fetchedEvents = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        managedContext.undoManager!.registerUndo(withTarget: self) { target in
            //simply save the hohle table view. A bit uniffcient but simple
            self.fetchedEvents = target.fetchedEvents
        }
        // Find the index of the event that is to be deleted from the array
        let index = fetchedEvents.firstIndex(where: {$0.objectID  == eventID})!
        // delete it from Core data
        managedContext.delete(fetchedEvents[index])
        // delete it from the arrays
        fetchedEvents.remove(at: index)

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
