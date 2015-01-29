//
//  accountViewController.swift
//  Emoiste
//
//  Created by david hevilla garcia on 28/1/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import UIKit

class accountViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var languageField: UITextField!
    @IBOutlet var countryField: UITextField!
    @IBOutlet var nickNameField: UITextField!
    
    @IBOutlet var femaleSwitch: UISwitch!
    @IBOutlet var maleSwith: UISwitch!
    @IBOutlet var otherSwith: UISwitch!
    
    @IBOutlet var femaleButton: UIButton!
    
    @IBOutlet var maleButton: UIButton!
    
    @IBOutlet var otherButton: UIButton!
    
    @IBOutlet var deleteAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        emailField.text = USER_DATA.email as NSString
        
        nickNameField.text = USER_DATA.nickName as NSString
        countryField.text = USER_DATA.country as NSString
    
        
        if (USER_DATA.gender as NSString == "male") {
            
            maleSwith.setOn(true, animated:true)
    } else if (USER_DATA.gender as NSString == "female") {
    
    femaleSwitch.setOn(true, animated:true)
    
        } else {
           
            otherSwith.setOn(true, animated: true)
            
        }
        
        
        println(USER_DATA.email)
        println(USER_DATA.country)
        println(USER_DATA.nickName)
        println(USER_DATA.gender)
        
        
        
        
        
        

    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
        println("cancel")
        
        
    }

}





