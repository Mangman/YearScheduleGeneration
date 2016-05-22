//
//  DateFormatter.swift
//  YearScheduleGeneration
//
//  Created by admin on 14.05.16.
//  Copyright © 2016 Stepan. All rights reserved.
//

import Foundation

class DateFormatter {
    let formatter = NSDateFormatter()
    let calendar = NSCalendar (calendarIdentifier: NSCalendarIdentifierGregorian)

    
    enum DateFormatterErrors: ErrorType {
        case WrongFormat
        case AddingDateError
    }
    
    init (dateFormat: String) {
        formatter.dateFormat = dateFormat
    }
    
    func dateFromString (string: String)throws -> NSDate {
        guard let date = formatter.dateFromString(string)
            else {
                throw DateFormatterErrors.WrongFormat
        }
        
        return date
    }
    
    func stringFromDate (date: NSDate) -> String {
        let date = formatter.stringFromDate(date)
        
        return date
    }
    
    func addOneDayTo (date: NSDate)throws -> NSDate {
        let calendar = NSCalendar (calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        guard let day = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: date, options: [])
            else {
             throw DateFormatterErrors.AddingDateError
        }
        
        return day
        }
    
    func prepareDateForLessonId (date: String) -> String{
    //Dele all the dot signs in date string
    let editedDate = date.stringByReplacingOccurrencesOfString(".", withString: "")
    
        return editedDate
    }

}
