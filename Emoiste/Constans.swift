//
//  Constans.swift
//  Emoiste
//
//  Created by Juan Manuel Hernandez del Olmo on 19/1/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import Foundation

// ViewController

let VC_HOME = "Home"

// NSUserDefault
let kUSER = "user"
let kLOGIN = "Login"
let kUSER_USERID = "user_userID"
let kUSER_NICKNAME = "user_nickName"
let kUSER_EMAIL = "user_email"
let kUSER_GENDER = "user_gender"
let kUSER_PICTURE = "user_picture"


let USER_DEFAULT = 0
let USER_FACEBOOK = 1
let USER_GOOGLE = 3

// WebService
let PATH_WS = "http://desarrollo-emoiste.appspot.com/"
let PATH_WS_USER = PATH_WS + "s/user/"
let PATH_WS_USER_REGISTER = PATH_WS_USER + "register"

let CLIENT_ID_EMOISTE = "ba3f2adea47b86b0d408de3f7e4d922c"
let DEFAULT_CODE = "EmGuest"
let DEFAULT_COUNTRY = "Canada"

// WebService : Response
let WS_RESPONSE_ELEMENT_DATA = "data"
let WS_RESPONSE_ELEMENT_RESULT = "result"
let WS_RESPONSE_ELEMENT_RESULT_STATUS = "status"
let WS_RESPONSE_ELEMENT_RESULT_MESSAGE = "msg"
let WS_RESPONSE_STATUS_OK = "ok"
let WS_RESPONSE_STATUS_KO = "fail"
let WS_RESPONSE_STATUS_KO_MSG_1 = "A user already exists with this nickname."
let WS_RESPONSE_STATUS_KO_MSG_2 = "A user already exists with this email."

// Google +
let GOOGLE_CLIENT_ID = "698470843790-10u93emn4sb2te6ea215vkcmtdgd7960.apps.googleusercontent.com"


// Variables globales
var TYPE_REGISTER_RRSS : Int!
var USER_DATA : User!


