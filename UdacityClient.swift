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
    
    var appDelegate: AppDelegate!
    

    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
        
        
    }
    func userLogin(userName: String, password:String , completionHandler: (success: Bool, error: String?) -> Void){
        let parameters = ["udacity" : ["username" : userName, "password" : password]]
        
        self.authentication(parameters){ (success, error) in
            if success{
                completionHandler(success: true, error: nil)
                
            }
            else {
                completionHandler(success: false, error: error)
            }
        }

        
        
    }
    
    func facebookLogin(access_token: String, completionHandler: (success: Bool, error: String?) -> Void){
        let parameters = ["facebook_mobile" : ["access_token" : access_token]]
        
        self.authentication(parameters){ (success, error) in
            if success{
                completionHandler(success: true, error: nil)
                
            }
            else {
                completionHandler(success: false, error: error)
            }
        }

    }
    
    //LOGIN- authentication
    func authentication(parameters: AnyObject, completionHandler: (success: Bool, error: String?) -> Void){
        
        /* 1. Set the parameters */
        // parameters
        
        
        /* 2. Build the URL */
        let url = NSURL(string: "https://www.udacity.com/api/session")!
    
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        // Headers
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted, error:nil)
            
        
        /* 4. Make the request */
    
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                completionHandler(success: false, error: "There was an error contacting the Udacity server")
                
            } else {
            /* 5/6. Parse the data and use the data (happens in completion handler) */
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                let response = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject]
                
                
                if let error = response!["error"] as? String {
                    completionHandler(success: false, error: error)
                    
                } else {
                    let account = response!["account"] as! [String: AnyObject]
                    let session = response!["session"] as! [String: AnyObject]
                    
                    if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                        var student = appDelegate.student
                        
                        student?.uniqueKey = (account["key"] as! String)
                        student?.id = (session["id"] as! String)
                        
                        self.saveUser(student!)
                    }
                    
                    
                    let key = account["key"] as! String
                    
                    
                    self.studentInfo(key){ (success, error) in
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
    
    // GETting Public User Data
    
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
                completionHandler(success: false, error: "There was an error contacting the Udacity server")
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

                        student?.firstName = (userResponse["first_name"] as! String)
                        student?.lastName = (userResponse["last_name"] as! String)
                        
                        self.saveUser(student!)
                        
                    }
    
                    
                    ParseClient.sharedInstance().getStudents({ (success, error) in
                        if success{
                            completionHandler(success: true, error: nil)
                            
                        }
                        else {
                            completionHandler(success: false, error: error)
                        }
                        }
)
                }
            }
            
        }
        
        /* 7. Start the request */
        task.resume()

    }
    func logginOut(completionHandler: (success: Bool, error: String?) -> Void){
        /* 1. Set the parameters */
        
        /* 2. Build the URL */
        let url = NSURL(string: "https://www.udacity.com/api/session")!
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
        }
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                // Handle error...
                completionHandler(success: false, error: "There was an error contacting the Udacity server")
            }
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            completionHandler(success: true, error: nil)
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    func saveUser(udacityStudent: Student){
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            appDelegate.student = udacityStudent
            
        }
    }
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
    
}