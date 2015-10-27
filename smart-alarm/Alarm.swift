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
    private var routine: Int
    private var wakeup: String
    
    private static var alarms:[Alarm] = []
    
    init () {
        self.arrival = NSDate()
        self.destination = "Home!"
        self.transportation = ""
        self.routine = 0
        self.wakeup = ""
    } // default constructor
    
    init (arrival: NSDate, destination: String, transportation: String, wakeup: String) {
        self.arrival = arrival
        self.destination = destination
        self.transportation = transportation
        self.routine = 0
        self.wakeup = wakeup
    }
    
    init (arrival: NSDate, destination: String, transportation: String, routine: Int, wakeup: String) {
        self.arrival = arrival
        self.destination = destination
        self.transportation = transportation
        self.routine = routine
        self.wakeup = wakeup
    }
    
    func getArrival() -> NSDate {
        return self.arrival
    }
    
    func getDestination() -> String {
        return self.destination
    }
    
    func getWakeup() -> String {
        return self.wakeup
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