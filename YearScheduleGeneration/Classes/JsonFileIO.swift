//
//  JsonFileIO.swift
//  YearScheduleGeneration
//
//  Created by admin on 14.05.16.
//  Copyright © 2016 Stepan. All rights reserved.
//

import Foundation

///Loads and Saves Jsons to files
class JsonFileIO {
    
    enum JsonIOErrors: ErrorType {
        case InvalidType
        case FileNotFound
        case InvalidJson
        case CreateFileError
    }
    
    ///Loads Json from file
    static func loadFromPath (path: String)throws -> NSData {
        let fileManager = NSFileManager()
        
        //Checking for type comformation
        guard path.hasSuffix(".json") == true
            else {
                throw JsonIOErrors.InvalidType
        }
        
        //Loading json, cheking for existence
        guard let loadedJson = fileManager.contentsAtPath(path)
            else {
                throw JsonIOErrors.FileNotFound
        }
        
        return loadedJson
    }
    
    ///Saves Json dictionary to file
    static func saveToPath (path: String, data: [String: AnyObject]) {
        do {
            //Make sure, that dictionary conforms to Json format
            guard NSJSONSerialization.isValidJSONObject(data)
                else {
                    throw JsonIOErrors.InvalidJson
            }
            
            //Generate NSData object
            let json = try! NSJSONSerialization.dataWithJSONObject (data, options: [])
            
            //Creating File Manager to save file
            let fileManager = NSFileManager()
            
            guard fileManager.createFileAtPath(path, contents: json, attributes: nil)
                else {
                    throw JsonIOErrors.CreateFileError
            }

        }
        catch JsonIOErrors.InvalidJson {
            print ("JsonToFileSaver ERROR: Json uncomforms saving function")
        }
        catch JsonIOErrors.CreateFileError {
            print ("JsontoFileSaver ERROR: Unable to create file")
        }
        catch {
            print ("JsonToFileSaver ERROR: Unknown error")
        }
        
       

        
    }
}
