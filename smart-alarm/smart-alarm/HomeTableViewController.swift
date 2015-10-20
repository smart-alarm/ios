//
//  HomeTableViewController.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 10/15/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var routineLabel: UILabel!
    @IBOutlet weak var wakeupLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.datePickerMode = .DateAndTime
        timePicker.datePickerMode = .Time
        updateTimeLabels(timePicker)
        locationLabel.text = ""
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func timeChanged(sender: UIDatePicker) {
            updateTimeLabels(sender)
    }

    func updateTimeLabels (sender: UIDatePicker) {
        let parsed = splitMinutes(routineLabel.text!)
        let time = subtractRoutine(sender.date, routineMinutes: Int(parsed)!)
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let timeString = dateFormatter.stringFromDate(time)
        wakeupLabel.text = timeString
    }
    
    func subtractRoutine (date: NSDate, routineMinutes: Int) -> NSDate {
        let components: NSDateComponents = NSDateComponents()
        components.setValue(routineMinutes*(-1), forComponent: NSCalendarUnit.Minute);
        let result = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))
        return result!
    }
    
    func splitMinutes (label: String) -> String {
        print(label)
        let split = label.characters.split{$0 == " "}.map(String.init)
        return split[0]
    }
    
    @IBAction func done (segue:UIStoryboardSegue) {
        print("Done")
        let routineTVC = segue.sourceViewController as! RoutineTableViewController
        let activities = routineTVC.activities
        Activities.update(activities)
        var time = 0
        for a in activities {
            time += Int(a["time"]!)!
        }
        routineLabel.text = "\(time) minutes"
        updateTimeLabels(timePicker)
    }
    
    @IBAction func locationSelected (segue:UIStoryboardSegue) {
        let locationVC = segue.sourceViewController as! LocationViewController
        let location = locationVC.searchBar.text!
        if location != "" {
            locationLabel.text = location
        }
    }
    
    @IBAction func locationCancelled (segue:UIStoryboardSegue) {
        print("cancelled")
    }
    
    

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 3
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 5
//    }

//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
//
//        // Configure the cell...
//
//        return cell
//    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
