//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 6/17/15.
//  Copyright (c) 2015 Cesar Colorado. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate{
    
    // UI connecttions
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLogin: FBSDKLoginButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        appDelegate.student = Student(dictionary: [:])
        
        activityIndicator.stopAnimating()
        activityView.hidden = true
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            FBSDKLoginManager().logOut()
        }
        
        self.facebookLogin.delegate = self
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    // regular loggin with error handler
    @IBAction func loginButtonTouch(sender: AnyObject) {
        if usernameTextField.text!.isEmpty {
            showAlert("Missing user name")
        } else if passwordTextField.text!.isEmpty {
            showAlert("Missing user password")
        } else {
            activityView.hidden = false
            activityIndicator.startAnimating()
            UdacityClient().userLogin( usernameTextField.text!, password: passwordTextField.text!){ (success, error) in
                if success {
                    self.completeLogin()
                    self.activityView.hidden = true
                    self.activityIndicator.stopAnimating()
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.showAlert(error!)
                }
            }
        }
    }
    
    // open udacity sign up page in safari
    @IBAction func signUp(sender: AnyObject) {
       UIApplication.sharedApplication().openURL(NSURL(string:"https://www.udacity.com/account/auth#!/signup")!)
    }
   
    // Alert message
    private func showAlert(alert:String){
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: "On the map", message: alert, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            self.presentViewController(alertController,animated:true, completion:nil)
            self.activityView.hidden = true
        })
    }
    // function to call next view
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    // MARK: Facebook Login Button Facebook Delegate Methods
    func loginButton(loginButton: FBSDKLoginButton!,
        didCompleteWithResult result: FBSDKLoginManagerLoginResult!,
        error: NSError!) {
            activityView.hidden = false
            activityIndicator.startAnimating()
            if ((error) != nil)
            {
                let message = error.userInfo?[FBSDKErrorDeveloperMessageKey] as? String
                self.showAlert(message!)
                
            } else if result.isCancelled {
                // Handle cancellations
                self.showAlert("Facebook Lognin has been Cancelled")
                self.activityIndicator.stopAnimating()
            } else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if result.grantedPermissions.contains("email")
                {
                    let access_token = result.token.tokenString
                    
                    UdacityClient().facebookLogin(access_token){ (success, error) in
                        if success {
                            self.completeLogin()
                            self.activityView.hidden = true
                            self.activityIndicator.stopAnimating()
                            }
                        else {
                            self.activityIndicator.stopAnimating()
                            self.showAlert(error!)
                            }
                        }
                }
            }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    // ends editing on outside tap
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}