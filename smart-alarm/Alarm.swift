//
//  Alarm.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 11/17/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import Foundation
import MapKit

class Alarm {
    
    /* FIELDS */
    
    private(set) var UUID: String
    private(set) var isActive: Bool
    private(set) var arrival: NSDate
    private(set) var routine: Routine
    private(set) var etaMinutes: Int
    private(set) var transportation: Transportation
    private(set) var destination: MKMapItem?
    private(set) var wakeup: NSDate
    
    enum Transportation: String {
        case Automobile = "Automobile"
        case Transit = "Transit"
    }
    
    /* CONSTRUCTORS */
    
    init () {
        self.UUID = NSUUID().UUIDString
        self.isActive = true
        self.arrival = NSDate()
        self.routine = Routine()
        self.etaMinutes = 0
        self.transportation = .Automobile
        self.destination = MKMapItem()
        self.wakeup = NSDate()
        self.wakeup = calculateWakeup()
    }
    
    init (UUID: String = NSUUID().UUIDString, arrival: NSDate, routine: Routine, transportation: Transportation, destination: MKMapItem) {
        self.UUID = UUID
        self.isActive = true
        self.arrival = arrival
        self.routine = routine
        self.etaMinutes = 0
        self.transportation = transportation
        self.destination = destination
        self.wakeup = NSDate()
        self.wakeup = calculateWakeup()
    }
    
    init (copiedAlarm: Alarm) {
        self.UUID = copiedAlarm.UUID
        self.isActive = copiedAlarm.isActive
        self.arrival = copiedAlarm.arrival
        self.routine = copiedAlarm.routine
        self.etaMinutes = copiedAlarm.etaMinutes
        self.transportation = copiedAlarm.transportation
        self.destination = copiedAlarm.destination
        self.wakeup = copiedAlarm.wakeup
    }
    
    /* METHODS */
    
    func copy() -> Alarm {
        return Alarm(copiedAlarm: self)
    }
    
    func toggleAlarm () {
        if self.isActive {
            isActive = false
        } else {
            isActive = true
        }
    }
    
    func getWakeupString () -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter.stringFromDate(self.wakeup)
    }
    
    func getDestinationName () -> String {
        if destination != nil {
            return (destination?.name)!
        }
        return ""
    }
    
    func getTransportString () -> String {
        return (self.transportation.rawValue)
    }
    
    func calculateWakeup() -> NSDate {
        let components: NSDateComponents = NSDateComponents()
        let combinedTime = self.routine.getTotalTime() + self.etaMinutes
        components.setValue(combinedTime*(-1), forComponent: NSCalendarUnit.Minute);
        let result = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self.arrival, options: NSCalendarOptions(rawValue: 0))
        return result!
    }
    
    /* ACCESS CONTROL METHODS */
    
    func setArrival (arrival: NSDate) {
        self.arrival = arrival
    }
    
    func setRoutine (routine: Routine) {
        self.routine = routine
    }
    
    func setETA (etaMinutes: Int) {
        self.etaMinutes = etaMinutes
    }
    
    func setTransportation (transportation: Transportation) {
        self.transportation = transportation
    }
    
    func setDestination(destination: MKMapItem) {
        self.destination = destination
    }
    
    func setWakeup (wakeup: NSDate) {
        self.wakeup = wakeup
    }
    
    /* SERIALIZATION */
    
    func toDictionary () -> NSDictionary {
        let dict: NSDictionary = [
            "UUID": self.UUID,
            "isActive": self.isActive,
            "arrival": self.arrival,
            "routine": self.routine.toArray(),
            "etaMinutes": self.etaMinutes,
            "transportation": self.transportation.rawValue,
            "destination": self.destination!.name!,
            "wakeup": self.wakeup
        ]
        return dict
    }
    
    func fromDictionary (dict: NSDictionary) {
        self.UUID = dict.valueForKey("UUID") as! String
        self.isActive = dict.valueForKey("isActive") as! Bool
        self.arrival = dict.valueForKey("arrival") as! NSDate
        self.routine.fromArray(dict.valueForKey("routine") as! NSArray)
        self.etaMinutes = dict.valueForKey("etaMinutes") as! Int
        self.transportation = Transportation(rawValue: dict.valueForKey("transportation") as! String)!
        self.destination = MKMapItem() // STILL NEED TO FIX!!!
        self.wakeup = dict.valueForKey("wakeup") as! NSDate
    }
}