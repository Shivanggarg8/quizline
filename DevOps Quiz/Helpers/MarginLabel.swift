//
//  MarginLabel.swift
//  Sales Force Management
//
//  Created by Shivang Garg on 20/09/17.
//  Copyright © 2017 Decimal Technologies Private Limited. All rights reserved.
//

import UIKit

class MarginLabel: UILabel {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }
    
    
}
