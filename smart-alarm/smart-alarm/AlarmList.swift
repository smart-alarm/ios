//
//  AlarmList.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 11/17/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AlarmList {
    
    // Singleton pattern ensures single instance of AlarmList
    class var sharedInstance: AlarmList {
        struct Static {
            static let instance: AlarmList = AlarmList()
        }
        return Static.instance
    }
    
    private let ALARMS_KEY = "alarmItems"
    
    func allAlarms () -> [Alarm] {
        let alarmDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ALARMS_KEY) ?? Dictionary()
        var alarmItems:[Alarm] = []
        
        for data in alarmDictionary.values {
            let UUID = data.valueForKey("UUID") as! String
            let arrival = data.valueForKey("arrival") as! NSDate
//            let routine = data.valueForKey("routine")
//            let transportation = data.valueForKey("transportation")
//            let destination = data.valueForKey("destination")
            
            let alarm = Alarm(UUID: UUID, arrival: arrival, routine: Routine(), transportation: .Automobile, destination: MKMapItem())
            alarmItems.append(alarm)
        }
        return alarmItems
    }
    
    
    // STILL WORK IN PROGRESS! NEED TO ENCODE AND DECODE ALARM
    // OBJECT PROPERLY TO SAVE IN NSUSERDEFAULTS
    // THIS IS A TEMPORARY TEST!!!
    // SOME FIELDS WILL BE LOST WHEN REOPENING APP UNTIL THEN!!!
    func addAlarm (newAlarm: Alarm) {
        // Create persistent dictionary of data
        var alarmDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ALARMS_KEY) ?? Dictionary()
        
        // Copy alarm object into persistent data
        alarmDictionary[newAlarm.UUID] = [
            "UUID": newAlarm.UUID,
            "isActive": newAlarm.isActive,
            "arrival": newAlarm.arrival,
            "routine": [],
            "etaMinutes": newAlarm.etaMinutes,
            "transportation": "",
            "destination": "",
            "wakeup": newAlarm.wakeup
        ]
        
        // Save or overwrite data
        NSUserDefaults.standardUserDefaults().setObject(alarmDictionary, forKey: ALARMS_KEY)
        
        // Set up local notifications here
        let notification = UILocalNotification()
        notification.alertBody = "Time to wakeup!"
        notification.fireDate = newAlarm.wakeup
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["UUID": newAlarm.UUID]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func removeAlarm (alarmToRemove: Alarm) {
        // Remove alarm notification
        for event in UIApplication.sharedApplication().scheduledLocalNotifications! {
            let notification = event as UILocalNotification

            if (notification.userInfo!["UUID"] as! String == alarmToRemove.UUID) {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break
            }
        }
        
        // Remove alarm from persistent data
        if var alarmDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ALARMS_KEY) {
            print("HERE!")
            print(alarmToRemove.UUID)
            alarmDictionary.removeValueForKey(alarmToRemove.UUID as String)
            
            print(alarmDictionary)
            NSUserDefaults.standardUserDefaults().setObject(alarmDictionary, forKey: ALARMS_KEY)        }
    }
}