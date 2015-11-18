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
        XCTAssert("" == alarm.getDestinationName())
        XCTAssert(0 == alarm.etaMinutes)
        XCTAssert(0 == alarm.routine.getTotalTime())
        XCTAssert("" == alarm.transportation)
        XCTAssert(alarm.isActive())
    }
    
    func testAlarmToggle() {
        let alarm = Alarm()
        XCTAssert(alarm.isActive)
        alarm.turnOff()
        XCTAssert(false == alarm.isActive())
        alarm.turnOn()
        XCTAssert(alarm.isActive())
    }
    
}
