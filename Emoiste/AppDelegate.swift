//
//  AppDelegate.swift
//  Emoiste
//
//  Created by David Hevilla Garcia on 6/1/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Initializamos Parse.
        Parse.setApplicationId("davbwGthV0heV7YvtZOpthYPdfH0uc9g3k8xv6ld",
            clientKey: "YWCAAe3tRW3OLf7Ip2UKmSYb4B1Ic9X4g2FySJ7a")
        
        //Inicializamos el api de Twitter
        PFTwitterUtils.initializeWithConsumerKey("OKNBoNs75QUVexkM460JMXaHB",
            consumerSecret:"SAdKXyuq96RkPBUYmVyaMI73cTXS4oyeJ9ueTUaRuxUWSlDcTI")
        
        // Override point for customization after application launch.
        let cache = NSURLCache(memoryCapacity: 8 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        NSURLCache.setSharedURLCache(cache)
        
        // Valores por defecto
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        // Login: 0-no login, 1-login facebook, 3-login Google+, 999-Cuenta
        if (defaults.objectForKey("Login") == nil) {
            defaults.setObject(0, forKey: "Login")
        }else{
            var login = defaults.integerForKey("Login")
            if(login == USER_GOOGLE){
                var signIn : GPPSignIn = GPPSignIn.sharedInstance()
                if(signIn.authentication == nil)
                {
                    signIn.shouldFetchGooglePlusUser = true;
                    signIn.shouldFetchGoogleUserEmail = true;  // Uncomment to get the user's email
                    
                    // You previously set kClientId in the "Initialize the Google+ client" step
                    let clientID = defaults.objectForKey(kUSER_USERID) as String
                    signIn.clientID = clientID
                    
                    // Uncomment one of these two statements for the scope you chose in the previous step
                    signIn.scopes.append(kGTLAuthScopePlusLogin);  // "https://www.googleapis.com/auth/plus.login" scope
                    //signIn.scopes = @[ @"profile" ];             // "profile" scope
                    
                    if(signIn.trySilentAuthentication())
                    {
                        NSLog("Silent G+ login successful (initially)")
                    }
                    else
                    {
                        NSLog("G+ silent authentication failed.")
                    }
                }
            }
            
        }
        
        // De momento el login no es persistente
        //defaults.setObject(0, forKey: "Login")
        //defaults.synchronize()
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if TYPE_REGISTER_RRSS == 3 {
            // Google+ (3)
            return GPPURLHandler.handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
        } else {
            // Facebook (1)
            var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
            return wasHandled
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

