//
//  ViewController.swift
//  OnTheMap
//
//  Created by Cesar Colorado on 6/17/15.
//  Copyright (c) 2015 Cesar Colorado. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "On The Map"
        let pin = UIBarButtonItem(image:UIImage(named:"pin.png"), style:.Plain, target:nil, action:nil)
        let refresh = UIBarButtonItem(image:UIImage(named:"refresh.png"),
            style:.Plain, target:nil, action:nil)
        
        self.navigationItem.rightBarButtonItems = [refresh, pin]
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

