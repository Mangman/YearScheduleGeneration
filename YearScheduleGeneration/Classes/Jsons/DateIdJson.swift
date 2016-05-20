//
//  DateIdJson.swift
//  YearScheduleGeneration
//
//  Created by admin on 14.05.16.
//  Copyright © 2016 Stepan. All rights reserved.
//

import Foundation

class DateIdJson {
    var json : [NSDate: Day] = [:]
    
    enum DateIdJsonErrors: ErrorType {
        case wrongJsonStructureInParser
        case invalidDateInParser
    }
    
    init (dictionary: [NSDate: Day]) {
        json = dictionary
    }
    
    init (data: NSData) {
        do {
            try parse(data)
        }
        catch DateIdJsonErrors.wrongJsonStructureInParser {
            print ("DateIdJson ERROR: wrong json structure. Make sure it conforms [String: Anyobject] style")
        }
        catch DateIdJsonErrors.invalidDateInParser {
            print ("DateIdJson ERROR: invalid date was found in source json. Make sure it conforms <dd.MM.yy> style")
        }
        catch {
            print ("DateIdJson ERROR: unknown error occured")
        }
    }
    
    init () {}
    
    
}

//MARK: Parser
extension DateIdJson {
    private func parse (data: NSData)throws {
        let dateFormatter = NSDateFormatter()
        
        //make json dictionary from NSData
        //there is double unwrapping here. Ask Mikhail
        guard
            let temp = try? NSJSONSerialization.JSONObjectWithData (data, options: []) as? [String: [String]],
            let unwrappedData = temp
            else {
                throw DateIdJsonErrors.wrongJsonStructureInParser
        }
        
        for (key, value) in unwrappedData {
            guard let dateKey = dateFormatter.dateFromString(key)
                else {
                    throw DateIdJsonErrors.invalidDateInParser
            }
            
            json[dateKey] = Day(lessons: value)
        }
    }
}

//MARK: Assembler
extension DateIdJson {
   func assemble() -> [String: [String]] {
        var dictionary = [String: [String]]()
        
        let dateFormatter = DateFormatter(dateFormat: "dd.MM.yyyy")
        
        for (key, value) in json {
            dictionary[dateFormatter.stringFromDate(key)] = value.lessons
        }
        
        return dictionary
    }
}
