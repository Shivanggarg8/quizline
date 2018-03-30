//
//  NSAConnection.swift
//  Anti Dopping
//
//  Created by Shivang Garg on 12/09/17.
//  Copyright © 2017 Next Step Apps. All rights reserved.
//

import UIKit

class NSAConnection: NSObject, URLSessionDelegate {
    
    
    //MARK: - Property
    static let BaseUrl = "http://128.136.227.185:9002/"
    
    
    
    //MARK: - Exposed methods
    static func getServerResponse(forAPI apiName: String, withDictionary requestDict:Dictionary<String, Any>?, completionHandler callback:@escaping (_ success: Bool,_ responseDict: Dictionary<String, Any>?, _ message: String) -> ()) -> Void
    {
        //Creating the absolute URl for the API
        let apiURL = NSAConnection.BaseUrl + apiName
        
        //Creating the request
        var request = URLRequest.init(url: URL.init(string: apiURL)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let requestBody = NSAConnection.convertToJSON(payload: requestDict as AnyObject)
        {
            NSLog("Request from server = \(requestBody)")
            request.httpBody = requestBody.data(using: String.Encoding.utf8.rawValue)
            request.httpMethod = "Post"
            
            //Creating session
            let sessionConfig = URLSessionConfiguration.default
            let newSession = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
            let task = newSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                
                if  let res = response as? HTTPURLResponse
                {
                    if res.statusCode == 200
                    {
                        do {
                            NSLog("Server Respnse = \(NSString.init(data: data!, encoding: String.Encoding.utf8.rawValue))")
                            let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                            
                            if let _ = (JSONResponse as? Dictionary<String, Any>) {
                                callback(true, JSONResponse as? Dictionary<String, Any>, "")
                            }
                            else {
                                callback(false, JSONResponse as? Dictionary<String, Any>, (JSONResponse as? Dictionary<String, Any>)?["message"] as! String)
                            }
                            
                        } catch {
                            callback(false, nil, "Invalid JSON in response")
                        }
                    }
                }
                else
                {
                    
                    NSLog(error.debugDescription)
                    callback(false, nil, (error?.localizedDescription)!)
                }
                
            })
            
            task.resume()
        }
        else
        {
            fatalError("Invalid Request Data")
        }
        
    }
    
    
    
    //MARK: - Exposed methods
    static func getServerResponse(ofType requestType:RequestType, forAPI apiName: String, withDictionary requestDict:Dictionary<String, Any>?, completionHandler callback:@escaping (_ success: Bool,_ responseDict: Dictionary<String, Any>?, _ message: String) -> ()) -> Void
    {
        //Creating the absolute URl for the API
        let apiURL = NSAConnection.BaseUrl + apiName
        
        //Creating the request
        var request = URLRequest.init(url: URL.init(string: apiURL)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requestDict != nil {
            if let requestBody = NSAConnection.convertToJSON(payload: requestDict as AnyObject) {
                request.httpBody = requestBody.data(using: String.Encoding.utf8.rawValue)
            }
            else {
                fatalError("Invalid JSON for the request")
            }
        }
        
        
        //Setting request type
        request.httpMethod = requestType.rawValue
        
        //Creating session
        let sessionConfig = URLSessionConfiguration.default
        let newSession = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        let task = newSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            
            if  let res = response as? HTTPURLResponse
            {
                if res.statusCode == 200
                {
                    do {
                        
                        let JSONResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        callback(true, JSONResponse as? Dictionary<String, Any>, "")
                        
                        
                    } catch {
                        callback(false, nil, "Invalid JSON in response")
                    }
                }
            }
            else
            {
                
                NSLog(error.debugDescription)
                callback(false, nil, (error?.localizedDescription)!)
            }
            
        })
        
        task.resume()
        
        
    }
    
    
    
    //MARK: - URLSession Delegates
    func connection(connection: NSURLConnection, canAuthenticateAgainstProtectionSpace protectionSpace: URLProtectionSpace) -> Bool{
        print("canAuthenticateAgainstProtectionSpace method Returning True")
        return true
    }
    
    
    func connection(connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: URLAuthenticationChallenge){
        
        print("did autherntcationchallenge = \(challenge.protectionSpace.authenticationMethod)")
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust  {
            print("send credential Server Trust")
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            
            challenge.sender!.use(credential, for: challenge)
            
        }else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodHTTPBasic{
            print("send credential HTTP Basic")
            let defaultCredentials: URLCredential = URLCredential(user: "username", password: "password", persistence:URLCredential.Persistence.forSession)
            challenge.sender!.use(defaultCredentials, for: challenge)
            
        }else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodNTLM{
            print("send credential NTLM")
            
        } else{
            challenge.sender!.performDefaultHandling!(for: challenge)
        }
    }
    
    
    
    
    
    //MARK: - JSON Converter
    static func convertToJSON(payload: AnyObject?) -> NSString? {
        do {
            if payload != nil {
                //convert payload to JSON format
                let payloadJSONData = try JSONSerialization.data(withJSONObject: payload as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
                //JSON input string
                let JSONInput = NSString(data: payloadJSONData, encoding: String.Encoding.utf8.rawValue)!
                // print("payload:: \(JSONInput.description)")
                return JSONInput
            }
            else {
                return nil
            }
        } catch {
            return nil
        }
    }

}
