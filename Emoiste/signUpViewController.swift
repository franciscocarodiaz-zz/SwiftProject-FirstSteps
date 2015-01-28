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
    let googleHelper = GoogleUserHelper();
    var signIn:GPPSignIn?;
    
    // Facebook
    let fbHelper = FBUserHelper();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("executeHandleFBUser:"), name: NOTIFICATION_FACEBOOK_LOGIN, object: nil);
        
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if (defaults.objectForKey(kUSER_LOGIN_FACEBOOK) != nil && defaults.objectForKey(kUSER_LOGIN_FACEBOOK) as Int == USER_FACEBOOK) {
            //println("Usuario logueado con Facebook. Modificar string en boton Sign Up.");
            //fbButton .setTitle("Login with Facebook", forState: UIControlState.Normal)
        }
        if (defaults.objectForKey(kUSER_LOGIN_GOOGLE) != nil && defaults.objectForKey(kUSER_LOGIN_GOOGLE) as Int == USER_GOOGLE) {
            //println("Usuario logueado con Google. Modificar string en boton Sign Up.");
            //fbButton .setTitle("Login with Google+", forState: UIControlState.Normal)
        }
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NOTIFICATION_FACEBOOK_LOGIN, object: nil);
    }
    
    @IBOutlet weak var fbButton: UIButton!
    // MARK: IBAction
    
    // Login Facebook
    @IBAction func loginFacebook(sender: AnyObject) {
        TYPE_REGISTER_RRSS = USER_FACEBOOK
        
        fbHelper.login();
    }

    // Login Google+
    @IBAction func loginWithGoogle(sender: AnyObject) {
        TYPE_REGISTER_RRSS = USER_GOOGLE
        
        //googleHelper.signIn?.delegate = self
        //googleHelper.login();
        
        signIn = GPPSignIn.sharedInstance()
        signIn?.shouldFetchGooglePlusUser = true
        signIn?.shouldFetchGoogleUserID = true
        signIn?.shouldFetchGoogleUserEmail = true
        signIn?.clientID = GOOGLE_CLIENT_ID
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
        self.performSegueWithIdentifier(VC_LOGIN, sender: self)
    }

    // Crear cuenta
    @IBAction func createAccount(sender: AnyObject) {
        self.performSegueWithIdentifier(VC_REGISTER, sender: self)
    }

    // MARK: Facebook
    
    func executeHandleFBUser(notification:NSNotification){
        
        // 1. Save user data
        let userData = notification.object as User;
        
        // 2. Save type of user
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(TYPE_REGISTER_RRSS, forKey: kLOGIN)
        defaults.synchronize()
        
        if (defaults.objectForKey(kUSER_LOGIN_FACEBOOK) != nil && defaults.objectForKey(kUSER_LOGIN_FACEBOOK) as Int == USER_FACEBOOK) {
            // Llamada a API para comprobar loginSocial
            USER_DATA = userData
            USER_DATA.loginFacebook = true
            
            self.navigateTo(VC_HOME)
        }else{
            // 3. Register user and go to Home screen
            self.registerUser(userData)
        }
        
    }
    
    //MARK: Google+
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        
        if let gotError = error {
            
            let _title = "Atención"
            var _message = "No se ha podido iniciar sesion con Google+"
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
            
            if (defaults.objectForKey(kUSER_LOGIN_GOOGLE) != nil && defaults.objectForKey(kUSER_LOGIN_GOOGLE) as Int == USER_GOOGLE) {
                // Llamada a API para comprobar loginSocial
                USER_DATA = userData
                USER_DATA.loginGPlus = true
                
                self.navigateTo(VC_HOME)
            }else{
                // 3. Register user and go to Home screen
                self.registerUser(userData)
            }
            
        }
    }
    
    func didDisconnectWithError(error: NSError!) {
        
        let _title = "Atención"
        var _message = "No se ha podido iniciar sesion con Google"
        let alertController = Util.showMessage(_title,message: _message)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Registramos usuario en Backend
    func registerUser(userData: User) {
        
        createLoader("Registrando usuario")
        
        var params = [
            "code" : DEFAULT_CODE,
            "nickName" : userData.nickName,
            "email" : userData.email,
            "password" : userData.userID,
            "country" : userData.country,
            "gender" : userData.gender,
            "isBlogger" : userData.isBlogger,
            "rememberMe" : userData.rememberMe,
            "notifications" : userData.notifications,
            "socialNetwork" : TYPE_REGISTER_RRSS
        ]
        
        self.callManager("register", parameters: params)
        
    }
    
    func callManager(method: String, parameters: AnyObject){
        
        let path = PATH_WS_USER;
        let baseURL = NSURL(string: path)
        
        let manager = AFHTTPRequestOperationManager(baseURL: baseURL)
        let jsonResponseSerializer = AFJSONResponseSerializer()
        jsonResponseSerializer.stringEncoding = NSUTF8StringEncoding
        manager.responseSerializer = jsonResponseSerializer
        
        manager.POST(method,
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                
                if (responseObject != nil) {
                    if let responseDict = responseObject.objectForKey(WS_RESPONSE_ELEMENT_RESULT) as? NSDictionary {
                        
                        let ws_response_status = responseDict.objectForKey(WS_RESPONSE_ELEMENT_RESULT_STATUS) as? String
                        let ws_response_msg = responseDict.objectForKey(WS_RESPONSE_ELEMENT_RESULT_MESSAGE) as? String
                        
                        if ws_response_status == WS_RESPONSE_STATUS_OK {
                            let dataUser = responseObject.objectForKey(WS_RESPONSE_ELEMENT_DATA) as? NSDictionary
                            let userDat  = Util.userToObject(dataUser!) as User
                            USER_DATA = userDat
                            
                            var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            if TYPE_REGISTER_RRSS == USER_FACEBOOK{
                                USER_DATA.loginFacebook = true
                                defaults.setObject(USER_FACEBOOK, forKey: kUSER_LOGIN_FACEBOOK)
                            }else if TYPE_REGISTER_RRSS == USER_GOOGLE{
                                USER_DATA.loginGPlus = true
                                defaults.setObject(USER_GOOGLE, forKey: kUSER_LOGIN_GOOGLE)
                            }
                            if method == "register"{
                                defaults.setObject(0, forKey: kTUTORIAL)
                            }
                            defaults.synchronize()
                            
                            self.navigateTo(VC_HOME)
                            
                        }
                    }
                } else {
                    self.dataUserFailed(TYPE_REGISTER_RRSS)
                }
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                self.dataUserFailed(TYPE_REGISTER_RRSS)
            }
        )
    }
    
    func createLoader(title: String) {
        let loadingHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingHUD.mode = MBProgressHUDModeIndeterminate
        loadingHUD.labelText = title
    }
    
    //MARK: Registro Backend
    func navigateTo(navigation: String) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
        self.performSegueWithIdentifier(navigation, sender: self)
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
    
    
    func dataUserFailed(social: Int) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
        var socialNetwork = ""
        if social == 1 {
            socialNetwork = "Facebook"
        } else {
            socialNetwork = "Google+"
        }
        
        let _title = "Atención"
        var _message = "No se ha podido iniciar sesión con \(socialNetwork)"
        let alertController = Util.showMessage(_title,message: _message)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
