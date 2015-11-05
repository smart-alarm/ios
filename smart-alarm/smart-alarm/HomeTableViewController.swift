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
        timePicker.setDate(alarm.getArrival(), animated: true) // set time
        routineLabel.text = "\(alarm.getRoutineMinutes()) minutes" // set routine
        locationLabel.text = "\(alarm.getDestinationName())" // set location
        updateTimeLabels(timePicker)
        
        // Don't allow saving until fill out destination
        if (locationLabel.text == "") {
            saveButton.enabled = false
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func timeChanged(sender: UIDatePicker) {
        updateTimeLabels(sender)
    }

    func updateTimeLabels (sender: UIDatePicker) {
        // Update model
        alarm.setArrival(sender.date)
        
        wakeupLabel.text = alarm.getWakeup()
        travelTime.text = "\(alarm.getETA()) minutes"
        routineLabel.text = "\(alarm.getRoutineMinutes()) minutes"
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
            routineTVC.routine = self.alarm.getRoutine()
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
                    alarm.setTransportation("Driving")
                    break
                case 1:
                    alarm.setTransportation("Transit")
                    break
                default:
                    break
            }
            print("ETA: \(alarm.getETA())")
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
