//
//  CopyDetailsController.swift
//  Calendar
//
//  Created by Wingyin Chan on 30.01.22.
//

import CoreData
import UIKit

class CopyDetailsController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var event: NSManagedObject?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 8
        textView.text = setText()
        super.viewDidLoad()
        
    }
    
    // MARK: Helper functions
    
    // set text in the text view
    func setText() -> String {
        
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "d MMM y, HH:mm"
        
        let dateOnlyFormatter = DateFormatter()
        dateOnlyFormatter.dateFormat = "d MMM y"

        let eventTitle = String(event!.value(forKeyPath: Constants.EventsAttribute.titleAttribute) as? String ?? "")
        
        let isAllDay = event!.value(forKeyPath: Constants.EventsAttribute.allDayAttribute) as? Bool ?? false
        
        var dateString: String
        let startDate: String, endDate: String
        if isAllDay {
            startDate = dateOnlyFormatter.string(from: event!.value(forKeyPath: Constants.EventsAttribute.startDateAttribute) as? Date ?? Date.now)
            endDate = dateOnlyFormatter.string(from: event!.value(forKeyPath: Constants.EventsAttribute.endDateAttribute) as? Date ?? Date.now)
            dateString = " from " + startDate + " to " + endDate + " all-day"
        } else {
            startDate = dateTimeFormatter.string(from: event!.value(forKeyPath: Constants.EventsAttribute.startDateAttribute) as? Date ?? Date.now)
            endDate = dateTimeFormatter.string(from: event!.value(forKeyPath: Constants.EventsAttribute.endDateAttribute) as? Date ?? Date.now)
            dateString = " from " + startDate + " to " + endDate
        }
        
        var locationString: String = ""
        let location = String(event!.value(forKeyPath: Constants.EventsAttribute.locationAttribute) as? String ?? "")
        if !location.isEmpty {
            locationString = " at " + location
        }
   
        var urlString: String = ""
        let url = String(event!.value(forKeyPath: Constants.EventsAttribute.urlAttribute) as? String ?? "")
        if !url.isEmpty {
            urlString = " URL: " + url + "."
        }
        
        var notesString: String = ""
        let notes = String(event!.value(forKeyPath: Constants.EventsAttribute.notesAttribute) as? String ?? "")
        if !notes.isEmpty {
            notesString = " Notes: " + notes + "."
        }
        
        return eventTitle + dateString + locationString + "." + urlString + notesString
        
    }
    
    // MARK: - Actions
    
    // copy all text from text view to clipboard
    @IBAction func copyButton(_ sender: Any) {
        UIPasteboard.general.string = textView.text
        
        //Alert
        let dialogMessage = UIAlertController(title: "Copied", message: nil, preferredStyle: .alert)
        
        // Create Close button with action handlder
        let close = UIAlertAction(title: "Close", style: .cancel) { (action) -> Void in
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(close)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    
    }
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
