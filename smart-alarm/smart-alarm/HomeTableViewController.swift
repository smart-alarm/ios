//
//  HomeTableViewController.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 10/15/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var routineLabel: UILabel!
    @IBOutlet weak var wakeupLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var travelTime: UILabel!
    
    var alarm = Alarm()
    var routine = Routine()
    var routineMinutes: Int = 0
    var etaMinutes: Int = 0
    var transportationMode: String = "Driving"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.datePickerMode = .DateAndTime
        timePicker.datePickerMode = .Time
        locationLabel.text = ""
        routineLabel.text = "0 minutes"
        updateTimeLabels(timePicker)
        saveButton.enabled = false
        
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func timeChanged(sender: UIDatePicker) {
        updateTimeLabels(sender)
    }

    func updateTimeLabels (sender: UIDatePicker) {
        let parsed = splitMinutes(routineLabel.text!)
        routineMinutes = Int(parsed)!
        let  totalTime = subtractTimes(sender.date, routineMinutes: Int(parsed)!, etaMinutes: etaMinutes)
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let timeString = dateFormatter.stringFromDate(totalTime)
        wakeupLabel.text = timeString
        travelTime.text = "\(etaMinutes) minutes"
    }
    
    func subtractTimes (date: NSDate, routineMinutes: Int, etaMinutes: Int) -> NSDate {
        let components: NSDateComponents = NSDateComponents()
        let combinedTime = routineMinutes + etaMinutes
        components.setValue(combinedTime*(-1), forComponent: NSCalendarUnit.Minute);
        let result = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))
        return result!
    }
    
    func splitMinutes (label: String) -> String {
        let split = label.characters.split{$0 == " "}.map(String.init)
        return split[0]
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Update model and pass routine to destination controller
        if (segue.identifier == "addRoutine") {
            let routineTVC = segue.destinationViewController as! RoutineTableViewController
            routineTVC.routine = self.routine
        }
    }
    
    
    /* UNWIND SEGUES */

    @IBAction func saveLocation (segue:UIStoryboardSegue) {
        let locationVC = segue.sourceViewController as! LocationViewController
        let location = locationVC.searchBar.text!
        if location != "" {
            locationLabel.text = location
            etaMinutes = Int(round(locationVC.etaMinutes))
            switch (locationVC.transportationType.selectedSegmentIndex) {
                case 0:
                    transportationMode = "Driving"
                    break
                case 1:
                    transportationMode = "Transit"
                    break
                default:
                    break
            }
            print("ETA: \(etaMinutes)")
            updateTimeLabels(timePicker)
            self.saveButton.enabled = true
        }
    }
    
    @IBAction func cancelLocation (segue:UIStoryboardSegue) {
        print("cancelled")
    }
    
    @IBAction func saveRoutine (segue:UIStoryboardSegue) {
        print("Saved Routine")
        let routineTVC = segue.sourceViewController as! RoutineTableViewController
        
        // Update model
        routine = routineTVC.routine
        
        let activities = routineTVC.routine.getActivities()
        var time = 0
        for a in activities {
            time += a.getTime()
        }
        routineLabel.text = "\(time) minutes"
        updateTimeLabels(timePicker)
    }
    
    @IBAction func cancelRoutine (segue:UIStoryboardSegue) {
        print("Cancelled Routine")
    }

}
