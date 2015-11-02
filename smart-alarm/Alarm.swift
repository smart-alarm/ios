//
//  Alarm.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 10/26/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import Foundation

class Alarm {
    private var arrival: NSDate
    private var destination: String
    private var transportation: String
    private var routineMinutes: Int
    private var etaMinutes: Int
    private var wakeup: String
    
    var routine: Routine
    
    private static var alarms:[Alarm] = []
    
    init () {
        self.arrival = NSDate()
        self.destination = ""
        self.transportation = ""
        self.routineMinutes = 0
        self.etaMinutes = 0
        self.wakeup = ""
        self.routine = Routine()
    } // default constructor
    
    init (arrival: NSDate, destination: String, transportation: String, wakeup: String) {
        self.arrival = arrival
        self.destination = destination
        self.transportation = transportation
        self.routineMinutes = 0
        self.etaMinutes = 0
        self.wakeup = wakeup
        self.routine = Routine()
    }
    
    init (arrival: NSDate, destination: String, transportation: String, routine: Int, wakeup: String) {
        self.arrival = arrival
        self.destination = destination
        self.transportation = transportation
        self.routineMinutes = routine
        self.etaMinutes = 0
        self.wakeup = wakeup
        self.routine = Routine()
    }
    
    init (newAlarm: Alarm) {
        self.arrival = newAlarm.arrival
        self.destination = newAlarm.destination
        self.transportation = newAlarm.transportation
        self.routineMinutes = newAlarm.routineMinutes
        self.etaMinutes = newAlarm.etaMinutes
        self.wakeup = newAlarm.wakeup
        self.routine = newAlarm.routine.copy()
    } // Copy constructor
    
    func copy() -> Alarm {
        return Alarm(newAlarm: self)
    }
    
    func getArrival() -> NSDate {
        return self.arrival
    }
    
    func getDestination() -> String {
        return self.destination
    }
    
    func getTransportation() -> String {
        return self.transportation
    }
    
    func getRoutine () -> Int {
        return self.routineMinutes
    }
    
    func getETA () -> Int {
        return self.etaMinutes
    }
    
    func getWakeup() -> String {
        return self.wakeup
    }
    
    func setArrival (time: NSDate) {
        self.arrival = time
    }
    
    func setDestination (location: String) {
        self.destination = location
    }
    
    func setTransportation (mode: String) {
        self.transportation = mode
    }
    
    
    func setRoutine (minutes: Int) {
        self.routineMinutes = minutes
    }
    
    func setETA (minutes: Int) {
        self.etaMinutes = minutes
    }
    
    func setWakeup (time: String) {
        self.wakeup = time
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