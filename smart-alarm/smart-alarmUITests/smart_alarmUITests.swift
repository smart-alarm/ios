//
//  smart_alarmUITests.swift
//  smart-alarmUITests
//
//  Created by Gideon I. Glass on 9/30/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import XCTest

class smart_alarmUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRegistration() {
        let app = XCUIApplication()
        app.buttons["Sign Up"].tap()
        
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("test@test.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        
        let verifyPasswordSecureTextField = app.secureTextFields["Verify Password"]
        verifyPasswordSecureTextField.tap()
        verifyPasswordSecureTextField.typeText("password")
        emailTextField.tap()
        app.buttons["Register"].tap()
    }
    
    func testLogin() {
        let app = XCUIApplication()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("test@test.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("password")
        app.buttons["Sign In"].tap()
    }
    
    func testTabViews() {
        testLogin()
        let tabBarsQuery = XCUIApplication().tabBars
        tabBarsQuery.buttons["Home"].tap()
        tabBarsQuery.buttons["Routine"].tap()
    }
    
    func randomTest() {
        
        
    }
    
    
}
