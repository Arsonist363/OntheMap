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
    var id : String?
    var uniqueKey : String?
    var firstName : String?
    var lastName: String?
    var latitude = 40.7127827
    var longitude = -74.0059413
    var mediaURL : String?
    var mapString : String?

    /* Construct a Student id from a dictionary */
    init(dictionary: [String: AnyObject]){
        if let session = dictionary["session"] as? [String: AnyObject] {
            if let account = dictionary["account"] as? [String: AnyObject] {
                id = session["id"] as? String
                uniqueKey = account["key"] as? String
            }
        }
    }
    
}