//
//  OntheMapStudents.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 7/20/15.
//  Copyright © 2015 Cesar Colorado. All rights reserved.
//

import Foundation


struct Students {

    var createdAt = ""
    var firstName = ""
    var lastName = ""
    var latitude = 0.0
    var longitude = 0.0
    var mapString = ""
    var mediaURL = "Google.com"
    var objectID = ""
    var uniqueKey = ""
    var updatedAt = ""
    
    /* Construct a Students from a dictionary */
    init(dictionary: [String: AnyObject]){

        if let createdAt = dictionary["createdAt"] as? String {
            firstName = createdAt
        }
        if let first = dictionary["firstName"] as? String {
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
        if let id = dictionary["objectID"] as? String {
            objectID = id
        }
        if let key = dictionary["uniqueKey"] as? String {
            uniqueKey = key
        }
        if let updatedAt = dictionary["updatedAt"] as? String {
            uniqueKey = updatedAt
        }
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of Students objects */
    
    static func studentsFromResults(results: [[String : AnyObject]]) -> [Students] {
        var students = [Students]()
        
        for result in results {
            students.append(Students(dictionary: result))
        }
        
        return students
    }
}
