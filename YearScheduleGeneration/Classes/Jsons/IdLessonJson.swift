//
//  IdLessonJson.swift
//  YearScheduleGeneration
//
//  Created by admin on 14.05.16.
//  Copyright © 2016 Stepan. All rights reserved.
//

import Foundation


class IdLessonJson {
    var json : [String: Lesson] = [:]
    
    enum IdLessonErrors: ErrorType {
        case wrongJsonStructureInParser
        case invalidDateInParser
        case lessonParametersNotFound
    }

    init (dictionary: [String: Lesson]) {
        json = dictionary
    }
    
    init () {
        json = [String: Lesson]()
    }    
}

//MARK: Parser
extension IdLessonJson {
    private func parse (data: NSData)throws {
        //make json dictionary from NSData
        //there is double unwrapping here. Ask Mikhail
        guard
        let temp = try? NSJSONSerialization.JSONObjectWithData (data, options: []) as? [String: [String: String]],
            let unwrappedData = temp
            else {
                throw IdLessonErrors.wrongJsonStructureInParser
        }
        
        for (key, value) in unwrappedData {
            json[key] = try readLesson(value)
        }
    }

    
    private func readLesson (dictionary: [String: String])throws  -> Lesson{
        if let name = dictionary["name"],
           let room = dictionary["room"],
           let teacherId = dictionary ["teacherId"] {
           let hometaskId = dictionary["hometaskId"] ?? "-1"
            
            let lesson = Lesson (name: name, room: room, teacherId: teacherId, hometaskId: hometaskId)
            
            return lesson
        }
        else {
            throw IdLessonErrors.lessonParametersNotFound
        }
        
    }
}

//MARK: Assembler
extension IdLessonJson {
    
    func assemble() -> [String: [String: String]] {
        var dictionary = [String: [String: String]]()
        
        for (key, value) in json {
            dictionary[key] = assembleLesson(value)
        }
        
        return dictionary
    }
    
    private func assembleLesson (lesson: Lesson) -> [String: String]{
        var dictionary = [String: String]()
        
        dictionary["name"] = lesson.name
        dictionary["room"] = lesson.room
        dictionary["teacherId"] = lesson.teacherId
        dictionary["hometaskId"] = lesson.hometaskId
        
        return dictionary
    }
}
