//
//  QuizReviewCollectionViewCell.swift
//  Sales Force Management
//
//  Created by Shivang Garg on 31/01/18.
//  Copyright © 2018 Decimal Technologies Private Limited. All rights reserved.
//

import UIKit

class QuizReviewCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    let reviewCollectionViewController: QuizReviewViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuizReview") as! QuizReviewViewController
    var questionsArray: [Any]? = nil {
        didSet {
            reviewCollectionViewController.questionsArray = questionsArray
        }
    }
    var parentController: QuizViewController? = nil {
        didSet {
            setup()
        }
    }
    var screenMode: QuizMode = .test {
        didSet {
            reviewCollectionViewController.screenMode = screenMode
        }
    }
    var quizDelegate: QuizDelegate? = nil {
        didSet {
            reviewCollectionViewController.quizDelegate = quizDelegate
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
            reviewCollectionViewController.view.tag = 111
            
            //Adding Tableview as subview
            parentController?.addChildViewController(reviewCollectionViewController)
            self.addSubview(reviewCollectionViewController.view)
            reviewCollectionViewController.didMove(toParentViewController: parentController)
            self.bringSubview(toFront: reviewCollectionViewController.view)
            
            
            reviewCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
            reviewCollectionViewController.view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            reviewCollectionViewController.view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            reviewCollectionViewController.view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            reviewCollectionViewController.view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            
        }
    }
}
