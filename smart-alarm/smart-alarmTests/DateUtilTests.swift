//
//  DateUtilTests.swift
//  smart-alarm
//
//  Created by Edward Wu on 10/12/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import XCTest
@testable import smart_alarm

class DateUtilTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("breakfast")
        defaults.removeObjectForKey("exercise")
        defaults.removeObjectForKey("shower")
        defaults.removeObjectForKey("other")
    }
    
    override func tearDown() {
        super.tearDown()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("breakfast")
        defaults.removeObjectForKey("exercise")
        defaults.removeObjectForKey("shower")
        defaults.removeObjectForKey("other")
    }
    
    func testZeroTime() {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let origComponents = NSDateComponents()
        origComponents.hour = 1
        origComponents.minute = 31
        let time = gregorian?.dateFromComponents(origComponents)
        
        let calculatedTime = DateUtil.subtractRoutineFromTime(time!)
        
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
        let time = gregorian?.dateFromComponents(origComponents)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("30", forKey: "breakfast")
        
        let calculatedTime = DateUtil.subtractRoutineFromTime(time!)
        
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
        let time = gregorian?.dateFromComponents(origComponents)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("30", forKey: "breakfast")
        
        let calculatedTime = DateUtil.subtractRoutineFromTime(time!)
        
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
        let time = gregorian?.dateFromComponents(origComponents)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("30", forKey: "breakfast")
        
        let calculatedTime = DateUtil.subtractRoutineFromTime(time!)
        
        let timeComponents = gregorian?.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: calculatedTime)
        let hour = timeComponents!.hour
        let minute = timeComponents!.minute
        
        XCTAssert(hour == 23)
        XCTAssert(minute == 59)
    }
    
    
}

