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
    
    @IBOutlet var backgroundImage: UIButton!
    
    
    @IBAction func resetPassword(sender: AnyObject) {
        
        resetPassword("davidhev@me.com")
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        
        
        
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var texto = "Nick Name: \(USER_DATA.nickName)\nEmail: \(USER_DATA.email)"
        userTextView.text = texto
        
        
        
        
        
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func dataUserFailed() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
        let alertController = UIAlertController(title: "Atención", message:
            "No se ha podido recuperar la contraseña", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func dataUserLoaded(responseObject: AnyObject) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
        if let responseDict = responseObject.objectForKey("result") as? NSDictionary {
            let status = responseDict.objectForKey("status") as? String
            if status == "ok" {
                
                let alertController = UIAlertController(title: "Atención", message:
                    "Se ha enviado una nueva contraseña a tu correo", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                
                
                
                
                
            } else {
                println(responseDict.objectForKey("msg"))
                self.dataUserFailed()
            }
            
            
            
            
        }
    }

    
    
    
    func resetPassword(email:String) {
        
        
        
        
        
        
        let loadingHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingHUD.mode = MBProgressHUDModeIndeterminate
        loadingHUD.labelText = "Iniciando"
        
        let path = PATH_WS_USER;
        let baseURL = NSURL(string: path)
        
        var params = [
            "email" : email,
            
        ]
        
        let manager = AFHTTPRequestOperationManager(baseURL: baseURL)
        let jsonResponseSerializer = AFJSONResponseSerializer()
        jsonResponseSerializer.stringEncoding = NSUTF8StringEncoding
        manager.responseSerializer = jsonResponseSerializer
        
        manager.POST(RESET_PASSWORD,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                //println(responseObject.description)
                if (responseObject != nil) {
                    self.dataUserLoaded(responseObject)
                } else {
                    self.dataUserFailed()
                }
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                println(error.description)
                self.dataUserFailed()
            }
        )
    }
    
}


    



