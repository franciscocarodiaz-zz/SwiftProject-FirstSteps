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

class MainViewController: UIViewController,GPPSignInDelegate {
    
    let fbHelper = FBUserHelper();
    var signIn:GPPSignIn?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("executeHandleFBUser:"), name: NOTIFICATION_FACEBOOK_LOGIN, object: nil);
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NOTIFICATION_FACEBOOK_LOGIN, object: nil);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Valores por defecto
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if (defaults.objectForKey(kLOGIN) as Int == 0) {
            // Login
            self.performSegueWithIdentifier(VC_LOGIN, sender: self)
        } else if(defaults.objectForKey(kLOGIN) as Int == USER_FACEBOOK){
            // Facebook Login
            fbHelper.login();
        } else if(defaults.objectForKey(kLOGIN) as Int == USER_GOOGLE){
            // Google+ Login
            signIn = GPPSignIn.sharedInstance()
            signIn?.shouldFetchGooglePlusUser = true
            signIn?.shouldFetchGoogleUserID = true
            signIn?.shouldFetchGoogleUserEmail = true
            signIn?.clientID = GOOGLE_CLIENT_ID
            signIn?.scopes = [kGTLAuthScopePlusLogin]
            signIn?.delegate = self
            signIn?.authenticate()
        }
    }
    
    func executeHandleFBUser(notification:NSNotification){
        let userData = notification.object as User;
        USER_DATA = userData
        self.performSegueWithIdentifier(VC_HOME, sender: self)
    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        
        if let gotError = error {
            
            let _title = "Atención"
            var _message = "No se ha podido iniciar sesion con Google"
            let alertController = Util.showMessage(_title,message: _message)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            
            // 1. Save user data
            let cliendId = auth.clientID
            let parameters = auth.parameters
            let id_token = parameters.objectForKey("id_token") as? String
            let access_token = parameters.objectForKey("access_token") as? String
            let properties = auth.properties as NSDictionary
            let user_id = properties.objectForKey("user_id") as String!
            let name = signIn?.googlePlusUser.displayName as String!
            let nickName = name.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let email : NSString = auth.userEmail
            let gender = signIn?.googlePlusUser.gender as String!
            let userImageURL = signIn?.googlePlusUser.image.url as String!
            
            var userData = User(userID: user_id, nickName: nickName, email: email, gender:gender,picture:userImageURL);
            
            // 2. Save type of user
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(TYPE_REGISTER_RRSS, forKey: kLOGIN)
            defaults.synchronize()
            
            USER_DATA = userData
            USER_DATA.loginGPlus = true
            self.performSegueWithIdentifier(VC_HOME, sender: self)
            
        }
    }
    
    func didDisconnectWithError(error: NSError!) {
        let _title = "Atención"
        var _message = "No se ha podido iniciar sesion con Google"
        let alertController = Util.showMessage(_title,message: _message)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }

    
}
