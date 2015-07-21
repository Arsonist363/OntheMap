//
//  ViewController.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 6/17/15.
//  Copyright (c) 2015 Cesar Colorado. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "On The Map"
        let pin = UIBarButtonItem(image:UIImage(named:"pin.png"), style:.Plain, target:self, action:"gotoWhere")
       
        let refresh = UIBarButtonItem(image:UIImage(named:"refresh.png"),style:.Plain, target:self, action:"refresh")
        
        let logOut = UIBarButtonItem(title: "LogOut", style:.Plain, target:self, action:"logOut")
        
        self.navigationItem.rightBarButtonItems = [refresh, pin]
        self.navigationItem.leftBarButtonItems = [logOut]
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func gotoWhere(){
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("WhereViewController") as UIViewController
            self.presentViewController(controller, animated: true, completion: nil)
        })
        }
    @IBAction func refresh(){
        ParseClient.sharedInstance().getStudents()
        print("refresh")
    }
    
    @IBAction func logOut(){
        
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewCotroller") as UIViewController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }

}

