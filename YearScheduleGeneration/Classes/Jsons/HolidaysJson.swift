//
//  HolidaysJson.swift
//  YearScheduleGeneration
//
//  Created by admin on 20.05.16.
//  Copyright © 2016 Stepan. All rights reserved.
//

import Foundation

class HolidaysJson {
    private (set) var json: [String] = []
    
    enum HolidaysError: ErrorType {
        case wrongJsonStructureInParser
    }
    
    init (data: NSData) {
        do {
            try parse (data)
        }
        catch HolidaysError.wrongJsonStructureInParser {
            print ("HolidaysJson ERROR: wrong json structure. Make sure it conforms [String] style")
        }
        catch {
            print ("HolidaysJson ERROR: unknown error in NSJSONSerialization. my bad")
        }
    }
    
    private func parse (data: NSData)throws {
        //make json dictionary from NSData
        //there is double unwrapping here. Ask Mikhail
        guard
            let temp = try? NSJSONSerialization.JSONObjectWithData (data, options: []) as? [String],
            let unwrappedData = temp
            else {
                throw HolidaysError.wrongJsonStructureInParser
        }
        
        json = unwrappedData
    }
}
