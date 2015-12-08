//
//  RoutineTests.swift
//  smart-alarm
//
//  Created by Edward Wu on 12/8/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import XCTest
@testable import smart_alarm

class RoutineTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDefaultConstructor() {
        let routine = Routine()
        XCTAssert(routine.activities.count == 0)
    }
    
    func testAddActivity() {
        let routine = Routine()
        XCTAssert(routine.activities.count == 0)
        routine.addActivity(Activity(name: "Test1", time: 1))
        XCTAssert(routine.activities.count == 1)
    }
    
    func testGetTotalTime() {
        let routine = Routine()
        routine.addActivity(Activity(name: "Test1", time: 1))
        XCTAssert(1 == routine.getTotalTime())
        routine.addActivity(Activity(name: "Test2", time: 2))
        XCTAssert(3 == routine.getTotalTime())
    }
    
    func testDeepCopy() {
        let routine = Routine()
        routine.addActivity(Activity(name: "Test1", time: 1))
        routine.addActivity(Activity(name: "Test2", time: 2))
        
        let deepCopy = routine.copy()
        deepCopy.removeActivity(1)
        XCTAssert(1 == deepCopy.getTotalTime())
        XCTAssert(3 == routine.getTotalTime())
    }
    
    func testSerialization() {
        let routine = Routine()
        routine.addActivity(Activity(name: "Test1", time: 1))
        routine.addActivity(Activity(name: "Test2", time: 2))
        XCTAssert(3 == routine.getTotalTime())
        
        let array = routine.toArray()
        XCTAssert(array.count == 2)
        let recreatedRoutine = Routine()
        recreatedRoutine.fromArray(array)
        XCTAssert(3 == recreatedRoutine.getTotalTime())
    }
    
}
