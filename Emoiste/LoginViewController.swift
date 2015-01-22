//
//  LoginViewController.swift
//  Emoiste
//
//  Created by David Hevilla Garcia on 20/1/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // @BOutlet
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftPaddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        leftPaddingView1.backgroundColor = UIColor.clearColor()
        emailField.leftView = leftPaddingView1
        emailField.leftViewMode = .Always
        
        let leftPaddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        leftPaddingView2.backgroundColor = UIColor.clearColor()
        passwordField.leftView = leftPaddingView2
        passwordField.leftViewMode = .Always
        
        // Valores iniciales
        emailField.text = ""
        passwordField.text = ""
        
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    // MARK: IBAction
    
    // Volver
    @IBAction func backPressed(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Login
    @IBAction func loginPressed(sender: AnyObject) {
        
        // Comprobamos los campos
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

        // Datos
        let email = emailField.text
        let password = passwordField.text
        
        // Login
        loginUser(email, password: password)
        
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
    
    //MARK: Login Backend
    
    // Login en Backend
    func loginUser(email:String, password: String) {
        
        let loadingHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingHUD.mode = MBProgressHUDModeIndeterminate
        loadingHUD.labelText = "Iniciando"
        
        let path = PATH_WS_USER;
        let baseURL = NSURL(string: path)
        
        var params = [
            "email" : email,
            "password" : password,
        ]
        
        let manager = AFHTTPRequestOperationManager(baseURL: baseURL)
        let jsonResponseSerializer = AFJSONResponseSerializer()
        jsonResponseSerializer.stringEncoding = NSUTF8StringEncoding
        manager.responseSerializer = jsonResponseSerializer
        
        manager.POST("login",
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
            "No se ha podido iniciar sesión", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

