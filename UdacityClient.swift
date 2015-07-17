//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 6/30/15.
//  Copyright (c) 2015 Cesar Colorado. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {
    
    /* Shared session */
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    //LOGIN- POST
    func authentication(userName:String,password:String, completionHandler: (success: Bool, error: String?)-> Void){
    
        /* 1. Set the parameters */
         var jsonBody = ["udacity" : ["username" : userName, "password" : password]]
    
        /* 2. Build the URL */
        let url = NSURL(string: "https://www.udacity.com/api/session")!
    
    
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        var jsonifyError: NSError? = nil
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) {data, response, error in
            if error != nil {
                completionHandler(success: false, error: "There was an error contacting the server")
                println("Could not complete the request \(error)")
            } else {
            /* 5/6. Parse the data and use the data (happens in completion handler) */
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                println(NSString(data: newData, encoding: NSUTF8StringEncoding))
            }
            
        }
        
        /* 7. Start the request */
        task.resume()
    }
}