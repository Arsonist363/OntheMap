//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 6/17/15.
//  Copyright (c) 2015 Cesar Colorado. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {
    
    @IBOutlet weak var studentsTableView: UITableView!
    var appDelegate: AppDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (appDelegate.students?.count)!
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentsTableViewCell", forIndexPath: indexPath)
        let student = appDelegate.students![indexPath.row]
        
        // Configure the cell...
        let studentsName = student.firstName + " " + student.lastName
        cell.textLabel!.text = studentsName
        cell.detailTextLabel!.text = student.mapString
        
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentsurl = self.appDelegate.students![indexPath.row].mediaURL
        
        if let url = NSURL(string:studentsurl) {
            UIApplication.sharedApplication().openURL(url)
        }

    }
    
}
