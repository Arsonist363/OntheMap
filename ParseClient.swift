//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 7/17/15.
//  Copyright © 2015 Cesar Colorado. All rights reserved.
//

import Foundation
import UIKit


class ParseClient : NSObject{
    
    /* Shared session */
    var session: NSURLSession
    var err: NSError? = nil
    
    var appDelegate: AppDelegate!
    
    
    override init() {
        session = NSURLSession.sharedSession()
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        super.init()
    }
    
    
    //GETting StudentLocations
    
    func getStudents(completionHandler: (success: Bool, error: String?) -> Void) {
        /* 1. Set the parameters */
        //optional not used
        
        /* 2. Build the URL */
        var URL = NSURL(string: "https://api.parse.com/1/classes/StudentLocation")
        
        /* 3. Configure the request */
        
        let request = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = "GET"
        
        // Headers
        
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {studentData, response, error in
            if error != nil {
                //let statusCode = (response as! NSHTTPURLResponse).statusCode
                completionHandler(success: false, error: "There was an error contacting the Parse server")
                //print("URL Session Task Succeeded: HTTP \(statusCode)")
            }
            else {
                /* 5/6. Parse the data and use the data (happens in completion handler) */
                let response = NSJSONSerialization.JSONObjectWithData(studentData!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject]
                
                if let error = response!["error"] as? String {
                    completionHandler(success: false, error: error)
                    
                } else {
                    let results = response!["results"] as! [[String: AnyObject]]
                    var students = Students.studentsFromResults(results)
                    self.saveUsers(students)
                    completionHandler(success: true, error: nil)
                }
            }
            
        }
        
        
        
        /* 7. Start the request */
        task.resume()
    }
     // Querying for a StudentLocation
    func queryStudents(completionHandler: (success: Bool, error: String?) -> Void) {
        /* 1. Set the parameters */
        let uniqueKey = appDelegate.student?.uniqueKey
        
        /* 2. Build the URL */
        let urlString = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22" + uniqueKey! + "%22%7D"
        println(urlString)
        
        var URL = NSURL(string: urlString)!
        
        /* 3. Configure the request */
        
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        
        // Headers
        
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {studentData, response, error in
            if error != nil {
                //let statusCode = (response as! NSHTTPURLResponse).statusCode
                completionHandler(success: false, error: "There was an error contacting the Parse server")
                //print("URL Session Task Succeeded: HTTP \(statusCode)")
            }
            else {
                /* 5/6. Parse the data and use the data (happens in completion handler) */
                let response = NSJSONSerialization.JSONObjectWithData(studentData!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject]
                
                println(response)
                
                if let error = response!["error"] as? String {
                    completionHandler(success: false, error: error)
                    
                } else {
                    let results = response!["results"] as! [[String: AnyObject]]
                    
                    if results != []{
                        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
                            var student = appDelegate.student
                            
                            let firstresult = results[0]
                            
                            student?.objectId = (firstresult["objectId"] as! String)
                            self.saveUser(student!)
                        }
                        
                    }
                    completionHandler(success: true, error: nil)
                }
            }
            
        }
        
        
        
        /* 7. Start the request */
        task.resume()
    }

    //POSTing a StudentLocation
    func postStudents(completionHandler: (success: Bool, error: String?) -> Void){
        
        /* 1. Set the parameters */
        let firstName = appDelegate.student?.firstName
        let lastName = appDelegate.student?.lastName
        let latitude = appDelegate.student?.latitude
        let longitude = appDelegate.student?.longitude
        let mapString = appDelegate.student?.mapString
        let mediaURL = appDelegate.student?.mediaURL
        let uniqueKey = appDelegate.student?.uniqueKey
        let objectId = appDelegate.student?.objectId
    
        
        var parameters : [String:AnyObject] = ["firstName" : firstName!, "lastName" : objectId!,
            "latitude" : latitude!,
            "longitude" : longitude!,
            "mapString" : mapString!,
            "mediaURL" : mediaURL!,
            "uniqueKey" : uniqueKey!]
        
        
        /* 2. Build the URL */
        let urlString = "https://api.parse.com/1/classes/StudentLocation/" + uniqueKey!
        var URL = NSURL(string: "https://api.parse.com/1/classes/StudentLocation")
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = "PUT"
        
        // Headers
        
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted, error:nil)
        
        
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                completionHandler(success: false, error: "There was an error contacting the Parse server")
            } else {
                /* 5/6. Parse the data and use the data (happens in completion handler) */
    
                let response = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject]
                
                if let error = response!["error"] as? String {
                    completionHandler(success: false, error: error)
                }else{
                    completionHandler(success: true, error: nil)
                }
                
            }
        }
     task.resume()
    }
    
    //PUTing (Updating) a StudentLocation
    func putStudents(completionHandler: (success: Bool, error: String?) -> Void){
        
        /* 1. Set the parameters */
        let firstName = appDelegate.student?.firstName
        let lastName = appDelegate.student?.lastName
        let latitude = appDelegate.student?.latitude
        let longitude = appDelegate.student?.longitude
        let mapString = appDelegate.student?.mapString
        let mediaURL = appDelegate.student?.mediaURL
        let uniqueKey = appDelegate.student?.uniqueKey
        
        
        var parameters : [String:AnyObject] = ["firstName" : firstName!, "lastName" : lastName!,
            "latitude" : latitude!,
            "longitude" : longitude!,
            "mapString" : mapString!,
            "mediaURL" : mediaURL!,
            "uniqueKey" : uniqueKey!]
        
        
        /* 2. Build the URL */
        
        var URL = NSURL(string: "https://api.parse.com/1/classes/StudentLocation")
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = "POST"
        
        // Headers
        
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted, error:nil)
        
        
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                completionHandler(success: false, error: "There was an error contacting the Parse server")
            } else {
                /* 5/6. Parse the data and use the data (happens in completion handler) */
                
                let response = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject]
                
                if let error = response!["error"] as? String {
                    completionHandler(success: false, error: error)
                }else{
                    completionHandler(success: true, error: nil)
                }
                
            }
        }
        task.resume()
    }

    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
    func saveUsers(udacityStudent: [Students]){
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            appDelegate.students = udacityStudent
        }
    }
    
    func saveUser(udacityStudent: Student){
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            appDelegate.student = udacityStudent
        }
    }
    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }


}