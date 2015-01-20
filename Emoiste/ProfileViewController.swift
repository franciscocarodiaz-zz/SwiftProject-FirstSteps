//
//  ProfileViewController.swift
//  Emoiste
//
//  Created by David Hevilla Garcia on 6/1/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import UIKit
import AddressBook
import MediaPlayer
import AssetsLibrary
import CoreLocation
import CoreMotion

class ProfileViewController: UIViewController, FBLoginViewDelegate, GPPSignInDelegate{

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var fbLoginView: FBLoginView!
    
    @IBOutlet var googleLogin: UIButton!
    
    var signIn : GPPSignIn?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.fbLoginView.delegate  = self
        self.fbLoginView.readPermissions = ["public_profile", "publish_actions"]
        
        //Configuramos el login Google
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        
        profileImageView.hidden = false
        nameLabel.hidden = false
        
    }
    
    //MARK: G+
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        print(auth)
    }
    
    func didDisconnectWithError(error: NSError!) {
        
    }

    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        
        println(user)
        
        nameLabel.text = user.name
        let userImageURL = "https://graph.facebook.com/\(user.objectID)/picture?type=small"
        let url = NSURL (string: userImageURL)
        let imageData = NSData (contentsOfURL: url!)
        let image = UIImage(data: imageData!)
        profileImageView.image = image
        
    }
    
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        
        profileImageView.hidden = true
        nameLabel.hidden = true
    }
    
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        
        println("Error: \(error.localizedDescription)")
        
    }
    
}
