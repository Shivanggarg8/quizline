//
//  FrontMarginTextField.swift
//  Sales Force Management
//
//  Created by Shivang Garg on 15/09/17.
//  Copyright © 2017 Decimal Technologies Private Limited. All rights reserved.
//

import UIKit

class FrontMarginTextField: UITextField {

    override func draw(_ rect: CGRect) {

    }
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
}
