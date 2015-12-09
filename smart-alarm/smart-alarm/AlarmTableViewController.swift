//
//  AlarmTableViewController.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 10/26/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit
import MapKit
import WatchConnectivity

class AlarmTableViewController: UITableViewController, CLLocationManagerDelegate, WCSessionDelegate {

    var alarms:[Alarm] = []
    let locationManager = CLLocationManager()
    let noDataLabel = UILabel()
    var session: WCSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        
        // Configure data source
        alarms = AlarmList.sharedInstance.allAlarms()
        
        // Check if empty
        noDataLabel.text = "No scheduled alarms"
        noDataLabel.font = UIFont(name: "Lato", size: 20)
        noDataLabel.textAlignment = NSTextAlignment.Center
        noDataLabel.textColor = UIColor(hue: 0.5833, saturation: 0.44, brightness: 0.36, alpha: 1.0)
        noDataLabel.alpha = 0.0
        self.tableView.backgroundView = noDataLabel
        checkScheduledAlarms()

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

        // Check if session is supported
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
            print("PHONE SESSION SUPPORTED")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        checkScheduledAlarms()
        
        // Send data to watch if supported
        if (WCSession.isSupported()) {
            sendAlarmsToWatch(AlarmList.sharedInstance.allAlarmsRaw())
        }
    }
    
    /* WATCH CONNECTIVITY */
    
    func sendAlarmsToWatch (phoneAlarms: NSArray) {
        print("PHONE SESSION SENDING")

        let applicationDict = ["phone-alarms": phoneAlarms]
        do {
            try session.updateApplicationContext(applicationDict)
        } catch {
            print("ERROR CONNECTING TO WATCH")
        }
    }
    
    /* HANDLE EMPTY DATA SOURCE */
    
    func checkScheduledAlarms () {
        UIView.animateWithDuration(0.25, animations: {
            if self.alarms.count == 0 {
                self.noDataLabel.alpha = 1.0
            } else {
                self.noDataLabel.alpha = 0.0
            }
        })  
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
        let alarm = alarms[indexPath.row]
        cell.alarmToggle.setOn(alarm.isActive, animated: false)
        cell.accessoryView = cell.alarmToggle
        return cell
    }
    
    /* TOGGLE ALARM STATE */
    
    func toggleAlarm (switchState: UISwitch) {
        let index = switchState.tag
        
        if switchState.on {
            alarms[index].turnOn()
            AlarmList.sharedInstance.scheduleNotification(alarms[index], category: "ALARM_CATEGORY")
            AlarmList.sharedInstance.scheduleNotification(alarms[index], category: "FOLLOWUP_CATEGORY")
            if (WCSession.isSupported()) {
                sendAlarmsToWatch(AlarmList.sharedInstance.allAlarmsRaw())
            }
        } else {
            alarms[index].turnOff()
            AlarmList.sharedInstance.cancelNotification(alarms[index], category: "ALARM_CATEGORY")
            AlarmList.sharedInstance.cancelNotification(alarms[index], category: "FOLLOWUP_CATEGORY")
            if (WCSession.isSupported()) {
                sendAlarmsToWatch(AlarmList.sharedInstance.allAlarmsRaw())
            }
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
            
            checkScheduledAlarms()
            
            // Send data to watch if supported
            if (WCSession.isSupported()) {
                sendAlarmsToWatch(AlarmList.sharedInstance.allAlarmsRaw())
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
            
            // Send data to watch if supported
            if (WCSession.isSupported()) {
                sendAlarmsToWatch(AlarmList.sharedInstance.allAlarmsRaw())
            }
        } else {
            let indexPath = self.tableView.indexPathForSelectedRow!
            self.alarms[indexPath.row] = detailTVC.alarm.copy()
            AlarmList.sharedInstance.updateAlarm(self.alarms[indexPath.row])

            self.tableView.beginUpdates()
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.endUpdates()
            
            // Send data to watch if supported
            if (WCSession.isSupported()) {
                sendAlarmsToWatch(AlarmList.sharedInstance.allAlarmsRaw())
            }
        }
    }
    
    @IBAction func cancelAlarm (segue:UIStoryboardSegue) {
        // Do nothing!
    }
    
    /* BACKGROUND REFRESH */
    
    // TODO: FIX!!!
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        //for alarm in self.alarms {
        for var index = 0; index < alarms.count; index++ {
            let alarm = alarms[index]
            
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
                    AlarmList.sharedInstance.updateAlarm(alarm)
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func backgroundFetchDone() {
        print("Fetch completion handler called.")
        //locationManager.stopUpdatingLocation()
    }
    
    func fetch(completionHandler: () -> Void) {
        for var index = 0; index < alarms.count; index++ {
            let alarm = alarms[index]
            
            if alarm.isActive {
                let request = MKDirectionsRequest()
                let location = locationManager.location
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: (location?.coordinate)!, addressDictionary: nil))
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
                        print("Inside fetch: Failed to get routes.")
                        self.tableView.reloadData()
                        return
                    }
                    let minutes = (response?.expectedTravelTime)! / 60.0
                    alarm.setETA(Int(round(minutes)))
                    print("Inside fetch: \(minutes)")
                    print("The estimated time is: \(alarm.getWakeupString())")
                    AlarmList.sharedInstance.updateAlarm(alarm)
                    self.tableView.reloadData()
                })
            }
        }
        //Call completionHandler
        completionHandler()
    }
    
}
