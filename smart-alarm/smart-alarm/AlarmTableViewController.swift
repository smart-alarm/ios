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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
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
        cell.alarmTime.text! = formatDate(alarms[indexPath.row].getArrival())
        cell.alarmDestination!.text = alarms[indexPath.row].getDestination()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    /* UNWIND SEGUES */
    
    @IBAction func saveAlarm (segue:UIStoryboardSegue) {
        print("New Alarm Saved")
        let alarmTVC = segue.sourceViewController as! HomeTableViewController
        
        let arrival = alarmTVC.timePicker.date
        let destination = alarmTVC.locationLabel.text!
        let transportation = ""
        let routine = 0
        
        if (destination == "") {
            return
        }
        
        let newAlarm = Alarm(arrival: arrival, destination: destination, transportation: transportation, routine: routine)
        
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
