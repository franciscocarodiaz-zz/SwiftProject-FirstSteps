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
    var userID : String?
    var nickName : String?
    var email: String?
    var fullName: String?
    var country: String?
    var gender: String?
    var myStyle: String?
    var isBlogger: String?
    var rememberMe: String?
    var picture: String?
    var aboutYou: String?
    var location: String?
    var birthDate: String?
    var notifications: String?
    var blog: String?
    var loginFacebook: String?
    var loginGPlus: String?
    var twitter: String?
    var created: String?
    var userType: String?
    var deviceType: String?
    var deviceOS: String?
    var sessionRemember: String?
    var notiNewFollowMe: String?
    var notiCommentMyTimeline: String?
    var notiShareWithMe: String?
    var notiTrendsetterAddNewItem: String?
    var notiNewTrendsetter: String?
    var notiBrandHasNewItem: String?
    var notiNewBrand: String?
    var pasosConfiguracion: String?
    var userTypeDesc: String?
    var genderDesc: String?
    var activateDesc: String?
    var influencerName: String?
    var followMeCount: String?
    
    init () {}
    
    init(userID:String, nickName:String, email:String, gender:String, picture:String){
        self.userID = userID
        self.nickName = nickName
        self.email=email
        self.gender = gender
        self.picture = picture
    }
}