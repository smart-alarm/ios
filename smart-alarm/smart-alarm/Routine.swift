//
//  Routine.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 10/27/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import Foundation

class Routine {
    private var activities: [Activity]
    var count: Int
    
    init () {
        self.activities = []
        self.count = 0
    }
    
    init (newActivities: [Activity]) {
        self.activities = newActivities
        self.count = newActivities.count
    }
    
    init (newRoutine: Routine) {
        self.activities = []
        for a in newRoutine.activities {
            self.activities.append(a.copy())
        }
        self.count = newRoutine.count
    } // copy constructor
    
    func copy() -> Routine {
        return Routine(newRoutine: self)
    }
    
    func getActivities () -> [Activity] {
        return self.activities
    }
    
    func addActivity (newActivity: Activity) {
        self.activities.append(newActivity)
        self.count += 1
    }
    
    func removeActivity (index: Int) {
        self.activities.removeAtIndex(index)
        self.count -= 1
    }
    
    func update (newActivities: [Activity]) {
        self.activities = newActivities
        self.count = newActivities.count
    }
    
    func getTotalTime () -> Int {
        var total = 0
        for a in activities {
            total += a.getTime()
        }
        return total
    }
    
    /* SERIALIZATION */
    
    func toArray () -> NSArray {
        var array = Array<NSDictionary>()
        for activity in self.activities {
            array.append(activity.toDictionary())
        }
        return array
    }
    
    func fromArray (array: NSArray) {
        for data in array {
            let name = data.valueForKey("name") as! String
            let time = data.valueForKey("time") as! Int
            let activity = Activity(name: name, time: time)
            self.addActivity(activity)
        }
    }
}