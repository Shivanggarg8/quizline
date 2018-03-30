//
//  QuizViewScoreViewController.swift
//  Sales Force Management
//
//  Created by Shivang Garg on 30/01/18.
//  Copyright © 2018 Decimal Technologies Private Limited. All rights reserved.
//

import UIKit

class QuizViewScoreViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var percentageTitleLabel: UILabel!



    
    
    //MARK: - Properties
    var productDetails: NSMutableDictionary?
    var quizUserResponseArray:[[String:Any]]?
    var feedbackUserResponseArray: [Any]?
    var itemDetails: NSMutableDictionary?
    var userLocation: String?
    var userId:String?
    
    //MARK: - Viewcontroller Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initializer {
            
            self.showProgressLoader()

            self.submitAnswers(completionHandler: { (status) in
              
                self.getScore(completionHandler: { (status) in
                    DispatchQueue.main.async {
                        self.hideProgressLoader()
                        self.exitButton.isHidden = false
                        self.percentageTitleLabel.isHidden = false
                        self.messageLabel.isHidden = false
                        self.percentageLabel.isHidden = false
                        
                    }
                })
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK: - Initializers
    func initializer(complete: () -> ()) -> Void {
        
        //Initialization code here
        percentageLabel.text = ""
        messageLabel.text = ""
        exitButton.isHidden = true
        percentageTitleLabel.isHidden = true
        self.navigationItem.hidesBackButton = true
        
        self.title = "Score"
        
        complete()
    }
    
    
    //MARK: - Server handlers
    func submitAnswers(completionHandler complete: @escaping (Bool) -> ()) -> Void {
        
        var userResponseArray: [[String:Any]] = [[String:Any]]()
        for response in quizUserResponseArray ?? [] {
            userResponseArray.append(["question_no":response["QUESTION_NO"] as? String ?? "", "answer":response["selectedOptionId"] as? String ?? "", "login_id":userId!])
        }
        
        NSAConnection.getServerResponse(forAPI:"SUBMITOUESTIONS", withDictionary: ["x_questions": userResponseArray]) { (status, serverResponse, errorMessage) in
            
            if status {
                if (serverResponse?["X_RESULT"] as? [[String:Any]])?.count ?? 0 > 0 {
                    let serverAuthenticationResponse: [String:Any]? = (serverResponse?["X_RESULT"] as? [[String:Any]])?.first
                    if let response = serverAuthenticationResponse {
                        if (response["RESPONSE_TYPE"] as? String)?.uppercased() == "Y" {
                            complete(true)
                        }
                        else {
                            self.hideProgressLoader()
                            self.showAlert(withMessage:(response["RESPONSE_MESSAGE"] as? String) ?? "Server Not Responding", alertType: .Error)
                        }
                    }
                    else {
                        self.hideProgressLoader()
                        self.showAlert(withMessage: "Server not responding", alertType: .Alert)
                    }
                }
                else {
                    self.hideProgressLoader()
                    self.showAlert(withMessage: "Server not responding", alertType: .Alert)
                }
            }
            else {
                self.hideProgressLoader()
                self.showAlert(withMessage: errorMessage, alertType: .Alert)
            }
        }
        
    }
    
    func getScore(completionHandler complete: @escaping (Bool) -> ()) -> Void {
    
        NSAConnection.getServerResponse(forAPI:"GETQUIZSCORE", withDictionary: ["login_id": userId!]) { (status, serverResponse, errorMessage) in
            
            if status {
                if (serverResponse?["X_RESULT"] as? [[String:Any]])?.count ?? 0 > 0 {
                    let serverAuthenticationResponse: [String:Any]? = (serverResponse?["X_RESULT"] as? [[String:Any]])?.first
                    if let response = serverAuthenticationResponse {
                        DispatchQueue.main.async {
                            self.messageLabel.text = response["STATUS"] as? String ?? ""
                            self.percentageLabel.text = "\(response["SCORE"]!)"
                            complete(true)
                        }
                    }
                    else {
                        self.hideProgressLoader()
                        self.showAlert(withMessage: "Server not responding", alertType: .Alert)
                    }
                }
                else {
                    self.hideProgressLoader()
                    self.showAlert(withMessage: "Server not responding", alertType: .Alert)
                }
            }
            else {
                self.hideProgressLoader()
                self.showAlert(withMessage: errorMessage, alertType: .Alert)
            }
        }

    }
    
    
    //MARK: - Actions
   @IBAction func retakeQuizButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "startQuiz", sender: self)
    }
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "mLearningSearchedItemListScreen", sender: self)
        self.performSegue(withIdentifier: "mLearningItemlistScreen", sender: self)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }

}
