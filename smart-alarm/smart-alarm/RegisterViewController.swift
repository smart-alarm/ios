//
//  RegisterViewController.swift
//  Smart Alarm
//
//  Created by Gideon I. Glass on 9/21/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit

protocol RegisterViewControllerDelegate {
    func registerInfo(email: String!, password: String!)
}

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordVerifyField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var delegate: RegisterViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerButton.enabled = false;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func verifyPassword(sender: UITextField) {
        if (passwordField.text == passwordVerifyField.text){
            registerButton.enabled = true;
        } else {
            registerButton.enabled = false;
        }
    }

    @IBAction func registerUser(sender: UIButton) {
        // TODO: Get text from fields
        // HTTP POST
//        let url = NSURL(string: "https://api.wunderground.com/api/73b5e3c030b52287/geolookup/conditions/q/IA/Cedar_Rapids.json")!
//        
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
//            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
//        }
//        
//        task.resume()
        let userDict: NSMutableDictionary = NSMutableDictionary()
        userDict.setValue(emailField.text, forKey: "email")
        userDict.setValue(passwordField.text, forKey: "password")
        userDict.setValue(passwordVerifyField.text, forKey: "password_confirmation")
        
        let jsonDict: NSMutableDictionary = NSMutableDictionary()
        jsonDict.setValue(userDict, forKey: "user")
        
        let http = HTTP()
        http.post("https://smart-alarm-server.herokuapp.com/users/create", body: jsonDict, callBack: {
            (success: Bool, message: String) -> () in
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Accept", style: .Cancel, handler: {action in self.dismissViewControllerAnimated(true, completion: nil)}))
            self.presentViewController(alert, animated: true, completion: nil)
        })
        
        // Save the text fields to user defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(emailField.text, forKey: "email")
        defaults.setObject(passwordField.text, forKey: "password")
        view.endEditing(true)

//      loading.startAnimating()
        self.delegate?.registerInfo(emailField.text!, password: passwordField.text!)
//        dismissViewControllerAnimated(true, completion: {})
    }
}
