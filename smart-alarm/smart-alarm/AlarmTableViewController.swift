//
//  AlarmTableViewController.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 10/26/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit
import MapKit

class AlarmTableViewController: UITableViewController, CLLocationManagerDelegate {

    var alarms:[Alarm] = []
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure data source
        alarms = AlarmList.sharedInstance.allAlarms()

        // Enable edit button
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        // Manage selection during editing mode
        self.tableView.allowsSelection = false
        self.tableView.allowsSelectionDuringEditing = true
        
        // Set up the CLLocationManager, adjust location updates here
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.distanceFilter = kCLLocationAccuracyKilometer
    }

    /* CONFIGURE ROWS AND SECTIONS */

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    /* CONFIGURE CELL */
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("alarmCell", forIndexPath: indexPath) as! AlarmTableViewCell
        cell.alarmTime.text! = alarms[indexPath.row].getWakeupString()
        cell.alarmDestination!.text = alarms[indexPath.row].getDestinationName()
        cell.accessoryView = cell.alarmToggle
        return cell
    }

    /* ENABLE EDITING */
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            AlarmList.sharedInstance.removeAlarm(alarms[indexPath.row]) // remove from persistent data
            alarms.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.editing == true) {
            performSegueWithIdentifier("editAlarm", sender: self)
        }
    }

    /* NAVIGATION */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navVC = segue.destinationViewController as! UINavigationController
        let homeTVC = navVC.viewControllers.first as! HomeTableViewController
        
        if (segue.identifier == "editAlarm") {
            let indexPath = self.tableView.indexPathForSelectedRow!
            homeTVC.alarm = alarms[indexPath.row].copy()
            homeTVC.title = "Edit Alarm"
        } else {
            homeTVC.title = "Add Alarm"
        }
    }
    
    /* UNWIND SEGUES */
    
    @IBAction func saveAlarm (segue:UIStoryboardSegue) {
        let homeTVC = segue.sourceViewController as! HomeTableViewController
        let newAlarm = homeTVC.alarm.copy()
        
        if (self.tableView.editing == false) {
            print("New Alarm Saved")
            
            if (newAlarm.getDestinationName() == "") {
                return
            }
        
            let indexPath = NSIndexPath(forRow: alarms.count, inSection: 0)
            alarms.append(newAlarm)
            AlarmList.sharedInstance.addAlarm(newAlarm)

            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.endUpdates()
        } else {
            print("Editing!")
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            self.alarms[indexPath.row] = homeTVC.alarm.copy()

            self.tableView.beginUpdates()
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.endUpdates()
        }
    }
    
    @IBAction func cancelAlarm (segue:UIStoryboardSegue) {
        print("New Alarm Cancelled")
        if (self.tableView.editing == true) {
            let homeTVC = segue.sourceViewController as! HomeTableViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            homeTVC.alarm = self.alarms[indexPath.row].copy() // Reset edited alarm to clean state
            print(homeTVC.alarm.routine)
            print(self.alarms[indexPath.row].routine)
        }
    }
    
    // MARK: - Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        for alarm in self.alarms {
            if alarm.isActive {
                let request = MKDirectionsRequest()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: newLocation.coordinate, addressDictionary: nil))
                request.destination = alarm.destination
                if alarm.transportation == .Transit {
                    request.transportType = .Transit
                }
                else {
                    request.transportType = .Automobile
                }
                request.requestsAlternateRoutes = false
                let direction = MKDirections(request: request)
                direction.calculateETAWithCompletionHandler({
                    (response, err) -> Void in
                    if response == nil {
                        print("Inside didUpdateToLocation: Failed to get routes.")
                        alarm.setETA(0)
                        self.tableView.reloadData()
                        return
                    }
                    let minutes = (response?.expectedTravelTime)! / 60.0
                    alarm.setETA(Int(round(minutes)))
                    print("Inside didUpdateToLocation: \(minutes)")
                    print("The estimated time is: \(alarm.getWakeupString())")
                    self.tableView.reloadData()
                })
            }
        }
        //self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
    }
}
