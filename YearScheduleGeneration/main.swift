//
//  main.swift
//  YearScheduleGeneration
//
//  Created by admin on 10.05.16.
//  Copyright © 2016 Stepan. All rights reserved.
//

import Foundation

let arguments = Process.arguments

//Make sure that json's path was given
guard arguments.count == 3
    else {
        print ("Arguments error\n")
        exit(0)
}

do {
    //load week json
    let weekJson     = try JsonFileIO.loadFromPath (arguments[1])
    let holidaysJson = try JsonFileIO.loadFromPath (arguments[2])
    
    //Assemble year schedule
    let assembly = YearScheduleJsonAssembly.assemble(weekJson, holidaysJson: holidaysJson)
    
    //Save two jsons to files
    JsonFileIO.saveToPath ("/Users/admin/SwiftProjects/YearScheduleGeneration/Results/DateId.json",   data: assembly.DateId)
    JsonFileIO.saveToPath ("/Users/admin/SwiftProjects/YearScheduleGeneration/Results/Idlesson.json", data: assembly.IdLesson)
    
    print ("\nJsons saved successfully")
}
catch JsonFileIO.JsonIOErrors.InvalidType {
    print("JsonFileIO ERROR: file has wrong type. Use .json")
}
catch JsonFileIO.JsonIOErrors.FileNotFound {
    print("JsonFileIO ERROR: file with such name does not exist")
}
catch {
    print("JsonFileIO ERROR: unknown error")
}