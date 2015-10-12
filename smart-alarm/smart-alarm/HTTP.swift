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
    
    func post(url: String, body: NSMutableDictionary, callBack : (success: Bool, response: String) -> ()){
        
        // HTTP POST request
        
        NSLog("%@", body)
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
            request.HTTPBody = jsonBody
            let task = session.dataTaskWithRequest(request, completionHandler: {
                data, response, error -> Void in
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    if let parseJSON = json {
                        let status = parseJSON["status"] as! NSString
                        NSLog(status as String)
                        callBack(success: true, response: status as String)
                    }
                    else {
                        callBack(success: false, response: "HTTP.Swift: Couldn't find status key.")
                    }
                } catch {
                    NSLog("Failed to convert response data into JSON")
                    callBack(success: false, response: "Failed to convert response data into JSON")
                }
            })
            task.resume()
        } catch {
            NSLog("Failed to convert dictionary to JSON")
            callBack(success: false, response: "Failed to convert dictionary to JSON")
        }

    }
    
    func get(URL: String) -> String {
        var result: NSString!
        let url = NSURL(string: URL)!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            result = NSString(data: data!, encoding:
                NSASCIIStringEncoding)!
        }
        
        task.resume()
        return result as String
    }
}
