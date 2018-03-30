//
//  FloatLabelTextField.swift
//  FloatLabelFields
//
//  Created by Fahim Farook on 28/11/14.
//  Copyright (c) 2014 RookSoft Ltd. All rights reserved.


import UIKit
@IBDesignable class FloatLabelTextField: UITextField, UITextFieldDelegate {
    
    
	let animationDuration = 0.3
	var title = UILabel()
	
	// MARK:- Properties
	override var accessibilityLabel:String? {
		get {
			if let txt = text, txt.isEmpty {
				return title.text
			} else {
				return text
			}
		}
		set {
			self.accessibilityLabel = newValue
		}
	}
	
	override var placeholder:String? {
		didSet {
			title.text = placeholder
			title.sizeToFit()
		}
	}
	
	override var attributedPlaceholder:NSAttributedString? {
		didSet {
			title.text = attributedPlaceholder?.string
			title.sizeToFit()
		}
	}
	
	var titleFont:UIFont = UIFont.systemFont(ofSize: 12.0) {
		didSet {
			title.font = titleFont
			title.sizeToFit()
		}
	}
	
	@IBInspectable var hintYPadding:CGFloat = 0.0

	@IBInspectable var titleYPadding:CGFloat = -16.0 {
		didSet {
			var r = title.frame
			r.origin.y = titleYPadding
			title.frame = r
		}
	}
	
//	@IBInspectable var titleTextColour:UIColor = UIColor(hex: "ec6726"){
//		didSet {
//			if !isFirstResponder {
//				title.textColor = titleTextColour
//			}
//		}
//	}
	
	@IBInspectable var titleActiveTextColour:UIColor! {
		didSet {
			if isFirstResponder {
				title.textColor = titleActiveTextColour
			}
		}
	}
		
	// MARK:- Init
	required init?(coder aDecoder:NSCoder) {
		super.init(coder:aDecoder)
		setup()
	}
	
	override init(frame:CGRect) {
		super.init(frame:frame)
		setup()
	}
	
	// MARK:- Overrides
	override func layoutSubviews() {
		super.layoutSubviews()
		setTitlePositionForTextAlignment()
		let isResp = isFirstResponder
		if let txt = text, !txt.isEmpty && isResp {
			title.textColor = titleActiveTextColour
		} else {
//			title.textColor = titleTextColour
		}
		// Should we show or hide the title label?
		if let txt = text, txt.isEmpty {
			// Hide
			hideTitle(animated: isResp)
		} else {
			// Show
			showTitle(animated: isResp)
		}
	}
	
	override func textRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.textRect(forBounds: bounds)
		if let txt = text, !txt.isEmpty {
			var top = ceil(title.font.lineHeight + hintYPadding)
		//	top = min(top, maxTopInset())
            if top >= maxTopInset()
            {
                top = maxTopInset()
            }
			r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
		}
		return r.integral
	}
	
	override func editingRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.editingRect(forBounds: bounds)
		if let txt = text, !txt.isEmpty {
			var top = ceil(title.font.lineHeight + hintYPadding)
			
       //     top = min(top, maxTopInset())
            if top >= maxTopInset()
            {
                top = maxTopInset()
            }
			r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
		}
		return r.integral
	}
	
	override func clearButtonRect(forBounds bounds:CGRect) -> CGRect {
		var r = super.clearButtonRect(forBounds: bounds)
		if let txt = text, !txt.isEmpty {
			var top = ceil(title.font.lineHeight + hintYPadding)
			//top = min(top, maxTopInset())
            if top >= maxTopInset()
            {
                top = maxTopInset()
            }
			r = CGRect(x:r.origin.x, y:r.origin.y + (top * 0.5), width:r.size.width, height:r.size.height)
		}
		return r.integral
	}
	
	// MARK:- Public Methods
	
	// MARK:- Private Methods
	private func setup() {
		borderStyle = UITextBorderStyle.none
//		titleActiveTextColour = UIColor(hex: "ec6726")//tintColor
		// Set up title label
		title.alpha = 0.0
		title.font = titleFont
//		title.textColor = titleTextColour
		if let str = placeholder, !str.isEmpty {
			title.text = str
			title.sizeToFit()
		}
		self.addSubview(title)
	}

	private func maxTopInset()->CGFloat {
		if let fnt = font {
			return max(0, floor(bounds.size.height - fnt.lineHeight - 4.0))
		}
		return 0
	}
	
	private func setTitlePositionForTextAlignment() {
		let r = textRect(forBounds: bounds)
		var x = r.origin.x
		if textAlignment == NSTextAlignment.center {
			x = r.origin.x + (r.size.width * 0.5) - title.frame.size.width
		} else if textAlignment == NSTextAlignment.right {
			x = r.origin.x + r.size.width - title.frame.size.width
		}
		title.frame = CGRect(x:x, y:title.frame.origin.y, width:title.frame.size.width, height:title.frame.size.height)
	}
	
	private func showTitle(animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseOut], animations:{
				// Animation
				self.title.alpha = 1.0
				var r = self.title.frame
				r.origin.y = self.titleYPadding
				self.title.frame = r
			}, completion:nil)
	}
	
	private func hideTitle(animated:Bool) {
		let dur = animated ? animationDuration : 0
		UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseIn], animations:{
			// Animation
			self.title.alpha = 0.0
			var r = self.title.frame
			r.origin.y = self.title.font.lineHeight + self.hintYPadding
			self.title.frame = r
			}, completion:nil)
	}
    
    
    
    
    
    //MARK:- Added methods 
    
    var customeDelegate: UITextFieldDelegate?
    var regixString:NSString?
    var errorMessage:NSString?
    
    var maxLength: Int?
    
    var isMandatory: Bool?
    
    override func draw(_ rect: CGRect) {
        self.delegate = self
    }
    
    
    //MARK:- Textfield Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let _ = customeDelegate {
        if(customeDelegate?.responds(to: #selector(UITextFieldDelegate.textFieldDidBeginEditing(_:))))!
        {
            customeDelegate?.textFieldDidBeginEditing!(textField)
        }
        }}


func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    let currentCharacterCount = textField.text?.characters.count ?? 0
    
    let newLength = currentCharacterCount + string.characters.count - range.length
    
    
    if let max = maxLength {
        if(newLength<=max)
        {
            return customeDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
        }else
        {
            return false
        }
    }
    
    return true
    
}
    
    
    var hint: String = ""
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     let  _ = customeDelegate?.textFieldShouldReturn?(textField)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        let _ = customeDelegate?.textFieldDidEndEditing?(textField)
    }
    

    func validate() -> (Bool,NSString)
    {
        
        if let regix = regixString {
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regix)
        if emailTest.evaluate(with: self.text) {
            
            return (true,"")
        }else
        {
            
            return (false,errorMessage ?? "error")
        }
        }
        
        
        return (true,"")

    }

}
