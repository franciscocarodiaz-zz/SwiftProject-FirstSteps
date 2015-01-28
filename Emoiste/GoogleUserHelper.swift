//
//  GoogleUserHelper.swift
//  Emoiste
//
//  Created by Francisco Caro Diaz on 28/01/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import Foundation
class GoogleUserHelper{
    
    var signIn:GPPSignIn?;

    init(){
        self.signIn = nil;
    }
    
    func logout(){
        self.signIn?.signOut()
    }
    
    func login() {
        signIn = GPPSignIn.sharedInstance()
        signIn?.shouldFetchGooglePlusUser = true
        signIn?.shouldFetchGoogleUserID = true
        signIn?.shouldFetchGoogleUserEmail = true
        signIn?.clientID = GOOGLE_CLIENT_ID
        signIn?.scopes = [kGTLAuthScopePlusLogin]
        signIn?.authenticate()
    }
    /*
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        
        if let gotError = error {
            
            let alertController = UIAlertController(
                title: "Atención",
                message: "No se ha podido iniciar sesión con Google+",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            //self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            
            let cliendId = auth.clientID
            let parameters = auth.parameters
            let id_token = parameters.objectForKey("id_token") as? String
            let access_token = parameters.objectForKey("access_token") as? String
            
            let properties = auth.properties as NSDictionary
            let user_id = properties.objectForKey("user_id") as? String
            
            //var user_id = properties.objectForKey("user_id") as? String
            
            let code: NSString = DEFAULT_CODE
            let name = signIn?.googlePlusUser.displayName as String!
            let nickName = name.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let email : NSString = auth.userEmail
            let password = signIn?.googlePlusUser.identifier as String!
            let gender = signIn?.googlePlusUser.gender as String!
            let notifications = true
            let socialNetwork = 3
            
            // Registramos usuario en Backend
            let country = "United States"
            var rememberMe = false
            var isBlogger = false
            
            //NSUserDefaults.standardUserDefaults().setObject(userImageURL, forKey: kUSER_PICTURE)
            //self.registerUser(code, nickName: nickName, email: email, password: password, country: country, gender: gender, notifications: notifications, isBlogger: isBlogger, rememberMe: rememberMe, socialNetwork: socialNetwork, idSocialNetwork:user_id!)
            
            
            
        }
    }
    */
}