//
//  WhereMapViewController.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 7/20/15.
//  Copyright © 2015 Cesar Colorado. All rights reserved.
//

import UIKit
import MapKit

class WhereMapViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var whereMap: MKMapView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityView: UIView!
    
    var appDelegate: AppDelegate!
    var student: Student?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        student = appDelegate.student
        
        let lat = CLLocationDegrees(student!.latitude as Double)
        let long = CLLocationDegrees(student!.longitude as Double)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        
        var annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.75, longitudeDelta: 0.75))
        
        
        self.whereMap.addAnnotation(annotation)
        self.whereMap.setRegion(region, animated: true)
        
        self.urlTextField.delegate = self
        
        activityIndicator.stopAnimating()
        activityView.hidden = true
        
        submitButton.backgroundColor = UIColor.clearColor()
        submitButton.layer.cornerRadius = 5
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.blackColor().CGColor
        
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            
        }
            
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    @IBAction func returnToMain(sender: AnyObject) {
        self.gotomain()
    }

    @IBAction func postStudentinfo(sender: AnyObject) {
        activityView.hidden = false
        self.activityIndicator.startAnimating()
        student?.mediaURL = urlTextField.text!
        self.saveUser(student!)
        if appDelegate.student?.objectId == "" {
            
            ParseClient.sharedInstance().postStudents(){ (success, error) in
                if success {
                    ParseClient.sharedInstance().getStudents(){ (success, error) in
                        if success {
                            self.activityView.hidden = true
                            self.activityIndicator.stopAnimating()
                            self.gotomain()
                        }
                        else {
                            self.activityIndicator.stopAnimating()
                            self.showAlert(error!)
                        }
                    }
                }
                else {
                    self.showAlert(error!)
                }
            }
        
        } else {
            ParseClient.sharedInstance().putStudents(){ (success, error) in
                if success {
                    ParseClient.sharedInstance().getStudents(){ (success, error) in
                        if success {
                            self.activityView.hidden = true
                            self.activityIndicator.stopAnimating()
                            self.gotomain()
                        }
                        else {
                            self.activityIndicator.stopAnimating()
                            self.showAlert(error!)
                        }
                    }
                }
                else {
                    self.showAlert(error!)
                }
            }

        }
        

    }
    
    //dismiss keyboard after return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        urlTextField.resignFirstResponder()
        return true;
    }
    func saveUser(udacityStudent: Student){
        appDelegate.student = udacityStudent
    }
    func gotomain() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Erase default text.
        if urlTextField.text == "Enter a Link to Share Here"{
            textField.text = ""
        }
    }
    
    // ends editing on outside tap
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
