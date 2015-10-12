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
    @IBOutlet weak var cancelButton: UIButton!
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
        let userDict: NSMutableDictionary = NSMutableDictionary()
        userDict.setValue(emailField.text, forKey: "email")
        userDict.setValue(passwordField.text, forKey: "password")
        userDict.setValue(passwordVerifyField.text, forKey: "password_confirmation")
        
        let jsonDict: NSMutableDictionary = NSMutableDictionary()
        jsonDict.setValue(userDict, forKey: "user")
        
        let http = HTTP()
        let params:[String:String] = [
            "email": emailField.text!,
            "password": passwordField.text!,
            "password_confirmation": passwordVerifyField.text!
        ]
        
        http.post(params, url: "https://smart-alarm-server.herokuapp.com/users/create", postCompleted: {
            (succeeded: Bool, msg: String) -> () in
            
            if (succeeded) {
                print("Successful post to server")
                
                // Save the text fields to user defaults
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(self.emailField.text, forKey: "email")
                defaults.setObject(self.passwordField.text, forKey: "password")
                self.view.endEditing(true)
                
                self.delegate?.registerInfo(self.emailField.text!, password: self.passwordField.text!)
                self.dismissViewControllerAnimated(true, completion: {})
            } else {
                print("Failed to post to server")
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.failedRegistration()
                }
            }
        })
    }
    
    @IBAction func cancelRegistration(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: {})
    }
    
    func failedRegistration() {
        let alertController = UIAlertController(title: "Registration Failed!", message: "Enter valid email/password", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
