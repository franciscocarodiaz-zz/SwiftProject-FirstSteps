//
//  HomeViewController.swift
//  Emoiste
//
//  Created by Juan Manuel Hernandez del Olmo on 19/1/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var userTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var texto = "Nick Name: \(USER_DATA.nickName!)\nEmail: \(USER_DATA.email!)"
        userTextView.text = texto
        
    }
    
    // MARK: IBAction
    
    @IBAction func logout(sender: AnyObject) {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        // Login: 0-no login
        defaults.setObject(0, forKey: kLOGIN)
        defaults.synchronize()
        // Login
        self.performSegueWithIdentifier(VC_LOGIN, sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
