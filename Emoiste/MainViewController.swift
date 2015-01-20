//
//  MainViewController.swift
//  Emoiste
//
//  Created by Juan Manuel Hernandez del Olmo on 19/1/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Valores por defecto
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if (defaults.objectForKey("Login") as Int == 0) {
            // Login
            self.performSegueWithIdentifier("Login", sender: self)
        } else {
            // Home
            self.performSegueWithIdentifier("Home", sender: self)
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }

    
}
