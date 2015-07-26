//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 6/17/15.
//  Copyright (c) 2015 Cesar Colorado. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var uiActivityInd: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // call the delegat to allow to access data
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // make the view controller the delegat to allow info button
        mapView.delegate = self;
        
        let locations = appDelegate.students!
        
        var annotations = [MKPointAnnotation]()
        
        for students in locations {
            
            let lat = CLLocationDegrees(students.latitude as Double)
            let long = CLLocationDegrees(students.longitude as Double)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = students.firstName as String
            let last = students.lastName as String
            let mediaURL = students.mediaURL as String
            
            // create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
            
            
        }
        
        self.mapView.addAnnotations(annotations)

    }
    
    override func viewWillAppear(animated: Bool) {
        activityIndicator.startAnimating()
        activityView.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        activityIndicator.stopAnimating()
        activityView.hidden = true
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
      
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation.subtitle!)!)
        }
    }
    
    
}

