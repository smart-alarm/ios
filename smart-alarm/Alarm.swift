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
    private(set) var followupID: String
    private(set) var isActive: Bool
    private(set) var arrival: NSDate
    private(set) var routine: Routine
    private(set) var etaMinutes: Int
    private(set) var transportation: Transportation
    private(set) var destination: Destination
    private(set) var wakeup: NSDate
    
    // TODO: CONFIRMATION NOTIFICATION UUID
    
    enum Transportation: String {
        case Automobile = "Automobile"
        case Transit = "Transit"
    }
    
    /* CONSTRUCTORS */
    
    init () {
        self.UUID = NSUUID().UUIDString
        self.followupID = NSUUID().UUIDString
        self.isActive = true
        self.arrival = NSDate()
        self.routine = Routine()
        self.etaMinutes = 0
        self.transportation = .Automobile
        self.destination = Destination()
        self.wakeup = NSDate()
        self.wakeup = calculateWakeup()
    }
    
    init (UUID: String = NSUUID().UUIDString, followupID: String = NSUUID().UUIDString, arrival: NSDate, routine: Routine, transportation: Transportation, destination: Destination) {
        self.UUID = UUID
        self.followupID = followupID
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
        self.followupID = copiedAlarm.followupID
        self.isActive = copiedAlarm.isActive
        self.arrival = copiedAlarm.arrival
        self.routine = copiedAlarm.routine.copy()
        self.etaMinutes = copiedAlarm.etaMinutes
        self.transportation = copiedAlarm.transportation
        self.destination = copiedAlarm.destination.copy()
        self.wakeup = copiedAlarm.wakeup
    }
    
    /* METHODS */
    
    func copy() -> Alarm {
        return Alarm(copiedAlarm: self)
    }
    
    func turnOn () {
        self.isActive = true
    }
    
    func turnOff () {
        self.isActive = false
    }
    
    func getWakeupString () -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter.stringFromDate(self.wakeup)
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
    
    func setDestination(mapItem: MKMapItem) {
        self.destination = Destination(mapItem: mapItem)
    }
    
    func setWakeup (wakeup: NSDate) {
        self.wakeup = wakeup
    }
    
    /* SERIALIZATION */
    
    func toDictionary () -> NSDictionary {
        let dict: NSDictionary = [
            "UUID": self.UUID,
            "followupID": self.followupID,
            "isActive": self.isActive,
            "arrival": self.arrival,
            "routine": self.routine.toArray(),
            "etaMinutes": self.etaMinutes,
            "transportation": self.transportation.rawValue,
            "destination": self.destination.toDictionary(),
            "wakeup": self.wakeup
        ]
        return dict
    }
    
    func fromDictionary (dict: NSDictionary) {
        self.UUID = dict.valueForKey("UUID") as! String
        self.followupID = dict.valueForKey("followupID") as! String
        self.isActive = dict.valueForKey("isActive") as! Bool
        self.arrival = dict.valueForKey("arrival") as! NSDate
        self.routine.fromArray(dict.valueForKey("routine") as! NSArray)
        self.etaMinutes = dict.valueForKey("etaMinutes") as! Int
        self.transportation = Transportation(rawValue: dict.valueForKey("transportation") as! String)!
        self.destination.fromDictionary(dict.valueForKey("destination") as! NSDictionary)
        self.wakeup = dict.valueForKey("wakeup") as! NSDate
    }
}