//
//  UdacityStudent.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 7/18/15.
//  Copyright © 2015 Cesar Colorado. All rights reserved.
//

import Foundation

import Foundation

struct Student {
    var id = ""
    var key = ""
    var firstName = ""
    var lastName = ""

    
    /* Construct a Student id from a dictionary */
    init(dictionary: [String: AnyObject]){
        if let session = dictionary["session"] as? [String: AnyObject] {
            if let account = dictionary["account"] as? [String: AnyObject] {
                id = session["id"] as! String
                key = account["key"] as! String
            }
        }
    }
    
}