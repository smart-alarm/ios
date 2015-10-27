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
    }
    
    @IBAction func nextKeyEmail(sender: UITextField) {
        sender.resignFirstResponder()
        passwordField.becomeFirstResponder()
    }
    
    
    @IBAction func nextKeyPassword(sender: UITextField) {
        sender.resignFirstResponder()
        passwordVerifyField.becomeFirstResponder()
    }
    
    @IBAction func doneKey(sender: UITextField) {
        sender.resignFirstResponder()
        registerUser(registerButton)
    }
    
    func signUp () {
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
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    // Save the text fields to user defaults
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(self.emailField.text, forKey: "email")
                    defaults.setObject(self.passwordField.text, forKey: "password")
                    self.view.endEditing(true)
                    
                    self.delegate?.registerInfo(self.emailField.text!, password: self.passwordField.text!)
                    self.dismissViewControllerAnimated(true, completion: {})
                    self.loading.stopAnimating()
                    self.registerButton.enabled = true
                }
                
            } else {
                print("Failed to post to server")
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.loading.stopAnimating()
                    self.registerButton.enabled = true
                    self.failedRegistration(msg)
                }
            }
        })
    }
    
    @IBAction func registerUser(sender: UIButton) {
        loading.startAnimating()
        registerButton.enabled = false
        
        if (emailField.text != "" && passwordField.text == passwordVerifyField.text && passwordVerifyField.text != ""){
            signUp()
        } else {
            invalidPassword()
            loading.stopAnimating()
            registerButton.enabled = true
        }
    }
    
    @IBAction func cancelRegistration(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: {})
    }
    
    func failedRegistration(status: String) {
        let alertController = UIAlertController(title: "Registration Failed!", message: status, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func invalidPassword() {
        let alertController = UIAlertController(title: "Try again!", message: "Password fields do not match.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
