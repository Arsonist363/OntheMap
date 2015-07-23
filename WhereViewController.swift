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
    
    var appDelegate: AppDelegate!
    var student: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        student = appDelegate.student
        
        
        let firstName = student!.firstName
        let lastName = student!.lastName
        let name = firstName! + " " + lastName!
        nameLabel.text = "Hi" + " " + name
            
        self.locationTextField.delegate = self
        locationTextField.text = "New York, NY"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
                self.showError("text field empty")
        }
            else {
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(locationTextField.text!){textlocation, error in
                    if(error != nil){
                        self.showError("Invalid location")
                    }
                    else{
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
    func showError(error: String){
        let alert = UIAlertView()
        alert.title = "Error"
        alert.message = error
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    func saveUser(udacityStudent: Student){
        appDelegate.student = udacityStudent
        }
}
