//
//  QuizViewController.swift
//  Sales Force Management
//
//  Created by Shivang Garg on 31/01/18.
//  Copyright © 2018 Decimal Technologies Private Limited. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QuizDelegate {
    
    
    //MARK: - Outlets
    @IBOutlet weak var screensCollectionView: UICollectionView?
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var timerContentView: UIView!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var hrsLabel: UILabel!
    @IBOutlet weak var endQuizButton: UIButton!
    @IBOutlet weak var timeHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerStackView: UIStackView!

    
    //MARK: - Properties
    var productDetails: NSMutableDictionary?
    var itemDetails: NSMutableDictionary?
    var timeDuration: Int?
    var timer = Timer()
    var questionsArray: [Any]?
    var currentLocation: String?
    var screenMode: QuizMode = .test
    var numberOfVisibleOptions: Int = 3
    var userId: String?
    
    
    //MARK: - Viewcontroller Delegates
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initializer {

            if screenMode == .test {
                self.timeDuration = (self.timeDuration ?? 0) * 60 //Convertion of minutes to seconds
                let timeLeft = (self.timeDuration ?? 0).secondsToHoursMinutesSeconds()
                self.remainingTimeLabel.text = String.init(format: "%02d", timeLeft.hour) + ":" + String.init(format: "%02d", timeLeft.minute) + ":" + String.init(format: "%02d", timeLeft.second)
                self.hrsLabel.text = "hrs remaining"
                self.showTestHeaderOptions()
                screensCollectionView?.reloadData()
            }
            else {
                self.remainingTimeLabel.text = "Questions"
                self.hrsLabel.text = ""
                self.showReviewHeaderOptions()
                screensCollectionView?.reloadData()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        screensCollectionView?.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
        screensCollectionView?.isHidden = false
        if screenMode == .test {
            self.scheduledTimerWithTimeInterval()
        }
        else{
            self.timer.invalidate()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //MARK: - Initializers
    func initializer(complete: () -> ()) -> Void {
        
        //Initialization code here
        screensCollectionView?.isHidden = true
        self.navigationItem.hidesBackButton = true

        //Setting Title Label
        self.title = "Quiz"
        
        //Notification Observer added for change in question attempt status
        NotificationCenter.default.addObserver(self, selector: #selector(questionAttemptStatus(_ :)), name: NSNotification.Name.init("changeQuestionAttemptStatus"), object: nil)
        
        //Notification Observers added
        NotificationCenter.default.addObserver(self, selector: #selector(questionsButtonPressed), name: NSNotification.Name.init("openQuestionScreen"), object: nil)
        
        complete()
    }
    
    
    //MARK: - CollectionView Delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfVisibleOptions
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print(questionsArray)

        switch indexPath.row {
        case 0:
            let cell: QuizReviewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizReview", for: indexPath) as! QuizReviewCollectionViewCell
            cell.parentController = self
            cell.quizDelegate = self
            cell.screenMode = screenMode
            cell.questionsArray = questionsArray
            return cell
            
        case 1:
            let cell: QuizQuestionsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizQuestions", for: indexPath) as! QuizQuestionsCollectionViewCell
            cell.parentController = self
            cell.quizDelegate = self
            cell.screenMode = screenMode
            cell.questionsArray = questionsArray
            return cell
            
        case 2:
            let cell: QuizEndConfirmationCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizEndConfirmation", for: indexPath) as! QuizEndConfirmationCollectionViewCell
            cell.parentController = self
            cell.quizDelegate = self
            cell.questionsArray = questionsArray
            return cell
            
        default:
            return UICollectionViewCell.init()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.size.width, height: self.view.frame.size.height - 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let xPosition = scrollView.contentOffset.x
        let selectedIndex: Int = Int.init((xPosition/CGFloat.init(numberOfVisibleOptions))/(self.view.frame.size.width/CGFloat.init(numberOfVisibleOptions)))
        
        if selectedIndex == 0 {
            reviewButtonPressed(UIButton.init())
        }
        else if selectedIndex == 1 {
            questionsButtonPressed(UIButton.init())
        }
        else {
            endQuizButtonPressed(UIButton.init())
        }
    }
    
    
    //MARK: - Actions
    @IBAction func reviewButtonPressed(_ sender: UIButton) {
        self.selectReviewButton()
        screensCollectionView?.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
    }
    
    @IBAction func questionsButtonPressed(_ sender: Any) {
        self.selectQuestionsButton()
        screensCollectionView?.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
    }
    
    @IBAction func endQuizButtonPressed(_ sender: UIButton) {
        self.selectEndQuizButton()
        screensCollectionView?.scrollToItem(at: IndexPath.init(item: 2, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
    }
    
    
    //MARK: - Helper
    func selectReviewButton() -> Void {
        
        //Making UI change in review button
        reviewButton.backgroundColor = UIColor.appBlueColor
        reviewButton.setTitleColor(UIColor.white, for: .normal)
        
        //Making UI change in timerButton
        timerContentView.backgroundColor = UIColor.appLightGreyColor
        remainingTimeLabel.textColor = UIColor.appDarkTextColor
        hrsLabel.textColor = UIColor.appDarkTextColor
        
        //Making UI change in end quiz button
        endQuizButton.backgroundColor = UIColor.appLightGreyColor
        endQuizButton.setTitleColor(UIColor.appDarkTextColor, for: .normal)
    }
    
    func selectQuestionsButton() -> Void {
        
        //Making UI change in review button
        reviewButton.backgroundColor = UIColor.appLightGreyColor
        reviewButton.setTitleColor(UIColor.appDarkTextColor, for: .normal)
        
        //Making UI change in timerButton
        timerContentView.backgroundColor = UIColor.appBlueColor
        remainingTimeLabel.textColor = UIColor.white
        hrsLabel.textColor = UIColor.white
        
        //Making UI change in end quiz button
        endQuizButton.backgroundColor = UIColor.appLightGreyColor
        endQuizButton.setTitleColor(UIColor.appDarkTextColor, for: .normal)
    }
    
    func selectEndQuizButton() -> Void {
        
        //Making UI change in review button
        reviewButton.backgroundColor = UIColor.appLightGreyColor
        reviewButton.setTitleColor(UIColor.appDarkTextColor, for: .normal)

        //Making UI change in timerButton
        timerContentView.backgroundColor = UIColor.appLightGreyColor
        remainingTimeLabel.textColor = UIColor.appDarkTextColor
        hrsLabel.textColor = UIColor.appDarkTextColor

        //Making UI change in end quiz button
        endQuizButton.backgroundColor = UIColor.appBlueColor
        endQuizButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateQuizTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateQuizTime() -> Void {
        
        DispatchQueue.main.async {
            if (self.timeDuration ?? 0) > 0 {
                self.timeDuration = self.timeDuration! - 1
                let timeLeft = (self.timeDuration ?? 1).secondsToHoursMinutesSeconds()
                self.remainingTimeLabel.text = String.init(format: "%02d", (timeLeft.hour )) + ":" + String.init(format: "%02d", (timeLeft.minute)) + ":" + String.init(format: "%02d", (timeLeft.second))
            }
            else {
                self.timer.invalidate()
                let timeCompletionAlert: UIAlertController = UIAlertController.init(title: "Alert", message: "Time is Up !", preferredStyle: UIAlertControllerStyle.alert)
                let okAction: UIAlertAction = UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (okAction) in
                    self.completeQuiz()
                })
                timeCompletionAlert.addAction(okAction)
                self.present(timeCompletionAlert, animated: true, completion: nil)
            }
        }
    }
    
    func showTestHeaderOptions() -> Void {

        numberOfVisibleOptions = 3
        endQuizButton.isHidden = false

        headerStackView.removeArrangedSubview(reviewButton)
        headerStackView.removeArrangedSubview(timerContentView)
        headerStackView.removeArrangedSubview(endQuizButton)
        
        
        headerStackView.addArrangedSubview(reviewButton)
        headerStackView.addArrangedSubview(timerContentView)
        headerStackView.addArrangedSubview(endQuizButton)
        
    }
    
    func showReviewHeaderOptions() -> Void {
        numberOfVisibleOptions = 2
        headerStackView.removeArrangedSubview(endQuizButton)
        endQuizButton.isHidden = true
    }
    
    
    //MARK: - Notifications Observers
    @objc func questionAttemptStatus(_ sender:Notification) -> Void {
        
        let userInfo: [String: Any]? = sender.userInfo as? [String: Any]
        self.questionsArray = userInfo?["questionsArray"] as? [Any]
    }
    
    //MARK: - Server handlers
    func getQuizQuestionsFromServer(comletionHandler complete:() -> ()) -> Void {
        
        
        
    }
    
    //MARK: - Quiz Actions Delegate
    func completeQuiz() -> Void {
        self.timer.invalidate()
        if screenMode == .test {
            self.performSegue(withIdentifier: "calculateScore", sender: self)
        }
    }
    
    func quizCompletionCancelled() {
        self.questionsButtonPressed(UIButton.init() as Any)
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calculateScore" {
            let quizVewScoreController: QuizViewScoreViewController = segue.destination as! QuizViewScoreViewController
            quizVewScoreController.quizUserResponseArray = questionsArray as! [[String:Any]]
            quizVewScoreController.userId = userId
        }
        
    }
    
    
}

