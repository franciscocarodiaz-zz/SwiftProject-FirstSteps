//
//  MainViewController.swift
//  Emoiste
//
//  Created by Juan Manuel Hernandez del Olmo on 19/1/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import UIKit
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion

class MainViewController: UIViewController, FBLoginViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Valores por defecto
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if (defaults.objectForKey(kLOGIN) as Int == 0) {
            // Login
            self.performSegueWithIdentifier(VC_LOGIN, sender: self)
        } else {
            let userDat  = Util.userFromDefault() as User
            USER_DATA = userDat
            // Home
            self.performSegueWithIdentifier(VC_HOME, sender: self)
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }

    
}
