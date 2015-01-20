//
//  signUpViewController.swift
//  Emoiste
//
//  Created by david hevilla garcia on 7/1/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//


import UIKit
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion

class signUpViewController: UIViewController, FBLoginViewDelegate, GPPSignInDelegate {

    // Google+
    var signIn : GPPSignIn?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: IBAction
    
    // Login Facebook
    @IBAction func loginFacebook(sender: AnyObject) {
        TYPE_REGISTER_RRSS = 1
        self.loginFB();
    }

    // Login Google+
    @IBAction func loginWithGoogle(sender: AnyObject) {
        TYPE_REGISTER_RRSS = 3
        signIn = GPPSignIn.sharedInstance()
        signIn?.shouldFetchGooglePlusUser = true
        signIn?.shouldFetchGoogleUserID = true
        signIn?.shouldFetchGoogleUserEmail = true
        signIn?.clientID = CLIENT_ID
        signIn?.scopes = [kGTLAuthScopePlusLogin]
        signIn?.delegate = self
        signIn?.authenticate()
    }
    
    // Login Twitter
    @IBAction func loginTwitter(sender: AnyObject) {
        PFTwitterUtils.logInWithBlock {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Lo siento,el usuario ha cancelado la sesión twitter.")
            } else if user.isNew {
                NSLog("Usuario registrado y logado con Twitter!")
            } else {
                NSLog("Usuario logado con Twitter!")
            }
        }
    }
    
    // Login cuenta
    @IBAction func loginAccount(sender: AnyObject) {
        self.performSegueWithIdentifier("Login", sender: self)
    }

    // Crear cuenta
    @IBAction func createAccount(sender: AnyObject) {
        self.performSegueWithIdentifier("Registro", sender: self)
    }

    // MARK: Facebook
    
    func loginFB() {
        // Comprobamos si el token está en caché para iniciar sesión sin UI
        if FBSession.activeSession().state == FBSessionState.CreatedTokenLoaded {
            FBSession.openActiveSessionWithReadPermissions(["public_profile", "publish_actions", "email"], allowLoginUI: false, completionHandler: {
                (session, state, error) -> Void in
                self.fbHandler(session, state: state, error: error)
            })
        } else {
            // Iniciar sesión con UI
            FBSession.openActiveSessionWithReadPermissions(["public_profile", "publish_actions", "email"], allowLoginUI: true, completionHandler: {
                (session:FBSession!, state:FBSessionState, error:NSError!) in
                self.fbHandler(session, state: state, error: error)
            })
        }
    }
    
    func fbHandler(session:FBSession!, state:FBSessionState, error:NSError!) {
        if let gotError = error {
            let alertController = UIAlertController(title: "Atención", message:
                "No se ha podido iniciar sesión con Facebook", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            FBRequest.requestForMe()?.startWithCompletionHandler(self.fbRequestCompletionHandler);
        }
    }
    
    func fbRequestCompletionHandler(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) {
        if let gotError = error {
            let alertController = UIAlertController(title: "Atención", message:
                "No se ha podido iniciar sesión con Facebook", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let code: NSString = "EmGuest"
            let name = result.valueForKey("first_name")! as String
            let nickName = name.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let email : NSString = result.valueForKey("email")! as NSString
            let password = result.valueForKey("id")! as NSString
            let gender = result.valueForKey("gender")! as NSString
            let notifications = true
            let socialNetwork = 1
            /*let userImageURL = "https://graph.facebook.com/\(userFBID)/picture?type=small"
            let url = NSURL (string: userImageURL)
            let imageData = NSData (contentsOfURL: url!)
            let image = UIImage(data: imageData!)
            profileImageView.image = image*/
            
            // Registramos usuario en Backend
            registerUser(code, nickName: nickName, email: email, password: password, gender: gender, notifications: notifications, socialNetwork: socialNetwork)
            
        }
    }
    
    //MARK: Google+
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if let gotError = error {
            let alertController = UIAlertController(title: "Atención", message:
                "No se ha podido iniciar sesión con Google+", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let code: NSString = "EmGuest"
            let name = signIn?.googlePlusUser.displayName as String!
            let nickName = name.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let email : NSString = auth.userEmail
            let password = signIn?.googlePlusUser.identifier as String!
            let gender = signIn?.googlePlusUser.gender as String!
            let notifications = true
            let socialNetwork = 3
            // Registramos usuario en Backend
            registerUser(code, nickName: nickName, email: email, password: password, gender: gender, notifications: notifications, socialNetwork: socialNetwork)
        }
    }
    
    func didDisconnectWithError(error: NSError!) {
        let alertController = UIAlertController(title: "Atención", message:
            "No se ha podido iniciar sesión con Google+", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: Registro Backend
    
    // Registramos usuario en Backend
    func registerUser(code: String, nickName: String, email: String, password: String, gender: String, notifications: Bool, socialNetwork:Int) {

        let loadingHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingHUD.mode = MBProgressHUDModeIndeterminate
        loadingHUD.labelText = "Iniciando"
        
        let path = PATH_WS_USER;
        let baseURL = NSURL(string: path)
        
        var params = [
            "code" : code,
            "nickName" : nickName,
            "email" : email,
            "password" : password,
            "gender" : gender,
            "notifications" : notifications,
            "socialNetwork" : socialNetwork
        ]
        
        let manager = AFHTTPRequestOperationManager(baseURL: baseURL)
        let jsonResponseSerializer = AFJSONResponseSerializer()
        jsonResponseSerializer.stringEncoding = NSUTF8StringEncoding
        manager.responseSerializer = jsonResponseSerializer
        
        manager.POST("register",
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                //println(responseObject.description)
                if (responseObject != nil) {
                    self.dataUserLoaded(responseObject, social: socialNetwork)
                } else {
                     self.dataUserFailed(socialNetwork)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                //println(error.description)
                self.dataUserFailed(socialNetwork)
            }
        )
    }
    
    func dataUserLoaded(responseObject: AnyObject, social: Int) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
        if let responseDict = responseObject.objectForKey("result") as? NSDictionary {
            let status = responseDict.objectForKey("status") as? String
            if status == "ok" {
                if let dataUser = responseObject.objectForKey("data") as? NSDictionary {
                    // Guardamos datos del usuario
                    let userDat  = Util.userToObject(dataUser) as User
                    // PENDIENTE: ver donde guardar los datos
                    USER_DATA = userDat
                    // Activamos el Login
                    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(social, forKey: "Login")
                    defaults.synchronize()
                    // Home
                    self.performSegueWithIdentifier("Home", sender: self)
                } else {
                    self.dataUserFailed(social)
                }
            } else {
                //println(responseDict.objectForKey("msg"))
                self.dataUserFailed(social)
            }
        } else {
            self.dataUserFailed(social)
        }
    }
    
    func dataUserFailed(social: Int) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
        var socialNetwork = ""
        if social == 1 {
            socialNetwork = "Facebook"
        } else {
            socialNetwork = "Google+"
        }
        
        let alertController = UIAlertController(title: "Atención", message:
            "No se ha podido iniciar sesión con \(socialNetwork)", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
