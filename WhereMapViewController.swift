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
        
        println("mkpoint", coordinate.latitude)
        
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.75, longitudeDelta: 0.75))
        
        
        self.whereMap.addAnnotation(annotation)
        self.whereMap.setRegion(region, animated: true)
        
        self.urlTextField.delegate = self
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
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }

    @IBAction func postStudentinfo(sender: AnyObject) {
        student?.mediaURL = urlTextField.text!
        self.saveUser(student!)
        ParseClient.sharedInstance().postStudents()
    }
    
    //dismiss keyboard after return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        urlTextField.resignFirstResponder()
        return true;
    }
    func saveUser(udacityStudent: Student){
        appDelegate.student = udacityStudent
    }
}
