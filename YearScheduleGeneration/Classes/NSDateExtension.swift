//
//  NSDateUpgrades.swift
//  YearScheduleGeneration
//
//  Created by admin on 13.05.16.
//  Copyright © 2016 Stepan. All rights reserved.
//

import Foundation

extension NSDate {
    
    ///returns the day of the week, which this date belongs to
    var dayOfTheWeek: String {
        get {
            //setting calendar
            let calendar = NSCalendar (calendarIdentifier: NSCalendarIdentifierGregorian)!
            //obtaining the weekday
            let weekDayIndex: Int = calendar.components(.Weekday, fromDate: self).weekday
            
            var weekDayName: String!
            
            switch weekDayIndex {
            case 1: weekDayName = "Monday"
            case 2: weekDayName = "Tuesday"
            case 3: weekDayName = "Wednesday"
            case 4: weekDayName = "Thursday"
            case 5: weekDayName = "Friday"
            case 6: weekDayName = "Saturday"
            case 7: weekDayName = "Sunday"
            default:
                print ("It cant be!")
                exit (0)
            }
            
            return weekDayName
        }
    }
    
}