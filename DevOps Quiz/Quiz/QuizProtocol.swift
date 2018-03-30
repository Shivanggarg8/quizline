//
//  QuizProtocol.swift
//  Sales Force Management
//
//  Created by Shivang Garg on 05/02/18.
//  Copyright © 2018 Decimal Technologies Private Limited. All rights reserved.
//

import Foundation

protocol QuizDelegate {
    func completeQuiz() -> Void;
    func quizCompletionCancelled() -> Void;
}
