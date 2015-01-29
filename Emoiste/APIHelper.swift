//
//  APIHelper.swift
//  Emoiste
//
//  Created by Francisco Caro Diaz on 29/01/15.
//  Copyright (c) 2015 Emoiste. All rights reserved.
//

import Foundation

class APIHelper {
    
    
    typealias ObjectHandler = (AnyObject! , Bool!) -> Void
    class func callAPIUser(method:String , parameters:AnyObject, completionHandler: ObjectHandler!)
    {
        var str:String = ""
        let path = PATH_WS_USER;
        let baseURL = NSURL(string: path)
        
        let manager = AFHTTPRequestOperationManager(baseURL: baseURL)
        let jsonResponseSerializer = AFJSONResponseSerializer()
        jsonResponseSerializer.stringEncoding = NSUTF8StringEncoding
        manager.responseSerializer = jsonResponseSerializer
        
        manager.POST(method,
            parameters: parameters,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                
                if (responseObject != nil) {
                    completionHandler(responseObject,false)
                } else {
                    str = "Error, responseObject is null"
                    completionHandler("Error",true)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                str = "Error: \(error.localizedDescription)"
                completionHandler("Error",true)
        })
    }
}