//
//  AlarmTableViewCell.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 10/26/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var alarmTime: UILabel!
    @IBOutlet weak var alarmDestination: UILabel!
    @IBOutlet weak var alarmToggle: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.alarmToggle.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func stateChanged(switchState: UISwitch) {
        if switchState.on {
            alarmTime.textColor = UIColor.blackColor()
            alarmDestination.textColor = UIColor.blackColor()
        } else {
            alarmTime.textColor = UIColor.lightGrayColor()
            alarmDestination.textColor = UIColor.lightGrayColor()
        }
    }
    
    

}
