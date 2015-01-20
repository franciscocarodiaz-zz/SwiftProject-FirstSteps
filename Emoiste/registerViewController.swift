//
//  registerViewController.swift
//  Emoiste
//
//  Created by david hevilla garcia on 7/1/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import UIKit

class registerViewController: UIViewController, UITextFieldDelegate {

    // @BOutlet
    @IBOutlet var nickField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var rememberSwitch: UISwitch!
    @IBOutlet var female: UIButton!
    @IBOutlet var male: UIButton!
    @IBOutlet var bloggerSwitch: UISwitch!
    
    var genderType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftPaddingView0 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        leftPaddingView0.backgroundColor = UIColor.clearColor()
        nickField.leftView = leftPaddingView0
        nickField.leftViewMode = .Always
        
        let leftPaddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        leftPaddingView1.backgroundColor = UIColor.clearColor()
        emailField.leftView = leftPaddingView1
        emailField.leftViewMode = .Always
        
        let leftPaddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        leftPaddingView2.backgroundColor = UIColor.clearColor()
        passwordField.leftView = leftPaddingView2
        passwordField.leftViewMode = .Always
        
        // Valores iniciales
        genderType = ""
        nickField.text = ""
        emailField.text = ""
        passwordField.text = ""
        female.backgroundColor = UIColor(red: 62.0/255.0, green: 55.0/255.0, blue: 52.0/255.0, alpha: 1.0)
        male.backgroundColor = UIColor(red: 62.0/255.0, green: 55.0/255.0, blue: 52.0/255.0, alpha: 1.0)
        rememberSwitch.setOn(false, animated:false)
        bloggerSwitch.setOn(false, animated:false)
        
        nickField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    // MARK: IBAction
    
    // Male
    @IBAction func malePressed(sender: AnyObject) {
        genderType = "male"
        male.backgroundColor = UIColor(red: 241.0/255.0, green: 111.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        female.backgroundColor = UIColor(red: 62.0/255.0, green: 55.0/255.0, blue: 52.0/255.0, alpha: 1.0)
    }
    
    // Female
    @IBAction func femalePressed(sender: AnyObject) {
        genderType = "female"
        female.backgroundColor = UIColor(red: 241.0/255.0, green: 111.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        male.backgroundColor = UIColor(red: 62.0/255.0, green: 55.0/255.0, blue: 52.0/255.0, alpha: 1.0)
    }
    
    // Volver
    @IBAction func backPressed(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Crear cuenta
    @IBAction func submitPressed(sender: AnyObject) {
        
        // Comprobamos los campos
        nickField.text = nickField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        if nickField.text == "" {
            let alertController = UIAlertController(title: "Atención", message:
                "Debe introducir el Nick", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        emailField.text = emailField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        if emailField.text == "" {
            let alertController = UIAlertController(title: "Atención", message:
                "Debe introducir el Email", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        if !self.isValidEmail(emailField.text) {
            let alertController = UIAlertController(title: "Atención", message:
                "El formato del Email no es correcto", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        passwordField.text = passwordField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        if passwordField.text == "" {
            let alertController = UIAlertController(title: "Atención", message:
                "Debe introducir el Password", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        if genderType == "" {
            let alertController = UIAlertController(title: "Atención", message:
                "Debe seleccionar Female - Male", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
    
        // Datos
        let code: NSString = "EmGuest"
        let nickName = nickField.text
        let email = emailField.text
        let password = passwordField.text
        let gender = genderType
        let notifications = true
        let socialNetwork = 0
        let country = "United States"
        var isBlogger = false
        if bloggerSwitch.on {
            isBlogger = true
        }
        var rememberMe = false
        if rememberSwitch.on {
            rememberMe = true
        }
        
        // Registramos usuario en Backend
        registerUser(code, nickName: nickName, email: email, password: password, country: country, gender: gender, notifications: notifications, isBlogger: isBlogger, rememberMe: rememberMe, socialNetwork: socialNetwork)

    }
    
    // Chequea si un email es válido
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }

    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        let newLength = countElements(textField.text!) + countElements(string!) - range.length
        return newLength <= 100 // Límite de 100 caracteres
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Registro Backend
    
    // Registramos usuario en Backend
    func registerUser(code: String, nickName: String, email: String, password: String, country: String, gender: String, notifications: Bool, isBlogger: Bool, rememberMe: Bool, socialNetwork:Int) {
        
        let loadingHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingHUD.mode = MBProgressHUDModeIndeterminate
        loadingHUD.labelText = "Creando cuenta"
        
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
                println(responseObject.description)
                if (responseObject != nil) {
                    self.dataUserLoaded(responseObject)
                } else {
                    self.dataUserFailed()
                }
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                //println(error.description)
                self.dataUserFailed()
            }
        )
    }
    
    func dataUserLoaded(responseObject: AnyObject) {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
        if let responseDict = responseObject.objectForKey("result") as? NSDictionary {
            let status = responseDict.objectForKey("status") as? String
            if status == "ok" {
                if let dataUser = responseObject.objectForKey("data") as? NSDictionary {
                    // Guardamos datos del usuario
                    let userDat  = Util.userToObject(dataUser) as User
                    // PENDIENTE: ver donde guardar los datos
                    USER_DATA = userDat
                    // Activamos el Login (999-cuenta)
                    var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(999, forKey: "Login")
                    defaults.synchronize()
                    // Home
                    self.performSegueWithIdentifier("Home", sender: self)
                } else {
                    self.dataUserFailed()
                }
            } else {
                println(responseDict.objectForKey("msg"))
                self.dataUserFailed()
            }
        } else {
            self.dataUserFailed()
        }
    }
    
    func dataUserFailed() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        
        let alertController = UIAlertController(title: "Atención", message:
            "No se ha podido crear la cuenta", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
   
    }

}
