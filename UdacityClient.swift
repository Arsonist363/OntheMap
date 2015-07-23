//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 6/30/15.
//  Copyright (c) 2015 Cesar Colorado. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient : NSObject {
    
    /* Shared session */
    var session: NSURLSession
    var err: NSError? = nil

    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    //LOGIN- POST
    func authentication(userName: String, password:String , completionHandler: (success: Bool, error: String?) -> Void){
    
        /* 1. Set the parameters */
        let jsonBody = ["udacity" : ["username" : userName, "password" : password]]
       
        /* 2. Build the URL */
        let url = NSURL(string: "https://www.udacity.com/api/session")!
    
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        // Headers
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: NSJSONWritingOptions.PrettyPrinted, error:nil)
            
        
        /* 4. Make the request */
    
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                //completionHandler(success: false, error: "There was an error contacting the server")
                print("Could not complete the request \(error)")
            } else {
            /* 5/6. Parse the data and use the data (happens in completion handler) */
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                let response = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject]
                
                if let error = response!["error"] as? String {
                    completionHandler(success: false, error: error)
                    
                } else {
                    let newstudent: Student = Student(dictionary: response!)
                    let key = newstudent.uniqueKey
                    self.saveUser(newstudent)
                    
                    self.studentInfo(key!){ (success, error) in
                        if success{
                            completionHandler(success: true, error: nil)
                        }
                        else {
                            completionHandler(success: false, error: error)
                        }
                    }

                    
                }
            }
            
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    func studentInfo(key: String, completionHandler: (success: Bool, error: String?) -> Void){
        /* 1. Set the parameters */
            // None
        
        /* 2. Build the URL */
        
        let url = NSURL(string: "https://www.udacity.com/api/users/" + key)!
        
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                //completionHandler(success: false, error: "There was an error contacting the server")
                print("Could not complete the request \(error)")
            } else {
                /* 5/6. Parse the data and use the data (happens in completion handler) */
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                let response = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject]
            
                if let error = response!["error"] as? String {
                    completionHandler(success: false, error: error)
                   
                } else {
                    // add the student first and last name to dataset
                    if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
                        var student = appDelegate.student
                        
                        let userResponse = response!["user"] as! [String: AnyObject]

                        student?.firstName = userResponse["first_name"] as! String
                        student?.lastName = userResponse["last_name"] as! String
                        
                        self.saveUser(student!)
                        
                    }
                    completionHandler(success: true, error: nil)
                }
            }
            
        }
        
        /* 7. Start the request */
        task.resume()

    }
    
    func saveUser(udacityStudent: Student){
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            appDelegate.student = udacityStudent
            
        }
    }
    
}