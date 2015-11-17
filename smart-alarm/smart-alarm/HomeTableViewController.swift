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
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var travelTime: UILabel!
    @IBOutlet weak var wakeupLabel: UILabel!
    
    var alarm = Alarm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fix iOS 9 bug in mildy hacky way...
        timePicker.datePickerMode = .DateAndTime
        timePicker.datePickerMode = .Time
        
        // Data model
        timePicker.setDate(alarm.arrival, animated: true)
        routineLabel.text = "\(alarm.routine.getTotalTime()) minutes"
        locationLabel.text = "\(alarm.getDestinationName())"
        updateTimeLabels(timePicker)
        
        // Don't allow saving until fill out destination
        if (locationLabel.text == "") {
            saveButton.enabled = false
        }
    }
    
    /* FUNCTIONS */
    
    @IBAction func timeChanged(sender: UIDatePicker) {
        updateTimeLabels(sender)
    }

    func updateTimeLabels (sender: UIDatePicker) {
        alarm.setArrival(sender.date)
        alarm.setWakeup(alarm.calculateWakeup())
        travelTime.text = "\(alarm.etaMinutes) minutes"
        routineLabel.text = "\(alarm.routine.getTotalTime()) minutes"
        wakeupLabel.text = alarm.getWakeupString()
    }
    
    /* NAVIGATION */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Update model and pass routine to destination controller
        if (segue.identifier == "addRoutine") {
            let routineTVC = segue.destinationViewController as! RoutineTableViewController
            routineTVC.routine = self.alarm.routine.copy()
        }
    }
    
    /* UNWIND SEGUES */

    @IBAction func saveLocation (segue:UIStoryboardSegue) {
        let locationVC = segue.sourceViewController as! LocationViewController
        let location = locationVC.searchBar.text!
        if location != "" {
            locationLabel.text = location
            alarm.setETA(Int(round(locationVC.etaMinutes)))
            alarm.setDestination(locationVC.destination!)
            switch (locationVC.transportationType.selectedSegmentIndex) {
                case 0:
                    alarm.setTransportation(.Automobile)
                    break
                case 1:
                    alarm.setTransportation(.Transit)
                    break
                default:
                    break
            }
            print("ETA: \(alarm.etaMinutes)")
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
        self.alarm.setRoutine(routineTVC.routine)
        
        updateTimeLabels(timePicker)
    }
    
    @IBAction func cancelRoutine (segue:UIStoryboardSegue) {
        print("Cancelled Routine")
    }
}
