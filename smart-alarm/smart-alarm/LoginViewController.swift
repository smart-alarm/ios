//
//  LoginViewController.swift
//  Smart Alarm
//
//  Created by Gideon I. Glass on 9/21/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, RegisterViewControllerDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let email = defaults.stringForKey("email") {
            emailField.text = email
        }
        if let password = defaults.stringForKey("password") {
            passwordField.text = password
        }
        
        if (emailField.text == "" || passwordField == "") {
            signInButton.enabled = false;
        } else {
            signInButton.enabled = true
        }
        
        
        // TODO: Fix the leftview icons
//        // Set email icon
//        let emailImageView = UIImageView()
//        emailImageView.alpha = 0.5
//        let emailIcon = UIImage(named: "email")
//        emailImageView.image = emailIcon
//        emailImageView.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
//        emailField.leftView = emailImageView
//        emailField.leftViewMode = UITextFieldViewMode.Always
//        
//        // Password icon
//        let passwordImageView = UIImageView()
//        passwordImageView.alpha = 0.5
//        let passwordIcon = UIImage(named: "password")
//        passwordImageView.image = passwordIcon
//        passwordImageView.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
//        passwordField.leftView = passwordImageView
//        passwordField.leftViewMode = UITextFieldViewMode.Always

        
        
        
        
    }
    
    @IBAction func nextKey(sender: UITextField) {
        emailField.resignFirstResponder()
        passwordField.becomeFirstResponder()
    }
    
    @IBAction func doneKey(sender: UITextField) {
        sender.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func verifyLogin(sender: UITextField) {
        if (emailField.text != "" && passwordField != ""){
            signInButton.enabled = true;
        } else {
            signInButton.enabled = false;
        }
    }
    
    @IBAction func signIn(sender: UIButton) {
        // Check if valid username and password
        let email = emailField.text
        let password = passwordField.text
        
        let baseUrl = "https://smart-alarm-server.herokuapp.com/users/authenticate?"
        let url = baseUrl + "email=" + email! + "&password=" + password!
        
        let http = HTTP()
        http.get(url, getCompleted: {
            (succeeded: Bool, msg: String) -> () in
            if (succeeded) {
                print("Successful login!")
                
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.performSegueWithIdentifier("signIn", sender: self)
                }
                
            } else {
                print("Failed to login.")
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.failedLogin()
                }
            }

        })
    }
    
    func failedLogin() {
        let alertController = UIAlertController(title: "Login Failed!", message: "Enter valid email/password", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signUp(sender: UIButton) {
        performSegueWithIdentifier("signUp", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signUp" {
            if let registerModal = segue.destinationViewController as? RegisterViewController{
                registerModal.delegate = self
            }
        }
    }
    
    func registerInfo(email: String!, password: String!) {
        print("BACK!")
        emailField.text = email
        passwordField.text = password
        signInButton.enabled = true
    }
}

