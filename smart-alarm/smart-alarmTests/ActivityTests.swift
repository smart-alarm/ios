//
//  ActivityTests.swift
//  smart-alarm
//
//  Created by Edward Wu on 12/8/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import XCTest
@testable import smart_alarm

class ActivityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDefaultConstructor() {
        let activity = Activity()
        XCTAssert("" == activity.name)
        XCTAssert(0 == activity.time)
    }
    
    func testParamConstructor() {
        let activity = Activity(name: "Test", time: 2)
        XCTAssert(2 == activity.time)
        XCTAssert("Test" == activity.name)
    }
    
    func testToDict() {
        let firstActivity = Activity(name: "Test", time: 2)
        let actAsDict = firstActivity.toDictionary()
        XCTAssert(actAsDict.objectForKey("name") as! String == "Test")
        XCTAssert(actAsDict.objectForKey("time") as! Int == 2)
    }
    
}
