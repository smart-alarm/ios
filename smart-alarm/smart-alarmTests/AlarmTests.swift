//
//  AlarmTests.swift
//  smart-alarm
//
//  Created by Edward Wu on 11/4/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import XCTest
@testable import smart_alarm

class AlarmTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDefaultConstructor() {
        let alarm = Alarm()
        XCTAssert("" == alarm.destination.name)
        XCTAssert(0 == alarm.routine.getTotalTime())
        XCTAssert(0 == alarm.etaMinutes)
        XCTAssert(0 == alarm.routine.getTotalTime())
        XCTAssert(alarm.isActive)
    }
    
    func testAlarmToggle() {
        let alarm = Alarm()
        XCTAssert(alarm.isActive)
        alarm.turnOff()
        XCTAssert(false == alarm.isActive)
        alarm.turnOn()
        XCTAssert(alarm.isActive)
    }
    
    func testZeroCalculateWakeUp() {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let arivComponents = NSDateComponents()
        arivComponents.hour = 1
        arivComponents.minute = 31
        let arrival = gregorian?.dateFromComponents(arivComponents)
        
        let alarm = Alarm()
        alarm.setArrival(arrival!)
        
        let calculatedTime = alarm.calculateWakeup()
        
        let timeComponents = gregorian?.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: calculatedTime)
        let hour = timeComponents!.hour
        let minute = timeComponents!.minute
        XCTAssert(hour == 1)
        XCTAssert(minute == 31)
    }
    
    func testHalfHour() {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let origComponents = NSDateComponents()
        origComponents.hour = 1
        origComponents.minute = 31
        let arrival = gregorian?.dateFromComponents(origComponents)
        
        let alarm = Alarm()
        alarm.setArrival(arrival!)
        let routine = Routine()
        routine.addActivity(Activity(name: "Test", time: 30))
        alarm.setRoutine(routine)
        
        let calculatedTime = alarm.calculateWakeup()
        
        let calcComponents = NSDateComponents()
        calcComponents.hour = 1
        calcComponents.minute = 1
        let expectedTime = gregorian?.dateFromComponents(calcComponents)
        
        XCTAssert(expectedTime!.compare(calculatedTime) == NSComparisonResult.OrderedSame)
    }
    
    func testHalfHourHourChanges() {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let origComponents = NSDateComponents()
        origComponents.hour = 1
        origComponents.minute = 29
        let arrival = gregorian?.dateFromComponents(origComponents)
        
        let alarm = Alarm()
        alarm.setArrival(arrival!)
        let routine = Routine()
        routine.addActivity(Activity(name: "Test", time: 30))
        alarm.setRoutine(routine)
        let calculatedTime = alarm.calculateWakeup()
        
        let calcComponents = NSDateComponents()
        calcComponents.hour = 0
        calcComponents.minute = 59
        let expectedTime = gregorian?.dateFromComponents(calcComponents)
        
        XCTAssert(expectedTime!.compare(calculatedTime) == NSComparisonResult.OrderedSame)
    }
    
    func testHalfHourMidnight() {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let origComponents = NSDateComponents()
        origComponents.hour = 0
        origComponents.minute = 29
        let arrival = gregorian?.dateFromComponents(origComponents)
        
        let alarm = Alarm()
        alarm.setArrival(arrival!)
        let routine = Routine()
        routine.addActivity(Activity(name: "Test", time: 30))
        alarm.setRoutine(routine)
        let calculatedTime = alarm.calculateWakeup()
        
        let timeComponents = gregorian?.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: calculatedTime)
        let hour = timeComponents!.hour
        let minute = timeComponents!.minute
        
        XCTAssert(hour == 23)
        XCTAssert(minute == 59)
    }
    
    func testDeepCopy() {
        let firstAlarm = Alarm()
        let secondAlarm = firstAlarm.copy()
        secondAlarm.setETA(5)
        XCTAssert(firstAlarm.etaMinutes != secondAlarm.etaMinutes)
    }
    
}
