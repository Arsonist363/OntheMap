//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 6/17/15.
//  Copyright (c) 2015 Cesar Colorado. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // UI connecttions
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        

    }
    
    
    @IBAction func loginButtonTouch(sender: AnyObject) {
        if usernameTextField.text!.isEmpty {
            showAlert("Missing user name")
        } else if passwordTextField.text!.isEmpty {
            showAlert("Missing user password")
        } else {
            
            UdacityClient().authentication( usernameTextField.text!, password: passwordTextField.text!){ (success, error) in
                if success{
                    self.completeLogin()
                    ParseClient.sharedInstance().getStudents()
                    }
                else {
                    self.showAlert(error!)
                    }
                }

        }
    }
    
    
    private func showAlert(alert:String){
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: "On the map", message: alert, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            self.presentViewController(alertController,animated:true, completion:nil)
        })
    }
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }

}