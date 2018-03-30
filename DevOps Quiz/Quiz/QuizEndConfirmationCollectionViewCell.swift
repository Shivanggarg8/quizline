//
//  QuizEndConfirmationCollectionViewCell.swift
//  Sales Force Management
//
//  Created by Shivang Garg on 31/01/18.
//  Copyright © 2018 Decimal Technologies Private Limited. All rights reserved.
//

import UIKit

class QuizEndConfirmationCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    let endConfirmationViewController: QuizEndConfirmationViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuizEndConfirmation") as! QuizEndConfirmationViewController
    var parentController: QuizViewController? = nil {
        didSet {
            setup()
        }
    }
    var questionsArray: [Any]? = nil {
        didSet {
            endConfirmationViewController.questionsArray = questionsArray
        }
    }
    var quizDelegate:QuizDelegate? = nil {
        didSet {
            endConfirmationViewController.quizDelegate = quizDelegate            
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
            endConfirmationViewController.view.tag = 111
            
            //Adding Tableview as subview
            parentController?.addChildViewController(endConfirmationViewController)
            self.addSubview(endConfirmationViewController.view)
            endConfirmationViewController.didMove(toParentViewController: parentController)
            self.bringSubview(toFront: endConfirmationViewController.view)
            
            
            endConfirmationViewController.view.translatesAutoresizingMaskIntoConstraints = false
            endConfirmationViewController.view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            endConfirmationViewController.view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            endConfirmationViewController.view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            endConfirmationViewController.view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            
        }
    }
}
