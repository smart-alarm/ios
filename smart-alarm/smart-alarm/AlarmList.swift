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
            let dict = data as! NSDictionary
            let alarm = Alarm()
            alarm.fromDictionary(dict)
            alarmItems.append(alarm)
        }
        return alarmItems
    }
    
    func addAlarm (newAlarm: Alarm) {
        // Create persistent dictionary of data
        var alarmDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ALARMS_KEY) ?? Dictionary()
        
        // Copy alarm object into persistent data
        alarmDictionary[newAlarm.UUID] = newAlarm.toDictionary()
        
        // Save or overwrite data
        NSUserDefaults.standardUserDefaults().setObject(alarmDictionary, forKey: ALARMS_KEY)
        
        // Set up local notifications here
        let notification = UILocalNotification()
        notification.alertBody = "Time to wakeup!"
        notification.fireDate = newAlarm.wakeup
        notification.soundName = UILocalNotificationDefaultSoundName // TODO: FIND LONGER SOUND FILE
        notification.userInfo = ["UUID": newAlarm.UUID]
        notification.category = "ALARM_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        // TODO: SCHEDULE ANOTHER NOTIFICATION TO ASK
        // USER AT ARRIVAL TIME, "DID YOU ARRIVE ON TIME?"
        // AND ADD "YES" AND "NO" ACTIONS...
        // ALSO, UPDATE IF ALARM ARRIVAL TIME IS MODIFIED
        scheduleFollowupNotification(newAlarm)
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
        
        cancelFollowupNotification(alarmToRemove)
        
        // Remove alarm from persistent data
        if var alarmDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ALARMS_KEY) {
            print("AlarmList: ", alarmToRemove.UUID)
            alarmDictionary.removeValueForKey(alarmToRemove.UUID as String)
            NSUserDefaults.standardUserDefaults().setObject(alarmDictionary, forKey: ALARMS_KEY)        }
    }
    
    // TODO: CHECK ISACTIVE FIELD BEFORE UPDATING!!!
    // TODO: FIX UPDATED NOTIFICATION!
    func updateAlarm (alarmToUpdate: Alarm) {
        // Create persistent dictionary of data
        var alarmDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ALARMS_KEY) ?? Dictionary()
        
        // Copy alarm object into persistent data
        alarmDictionary[alarmToUpdate.UUID] = alarmToUpdate.toDictionary()
        
        // Save or overwrite data
        NSUserDefaults.standardUserDefaults().setObject(alarmDictionary, forKey: ALARMS_KEY)
        
        // Update fire date
        for event in UIApplication.sharedApplication().scheduledLocalNotifications! {
            let notification = event as UILocalNotification
            
            if (notification.userInfo!["UUID"] as! String == alarmToUpdate.UUID) {
                notification.fireDate = alarmToUpdate.wakeup
                break
            }
            
            // TODO: ALSO UPDATE CONFIRMATIONS NOTIFICATION
        }
    }
    
    func scheduleFollowupNotification (alarm: Alarm) {
        let notification = UILocalNotification()
        notification.alertBody = "Did you arrive on time?"
        notification.fireDate = alarm.arrival
        notification.soundName = UILocalNotificationDefaultSoundName // TODO: FIND LONGER SOUND FILE
        notification.userInfo = ["UUID": alarm.followupID]
        notification.category = "FOLLOWUP_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func cancelFollowupNotification (alarm: Alarm) {
        for event in UIApplication.sharedApplication().scheduledLocalNotifications! {
            let notification = event as UILocalNotification
            
            if (notification.userInfo!["UUID"] as! String == alarm.followupID) {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break
            }
        }
    }
    
}