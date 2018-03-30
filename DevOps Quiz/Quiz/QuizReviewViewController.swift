//
//  QuizReviewViewController.swift
//  Sales Force Management
//
//  Created by Shivang Garg on 31/01/18.
//  Copyright © 2018 Decimal Technologies Private Limited. All rights reserved.
//

import UIKit

class QuizReviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: - Outlets
    @IBOutlet weak var answersCollectionView: UICollectionView!
    @IBOutlet weak var questionsAttemptCountLabel: UILabel!
    @IBOutlet weak var questionsStatusLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!

    
    
    //MARK: - Properties
    var quizDelegate: QuizDelegate?
    var questionsArray: [Any]? = nil {
        didSet {
            let attemptedAnswersArray: [Any]? = self.questionsArray?.filter({ (question) -> Bool in
                return ((question as! [String: Any])["selectedOptionId"] as? String) ?? "" != ""
            })
            self.questionsAttemptCountLabel.text = "\(attemptedAnswersArray?.count ?? 0)/\(self.questionsArray?.count ?? 0)"
            answersCollectionView.reloadData()
        }
    }
    var screenMode: QuizMode = .test {
        didSet {
            if screenMode == .test {
                submitButton.setTitle("SUBMIT", for: .normal)
            }
            else {
                submitButton.setTitle("EXIT", for: .normal)
            }
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
    
    //MARK: - CollectionView Delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ReviewAnswerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "answerCell", for: indexPath) as! ReviewAnswerCollectionViewCell
        cell.indexPath = indexPath
        
        
        if (((questionsArray?[indexPath.row] as! [String: Any])["correct"] as? String) ?? "") == "Y" {
            //Question is correct
            cell.status = .correct
        }
        else if (((questionsArray?[indexPath.row] as! [String: Any])["correct"] as? String) ?? "") == "N" {
            //Question is incorrect
            cell.status = .incorrect
        }
        else if let selectedAnswer = (questionsArray![indexPath.row] as! [String: Any])["selectedOptionId"] as? String {
            if selectedAnswer == "" {
                //Question is skipped
                cell.status = .skip
            }
            else {
                //Question is attempted
                cell.status = .attempt
            }
        }
        else {
            //Question is unattempted
            cell.status = .unattempt
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.view.frame.size.width - 75)/2, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name.init("openQuestionScreen"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name.init("openQuestion"), object: nil, userInfo: ["questionIndex":indexPath, "answerCollectionCell":collectionView.cellForItem(at: indexPath)!])
    }
    
    
    //MARK: - Helper
    @objc func questionAttemptStatus(_ sender:Notification) -> Void {
        
        DispatchQueue.main.async {
            let userInfo: [String: Any]? = sender.userInfo as? [String: Any]
            self.questionsArray = userInfo?["questionsArray"] as? [Any]
            self.answersCollectionView.reloadData()
        }
        
    }
    
    //MARK: - Actions
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        quizDelegate?.completeQuiz()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }


}
