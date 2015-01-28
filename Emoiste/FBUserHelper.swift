//
//  FBUserHelper.swift
//  Emoiste
//
//  Created by Francisco Caro Diaz on 28/01/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import Foundation

class FBUserHelper{
    
    var fbSession:FBSession?;
    
    init(){
        self.fbSession = nil;
    }
    
    func fbAlbumRequestHandler(connection:FBRequestConnection!, result:AnyObject!, error:NSError!){
        /*
        if let gotError = error{
            println(gotError.description);
        }
        else{
            if let graphData = result.valueForKey("data") as? Array{
                var albums:[AlbumModel] =  [AlbumModel]();
                for obj:FBGraphObject in graphData{
                    let desc = obj.description;
                    println(desc);
                    let name = obj.valueForKey("name") as String;
                    println(name);
                    if(name == "ETC"){
                        let test="";
                    }
                    let id = obj.valueForKey("id") as String;
                    var cover = "";
                    if let existsCoverPhoto : AnyObject = obj.valueForKey("cover_photo"){
                        let coverLink = existsCoverPhoto  as String;
                        cover = "/\(coverLink)/photos";
                    }
                    
                    
                    //println(coverLink);
                    let link = "/\(id)/photos";
                    
                    let model = AlbumModel(name: name, link: link, cover:cover);
                    albums.append(model);
                    
                }
                NSNotificationCenter.defaultCenter().postNotificationName("albumNotification", object: nil, userInfo: ["data":albums]);
            }
            
        }
        */
    }
    
    func fetchPhoto(link:String){
        let fbRequest = FBRequest.requestForMe();
        fbRequest.graphPath = link;
        fbRequest.startWithCompletionHandler(fetchPhotosHandler);
    }
    
    
    
    func fetchPhotosHandler(connection:FBRequestConnection!, result:AnyObject!, error:NSError!){
        /*
        if let gotError = error{
            
        }
        else{
            var pictures:[UIImage] = [UIImage]();
            if let graphData:Array = result.valueForKey("data") as? Array{
                var albums:[AlbumModel] =  [AlbumModel]();
                for obj:FBGraphObject in graphData{
                    println(obj.description);
                    let pictureURL = obj.valueForKey("picture") as String;
                    let url = NSURL(string: pictureURL);
                    let picData = NSData(contentsOfURL: url!);
                    let img = UIImage(data: picData!);
                    pictures.append(img!);
                }
                
                NSNotificationCenter.defaultCenter().postNotificationName("photoNotification", object: nil, userInfo: ["photos":pictures]);
            }
            
        }
        */
    }
    
    func fetchAlbum(){
        
        let request =  FBRequest.requestForMe();
        request.graphPath = "me/albums";
        
        request.startWithCompletionHandler(fbAlbumRequestHandler);
    }
    
    func logout(){
        self.fbSession?.closeAndClearTokenInformation();
        self.fbSession?.close();
    }
    /*
    func login(){
        let activeSession = FBSession.activeSession();
        let fbsessionState = activeSession.state;
        let permission = ["public_profile", "publish_actions", "email"];
        
        if fbsessionState == FBSessionState.CreatedTokenLoaded{
            FBSession.openActiveSessionWithReadPermissions(permission, allowLoginUI: false, completionHandler: {
                (session, state, error) -> Void in
                self.fbHandler(session, state: state, error: error)
            })
        } else {
            // Iniciar sesión con UI
            FBSession.openActiveSessionWithReadPermissions(permission, allowLoginUI: true, completionHandler: {
                (session:FBSession!, state:FBSessionState, error:NSError!) in
                self.fbHandler(session, state: state, error: error)
            })
        }
    }
    */
    func login() {
        // Comprobamos si el token está en caché para iniciar sesión sin UI
        let activeSession = FBSession.activeSession();
        let fbsessionState = activeSession.state;
        let permission = ["public_profile", "publish_actions", "email"];
        
        if(fbsessionState != FBSessionState.Open && fbsessionState != FBSessionState.OpenTokenExtended){
            
            FBSession.openActiveSessionWithReadPermissions(permission, allowLoginUI: true, completionHandler: self.fbHandler);
            
        }else if fbsessionState == FBSessionState.CreatedTokenLoaded || fbsessionState == FBSessionState.Open {
            FBSession.openActiveSessionWithReadPermissions(permission, allowLoginUI: false, completionHandler: {
                (session, state, error) -> Void in
                self.fbHandler(session, state: state, error: error)
            })
        }
    }
    
    func fbHandler(session:FBSession!, state:FBSessionState, error:NSError!) {
        if let gotError = error {
            let _title = "Atención"
            var _message = "No se ha podido iniciar sesion con Facebook"
            let alertController = Util.showMessage(_title,message: _message)
        } else {
            self.fbSession = session;
            FBRequest.requestForMe()?.startWithCompletionHandler(self.fbRequestCompletionHandler);
        }
    }
    
    func fbRequestCompletionHandler(connection:FBRequestConnection!, result:AnyObject!, error:NSError!){
        if let gotError = error{
            let _title = "Atención"
            var _message = "No se ha podido iniciar sesion con Facebook"
            let alertController = Util.showMessage(_title,message: _message)
            //self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            //let resultDict = result as Dictionary;
            //let email = result["email"];
            //let firstName = result["first_name"];
            
            let userFBID:AnyObject = result.valueForKey("id")!
            let firstName = result.valueForKey("first_name")! as String
            let nickName = firstName.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            let email : AnyObject = result.valueForKey("email")!
            let gender:AnyObject = result.valueForKey("gender")!
            let userImageURL = "https://graph.facebook.com/\(userFBID)/picture?type=small";
            
            let password = result.valueForKey("id")! as NSString
            let socialNetwork = 1
            let country = DEFAULT_COUNTRY
            
            /*
            let url = NSURL.URLWithString(userImageURL)
            let imageData = NSData(contentsOfURL: url);
            let image = UIImage(data: imageData!);
            */
            
            //println("userFBID: \(userFBID) \nEmail \(email) \nFirstName:\(firstName) \ngender: \(gender) \nimage: \(userImageURL)");
            
            // userID:AnyObject, nickName:AnyObject, email:AnyObject, gender:AnyObject, picture:AnyObject
            var userModel = User(userID: userFBID, nickName: firstName, email: email, gender:gender,picture:userImageURL);
            
            NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_FACEBOOK_LOGIN, object: userModel, userInfo: nil);
            
        }
    }
}