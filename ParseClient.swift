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
    
    //var appDelegate: AppDelegate!
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    //GETting StudentLocations
    
    func getStudents() {
        
        session = NSURLSession.sharedSession()
        
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
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
            }
            else {
                /* 5/6. Parse the data and use the data (happens in completion handler) */
                let response = try! NSJSONSerialization.JSONObjectWithData(studentData!, options: NSJSONReadingOptions.AllowFragments) as? [String : AnyObject]
                
                if let error = response!["error"] as? String {
                    
                    
                } else {
                    let results = response!["results"] as! [[String: AnyObject]]
                    var students = Students.studentsFromResults(results)
                    self.saveUser(students)
                    
                }
            }
            
        }
        
        
        
        /* 7. Start the request */
        task!.resume()
    }
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
    func saveUser(udacityStudent: [Students]){
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            appDelegate.students = udacityStudent

        }
    }

}