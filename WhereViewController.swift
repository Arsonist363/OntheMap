//
//  WhereViewController.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 7/20/15.
//  Copyright © 2015 Cesar Colorado. All rights reserved.
//

import UIKit
import MapKit

class WhereViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var activityView: UIView!
    
    var appDelegate: AppDelegate!
    var student: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        student = appDelegate.student
        
        
        let firstName = student!.firstName
        let lastName = student!.lastName
        let name = firstName + " " + lastName
        nameLabel.text = "Hi" + " " + name
            
        self.locationTextField.delegate = self
        

        activityIndicator.stopAnimating()
        activityView.hidden = true
        
        findButton.backgroundColor = UIColor.clearColor()
        findButton.layer.cornerRadius = 5
        findButton.layer.borderWidth = 1
        findButton.layer.borderColor = UIColor.blackColor().CGColor
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func returnToMain(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    //dismiss keyboard after return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        locationTextField.resignFirstResponder()
        return true;
    }


    @IBAction func goToWhereMap(sender: AnyObject) {
            if locationTextField.text == ""{
                self.showAlert("You must enter a valid address")
        }
            else {
                self.activityView.hidden = true
                self.activityIndicator.startAnimating()
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(locationTextField.text!){textlocation, error in
                    if(error != nil){
                        self.activityIndicator.stopAnimating()
                        self.showAlert("Invalid location")
                    }
                    else{
                        self.activityView.hidden = true
                        self.activityIndicator.stopAnimating()
                        
                        var location:CLPlacemark = textlocation[0] as! CLPlacemark
                
                        var coordinates:CLLocationCoordinate2D = location.location.coordinate
                
                        var lat = coordinates.latitude
                        var long = coordinates.longitude
                
                        self.student?.latitude = lat
                        self.student?.longitude = long
                
                        self.saveUser(self.student!)
                
                        dispatch_async(dispatch_get_main_queue(), {
                            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("WhereMapViewController") as! UIViewController
                            self.presentViewController(controller, animated: true, completion: nil)
                        })
                
                    }
                }
            }
            student?.mapString = locationTextField.text!
            self.saveUser(student!)
    }
    
    func saveUser(udacityStudent: Student){
        appDelegate.student = udacityStudent
        }
    
  
    @IBAction func cancelRetun(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    // Displays any errrors
    private func showAlert(alert:String){
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: "On the map", message: alert, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            self.presentViewController(alertController,animated:true, completion:nil)
            self.activityView.hidden = true
        })
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Erase default text.
        if locationTextField.text == "Enter Your Location Here"{
            textField.text = ""
        }
    }
    
    // ends editing on outside tap
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}
