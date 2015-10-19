//
//  Activities.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 10/19/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import Foundation

class Activities {
    private static var activities: [Dictionary<String,String>] = []
    
    static func addActivity (newActivity: Dictionary<String,String>) {
        activities.append(newActivity)
    }
    
    static func deleteActivity (index: Int) {
        activities.removeAtIndex(index)
    }
    
    static func getActivities () -> [Dictionary<String,String>] {
        return activities
    }
    
    static func update (updatedActivities: [Dictionary<String,String>]) {
        activities = updatedActivities
    }
}
