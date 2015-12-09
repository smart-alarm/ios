//
//  InterfaceController.swift
//  smart-alarm-watch Extension
//
//  Created by Gideon I. Glass on 12/8/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    /* VARIABLES */
    
    @IBOutlet var alarmTable: WKInterfaceTable!
    var alarms: NSArray = []
    var session: WCSession!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Check if session is supported
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
            print("WATCH SESSION SUPPORTED")
        }
        
        loadAlarms(alarms)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        loadAlarms(alarms)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    func loadAlarms (phoneAlarms: NSArray) {
        
        // Get alarms from phone
        var watchAlarms = [Alarm]()
        for dict in phoneAlarms {
            let alarm = Alarm()
            alarm.fromDictionary(dict as! NSDictionary)
            
            if (alarm.isActive == true) {
                watchAlarms.append(alarm)
            }
        }
        
        // Set number of rows
        alarmTable.setNumberOfRows(watchAlarms.count, withRowType: "alarmRow")
        
        // Populate rows
        for (var i=0; i<alarmTable.numberOfRows; i++) {
            let row = alarmTable.rowControllerAtIndex(i) as! WKAlarmRowController
            let alarm = watchAlarms[i]
            
            row.alarmLabel?.setText("\(alarm.getWakeupString())")
            
            if (alarm.getTransportString() == "Automobile") {
                row.alarmImage?.setImageNamed("car")
            } else {
                row.alarmImage?.setImageNamed("subway")
            }
        }
    }
    
    /* WATCH CONNECTIVITY */
    
    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
        
        if let phoneAlarms = applicationContext["phone-alarms"] as? NSArray {
            print("WATCH SESSION RECEIVING")
            print(phoneAlarms)

            // Update UI
            dispatch_async(dispatch_get_main_queue()) {
                self.alarms = phoneAlarms
                self.loadAlarms(phoneAlarms)
            }
        }
    }
    

}
