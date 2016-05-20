//
//  YearScheduleGenerator.swift
//  YearScheduleGeneration
//
//  Created by admin on 13.05.16.
//  Copyright © 2016 Stepan. All rights reserved.
//

import Foundation


///Generates two Json dictionaries that contain Year schedule parts (date-id and id-lesson)
class YearScheduleGenerator {
    //Get access to all lessons in a particular day
    private (set) var dateIdJson  = DateIdJson()
    //Get access to lesson by its id
    private (set) var idLessonJson = IdLessonJson()
    
    private var beginDate: NSDate
    private var endDate:   NSDate
    private var holidays: [String]
    
    let dateFormatter = DateFormatter(dateFormat: "dd.MM.yyyy")

    enum YearGeneratorErrors: ErrorType {
        case invalidDate
        case dayInWeekScheduleNotFound
        case calendarInitializationError
    }
    
    init (beginDate: String, endDate: String, holidays: [String]) {
        guard let begin = try? dateFormatter.dateFromString(beginDate)
            else {
                print ("DateFormatter ERROR: wrong input string format. Use dd.MM.yyyy")
                exit(0)
        }
        guard let end = try? dateFormatter.dateFromString(endDate)
            else {
                print("DateFormatter ERROR: unknown error")
                exit(0)
        }
        
        self.beginDate = begin
        self.endDate   = end
        self.holidays  = holidays
    }
    
    func generate (fromweek week: WeekSchedule){
        do {
            print ("Filling year from-")
            print (dateFormatter.stringFromDate(beginDate))
            print ("to-")
            print (dateFormatter.stringFromDate(endDate))
            
            var day = beginDate
            while day.compare(endDate) != NSComparisonResult.OrderedDescending{
                //print ("\nKEK\n")
                //Fill all the information about lessons on the current day
                try fillOneDate(day, weekSchedule: week)
                
                //add 24 hours to the current date
                day = try dateFormatter.addOneDayTo(day)
        
            }
        }
        catch YearGeneratorErrors.invalidDate {
            print("YearScheduleGenerator ERROR: Invalid date was given. Mind that format is dd.MM.yyyy\n")
        }
        catch YearGeneratorErrors.dayInWeekScheduleNotFound {
            print ("YearScheduleGenerator ERROR: day of the week or n/a day info\n")
        }
        catch DateFormatter.DateFormatterErrors.AddingDateError {
            print ("DateFormatter ERROR: NSCalendar error in adding. maybe wrong date format\n")
        }
        catch WeekSchedule.weekScheduleErrors.invalidDayName {
            print ("WeekSchedule ERROR: your day name is invalid\n")
        }
        catch {
            print ("YearScheduleGenerator ERROR: unknown eror\n")
        }
    
    }

    private func fillOneDate (date: NSDate, weekSchedule: WeekSchedule)throws {
        //Retrieve weekday name for the date
        let weekDay = date.dayOfTheWeek
        
        //Its easier to work with string representation of NSDate
        let stringFromDate = dateFormatter.stringFromDate(date)
        
        //dont assign schedule to holiday
        if weekDay == "Sunday" || holidays.contains(stringFromDate) {
            return
        }

        //Counting number of lessons for that day
        let numberOfLessons = try weekSchedule.lessonsAtDay(weekDay).count
        
        //Starting to go through lessons on a day and filling dictionaries
        for lessonPlace in 0..<numberOfLessons
        {
            
            //Generating Id by applying lesson place to the date digits
            let Id = idGeneration(stringFromDate, lessonNumber: lessonPlace)
            
            try writeLessonToId (Id, weekSchedule: weekSchedule, weekDay: weekDay, lessonPlace: lessonPlace)
            
            writeToDate(date, Id: Id)
            
        }
    }
    
    private func idGeneration (date: String, lessonNumber: Int) -> String {
        let editedDateForId = dateFormatter.prepareDateForLessonId(date)
        
        //Put two of strings together to acquire Id
        let Id = editedDateForId + "\(lessonNumber)"
        
        return Id
    }
    
    private func writeLessonToId ( Id: String, weekSchedule: WeekSchedule, weekDay: String, lessonPlace: Int)throws {
        
        //Peek one lesson from day array
        let peekedLesson = try weekSchedule.lessonsAtDay(weekDay)[lessonPlace]

        //Insert lesson description to IdLesson dictionary
        idLessonJson.json[Id] = peekedLesson
    }
    
    private func writeToDate (date: NSDate, Id: String) {
        //create cell of a certain date if doesnt exist
        if let _ = dateIdJson.json[date] {
        }
        else {
        dateIdJson.json[date] = Day()
        }
        
        //Insert lesson Id on it date's cell
        dateIdJson.json[date]!.lessons.append(Id)
    }
}
