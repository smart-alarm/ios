//
//  HTTP.swift
//  Smart Alarm
//
//  Created by Gideon I. Glass on 9/21/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//
//  func post(url: String, body: NSMutableDictionary, callBack : (success: Bool, response: String) -> ()) was written with assistance of:
//  http://jamesonquave.com/blog/making-a-post-request-in-swift/

import UIKit

class HTTP: NSObject {
    
    func get(url: String, getCompleted: (succeeded: Bool, msg: String) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            (data, response, error) in
            
            // If no error occurred during server request
            if error == nil {
                // Parse the response
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    if let parseJSON = json {
                        let status = parseJSON["status"] as! NSString
                        print(status as String)
                        if (status as String == "Login successful!") {
                            getCompleted(succeeded: true, msg:"Successful login")
                        } else {
                            getCompleted(succeeded: false, msg:"Failed login")
                        }
                    }
                }
                catch {
                    print("Error parsing JSON")
                }
            }
                
            else {
                print(error)
                getCompleted(succeeded: false, msg: "Error occurred in get request")

            }
        })
        
        task.resume()
    }
    
    func post (params: Dictionary<String,String>, url: String, postCompleted: (succeeded: Bool, msg: String) -> ()) {
        // Set up request object
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        do {
            let body = ["user": params]
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    if let parseJSON = json {
                        let status = parseJSON["status"] as! NSString
                        print(status as String)
                        postCompleted(succeeded: true, msg:"Success")
                    }
                    else {
                        print("Failed to find key")
                        postCompleted(succeeded: false, msg:"Failed")
                    }
                }
                    
                catch {
                    print("Failed to parse response")
                    postCompleted(succeeded: false, msg:"Failed")
                }
                
            })
            task.resume()
        }
            
        catch {
            print("Failed to convert reponse to dictionary")
            postCompleted(succeeded: false, msg:"Failed")
        }
        
    }
    
}