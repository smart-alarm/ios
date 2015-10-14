//
//  TextField.swift
//  smart-alarm
//
//  Created by Gideon I. Glass on 10/14/15.
//  Copyright © 2015 Gideon I. Glass. All rights reserved.
//

import UIKit

@IBDesignable
class TextField: UITextField {

    @IBInspectable var inset: CGFloat = 0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
}
