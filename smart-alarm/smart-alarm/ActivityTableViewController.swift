//
//  ActivityTableViewController.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 10/18/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit
import MapKit

class ActivityTableViewController: UITableViewController {
    
    @IBOutlet weak var activityName: UITextField!
    @IBOutlet weak var activityTime: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
