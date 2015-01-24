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
        
        // Valores por defecto
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if (defaults.objectForKey("Login") as Int == 3) {
            self.performSegueWithIdentifier("Home", sender: self)
        } else {
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
                "No se ha podido iniciar sesion con Facebook", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let code: NSString = DEFAULT_CODE
            let name = result.valueForKey("first_name")! as String
            let nickName = name.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let email : NSString = result.valueForKey("email")! as NSString
            let password = result.valueForKey("id")! as NSString
            let gender = result.valueForKey("gender")! as NSString
            let notifications = true
            let socialNetwork = 1
            let country = DEFAULT_COUNTRY
            /*let userImageURL = "https://graph.facebook.com/\(userFBID)/picture?type=small"
            let url = NSURL (string: userImageURL)
            let imageData = NSData (contentsOfURL: url!)
            let image = UIImage(data: imageData!)
            profileImageView.image = image*/
            
            // Registramos usuario en Backend
            registerUser(code, nickName : nickName, email : email, password: password, country: country  , gender: gender, notifications: notifications, isBlogger: false, rememberMe: false, socialNetwork: socialNetwork)
        }
    }
    
    //MARK: Google+
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        
        if let gotError = error {
            
            let alertController = UIAlertController(
                title: "Atención",
                message: "No se ha podido iniciar sesión con Google+",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            
            let cliendId = auth.clientID
            let parameters = auth.parameters
            let id_token = parameters.objectForKey("id_token") as? String
            let access_token = parameters.objectForKey("access_token") as? String
            
            let properties = auth.properties
            var user_id = parameters.objectForKey("user_id") as? String
            
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
            
            self.registerUser(code, nickName: nickName, email: email, password: password, country: country, gender: gender, notifications: notifications, isBlogger: isBlogger, rememberMe: rememberMe, socialNetwork: socialNetwork)
            
            // OPTION 1
            /*
            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
            var existUserInBD  = false
            if existUserInBD {
                // SI el usuario existe en nuestra base de datos no haremos el registro
                
                /*
                let loadingHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                loadingHUD.mode = MBProgressHUDModeIndeterminate
                loadingHUD.labelText = "Comprobando cuenta"
                
                let path = PATH_WS_USER;
                let baseURL = NSURL(string: path)
                
                var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                var userId = defaults.objectForKey(kUSER_USERID) as String
                var params = [
                "userId" : userId
                ]
                
                let manager = AFHTTPRequestOperationManager(baseURL: baseURL)
                let jsonResponseSerializer = AFJSONResponseSerializer()
                jsonResponseSerializer.stringEncoding = NSUTF8StringEncoding
                manager.responseSerializer = jsonResponseSerializer
                
                manager.POST("getToken",
                parameters: params,
                success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                if (responseObject != nil) {
                self.dataUserLoaded(responseObject, social: socialNetwork)
                } else {
                // Registramos usuario normal en Backend
                self.registerUser(code, nickName: nickName, email: email, password: password, country: country, gender: gender, notifications: notifications, isBlogger: isBlogger, rememberMe: rememberMe, socialNetwork: socialNetwork)
                }
                },
                failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                self.dataUserFailed(socialNetwork)
                }
                )
                */
            }else{
                self.registerUser(code, nickName: nickName, email: email, password: password, country: country, gender: gender, notifications: notifications, isBlogger: isBlogger, rememberMe: rememberMe, socialNetwork: socialNetwork)
            }
           */
            
            
        }
    }
    
    func didDisconnectWithError(error: NSError!) {
        let alertController = UIAlertController(
            title: "Atención",
            message: "No se ha podido iniciar sesión con Google+",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // Registramos usuario en Backend
    func registerUser(code: String, nickName: String, email: String, password: String, country: String, gender: String, notifications: Bool, isBlogger: Bool, rememberMe: Bool, socialNetwork:Int) {
        
        createLoader("Registrando usuario")
        
        let path = PATH_WS_USER;
        let baseURL = NSURL(string: path)
        
        var params = [
            "code" : code,
            "nickName" : nickName,
            "email" : email,
            "password" : password,
            "country" : country,
            "gender" : gender,
            "isBlogger" : isBlogger,
            "rememberMe" : rememberMe,
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
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                if (responseObject != nil) {
                    if let responseDict = responseObject.objectForKey(WS_RESPONSE_ELEMENT_RESULT) as? NSDictionary {
                        
                        let ws_response_status = responseDict.objectForKey(WS_RESPONSE_ELEMENT_RESULT_STATUS) as? String
                        let ws_response_msg = responseDict.objectForKey(WS_RESPONSE_ELEMENT_RESULT_MESSAGE) as? String
                        
                        if ws_response_status == WS_RESPONSE_STATUS_OK {
                            let dataUser = responseObject.objectForKey(WS_RESPONSE_ELEMENT_DATA) as? NSDictionary
                            let userDat  = Util.userToObject(dataUser!) as User
                            self.navigateTo(VC_HOME,userData: userDat)
                        } else if ws_response_status == WS_RESPONSE_STATUS_KO && ws_response_msg == WS_RESPONSE_STATUS_KO_MSG_1 {
                            let userDat  = Util.userFromDefault() as User
                            self.navigateTo(VC_HOME,userData: userDat)
                        } else if ws_response_status == WS_RESPONSE_STATUS_KO && ws_response_msg == WS_RESPONSE_STATUS_KO_MSG_2 {
                            let userDat  = Util.userFromDefault() as User
                            self.navigateTo(VC_HOME,userData: userDat)
                        }
                    }
                } else {
                    self.dataUserFailed(socialNetwork)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                 self.dataUserFailed(socialNetwork)
            }
        )
    }
    
    func createLoader(title: String) {
        let loadingHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingHUD.mode = MBProgressHUDModeIndeterminate
        loadingHUD.labelText = title
    }
    
    //MARK: Registro Backend
    func navigateTo(navigation: String, userData: User) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
        USER_DATA = userData
        
        NSUserDefaults.standardUserDefaults().setInteger(TYPE_REGISTER_RRSS, forKey: kLOGIN)
        NSUserDefaults.standardUserDefaults().setObject(userData.userID, forKey: kUSER_USERID)
        NSUserDefaults.standardUserDefaults().setObject(userData.nickName, forKey: kUSER_NICKNAME)
        NSUserDefaults.standardUserDefaults().setObject(userData.email, forKey: kUSER_EMAIL)
        NSUserDefaults.standardUserDefaults().setObject(userData.gender, forKey: kUSER_GENDER)
        NSUserDefaults.standardUserDefaults().setObject(userData.picture, forKey: kUSER_PICTURE)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.performSegueWithIdentifier(navigation, sender: self)
    }
    
    func dataUserLoaded(responseObject: AnyObject, social: Int) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
        if let responseDict = responseObject.objectForKey(WS_RESPONSE_ELEMENT_RESULT) as? NSDictionary {
            
            let ws_response_status = responseDict.objectForKey(WS_RESPONSE_ELEMENT_RESULT_STATUS) as? String
            let ws_response_msg = responseDict.objectForKey(WS_RESPONSE_ELEMENT_RESULT_MESSAGE) as? String
            
            if ws_response_status == WS_RESPONSE_STATUS_OK {
                
                if let dataUser = responseObject.objectForKey(WS_RESPONSE_ELEMENT_DATA) as? NSDictionary {
                    // Guardamos datos del usuario
                    let userDat  = Util.userToObject(dataUser) as User
                    // PENDIENTE: ver donde guardar los datos
                    USER_DATA = userDat
                    
                    // Activamos el Login
                    //var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    NSUserDefaults.standardUserDefaults().setInteger(social, forKey: kLOGIN)
                    NSUserDefaults.standardUserDefaults().setObject(userDat.userID, forKey: kUSER_USERID)
                    NSUserDefaults.standardUserDefaults().setObject(userDat.nickName, forKey: kUSER_NICKNAME)
                    NSUserDefaults.standardUserDefaults().setObject(userDat.email, forKey: kUSER_EMAIL)
                    NSUserDefaults.standardUserDefaults().setObject(userDat.gender, forKey: kUSER_GENDER)
                    NSUserDefaults.standardUserDefaults().setObject(userDat.picture, forKey: kUSER_PICTURE)
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    // Home
                    self.performSegueWithIdentifier("Home", sender: self)
                } else {
                    self.dataUserFailed(social)
                }
                
            } else if ws_response_status == WS_RESPONSE_STATUS_KO {
                let _title = WS_RESPONSE_STATUS_KO
                var _message = ws_response_msg
                self.showMessage(_title,message: _message!)
                self.dataUserFailed(social)
            } else {
                let _title = "Atención"
                var socialNetwork = getSocialNetwork()
                var _message = "No se ha podido iniciar sesión con \(socialNetwork)"
                self.showMessage(_title,message: _message)
                self.dataUserFailed(social)
            }
            
        } else {
            self.dataUserFailed(social)
        }
        
    }
    
    func getSocialNetwork() -> String
    {
        var socialNetwork = ""
        
        switch(TYPE_REGISTER_RRSS){
        case 1:
            socialNetwork = "Facebook"
        case 3:
            socialNetwork = "Google"
        default:
            socialNetwork = ""
        }
        
        return (socialNetwork)
    }
    
    func showMessage(title: String, message: String) {
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
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
