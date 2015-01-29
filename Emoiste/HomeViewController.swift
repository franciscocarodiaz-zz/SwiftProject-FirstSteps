//
//  HomeViewController.swift
//  Emoiste
//
//  Created by Juan Manuel Hernandez del Olmo on 19/1/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let fbHelper = FBUserHelper();
    
    @IBOutlet weak var userTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("executeHandleReceiveUserFromServer:"), name: NOTIFICATION_USER_DATA_RECEIVE, object: nil);
        
        var texto = "Nick Name: \(USER_DATA.nickName)\nEmail: \(USER_DATA.email)"
        userTextView.text = texto
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NOTIFICATION_USER_DATA_RECEIVE, object: nil);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if (defaults.objectForKey(kTUTORIAL) as Int == 0) {
            
            defaults.setObject(1, forKey: kTUTORIAL)
            defaults.synchronize()
            
            self.performSegueWithIdentifier(VC_TUTORIAL, sender: self)
        }
        */
        
    }
    
    // MARK: IBAction
    
    @IBAction func logout(sender: AnyObject) {
        
        fbHelper.logout()
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        // Login: 0-no login
        defaults.setObject(0, forKey: kLOGIN)
        defaults.synchronize()
        // Login
        self.performSegueWithIdentifier(VC_LOGIN, sender: self)
    }
    
    func executeHandleReceiveUserFromServer(notification:NSNotification){
        var texto = "Nick Name: \(USER_DATA.nickName)\nEmail: \(USER_DATA.email)"
        userTextView.text = texto
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
