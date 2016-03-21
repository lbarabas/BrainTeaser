//
//  GameVC.swift
//  BrainTeaser
//
//  Created by Laszlo Barabas on 3/19/16.
//  Copyright © 2016 Laszlo Barabas. All rights reserved.
//

import UIKit
import pop

class GameVC: UIViewController {

    @IBOutlet weak var yesBtn: CustomButton!
    @IBOutlet weak var noBtn: CustomButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var scoreTitle: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var timeTitle: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    var currentCard: Card!
    
    var prevShape: String!
    
    var score: Int = 0
    
    var cards: Int = 0  //debug only
    var match: Int = 0
    var mismatch: Int = 0
    
    
    let RED = UIColor(red: 157.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).CGColor
    let GREEN = UIColor(red: 0.0/255.0, green: 157.0/255.0, blue: 0.0/255.0, alpha: 1.0).CGColor
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // this returns as array, so we can just grab the first element
        currentCard = NSBundle.mainBundle().loadNibNamed("Card", owner: self, options: nil)[0] as? Card
        
        currentCard.center = AnimationEngine.screenCenterPosition
        self.view.addSubview(currentCard)
        
        prevShape = currentCard.currentShape  // this is the very first card that is presented
    
    }

    override func viewDidAppear(animated: Bool) {
        //just as a test
        //AnimationEngine.animateToPosition(currentCard, position: CGPointMake(0, 0))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yesPressed(sender: UIButton) {
        if sender.titleLabel?.text == "YES" {
            checkAnswer(sender)
        } else {
            
            cards=0
            match=0
            mismatch=0
            
            // the YES button says START
            titleLbl.text = "Does this card match the previous ?"
            score = 0
            scoreLbl.text = "\(score)"
            scoreLbl.hidden = false
            scoreTitle.hidden = false
            gameTime = 10
            timeLbl.text = "\(Int(gameTime))"
            timeLbl.hidden = false
            timeTitle.hidden = false
            //starting the timer
            startGameTimer()

        }
        
        showNextCard()
        
    }
    
    @IBAction func noPressed(sender: UIButton) {
        checkAnswer(sender)
        showNextCard()
        
    }
    
    func checkAnswer(sender: UIButton) {
        
        //print("prev shape = \(prevShape),  curr shape = \(currentCard.currentShape)")

        if (sender.titleLabel?.text == "YES" && prevShape == currentCard.currentShape) ||
           (sender.titleLabel?.text == "NO" && prevShape != currentCard.currentShape)  {
            score++
            match++
            print("@\(cards) Correct")
            
            AnimationEngine.animateBackground(currentCard, color: GREEN, completion:
                { (anim: POPAnimation!, finished: Bool) -> Void in
                    // do not do any data manipulation here as can't guarantee success or order
                }
            )
            
        } else {
            print("@\(cards) Incorrect")
            score--
            mismatch++
            AnimationEngine.animateBackground(currentCard, color: RED, completion:
                { (anim: POPAnimation!, finished: Bool) -> Void in
                    // do not do any data manipulation here as can't guarantee success or order
                }
            )
            
        }
        scoreLbl.text = "\(score)"
        prevShape = currentCard.currentShape
        
    }
    
    
    func showNextCard() {
        
        cards++   //for debugging only
        
        if let current = currentCard {
            let cardToRemove = current
            
            //need to compare current and next/prev cards here
            
            currentCard = nil
 
            AnimationEngine.animateToPosition(cardToRemove, position: AnimationEngine.offScreenLeftPosition, completion:
                { (anim: POPAnimation!, finished: Bool) -> Void in
                    // do not do any data manipulation here as can't guarantee success or order
                    cardToRemove.removeFromSuperview()
                }
            )
            
        }
        
        
        if let next = createCardFromNib() {
            //immediately move if off the screen
            next.center = AnimationEngine.offScreenRightPosition
            self.view.addSubview(next)
            currentCard = next
            
            if noBtn.hidden {
                noBtn.hidden = false
                yesBtn.setTitle("YES", forState: .Normal)
            }
            
            AnimationEngine.animateToPosition(next, position: AnimationEngine.screenCenterPosition, completion:
                { (anim: POPAnimation!, finished: Bool) -> Void in
                
                }
            )
            
        }
        
    }
    
    func createCardFromNib() -> Card? {
        return NSBundle.mainBundle().loadNibNamed("Card", owner: self, options: nil )[0] as? Card
        
    }
    

    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var gameTime : Double = 10
    
    
    func startGameTimer() {
        
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
    }
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime = currentTime - startTime
        let seconds = gameTime-elapsedTime
        if seconds > 0 {
            elapsedTime -= NSTimeInterval(seconds)
            timeLbl.text = "\(Int(seconds))"
            
           // print("\(Int(seconds)) sec left")  //debug output
        } else {
           // print("time is up, \(Int(seconds))") //debug output
            
            titleLbl.text = "Game over !"
            
          //  noBtn.enabled = false   // doesn't make a difference
          //  yesBtn.enabled = false
            
            noBtn.hidden = true
            yesBtn.setTitle("START N", forState: .Normal)
            yesBtn.setTitle("START S", forState: .Selected)
            yesBtn.setTitle("START F", forState: .Focused)
            yesBtn.setTitle("START H", forState: .Highlighted)
            yesBtn.setTitle("START D", forState: .Disabled)
            
            // this following line is a guess to make sure that the buttons get updated - without they are not always and the game goes on
            yesBtn.setNeedsDisplay()    //doesn't solve the problem
            yesBtn.layoutIfNeeded()     //doesn't solve the problem
            noBtn.setNeedsDisplay()    //doesn't solve the problem
            noBtn.layoutIfNeeded()     //doesn't solve the problem

            
          //  noBtn.enabled = true
          //  yesBtn.enabled = true
            
            timeLbl.hidden = true
            timeTitle.hidden = true
            
            print("match = \(match), mismatch = \(mismatch)")
            
            timer.invalidate()
        }
        
    }
    

}
