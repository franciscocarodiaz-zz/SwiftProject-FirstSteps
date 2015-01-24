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
        let typeLogin = defaults.objectForKey("Login") as Int
        let nickName = defaults.objectForKey(kUSER_NICKNAME) as String
        let email = defaults.objectForKey(kUSER_EMAIL) as String
        var texto = "Nick Name: \(USER_DATA.nickName!)\nEmail: \(USER_DATA.email!)"
        //var texto = "Nick Name: \(nickName)\nEmail: \(email)"
        userTextView.text = texto
        
    }
    
    // MARK: IBAction
    
    @IBAction func logout(sender: AnyObject) {
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        // Login: 0-no login
        defaults.setObject(0, forKey: "Login")
        defaults.synchronize()
        // Login
        self.performSegueWithIdentifier("Login", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
