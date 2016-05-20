//
//  Day.swift
//  YearScheduleGeneration
//
//  Created by admin on 13.05.16.
//  Copyright © 2016 Stepan. All rights reserved.
//

import Foundation


///Contains array of lessons on a particuar day
///The index of the object is its number
struct Day {
    var lessons: [String]
    
    //takes the array and just wraps it with class
    init (lessons: [String]) {
        self.lessons = lessons
    }
    
    init () {
        lessons = [String]()
    }
}