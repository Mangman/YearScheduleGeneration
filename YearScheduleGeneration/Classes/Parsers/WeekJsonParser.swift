//
//  File.swift
//  YearScheduleGeneration
//
//  Created by admin on 12.05.16.
//  Copyright © 2016 Stepan. All rights reserved.
//

import Foundation

///Parses NSData Json to Swift dictionary
class WeekJsonParser {
    ///Result of parsing
    private (set) var parsedJson: WeekSchedule?
    
    enum WeekJsonParserErrors: ErrorType {
        case wrongStructure
        case emptyParameter
        case dontHaveDay
    }
    
    init (data: NSData) {
        do {
            //parse Json into internal value
            try parse(data)
            
            print ("WeekJsonParser: parsing \n")
        }
        catch WeekJsonParserErrors.wrongStructure {
            print("WeekParser ERROR: Given Json cannot be downcasted to what we seek.\n")
        }
        catch WeekJsonParserErrors.emptyParameter {
            print("WeekParser ERROR: Some of the parameters or their values are not provided.\n")
        }
        catch WeekJsonParserErrors.dontHaveDay {
            print("WeekParser ERROR: Information on some of the working days is not provided.\n")
        }
        catch {
            print("WeekParser ERROR: unknown NSJSONSerialzation error\nits probably my fault.\n")
        }
    }
    
    private func parse (rawJsonData: NSData)throws {
       //Unwraps Json form NSData to Dictionary
        guard let unwrappedData = try? NSJSONSerialization.JSONObjectWithData (rawJsonData, options: []) as?
            [String: [[String: AnyObject]]]
            else {
                throw WeekJsonParserErrors.wrongStructure
        }
        
        //temporary value for the WeekSchedule initializer
        var dictionary = [String: [Lesson]]()
        //Filling parsedJson dictionary
        for (key, value) in unwrappedData! {
            dictionary[key] = try value.map (readLesson)
        }
        
        //Filling the final value -- WeekSchedule
        try fillWeekContainer(dictionary)
        
    }
    
    private func readLesson (dictionary: [String: AnyObject])throws -> Lesson {
        //reading Lesson parameters
        guard
            let name      = dictionary["name"] as? String,
            let room      = dictionary["room"] as? String,
            let teacherId = dictionary["teacherId"] as? String
            else {
               throw WeekJsonParserErrors.emptyParameter
        }
        //We dont care if there is no hometask
        let hometaskId = dictionary["hometaskId"] as? String ?? "-1"
    
        //final variable initialization
        let lesson = Lesson (name: name, room: room, teacherId: teacherId, hometaskId: hometaskId)
        
        return lesson
    }
    
    private func fillWeekContainer (dictionary: [String: [Lesson]])throws {
        //Getting day contents
        guard
            let mondayLessons    = dictionary["Monday"],
            let tuesdayLessons   = dictionary["Tuesday"],
            let wednesdayLessons = dictionary["Wednesday"],
            let thursdayLessons  = dictionary["Thursday"],
            let fridayLessons    = dictionary["Friday"],
            let saturdayLessons  = dictionary["Saturday"]
            else {
                throw WeekJsonParserErrors.dontHaveDay
        }
        
        //Final value initializer -- looking fancy, innit?
        parsedJson = WeekSchedule (monday:    mondayLessons,
                                   tuesday:   tuesdayLessons,
                                   wednesday: wednesdayLessons,
                                   thursday:  thursdayLessons,
                                   friday:    fridayLessons,
                                   saturday:  saturdayLessons)
    }
    
}
