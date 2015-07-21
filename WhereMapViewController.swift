//
//  WhereMapViewController.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 7/20/15.
//  Copyright © 2015 Cesar Colorado. All rights reserved.
//

import UIKit
import MapKit

class WhereMapViewController: UIViewController {

    @IBOutlet weak var whereMap: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
