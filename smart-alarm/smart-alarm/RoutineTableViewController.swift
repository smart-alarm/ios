//
//  RoutineTableViewController.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 10/17/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit

class RoutineTableViewController: UITableViewController {
    
    var activities = Activities.getActivities()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        print("loaded")

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func cancel (segue:UIStoryboardSegue) {
        print("Cancel")
    }
    
    @IBAction func save (segue:UIStoryboardSegue) {
        print("Save")
        let activityTVC = segue.sourceViewController as! ActivityTableViewController
        if activityTVC.activityName.text != "" && activityTVC.activityTime.text != "" {
            let name = activityTVC.activityName.text!
            let time = activityTVC.activityTime.text!
            let indexPath = NSIndexPath(forRow: activities.count, inSection: 0)
            activities.append(["activity": name, "time": time])
            
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.endUpdates()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath)
        cell.textLabel!.text = activities[indexPath.row]["activity"]!
        cell.detailTextLabel!.text = activities[indexPath.row]["time"]! + " minutes"
        return cell
    }

    @IBAction func addRow(sender: UIBarButtonItem) {
//        let newActivity: Dictionary<String,String> = ["activity": "Activity", "time": "0"]
//        let indexPath = NSIndexPath(forRow: activities.count, inSection: 0)
//        activities.append(newActivity)
//        self.tableView.beginUpdates()
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        self.tableView.endUpdates()
//        print("Adding!")
//        performSegueWithIdentifier("addActivity", sender: self)
    }

//    // Override to support conditional editing of the table view.
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            print("Deleting")
            activities.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
