//
//  Alarm.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 10/26/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import Foundation
import MapKit

class Alarm {
    private var arrival: NSDate
    private var transportation: String
    private var routine: Routine
    private var etaMinutes: Int
    private var wakeup: String
    private var active: Bool
    private var destination: MKMapItem?

    
    private static var alarms:[Alarm] = []
    
    init () {
        self.arrival = NSDate()
        self.transportation = ""
        self.etaMinutes = 0
        self.wakeup = ""
        self.routine = Routine()
        self.active = true
    } // default constructor
    
    init (arrival: NSDate, destinationName: String, transportation: String, wakeup: String) {
        self.arrival = arrival
        self.transportation = transportation
        self.etaMinutes = 0
        self.wakeup = wakeup
        self.routine = Routine()
        self.active = true
    }
    
    init (newAlarm: Alarm) {
        self.arrival = newAlarm.arrival
        self.transportation = newAlarm.transportation
        self.etaMinutes = newAlarm.etaMinutes
        self.wakeup = newAlarm.wakeup
        self.routine = newAlarm.routine.copy()
        self.active = newAlarm.active
        self.destination = MKMapItem(placemark: newAlarm.destination!.placemark)
    } // Copy constructor
    
    func copy() -> Alarm {
        return Alarm(newAlarm: self)
    }
    
    func getArrival() -> NSDate {
        return self.arrival
    }
    
    func getDestination() -> MKMapItem {
        return self.destination!
    }
    
    func getDestinationName() -> String {
        if destination != nil {
            return (destination?.name)!
        }
        return ""
    }
    
    func getTransportation() -> String {
        return self.transportation
    }
    
    func getRoutine() -> Routine {
        return self.routine
    }
    
    func getRoutineMinutes() -> Int {
        return self.routine.getTotalTime()
    }
    
    func getETA () -> Int {
        return self.etaMinutes
    }
    
    //Returns the Wakeup time formatted as a string
    func getWakeup() -> String {
        //return self.wakeup
        // Format labels
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return dateFormatter.stringFromDate(self.getWakeUpTime())
    }
    
    func isActive() -> Bool {
        return self.active
    }
    
    func setArrival (time: NSDate) {
        self.arrival = time
    }
    
    func setDestination(destination: MKMapItem) {
        self.destination = destination
    }
    
    func setTransportation (mode: String) {
        self.transportation = mode
    }
    
    
    func setRoutine (routine: Routine) {
        self.routine = routine
    }
    
    func setETA (minutes: Int) {
        self.etaMinutes = minutes
    }
    
    func setWakeup (time: String) {
        self.wakeup = time
    }
    
    func turnOn() {
        self.active = true
    }
    
    func turnOff() {
        self.active = false
    }
    
    //Returns the Wakeup time as an NSDate object (Arrival time minus the routine and ETA)
    func getWakeUpTime() -> NSDate {
        let components: NSDateComponents = NSDateComponents()
        let combinedTime = self.getRoutineMinutes() + self.getETA()
        components.setValue(combinedTime*(-1), forComponent: NSCalendarUnit.Minute);
        let result = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self.getArrival(), options: NSCalendarOptions(rawValue: 0))
        return result!
    }
    
    static func getAlarms () -> [Alarm] {
        return alarms
    }
    
    static func addAlarm (a: Alarm) {
        alarms.append(a)
    }
    
    static func deleteAlarm (index: Int) {
        alarms.removeAtIndex(index)
    }
    
    static func update (updatedAlarms: [Alarm]) {
        alarms = updatedAlarms
    }
    
}