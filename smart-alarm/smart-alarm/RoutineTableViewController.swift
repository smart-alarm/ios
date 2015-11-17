//
//  RoutineTableViewController.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 10/17/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit

class RoutineTableViewController: UITableViewController {
    
    // Model
    var routine = Routine()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func cancelActivity (segue:UIStoryboardSegue) {
        print("Cancelled Activity")
    }
    
    @IBAction func saveActivity (segue:UIStoryboardSegue) {
        print("Save")
        let activityTVC = segue.sourceViewController as! ActivityTableViewController
        if activityTVC.activityName.text != "" && activityTVC.activityTime.text != "" {
            let name = activityTVC.activityName.text!
            let time = activityTVC.activityTime.text!
            let indexPath = NSIndexPath(forRow: routine.count, inSection: 0)
            let newActivity = Activity(name: name, time: Int(time)!)
            routine.addActivity(newActivity)
            
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.endUpdates()
            
            print("Saved Activity")
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routine.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath)
        let activities = routine.getActivities()
        let name = activities[indexPath.row].getName()
        let time = activities[indexPath.row].getTime()
        cell.textLabel!.text = name
        cell.detailTextLabel!.text = "\(time) minutes"
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            routine.removeActivity(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            print("Deleted Activity")
        }
    }
}
