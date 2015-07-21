//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 6/17/15.
//  Copyright (c) 2015 Cesar Colorado. All rights reserved.
//

import MapKit
import Foundation
import UIKit


class MapViewController: UIViewController, MKMapViewDelegate {
    
   
    @IBOutlet weak var studentMap: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationView.draggable = true
            pinAnnotationView.canShowCallout = true
            
        
            return pinAnnotationView
        }
        
        return nil

    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
       //
    }
    
    
}

