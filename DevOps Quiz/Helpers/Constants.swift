//
//  Constants.swift
//  Sales Force Management
//
//  Created by Shankar Kumar on 08/09/17.
//  Copyright © 2017 Decimal Technologies Private Limited. All rights reserved.
//

import Foundation
import UIKit


enum AlertType: String {
    case Success = "Success"
    case Alert = "Alert"
    case Failure = "Failure"
    case Information = "Information"
    case Error = "Error"
}


let WorkSansBold = "WorkSans-Bold"
let WorkSansSemiBold = "WorkSans-SemiBold"
let ApplicationVersionKey = "ApplicationVersion"
let PlatwareConfigurationVersion = 1.0
let PlatwareConfigurationVersionKey = "PlatwareConfigurationVersionKey"
let UserAuthenticatedKey = "UserAuthenticated"
let PlatwareConfiguration = "Platware Configuration"
let IncentiveBasicInformation = "Incentive Basic Information"
let KRABasicInformation = "KRA Basic Information"
let IncentiveProductsList = "Incentive Products List"
let IncentiveDetailInformation = "Incentive Detail Information"
let mLearningTypes = "mLearning Types"
let employeeHierarchy = "Employee Hierarchy"
let mLearningProductMaster = "mLearning Product Master"

let MonthsInformationDictionary:[String: String] = ["4":"Apr", "5":"May", "6":"Jun", "7":"Jul", "8":"Aug", "9":"Sep", "10":"Oct", "11":"Nov", "12":"Dec", "1":"Jan", "2":"Feb", "3":"Mar"]
let blankListMessage: String = "No data found"

extension NSURL {
        
    static var PlatwareURL: String {
        
        return "http://128.136.227.187/pw_sfm"
    }
    
}



extension UIFont {
    
    static var Bold: String { return "WorkSans-Bold" }
    static var ExtraBold: String { return "WorkSans-ExtraBold" }
    static var ExtraLight: String { return "WorkSans-ExtraLight" }
    static var HairLine: String { return "WorkSans-Hairline" }
    static var Light: String { return "WorkSans-Light" }
    static var Medium: String { return "WorkSans-Medium" }
    static var Regular: String { return "WorkSans-Regular" }
    static var SemiBold: String { return "WorkSans-SemiBold" }
    static var Thin: String { return "WorkSans-Thin" }

    
}


extension String {
    
    //MARK: - URL decoding encoding for handling unusual charecters in url string
    func encodeUrlString() -> String {
        let removedEncoding: String = self.removingPercentEncoding ?? ""
        let encodedString: String = removedEncoding.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
        return encodedString
    }
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

extension NSAttributedString {
    
    //MARK: - For converting html text into attributed text
    static func getAttributedStringFrom(htmlString string:String) -> NSAttributedString {
        
        do {
            return try NSAttributedString(data: (string.data(using: .utf8))!, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString.init(string: "")
        }
    }
}

extension Int {
    
    //Conversion of Seconds to Hour Minute Second
    func secondsToHoursMinutesSeconds () -> (hour: Int,minute: Int,second: Int) {
        return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    }
    
    //Conversion of Hour Minute Second to Second
    static func hoursMinutesSecondsToSeconds(hours hour:Int, minutes minute:Int, seconds second:Int) -> Int {
        return hour * 3600 + minute * 60 + second
    }
}


extension UIViewController {
    
    //MARK: - Progress Loaders
    func showProgressLoader() -> Void {
        
        //Showing loader on main thread
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
    }
    
    
    func hideProgressLoader() -> Void {
        
        //Hiding loader on main thread
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
    }
    
    
    func showAlert(withMessage message: String, alertType type: AlertType) -> Void {
        
        DispatchQueue.main.async {
            let alert: UIAlertController = UIAlertController.init(title: type.rawValue, message: message, preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: { (action) in
                
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showInteractiveAlert(withMessage message: String, alertType type:AlertType,userActions actions:[UIAlertAction]?) {
        DispatchQueue.main.async {
            let alert: UIAlertController = UIAlertController.init(title: type.rawValue, message: message, preferredStyle: .alert)
            for action in actions ?? [] {
                alert.addAction(action)
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


extension UIColor {
    static func rgb(_ red: Float, green: Float, blue: Float, alpha: Float) -> UIColor {
        return UIColor.init(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: CGFloat(alpha))
    }
    
    static var appBlueColor: UIColor {
        get {
            return self.rgb(6, green: 57, blue: 116, alpha: 1.0)
        }
    }
    
    static var appLightGreyColor: UIColor {
        get {
            return self.rgb(216, green: 216, blue: 216, alpha: 1.0)
        }
    }
    
    static var appDarkTextColor: UIColor {
        get {
            return self.rgb(51, green: 51, blue: 51, alpha: 1.0)
        }
    }
    
    static var appBorderDarkColor: UIColor {
        get {
            return self.rgb(185, green: 185, blue: 185, alpha: 1.0)
        }
    }
    
    static var appMahroonColor: UIColor {
        get {
            return self.rgb(131, green: 38, blue: 37, alpha: 1.0)
        }
    }
    
    static var quizCorrectAnswerColor: UIColor {
        get {
            return self.rgb(204, green: 255, blue: 202, alpha: 1.0)
        }
    }
    
    static var quizIncorrectAnswerColor: UIColor {
        get {
            return self.rgb(255, green: 204, blue: 202, alpha: 1.0)
        }
    }
    
    static var quizAttemptAnswerColor: UIColor {
        get {
            return self.rgb(231, green: 214, blue: 179, alpha: 1.0)
        }
    }
    
    static var quizUnattemptAnswerColor: UIColor {
        get {
            return self.rgb(212, green: 212, blue: 212, alpha: 1.0)
        }
    }
}


extension UIView {
    
    
    func makeViewCornerRoundedAndShadow(ofRadius radius: CGFloat)
    {
        let plane: CALayer = self.layer;
        plane.cornerRadius = radius;
        plane.shadowOpacity = 0.5;
        plane.shadowRadius = 10.0;
        plane.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        
    }
    
    
    func makeViewCornerRoundedAndLowShadow(ofRadius radius: CGFloat)
    {
        let plane: CALayer = self.layer;
        plane.cornerRadius = radius;
        plane.shadowOpacity = 0.1;
        plane.shadowRadius = 5.0;
        plane.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        
    }
    
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) -> Void {
        
        let bounds: CGRect  = self.bounds;
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radius, height: radius))
        
        let maskLayer: CAShapeLayer = CAShapeLayer.init()
        maskLayer.frame = bounds;
        maskLayer.path = maskPath.cgPath;
        
        self.layer.mask = maskLayer;
        
        let frameLayer: CAShapeLayer = CAShapeLayer.init()
        frameLayer.frame = bounds;
        frameLayer.path = maskPath.cgPath;
        frameLayer.strokeColor = UIColor.red.cgColor;
        frameLayer.fillColor = nil;
        self.layer.addSublayer(frameLayer)
    }
    
    
}

enum GraphMode {
    case incentive
    case kra
}

enum ApplicationMode {
    case sit
    case uat
    case production
}

enum QuizQuestionStatus {
    case attempt
    case unattempt
    case correct
    case incorrect
    case skip
}

enum QuizMode {
    case test
    case review
}

enum RequestType: String {
    case post = "POST"
    case get = "GET"
}
