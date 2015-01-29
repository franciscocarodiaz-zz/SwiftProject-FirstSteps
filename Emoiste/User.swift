//
//  User.swift
//  Emoiste
//
//  Created by Juan Manuel Hernandez del Olmo on 16/1/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import Foundation
import UIKit

class User {
    var userID:AnyObject = "";
    var userIDFB:AnyObject = "";
    var userIDG:AnyObject = "";
    var nickName:AnyObject = "";
    var email:AnyObject = "";
    var fullName:AnyObject = "";
    var country:AnyObject = "";
    var gender:AnyObject = "";
    var myStyle:AnyObject = "";
    var isBlogger:AnyObject = "";
    var rememberMe:AnyObject = "";
    var picture:AnyObject = "";
    var aboutYou:AnyObject = "";
    var location:AnyObject = "";
    var birthDate:AnyObject = "";
    var notifications:AnyObject = "";
    var blog:AnyObject = "";
    var loginFacebook:AnyObject = "";
    var loginGPlus:AnyObject = "";
    var twitter:AnyObject = "";
    var created:AnyObject = "";
    var userType:AnyObject = "";
    var deviceType:AnyObject = "";
    var deviceOS:AnyObject = "";
    var sessionRemember:AnyObject = "";
    var notiNewFollowMe:AnyObject = "";
    var notiCommentMyTimeline:AnyObject = "";
    var notiShareWithMe:AnyObject = "";
    var notiTrendsetterAddNewItem:AnyObject = "";
    var notiNewTrendsetter:AnyObject = "";
    var notiBrandHasNewItem:AnyObject = "";
    var notiNewBrand:AnyObject = "";
    var pasosConfiguracion:AnyObject = "";
    var userTypeDesc:AnyObject = "";
    var genderDesc:AnyObject = "";
    var activateDesc:AnyObject = "";
    var influencerName:AnyObject = "";
    var followMeCount:AnyObject = "";
    
    init(){}
    
    init(userID:AnyObject, nickName:AnyObject, email:AnyObject, gender:AnyObject, picture:AnyObject){
        self.userID = userID
        self.nickName = nickName
        self.email=email
        self.gender = gender
        self.picture = picture
    }
    
    init(userID:AnyObject, userIDFB:AnyObject, userIDG:AnyObject, nickName:AnyObject, email:AnyObject, gender:AnyObject, picture:AnyObject){
        self.userID = userID
        self.userIDFB = userIDFB
        self.userIDG = userIDG
        self.nickName = nickName
        self.email=email
        self.gender = gender
        self.picture = picture
    }
    
}