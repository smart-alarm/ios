//
//  RoutineTableViewController.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 10/17/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit

class RoutineTableViewController: UITableViewController {
    
    var routine = Routine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /* CONFIGURE ROWS AND SECTIONS */

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routine.activities.count
    }
    
    /* CONFIGURE CELL */

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath)
        let activities = routine.activities
        let name = activities[indexPath.row].name
        let time = activities[indexPath.row].time
        cell.textLabel!.text = name
        cell.detailTextLabel!.text = "\(time) minutes"
        return cell
    }
    
    /* ENABLE EDITING */
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            routine.removeActivity(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    /* UNWIND SEGUES */
    
    @IBAction func cancelActivity (segue:UIStoryboardSegue) {
        // Do nothing!
    }
    
    @IBAction func saveActivity (segue:UIStoryboardSegue) {
        let activityTVC = segue.sourceViewController as! ActivityTableViewController
        if activityTVC.activityName.text != "" && activityTVC.activityTime.text != "" {
            let name = activityTVC.activityName.text!
            let time = activityTVC.activityTime.text!
            let indexPath = NSIndexPath(forRow: routine.activities.count, inSection: 0)
            let newActivity = Activity(name: name, time: Int(time)!)
            routine.addActivity(newActivity)
            
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.endUpdates()
        }
    }

}
