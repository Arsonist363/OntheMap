//
//  WhereViewController.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 7/20/15.
//  Copyright © 2015 Cesar Colorado. All rights reserved.
//

import UIKit

class WhereViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate{
            let firstName = appDelegate.student?.firstName
            let lastName = appDelegate.student?.lastName
            let name = firstName! + " " + lastName!
            nameLabel.text = "Hi" + " " + name
            
        }

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

    @IBAction func goToWhereMap(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("WhereMapViewController") as UIViewController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
}
