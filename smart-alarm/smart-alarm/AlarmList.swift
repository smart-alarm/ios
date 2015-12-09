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
    
    private let ALARMS_KEY = "alarmItems"
    
    /* SINGLETON CONSTRUCTOR */
    
    class var sharedInstance: AlarmList {
        struct Static {
            static let instance: AlarmList = AlarmList()
        }
        return Static.instance
    }
    
    /* ALARM FUNCTIONS */
    
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
    
    func allAlarmsRaw () -> NSArray {
        let alarmDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ALARMS_KEY) ?? Dictionary()
        var alarmItems:[NSDictionary] = []
        
        for data in alarmDictionary.values {
            let alarmDict = data as! NSDictionary
            alarmItems.append(alarmDict)
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
        
        // Schedule notifications
        scheduleNotification(newAlarm, category: "ALARM_CATEGORY")
        scheduleNotification(newAlarm, category: "FOLLOWUP_CATEGORY")
    }
    
    func removeAlarm (alarmToRemove: Alarm) {
        // Remove alarm notifications
        cancelNotification(alarmToRemove, category: "ALARM_CATEGORY")
        cancelNotification(alarmToRemove, category: "FOLLOWUP_CATEGORY")
        
        // Remove alarm from persistent data
        if var alarmDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ALARMS_KEY) {
            alarmDictionary.removeValueForKey(alarmToRemove.UUID as String)
            NSUserDefaults.standardUserDefaults().setObject(alarmDictionary, forKey: ALARMS_KEY)
        }
    }
    
    func updateAlarm (alarmToUpdate: Alarm) {
        // Remove old alarm
        removeAlarm(alarmToUpdate)
        
        // Create new unique IDs
        let newUUID = NSUUID().UUIDString
        let newFollowupID = NSUUID().UUIDString
        
        // Associate with the alarm by updating IDs
        alarmToUpdate.setUUID(newUUID)
        alarmToUpdate.setFollowupID(newFollowupID)
        
        // Reschedule new alarm
        addAlarm(alarmToUpdate)
        
        print("UPDATING: ", alarmToUpdate.isActive)
    }
    
    /* NOTIFICATION FUNCTIONS */
    
    func scheduleNotification (alarm: Alarm, category: String) {
        let notification = UILocalNotification()
        notification.category = category
        notification.repeatInterval = NSCalendarUnit.Day
        
        switch category {
        case "ALARM_CATEGORY":
            notification.userInfo = ["UUID": alarm.UUID]
            notification.alertBody = "Time to wake up!"
            notification.fireDate = alarm.wakeup
            notification.soundName = "loud_alarm.caf"
            break
        case "FOLLOWUP_CATEGORY":
            notification.userInfo = ["UUID": alarm.followupID]
            notification.alertBody = "Did you arrive yet?"
            notification.fireDate = alarm.arrival
            notification.soundName = UILocalNotificationDefaultSoundName
            break
        default:
            print("ERROR SCHEDULING NOTIFICATION")
            return
        }
        
        // For debugging purposes
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        print("ALARM SCHEDULED FOR :", dateFormatter.stringFromDate(notification.fireDate!))
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func cancelNotification (alarm: Alarm, category: String) {
        var ID: String
        switch category {
        case "ALARM_CATEGORY":
            ID = alarm.UUID
            break
        case "FOLLOWUP_CATEGORY":
            ID = alarm.followupID
            break
        default:
            print("ERROR CANCELLING NOTIFICATION")
            return
        }
        
        for event in UIApplication.sharedApplication().scheduledLocalNotifications! {
            let notification = event as UILocalNotification
            if (notification.userInfo!["UUID"] as! String == ID) {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break
            }
        }
    }
}