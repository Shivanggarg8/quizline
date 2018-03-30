//
//  QuizQuestionsCollectionViewCell.swift
//  Sales Force Management
//
//  Created by Shivang Garg on 31/01/18.
//  Copyright © 2018 Decimal Technologies Private Limited. All rights reserved.
//

import UIKit

class QuizQuestionsCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    let questionViewController: QuizQuestionsViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuizQuestions") as! QuizQuestionsViewController
    var questionsArray: [Any]? = nil {
        didSet {
            questionViewController.questionsArray = questionsArray
        }
    }
    var parentController: QuizViewController? = nil {
        didSet {
            setup()
        }
    }
    var screenMode: QuizMode = .test {
        didSet {
            questionViewController.screenMode = screenMode
        }
    }
    var quizDelegate: QuizDelegate? = nil {
        didSet {
            questionViewController.quizDelegate = quizDelegate
        }
    }
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    
    //MARK: - Helpers
    func setup() -> Void {
        if self.viewWithTag(111) == nil {
            questionViewController.view.tag = 111
            
            //Adding Tableview as subview
            parentController?.addChildViewController(questionViewController)
            self.addSubview(questionViewController.view)
            questionViewController.didMove(toParentViewController: parentController)
            self.bringSubview(toFront: questionViewController.view)
            
            
            questionViewController.view.translatesAutoresizingMaskIntoConstraints = false
            questionViewController.view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            questionViewController.view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            questionViewController.view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            questionViewController.view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            
        }
    }
}
