//
//  Util.swift
//  Emoiste
//
//  Created by David Hevilla Garcia on 19/1/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import Foundation

class Util {
    
    class func userToObject(dict: NSDictionary) -> User {
        
        let user = User()
        
        if let userID = dict.objectForKey("userID") as? String {
            user.userID =  userID
        } else {
            user.userID = ""
        }
        if let nickName = dict.objectForKey("nickName") as? String {
            user.nickName =  nickName
        } else {
            user.nickName = ""
        }
        if let email = dict.objectForKey("email") as? String {
            user.email =  email
        } else {
            user.email = ""
        }
        if let fullName = dict.objectForKey("fullName") as? String {
            user.fullName =  fullName
        } else {
            user.fullName = ""
        }
        if let country = dict.objectForKey("country") as? String {
            user.country =  country
        } else {
            user.country = ""
        }
        if let gender = dict.objectForKey("gender") as? String {
            user.gender =  gender
        } else {
            user.gender = ""
        }
        if let myStyle = dict.objectForKey("myStyle") as? String {
            user.myStyle =  myStyle
        } else {
            user.myStyle = ""
        }
        if let isBlogger = dict.objectForKey("isBlogger") as? String {
            user.isBlogger =  isBlogger
        } else {
            user.isBlogger = ""
        }
        if let rememberMe = dict.objectForKey("rememberMe") as? String {
            user.rememberMe =  rememberMe
        } else {
            user.rememberMe = ""
        }
        if let picture = dict.objectForKey("picture") as? String {
            user.picture =  picture
        } else {
            user.picture = ""
        }
        if let aboutYou = dict.objectForKey("aboutYou") as? String {
            user.aboutYou =  aboutYou
        } else {
            user.aboutYou = ""
        }
        if let location = dict.objectForKey("location") as? String {
            user.location =  location
        } else {
            user.location = ""
        }
        if let birthDate = dict.objectForKey("birthDate") as? String {
            user.birthDate =  birthDate
        } else {
            user.birthDate = ""
        }
        if let notifications = dict.objectForKey("notifications") as? String {
            user.notifications =  notifications
        } else {
            user.notifications = ""
        }
        if let blog = dict.objectForKey("blog") as? String {
            user.blog =  blog
        } else {
            user.blog = ""
        }
        if let loginFacebook = dict.objectForKey("loginFacebook") as? String {
            user.loginFacebook =  loginFacebook
        } else {
            user.loginFacebook = ""
        }
        if let loginGPlus = dict.objectForKey("loginGPlus") as? String {
            user.loginGPlus =  loginGPlus
        } else {
            user.loginGPlus = ""
        }
        if let twitter = dict.objectForKey("twitter") as? String {
            user.twitter =  twitter
        } else {
            user.twitter = ""
        }
        if let created = dict.objectForKey("created") as? String {
            user.created =  created
        } else {
            user.created = ""
        }
        if let userType = dict.objectForKey("userType") as? String {
            user.userType =  userType
        } else {
            user.userType = ""
        }
        if let deviceType = dict.objectForKey("deviceType") as? String {
            user.deviceType =  deviceType
        } else {
            user.deviceType = ""
        }
        if let deviceOS = dict.objectForKey("deviceOS") as? String {
            user.deviceOS =  deviceOS
        } else {
            user.deviceOS = ""
        }
        if let sessionRemember = dict.objectForKey("sessionRemember") as? String {
            user.sessionRemember =  sessionRemember
        } else {
            user.sessionRemember = ""
        }
        if let notiNewFollowMe = dict.objectForKey("notiNewFollowMe") as? String {
            user.notiNewFollowMe =  notiNewFollowMe
        } else {
            user.notiNewFollowMe = ""
        }
        if let notiCommentMyTimeline = dict.objectForKey("notiCommentMyTimeline") as? String {
            user.notiCommentMyTimeline =  notiCommentMyTimeline
        } else {
            user.notiCommentMyTimeline = ""
        }
        if let notiShareWithMe = dict.objectForKey("notiShareWithMe") as? String {
            user.notiShareWithMe =  notiShareWithMe
        } else {
            user.notiShareWithMe = ""
        }
        if let notiTrendsetterAddNewItem = dict.objectForKey("notiTrendsetterAddNewItem") as? String {
            user.notiTrendsetterAddNewItem =  notiTrendsetterAddNewItem
        } else {
            user.notiTrendsetterAddNewItem = ""
        }
        if let notiNewTrendsetter = dict.objectForKey("notiNewTrendsetter") as? String {
            user.notiNewTrendsetter =  notiNewTrendsetter
        } else {
            user.notiNewTrendsetter = ""
        }
        if let notiBrandHasNewItem = dict.objectForKey("notiBrandHasNewItem") as? String {
            user.notiBrandHasNewItem =  notiBrandHasNewItem
        } else {
            user.notiBrandHasNewItem = ""
        }
        if let notiNewBrand = dict.objectForKey("notiNewBrand") as? String {
            user.notiNewBrand =  notiNewBrand
        } else {
            user.notiNewBrand = ""
        }
        if let pasosConfiguracion = dict.objectForKey("pasosConfiguracion") as? String {
            user.pasosConfiguracion =  pasosConfiguracion
        } else {
            user.pasosConfiguracion = ""
        }
        if let userTypeDesc = dict.objectForKey("userTypeDesc") as? String {
            user.userTypeDesc =  userTypeDesc
        } else {
            user.userTypeDesc = ""
        }
        if let genderDesc = dict.objectForKey("genderDesc") as? String {
            user.genderDesc =  genderDesc
        } else {
            user.genderDesc = ""
        }
        if let activateDesc = dict.objectForKey("activateDesc") as? String {
            user.activateDesc =  activateDesc
        } else {
            user.activateDesc = ""
        }
        if let influencerName = dict.objectForKey("influencerName") as? String {
            user.influencerName =  influencerName
        } else {
            user.influencerName = ""
        }
        if let followMeCount = dict.objectForKey("followMeCount") as? String {
            user.followMeCount =  followMeCount
        } else {
            user.followMeCount = ""
        }
        
        return user
    }
    
}
