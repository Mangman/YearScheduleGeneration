//
//  IdTeacherJson.swift
//  YearScheduleGeneration
//
//  Created by admin on 20.05.16.
//  Copyright © 2016 Stepan. All rights reserved.
//

import Foundation

class IdTeacherJson {
    var json : [String: Teacher] = [:]
    
    enum IdTeacherErrors: ErrorType {
        case wrongJsonStructureInParser
        case invalidName
    }
    
    init (dictionary: [String: Teacher]) {
        json = dictionary
    }
    
    init (data: NSData) {
        do {
            try parse(data)
        }
        catch IdTeacherErrors.wrongJsonStructureInParser {
            print ("DateIdJson ERROR: wrong json structure. Make sure it conforms [String: Anyobject] style")
        }
        catch IdTeacherErrors.invalidName {
            print ("DateIdJson ERROR: invalid name. Maybe its empty")
        }
        catch {
            print ("DateIdJson ERROR: unknown error occured")
        }
    }
    
    init () {}
    
    
}

//MARK: Parser
extension IdTeacherJson {
    private func parse (data: NSData)throws {
        
        //make json dictionary from NSData
        //there is double unwrapping here. Ask Mikhail
        guard
        let temp = try? NSJSONSerialization.JSONObjectWithData (data, options: []) as? [String: [String: String]],
            let unwrappedData = temp
            else {
                throw IdTeacherErrors.wrongJsonStructureInParser
        }
        
        for (key, value) in unwrappedData {
                json[key] = try readTeacher(value)
        }
    }
    
    private func readTeacher (data: [String: String])throws -> Teacher {
        guard let name = data["name"]
            else {
                throw IdTeacherErrors.invalidName
        }
        let picReference = data["picReference"] ?? ""
        
        let teacher = Teacher(name: name, picReference: picReference)
        
        return teacher
    }
}


//MARK: Assembler
extension IdTeacherJson {
    func assemble() -> [String: [String: String]] {
        var dictionary = [String: [String: String]]()
              
        for (key, value) in json {
            dictionary[key] = writeTeacher (value)
        }
        
        return dictionary
    }
    
    private func writeTeacher (teacher: Teacher) -> [String: String] {
        var dict = [String: String]()
        
        dict["name"] = teacher.name
        dict["picReference"] = teacher.picReference
        
        return dict
    }
}
    

