//
//  AlarmTableViewController.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 10/26/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit

class AlarmTableViewController: UITableViewController {

    var alarms:[Alarm] = Alarm.getAlarms() // Data source
    var alarmToEdit: Alarm = Alarm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        // Manage selection during editing mode
        self.tableView.allowsSelection = false
        self.tableView.allowsSelectionDuringEditing = true
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("alarmCell", forIndexPath: indexPath) as! AlarmTableViewCell
        print(cell.alarmTime.text!)
        cell.alarmTime.text! = alarms[indexPath.row].getWakeup()
        cell.alarmDestination!.text = alarms[indexPath.row].getDestination()
        cell.accessoryView = cell.alarmToggle
        // TODO: Fix toggling of alarms
        return cell
    }
    
    // TODO: Fix toggling of alarms
    private func toggleAlarm(sender: UISwitch) {
        if sender.on {
            print("On")
        } else {
            print("Off")
        }
    }
    
    private func formatDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter.stringFromDate(date)
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            alarms.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.editing == true) {
            let indexPath = tableView.indexPathForSelectedRow
            self.alarmToEdit = alarms[indexPath!.row]
//            let cell = tableView.cellForRowAtIndexPath(indexPath!)! as! AlarmTableViewCell
//            print(cell.alarmTime.text!)
            performSegueWithIdentifier("editAlarm", sender: self)
        }
        
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        let destVC = segue.destinationViewController.ch
//        destVC.alarm = self.alarmToEdit
//        print(destVC.alarm.getWakeup())
    }
    
    
    /* UNWIND SEGUES */
    
    @IBAction func saveAlarm (segue:UIStoryboardSegue) {
        print("New Alarm Saved")
        let alarmTVC = segue.sourceViewController as! HomeTableViewController
        
        let arrival = alarmTVC.timePicker.date
        let destination = alarmTVC.locationLabel.text!
        let transportation = alarmTVC.transportationMode
        let routine = alarmTVC.routineMinutes
        let wakeup = alarmTVC.wakeupLabel.text!
        
        if (destination == "") {
            return
        }
        
        let newAlarm = Alarm(arrival: arrival, destination: destination, transportation: transportation, routine: routine, wakeup: wakeup)
        
        let indexPath = NSIndexPath(forRow: alarms.count, inSection: 0)
        
        alarms.append(newAlarm)

        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        self.tableView.endUpdates()
    }
    
    @IBAction func cancelAlarm (segue:UIStoryboardSegue) {
        print("New Alarm Cancelled")
    }
}
