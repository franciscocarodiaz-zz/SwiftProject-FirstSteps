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
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.objectForKey(kUSER_FB_USERID) as String != "") {
            //let user_id_fb = defaults.objectForKey(kUSER_FB_USERID) as String!
            //userData.userIDFB = user_id_fb
        }
        USER_DATA = userData
        
        let path = "get";
        let responseObject: AnyObject = ""
        var params = [
            "userId" : userData.userID
        ]
        
        APIHelper.callAPIUser(path,parameters: params, completionHandler: { (responseObject, errorValue) -> Void in
            if !errorValue{
                var str:String = ""
                println(responseObject)
                
                if let responseDict = responseObject.objectForKey(WS_RESPONSE_ELEMENT_RESULT) as? NSDictionary {
                    
                    let ws_response_status = responseDict.objectForKey(WS_RESPONSE_ELEMENT_RESULT_STATUS) as? String
                    let ws_response_msg = responseDict.objectForKey(WS_RESPONSE_ELEMENT_RESULT_MESSAGE) as? String
                    
                    if ws_response_status == WS_RESPONSE_STATUS_OK {
                        let dataUser = responseObject.objectForKey(WS_RESPONSE_ELEMENT_DATA) as? NSDictionary
                        let userDat  = Util.userToObject(dataUser!) as User
                        
                        //USER_DATA = Util.copyUserFromServer(userDat) as User
                        
                    }
                }
                
            }
        })
        
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
            
            // 2. Save type of user
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(TYPE_REGISTER_RRSS, forKey: kLOGIN)
            defaults.synchronize()
            
            let user_id_g = ""
            if (defaults.objectForKey(kUSER_G_USERID) as String != "") {
                //user_id_g = defaults.objectForKey(kUSER_G_USERID) as String!
            }
            
            var userData = User(userID: user_id, userIDFB: USER_DATA.userIDFB, userIDG: user_id_g, nickName: nickName, email: email, gender:gender,picture:userImageURL);
            
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
