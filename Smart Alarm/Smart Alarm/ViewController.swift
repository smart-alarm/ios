//
//  ViewController.swift
//  Smart Alarm
//
//  Created by Gideon I. Glass on 9/17/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var breakfastTextField: UITextField!
    @IBOutlet weak var showerTextField: UITextField!
    @IBOutlet weak var exerciseTextField: UITextField!
    @IBOutlet weak var otherTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let defaults = NSUserDefaults.standardUserDefaults()
        if let email = defaults.stringForKey("email") {
            emailTextField.text = email
        }
        if let password = defaults.stringForKey("password") {
            passwordTextField.text = password
        }
        if let breakfast = defaults.stringForKey("breakfast") {
            breakfastTextField.text = breakfast
        }
        if let shower = defaults.stringForKey("shower") {
            showerTextField.text = shower
        }
        if let exercise = defaults.stringForKey("exercise") {
            exerciseTextField.text = exercise
        }
        if let other = defaults.stringForKey("other") {
            otherTextField.text = other
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onDidEndOnExit(sender: AnyObject) {
    }
    @IBAction func saveButtonPressed(sender: AnyObject) {
        self.view.endEditing(true)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(emailTextField.text, forKey: "email")
        defaults.setObject(passwordTextField.text, forKey: "password")
        defaults.setObject(breakfastTextField.text, forKey: "breakfast")
        defaults.setObject(showerTextField.text, forKey: "shower")
        defaults.setObject(exerciseTextField.text, forKey: "exercise")
        defaults.setObject(otherTextField.text, forKey: "other")
    }

}

