//
//  UdacityStudent.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 7/18/15.
//  Copyright © 2015 Cesar Colorado. All rights reserved.
//

import Foundation



struct Student {
    var id = ""
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    var latitude = 40.7127827
    var longitude = -74.0059413
    var mediaURL = ""
    var mapString = ""

    
    init(dictionary: [String: AnyObject]){
        if let first = dictionary["firstName"] as? String{
            firstName = first
        }
        
        if let last = dictionary["lastName"] as? String {
            lastName = last
        }
        if let lat = dictionary["latitude"] as? Double {
            latitude = lat
        }
        if let long = dictionary["longitude"] as? Double {
            longitude = long
        }
        if let location = dictionary["mapString"] as? String {
            mapString = location
        }
        if let url = dictionary["mediaURL"] as? String {
            mediaURL = url
        }
        if let objectid = dictionary["id"] as? String {
            id = objectid
        }
        if let key = dictionary["uniqueKey"] as? String {
            uniqueKey = key
        }
    }
    
}