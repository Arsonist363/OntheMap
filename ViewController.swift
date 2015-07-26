//
//  ViewController.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 6/17/15.
//  Copyright (c) 2015 Cesar Colorado. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UITabBarController{
    
    var appDelegate: AppDelegate!
    
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add delegate to access data
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // add buttons on the navigation bar
        self.title = "On The Map"
        let pin = UIBarButtonItem(image:UIImage(named:"pin.png"), style:.Plain, target:self, action:"checkStudent")
       
        let refresh = UIBarButtonItem(image:UIImage(named:"refresh.png"),style:.Plain, target:self, action:"refresh")
        
        let logOut = UIBarButtonItem(title: "LogOut", style:.Plain, target:self, action:"logOut")
        
        self.navigationItem.rightBarButtonItems = [refresh, pin]
        self.navigationItem.leftBarButtonItems = [logOut]
        
        // add the activityindicator to the view
        activityView.center = self.view.center
        activityView.color = UIColor.blueColor()
        activityView.stopAnimating()
        self.view.addSubview(activityView)

        ParseClient.sharedInstance().queryStudents { (success, error) -> Void in
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func checkStudent(){
        if appDelegate.student?.objectId != ""{
            dispatch_async(dispatch_get_main_queue(), {
                let alertController = UIAlertController(title: "On the map", message: "You already made a post. Would you like to Overite the location.", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
                })
                let cancel = UIAlertAction(title: "Overite", style: .Cancel) { (action) -> Void in
                    self.gotoWhere()
                }
                alertController.addAction(ok)
                alertController.addAction(cancel)
                self.presentViewController(alertController,animated:true, completion:nil)
            })
        }else{
            gotoWhere()
        }
    
    }
    
    @IBAction func gotoWhere(){
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("WhereViewController") as! UIViewController
            self.presentViewController(controller, animated: true, completion: nil)
        })
        }
    
    @IBAction func refresh(){
        self.activityView.startAnimating()
        ParseClient.sharedInstance().getStudents(){ (success, error) in
            if success {
                self.activityView.stopAnimating()
            }
            else {
                self.activityView.stopAnimating()
                self.showAlert(error!)
            }
        }

    }
    

    @IBAction func logOut(){
        // logg of the session
        UdacityClient.sharedInstance().logginOut(){ (success, error) in
            if success {
                FBSDKLoginManager().logOut()
                dispatch_async(dispatch_get_main_queue(), {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewCotroller") as! UIViewController
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            }
            else {
                self.showAlert(error!)
            }
        }

        
    }
    // Alert message
    private func showAlert(alert:String){
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: "On the map", message: alert, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            self.presentViewController(alertController,animated:true, completion:nil)
        })
    }
    
    
}

