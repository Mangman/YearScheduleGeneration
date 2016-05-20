//
//  Lesson.swift
//  YearScheduleGeneration
//
//  Created by admin on 12.05.16.
//  Copyright © 2016 Stepan. All rights reserved.
//

import Foundation

///Stores all information about particular lesson
struct Lesson {
    var name: String
    var room: String
    
    var teacherId: String
    var hometaskId: String
    
    init (name: String, room: String, teacherId: String, hometaskId: String) {
        self.name = name
        self.room = room
        self.teacherId = teacherId
        self.hometaskId = hometaskId
    }
}