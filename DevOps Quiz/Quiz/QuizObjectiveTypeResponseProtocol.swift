//
//  QuizObjectiveTypeResponseProtocol.swift
//  Sales Force Management
//
//  Created by Shivang Garg on 06/02/18.
//  Copyright © 2018 Decimal Technologies Private Limited. All rights reserved.
//

import Foundation

protocol QuizObjectiveTypeResponse {
    func stronglyDisagree(_ sender: UIButton)
    func disagree(_ sender: UIButton)
    func neutral(_ sender: UIButton)
    func agree(_ sender: UIButton)
    func stronglyAgree(_ sender: UIButton)
    func notApplicable(_ sender: UIButton)
}
