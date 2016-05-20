//
//  YearScheduleJsonAssembly.swift
//  YearScheduleGeneration
//
//  Created by admin on 12.05.16.
//  Copyright © 2016 Stepan. All rights reserved.
//

import Foundation

///This class does all the work:
///
///    1. Parses week Json
///    2. Generate year schedule dictionaries
///    3. Generates and reurns NSData files for Jsons
class YearScheduleJsonAssembly {
    
    enum JsonAssemblyError : ErrorType {
        
    }
    /// Core method that should be called to start working
    static func assemble (weekJsonFile: NSData, holidaysJson: NSData) -> (DateId: [String: [String]], IdLesson: [String: [String: String]] ) {
        //Parse week Json
        guard let weekJsonFile = WeekJsonParser(data: weekJsonFile).parsedJson
            else {
                print ("weekScheduleJson unknown error\n")
                exit(0)
        }
        
        let holidays = HolidaysJson(data: holidaysJson).json
        
        //Generate Year Schedule
        let generator = YearScheduleGenerator(beginDate: "01.09.2016", endDate: "15.11.2016", holidays: holidays)
        
        generator.generate(fromweek: weekJsonFile)
        
        let dateId   = generator.dateIdJson
        let idLesson = generator.idLessonJson
        
        let dateIdDict   = dateId.assemble()
        let idLessonDict = idLesson.assemble()
        
        return (dateIdDict, idLessonDict)
}

}