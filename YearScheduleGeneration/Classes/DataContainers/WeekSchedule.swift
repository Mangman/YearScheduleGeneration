//
//  WeekSchedule.swift
//  YearScheduleGeneration
//
//  Created by admin on 13.05.16.
//  Copyright © 2016 Stepan. All rights reserved.
//

import Foundation

///Contains list of structure for each day of the working week
struct WeekSchedule {
    private var lessonsOnDay = [String: [Lesson]]()
    
    enum weekScheduleErrors: ErrorType {
        case invalidDayName
    }
    init (monday: [Lesson], tuesday: [Lesson], wednesday: [Lesson], thursday: [Lesson], friday: [Lesson], saturday: [Lesson]) {
        lessonsOnDay["Monday"]    = monday
        lessonsOnDay["Tuesday"]   = tuesday
        lessonsOnDay["Wednesday"] = wednesday
        lessonsOnDay["Thursday"]  = thursday
        lessonsOnDay["Friday"]    = friday
        lessonsOnDay["Saturday"]  = saturday
    }
    
    func lessonsAtDay(dayName: String)throws -> [Lesson] {
        guard let lessons = lessonsOnDay[dayName]
        else {
            throw weekScheduleErrors.invalidDayName
        }
        
        return lessons
    }
    
}