//
//  DestinationViewController.swift
//  Smart Alarm
//
//  Created by Gideon I. Glass on 9/21/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit
import MapKit

class DestinationViewController: UIViewController {
    @IBOutlet weak var estimatedWakeup: UILabel!
    @IBOutlet weak var destinationMap: MKMapView!
    @IBOutlet weak var arrivalInput: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle dismissing keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectArrivalTime(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Time
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("dateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    func dateChanged(sender: UIDatePicker) {
        // TODO: Call DateUtil function
        // Change label to estimated wakeup time
        let wakeUp = DateUtil.subtractRoutineFromTime(sender.date)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let actual = dateFormatter.stringFromDate(sender.date)
        let estimate = dateFormatter.stringFromDate(wakeUp)
        
        arrivalInput.text = actual
        estimatedWakeup.text = estimate
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
