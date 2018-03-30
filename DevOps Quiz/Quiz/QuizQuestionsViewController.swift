//
//  QuizQuestionsViewController.swift
//  Sales Force Management
//
//  Created by Shivang Garg on 31/01/18.
//  Copyright © 2018 Decimal Technologies Private Limited. All rights reserved.
//

import UIKit

class QuizQuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionContentLabel: UILabel!
    @IBOutlet weak var optionsTableviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var optionsTableview: UITableView!
    @IBOutlet weak var previousQuestionButton: UIButton!
    @IBOutlet weak var nextQuestionButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!

    
    //MARK: - Properties
    var quizDelegate:QuizDelegate?
    var activeQuestion: Int? = nil {
        didSet {
            
            if (activeQuestion ?? 0) == 0 {
                self.hidePreviousButton()
                nextQuestionButton.setTitle("NEXT", for: .normal)
            }
            else if (activeQuestion ?? 0) == (questionsArray?.count ?? 0) { //Check for last question
                quizDelegate?.completeQuiz()
            }
            else {
                
                if (activeQuestion ?? 0) + 1 == (questionsArray?.count ?? 0) {
                    if screenMode == .test {
                        nextQuestionButton.setTitle("SUBMIT", for: .normal)
                    }
                    else {
                        nextQuestionButton.setTitle("EXIT", for: .normal)
                    }
                }
                else {
                    nextQuestionButton.setTitle("NEXT", for: .normal)
                }
                
                if screenMode == .test {
                    //Setting question is skipped by not selecting anything
                    var question: [String: Any] = (questionsArray?[activeQuestion ?? 0] as! [String: Any])
                    if question["selectedOptionId"] == nil {
                        question["selectedOptionId"] = ""
                        questionsArray?[activeQuestion ?? 0] = question
                    }
                }
                
                self.showPreviousButton()
            }
            
            if (activeQuestion ?? 0) < (questionsArray?.count ?? 0) {
                questionNumberLabel.text = "Q \((activeQuestion ?? 0) + 1)/\(questionsArray?.count ?? 0)"
                questionContentLabel.text = (questionsArray![activeQuestion ?? 0] as! [String: Any])["QUESTION"] as? String
                
                let options:[String: String] = ((questionsArray![activeQuestion ?? 0] as! [String: Any])["OPTIONS"] as? [[String:Any]])?.first as! [String : String]
                activeOptionsArray = [options["OPTION1"]!,options["OPTION2"]!,options["OPTION3"]!,options["OPTION4"]!]
            }
        }
    }
    var activeOptionsArray: [String]? = nil {
        didSet {
            optionsTableview.reloadData()
        }
    }
    var questionsArray: [Any]? = nil {
        didSet {
            
            print(questionsArray)

            if activeQuestion == nil  {
                activeQuestion = 0
                
                if screenMode == .test {
                    var question: [String: Any] = (questionsArray?[activeQuestion ?? 0] as! [String: Any])
                    question["selectedOptionId"] = "" as Any
                    questionsArray?[activeQuestion ?? 0] = question
                }
            }
            optionsTableview.reloadData()
            
            if screenMode == .test {
                NotificationCenter.default.post(name: NSNotification.Name.init("changeQuestionAttemptStatus"), object: nil, userInfo: ["questionsArray": questionsArray!, "activeQuestion":activeQuestion ?? 0])
            }
        }
    }
    var screenMode: QuizMode = .test {
        didSet {
            optionsTableview.reloadData()
        }
    }
    
    //MARK: - Viewcontroller Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initializer {
            self.hidePreviousButton()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK: - Initializers
    func initializer(complete: () -> ()) -> Void {
        
        //Initialization code here
        optionsTableview.estimatedRowHeight = 69
        optionsTableview.rowHeight = UITableViewAutomaticDimension
                
        //Adding Notification Observers
        NotificationCenter.default.addObserver(self, selector: #selector(openQuestion(_ :)), name: NSNotification.Name.init("openQuestion"), object: nil)

        complete()
    }
    
    //MARK: - Tableview delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "option")
        
        //Checkbox button
        let checkboxButton: UIButton = cell?.viewWithTag(1) as! UIButton
        
        if screenMode == .test {
            checkboxButton.setBackgroundImage(#imageLiteral(resourceName: "rectangle7Copy3"), for: .normal)
            checkboxButton.setBackgroundImage(#imageLiteral(resourceName: "group4"), for: .selected)
        }
        else {
            checkboxButton.setBackgroundImage(#imageLiteral(resourceName: "rectangle7Copy3"), for: .normal)
            checkboxButton.setBackgroundImage(#imageLiteral(resourceName: "group4"), for: .selected)
        }
        
        //Option content
        let optionContentLabel: UILabel = cell?.viewWithTag(2) as! UILabel
        optionContentLabel.text = activeOptionsArray?[indexPath.row]
        
        if ((questionsArray?[activeQuestion ?? 0] as! [String: Any])["selectedOptionId"] as? String) == "" {
            checkboxButton.isSelected = false
            optionContentLabel.textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        }
        else if (activeOptionsArray?[indexPath.row] == (((questionsArray?[activeQuestion ?? 0] as! [String: Any])["selectedOptionId"] as? String)!)) ?? false
        {
            checkboxButton.isSelected = true
            optionContentLabel.textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        }
        else
        {
            checkboxButton.isSelected = false
            optionContentLabel.textColor = UIColor.init(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0)
        }
        
        
        return cell ?? UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if screenMode == .test {
            var cell: UITableViewCell?
            cell = tableView.cellForRow(at: indexPath)
            
            //Checkbox button
            let checkboxButton: UIButton = cell?.viewWithTag(1) as! UIButton
            
            //Option content
            let optionContentLabel: UILabel = cell?.viewWithTag(2) as! UILabel
            
            
            if checkboxButton.isSelected {
                
                //Checkbox deselected
                checkboxButton.isSelected = false
                optionContentLabel.textColor = UIColor.init(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0)

                //Deselecting selected answer
                var question: [String: Any] = (questionsArray?[activeQuestion ?? 0] as! [String: Any])
                if let _ = question["selectedOptionId"] as? String {
//                    var selectedOptions = question["selectedOptionId"] as! String
//                    selectedOptions =
//                    selectedOptions.remove(at: selectedOptions.index(where: { (item) -> Bool in
//                        return item == activeOptionsArray?[indexPath.row]
//                    })!)
//
//                    if selectedOptions.count == 0 {
//                        question["selectedOptionId"] = nil
//                    }
//                    else {
                        question["selectedOptionId"] = ""
//                    }
                }
                questionsArray?[activeQuestion ?? 0] = question
                
            }
            else {
                
                //Checkbox selected
                cell?.isSelected = true
                checkboxButton.isSelected = true
                optionContentLabel.textColor = UIColor.init(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)

                //Selecting new answer
                var question: [String: Any] = (questionsArray?[activeQuestion ?? 0] as! [String: Any])
                var selectedOptions = question["selectedOptionId"] as? String

                
                if let _ = question["selectedOptionId"] as? String {
                    selectedOptions = (activeOptionsArray?[indexPath.row])
                }
                question["selectedOptionId"] = selectedOptions as Any

                questionsArray?[activeQuestion ?? 0] = question
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if screenMode == .test {
            var cell: UITableViewCell?
            cell = tableView.cellForRow(at: indexPath)
            
            //Checkbox button
            let checkboxButton: UIButton = cell?.viewWithTag(1) as! UIButton
            
            //Option content
            let optionContentLabel: UILabel = cell?.viewWithTag(2) as! UILabel
            
            checkboxButton.isSelected = false
            optionContentLabel.textColor = UIColor.init(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0)

        }
    }
    
    //MARK: - Actions
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        if (activeQuestion ?? 0) > 0 {
            activeQuestion = (activeQuestion ?? 1) - 1
        }
    }
    
    @IBAction func nextbuttonPressed(_ sender: UIButton) {
        activeQuestion = (activeQuestion ?? 0) + 1
    }
    
    
    //MARK: - Helper
    @objc func openQuestion(_ sender:Notification) -> Void {
        
        let userInfo: [String: Any]? = sender.userInfo as? [String: Any]
        activeQuestion = ((userInfo?["questionIndex"] as? IndexPath)?.row ?? 0)
    }
    
    func showPreviousButton() -> Void {
        
        previousQuestionButton.isHidden = false
        nextQuestionButton.isHidden = false
        
        stackView.removeArrangedSubview(previousQuestionButton)
        stackView.removeArrangedSubview(nextQuestionButton)
        
        stackView.addArrangedSubview(previousQuestionButton)
        stackView.addArrangedSubview(nextQuestionButton)
        
    }
    
    func hidePreviousButton() -> Void {
        previousQuestionButton.isHidden = true
        stackView.removeArrangedSubview(previousQuestionButton)
        
    }
    
    func showNextButton() -> Void {
        
        previousQuestionButton.isHidden = false
        nextQuestionButton.isHidden = false
        
        stackView.removeArrangedSubview(previousQuestionButton)
        stackView.removeArrangedSubview(nextQuestionButton)
        
        stackView.addArrangedSubview(previousQuestionButton)
        stackView.addArrangedSubview(nextQuestionButton)
        
    }
    
    func hideNextButton() -> Void {
        nextQuestionButton.isHidden = true
        stackView.removeArrangedSubview(nextQuestionButton)
        
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
    
    
}

