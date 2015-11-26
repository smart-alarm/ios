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
        cell.alarmDestination!.text = alarms[indexPath.row].destination.name
        cell.alarmToggle.tag = indexPath.row
        cell.alarmToggle.addTarget(self, action: Selector("toggleAlarm:"), forControlEvents: UIControlEvents.ValueChanged)
        cell.accessoryView = cell.alarmToggle
        return cell
    }
    
    /* TOGGLE ALARM STATE */
    
    // TODO: UPDATE 
    func toggleAlarm (switchState: UISwitch) {
        let index = switchState.tag
        print("CELL INDEX: ", index)
        
        if switchState.on {
            alarms[index].turnOn()
            print("IS ON: ", alarms[index].isActive)
            AlarmList.sharedInstance.updateAlarm(alarms[index])
        } else {
            alarms[index].turnOff()
            print("IS ON: ", alarms[index].isActive)
            AlarmList.sharedInstance.updateAlarm(alarms[index])
        }
    }
    
    /* ENABLE EDITING */
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            AlarmList.sharedInstance.removeAlarm(alarms[indexPath.row]) // remove from persistent data
            alarms.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            // Update tags for alarm state
            var t = 0
            for cell in tableView.visibleCells as! [AlarmTableViewCell] {
                cell.alarmToggle.tag = t++
            }
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
        let detailTVC = navVC.viewControllers.first as! DetailTableViewController
        
        if (segue.identifier == "editAlarm") {
            let indexPath = self.tableView.indexPathForSelectedRow!
            detailTVC.alarm = alarms[indexPath.row].copy()
            detailTVC.title = "Edit Alarm"
        } else {
            detailTVC.title = "Add Alarm"
        }
    }
    
    /* UNWIND SEGUES */
    
    @IBAction func saveAlarm (segue:UIStoryboardSegue) {
        let detailTVC = segue.sourceViewController as! DetailTableViewController
        let newAlarm = detailTVC.alarm.copy()
        
        if (self.tableView.editing == false) {
            print("AlarmTableViewController: New Alarm Saved")
            
            // TODO: FIX THIS!!!
            if (newAlarm.destination.name == "") {
                return
            }
        
            let indexPath = NSIndexPath(forRow: alarms.count, inSection: 0)
            alarms.append(newAlarm)
            AlarmList.sharedInstance.addAlarm(newAlarm)

            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.endUpdates()
        } else {
            print("AlarmTableViewController: Editing!")
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            self.alarms[indexPath.row] = detailTVC.alarm.copy()
            AlarmList.sharedInstance.updateAlarm(self.alarms[indexPath.row])

            self.tableView.beginUpdates()
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.endUpdates()
        }
    }
    
    @IBAction func cancelAlarm (segue:UIStoryboardSegue) {
        print("AlarmTableViewController: New Alarm Cancelled")
    }
    
    /* BACKGROUND REFRESH */
    
    // TODO: FIX!!!
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        for alarm in self.alarms {
            if alarm.isActive {
                let request = MKDirectionsRequest()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: newLocation.coordinate, addressDictionary: nil))
                request.destination = alarm.destination.toMKMapItem()
                
                if alarm.transportation == .Transit {
                    request.transportType = .Transit
                } else {
                    request.transportType = .Automobile
                }
                
                request.requestsAlternateRoutes = false
                let direction = MKDirections(request: request)
                direction.calculateETAWithCompletionHandler({
                    (response, err) -> Void in
                    if response == nil {
                        print("Inside didUpdateToLocation: Failed to get routes.")
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
    }
}
