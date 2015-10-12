//
//  DateUtil.swift
//  smart-alarm
//
//  Created by Edward Wu on 10/12/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import Foundation

class DateUtil {
    
    class func subtractRoutineFromTime(time: NSDate) -> NSDate {
        
        //Gather the times from routine
        var breakfastTime : Int = 0
        var exerciseTime : Int = 0
        var showerTime : Int = 0
        var otherTime : Int = 0
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let breakfast = defaults.stringForKey("breakfast") {
            breakfastTime = Int(breakfast)!
        }
        if let exercise = defaults.stringForKey("exercise") {
            exerciseTime = Int(exercise)!
        }
        if let shower = defaults.stringForKey("shower") {
            showerTime = Int(shower)!
        }
        if let other = defaults.stringForKey("other") {
            otherTime = Int(other)!
        }
        
        //Calculate total routine time in hours and minutes
        let totalRoutineTime = breakfastTime + exerciseTime + showerTime + otherTime
        
        let routineHours = totalRoutineTime % 60
        let routineMinutes = totalRoutineTime - 60 * routineHours
        
        let offset = NSDateComponents()
        offset.minute = -1 * routineMinutes
        offset.hour = -1 * routineHours
        
        let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        let wakeUp : NSDate = (gregorian?.dateByAddingComponents(offset, toDate: time, options: []))!
        
        return wakeUp
        
        //Format the return string
//        let formatter : NSDateFormatter = NSDateFormatter()
//        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
//        return formatter.stringFromDate(wakeUp)
    }
    
}