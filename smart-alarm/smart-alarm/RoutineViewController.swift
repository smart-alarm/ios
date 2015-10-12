//
//  RoutineViewController.swift
//  Smart Alarm
//
//  Created by Gideon I. Glass on 9/21/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit

class RoutineViewController: UIViewController {
    @IBOutlet weak var breakfastField: UITextField!
    @IBOutlet weak var exerciseField: UITextField!
    @IBOutlet weak var showerField: UITextField!
    @IBOutlet weak var otherField: UITextField!
    @IBOutlet weak var saveRoutineButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up user defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        if let breakfast = defaults.stringForKey("breakfast") {
            breakfastField.text = breakfast
        }
        if let exercise = defaults.stringForKey("exercise") {
            exerciseField.text = exercise
        }
        if let shower = defaults.stringForKey("shower") {
            showerField.text = shower
        }
        if let other = defaults.stringForKey("other") {
            otherField.text = other
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveRoutine(sender: UIButton) {
        //Save the text fields to user defaults
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(breakfastField.text, forKey: "breakfast")
        defaults.setObject(exerciseField.text, forKey: "exercise")
        defaults.setObject(showerField.text, forKey: "shower")
        defaults.setObject(otherField.text, forKey: "other")
        view.endEditing(true)
    }

    @IBAction func onDidEndOnExit(sender: AnyObject) {
        //Dismisses keyboard
    }
}
