//
//  HTTP.swift
//  Smart Alarm
//
//  Created by Gideon I. Glass on 9/21/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit

class HTTP: NSObject {
    
    func post(){
        
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
