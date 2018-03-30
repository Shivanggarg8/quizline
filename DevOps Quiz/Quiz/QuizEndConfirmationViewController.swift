//
//  QuizEndConfirmationViewController.swift
//  Sales Force Management
//
//  Created by Shivang Garg on 31/01/18.
//  Copyright © 2018 Decimal Technologies Private Limited. All rights reserved.
//

import UIKit

class QuizEndConfirmationViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var questionsAttemptCountLabel: UILabel!
    
    
    //MARK: - Properties
    var quizDelegate:QuizDelegate?
    var questionsArray: [Any]? = nil {
        didSet {
            
            let attemptedAnswersArray: [Any]? = self.questionsArray?.filter({ (question) -> Bool in
                return ((question as! [String: Any])["selectedOptionId"] as? String) ?? "" != ""
            })
            questionsAttemptCountLabel.text = "\(attemptedAnswersArray?.count ?? 0)/\(self.questionsArray?.count ?? 0)"
        }
    }
    
    
    //MARK: - Viewcontroller Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializer {
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK: - Initializers
    func initializer(complete: () -> ()) -> Void {
        
        //Initialization code here

        //Notification Observer added for change in question attempt status
        NotificationCenter.default.addObserver(self, selector: #selector(questionAttemptStatus(_ :)), name: NSNotification.Name.init("changeQuestionAttemptStatus"), object: nil)
        
        complete()
    }
    
    //MARK: - Actions
    @IBAction func yesButtonPressed(_ sender: UIButton) {
        quizDelegate?.completeQuiz()
    }
    
    @IBAction func noButtonPressed(_ sender: UIButton) {
        quizDelegate?.quizCompletionCancelled()
    }
    
    //MARK: - Helper
    @objc func questionAttemptStatus(_ sender:Notification) -> Void {
        
        DispatchQueue.main.async {
            let userInfo: [String: Any]? = sender.userInfo as? [String: Any]
            let questionsArray: [Any]? = userInfo?["questionsArray"] as? [Any]
            let attemptedAnswersArray: [Any]? = questionsArray?.filter({ (question) -> Bool in
                return (((question as! [String: Any])["selectedOptionId"] as? [Int]) ?? []).count > 0
            })
            self.questionsAttemptCountLabel.text = "\(attemptedAnswersArray?.count ?? 0)/\(questionsArray?.count ?? 0)"
        }
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }

}
