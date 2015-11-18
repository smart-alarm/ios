//
//  Activity.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 10/27/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import Foundation

class Activity {
    private var name: String
    private var time: Int
    
    init () {
        name = ""
        time = 0
    }
    
    init (name: String, time: Int) {
        self.name = name
        self.time = time
    }
    
    init (newActivity: Activity) {
        self.name = newActivity.name
        self.time = newActivity.time
    } // copy constructor
    
    func copy() -> Activity {
        return Activity(newActivity: self)
    }
    
    func getName () -> String {
        return self.name
    }
    
    func getTime () -> Int {
        return self.time
    }
    
    func toDictionary () -> NSDictionary {
        let dict: NSDictionary = [
            "name": self.name,
            "time": self.time
        ]
        return dict
    }
}
