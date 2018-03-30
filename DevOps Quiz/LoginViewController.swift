//
//  LoginViewController.swift
//  Sales Force Management
//
//  Created by Shivang Garg on 01/09/17.
//  Copyright © 2017 Decimal Technologies Private Limited. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController, UITextFieldDelegate {

    
    
    //MARK: - Outlets
    @IBOutlet weak var usernameTextfield: FloatLabelTextField!
    @IBOutlet weak var passwordTextfield: FloatLabelTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var versionLabel: UILabel!

    
    //MARK: - Property
    var activeTextfield: UITextField? = nil
    var questionsArray: [[String:Any]]? = nil
    
    //MARK: - Viewcontroller Delegate Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Version String
        let appVersionString: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "0.0"
        versionLabel.text = "Version \(appVersionString)"
        
        
        
        intializer {
            self.navigationItem.title = "Quiz"
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Checking if app is in debug mode
        #if DEBUG
            usernameTextfield.text = "TEST01"
            passwordTextfield.text = "TEST"
        #else
            usernameTextfield.text = ""
            passwordTextfield.text = ""
        #endif
        
    }
    
    //MARK: - Initializers
    func intializer(complete:() -> ()) -> Void {
        
        usernameTextfield.customeDelegate = self
        passwordTextfield.customeDelegate = self
        usernameTextfield.autocorrectionType = .no
        usernameTextfield.maxLength = 50
        passwordTextfield.maxLength = 50
        
        
        let hideButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        hideButton.setImage(#imageLiteral(resourceName: "hidePassword"), for: .normal)
        hideButton.setImage(#imageLiteral(resourceName: "showPassword"), for: .selected)
        passwordTextfield.rightViewMode = .always
        passwordTextfield.rightView = hideButton
        hideButton.addTarget(self, action: #selector(hideShow(_:)), for: .touchUpInside)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        complete()
    }
    
    
    
    //MARK: - Textfield Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextfield = textField
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if activeTextfield == usernameTextfield {
            passwordTextfield.becomeFirstResponder()
        }
        else {
            view.endEditing(true)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        else {
            return true
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    @objc func keyboardDidShow(notification: NSNotification) {
        
        if  let info = notification.userInfo {
            
            if var kbRect = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                kbRect = self.view.convert(kbRect, from: nil)
                
                let contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbRect.size.height+10), 0.0)
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets
                
                var aRect = view.frame
                aRect.size.height -= (kbRect.size.height)
                if let tf = activeTextfield {
                    scrollView.scrollRectToVisible(tf.frame, animated: true)
                }
            }
        }
        
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        let contentInset: UIEdgeInsets = .zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        
    }
    
    
    
    //MARK: - Helper Methods
    @objc func hideShow(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        passwordTextfield.isSecureTextEntry = !passwordTextfield.isSecureTextEntry
        
    }
    
    
    //MARK: - Actions
    @IBAction func loginAction(_ sender: UIButton) {

        if self.checkFormValidation() {
            
            self.showProgressLoader()
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                
                let username: String = self.usernameTextfield.text!
                self.checkLogin(withUsername: self.usernameTextfield.text!, andPassword: self.passwordTextfield.text!, completeionHandler: { (success) in
                    
                    if success {

                        NSAConnection.getServerResponse(forAPI:"GETOUESTIONS", withDictionary: ["login_id":username]) { (status, serverResponse, errorMessage) in
                            
                            DispatchQueue.main.async {
                                self.hideProgressLoader()
                                if status {
                                    
                                    
                                    if (serverResponse?["X_RESULT"] as? [[String:Any]])?.count ?? 0 > 0 {
                                        let serverAuthenticationResponse: [[String:Any]]? = serverResponse?["X_RESULT"] as? [[String:Any]]
                                        if let response = serverAuthenticationResponse {
                                            self.questionsArray = response
                                            self.performSegue(withIdentifier: "startQuiz", sender: self)
                                        }
                                        else {
                                            self.showAlert(withMessage: "Server not responding", alertType: .Alert)
                                        }
                                    }
                                    else {
                                        self.showAlert(withMessage: "Server not responding", alertType: .Alert)
                                    }
                                }
                                else {
                                    self.showAlert(withMessage: errorMessage, alertType: .Alert)
                                }
                            }
                        }
                    }
                    
                })

            }
        }
    }

    
    
    
    //MARK: - Server Handlers
    func checkLogin(withUsername username: String, andPassword password: String, completeionHandler complete:@escaping (Bool) -> ()) -> Void {

        
        NSAConnection.getServerResponse(forAPI:"AuthenticatUser", withDictionary: ["login_id":username, "password":password]) { (status, serverResponse, errorMessage) in
            
            if status {
                if (serverResponse?["X_RESULT"] as? [[String:String]])?.count ?? 0 > 0 {
                    let serverAuthenticationResponse: [String:String]? = (serverResponse?["X_RESULT"] as? [[String:String]])?.first
                    if let response = serverAuthenticationResponse {
                        if response["RESPONSE_TYPE"]?.uppercased() == "Y" {
                            complete(true)
                        }
                        else {
                            self.showAlert(withMessage:response["RESPONSE_MESSAGE"] ?? "Invalid credentials", alertType: .Error)
                        }
                    }
                    else {
                        self.showAlert(withMessage: "Server not responding", alertType: .Alert)
                    }
                }
                else {
                    self.showAlert(withMessage: "Server not responding", alertType: .Alert)
                }
            }
            else {
                self.showAlert(withMessage: errorMessage, alertType: .Alert)
            }
            
        }
    }
    
    
    
    
    
    
    //MARK: - Helper
    func checkFormValidation() -> Bool {
        
        if usernameTextfield.text == "" {
            
            let errorAlert: UIAlertController = UIAlertController.init(title: "Error", message: "Please enter username to proceed", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction.init(title: "Dismiss", style: .cancel, handler: { (action) in
                
            })
            errorAlert.addAction(okAction)
            self.present(errorAlert, animated: true, completion: nil)
            return false
        }
        
        if passwordTextfield.text == "" {
            let errorAlert: UIAlertController = UIAlertController.init(title: "Error", message: "Please enter password to proceed", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction.init(title: "Dismiss", style: .cancel, handler: { (action) in
                
            })
            errorAlert.addAction(okAction)
            self.present(errorAlert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startQuiz" {
            let quizViewController: QuizViewController = segue.destination as! QuizViewController
            quizViewController.timeDuration = questionsArray?.count ?? 0
            quizViewController.questionsArray = questionsArray
            quizViewController.userId = self.usernameTextfield.text!
        }
        
    }

}
