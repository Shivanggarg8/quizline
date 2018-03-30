//
//  ReviewAnswerCollectionViewCell.swift
//  Sales Force Management
//
//  Created by Shivang Garg on 01/02/18.
//  Copyright © 2018 Decimal Technologies Private Limited. All rights reserved.
//

import UIKit

class ReviewAnswerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var questionStatusLabel: UILabel!
    
    //MARK: - Properties
    var indexPath: IndexPath?
    var status: QuizQuestionStatus? = nil {
        didSet {
            switch status ?? QuizQuestionStatus.unattempt {
            case QuizQuestionStatus.correct:
                questionStatusLabel.text = String((indexPath?.row ?? 0) + 1) + "/ Correct"
                questionStatusLabel.backgroundColor = UIColor.quizCorrectAnswerColor
                break
                
            case QuizQuestionStatus.incorrect:
                questionStatusLabel.text = String((indexPath?.row ?? 0) + 1) + "/ Incorrect"
                questionStatusLabel.backgroundColor = UIColor.quizIncorrectAnswerColor
                break
                
            case QuizQuestionStatus.skip:
                questionStatusLabel.text = String((indexPath?.row ?? 0) + 1) + "/ Skipped"
                questionStatusLabel.backgroundColor = UIColor.quizIncorrectAnswerColor
                break
                
            case QuizQuestionStatus.attempt:
                questionStatusLabel.text = String((indexPath?.row ?? 0) + 1) + "/ Attempted"
                questionStatusLabel.backgroundColor = UIColor.quizAttemptAnswerColor
                break
                
            default:
                questionStatusLabel.text = String((indexPath?.row ?? 0) + 1) + "/ Unattempted"
                questionStatusLabel.backgroundColor = UIColor.quizUnattemptAnswerColor
            }
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
}
