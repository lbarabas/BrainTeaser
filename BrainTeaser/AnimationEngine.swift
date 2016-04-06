//
//  AnimationEngine.swift
//  BrainTeaser
//
//  Created by Laszlo Barabas on 3/19/16.
//  Copyright © 2016 Laszlo Barabas. All rights reserved.
//

import UIKit
import pop

class AnimationEngine {
    
    class var offScreenRightPosition: CGPoint {
        return CGPointMake(UIScreen.mainScreen().bounds.width, CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    
    class var offScreenLeftPosition: CGPoint {
        return CGPointMake(-UIScreen.mainScreen().bounds.width, CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    class var screenCenterPosition: CGPoint {
        return CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), CGRectGetMidY(UIScreen.mainScreen().bounds))
    }
    
    let ANIM_DELAY: Int = 1    
    
    var originalConstants = [CGFloat]()
    var constraints: [NSLayoutConstraint]!
    
    init(constraints: [NSLayoutConstraint]) {
        
        for con in constraints {
            originalConstants.append(con.constant)
            con.constant = AnimationEngine.offScreenRightPosition.x
        }
        
        self.constraints = constraints
        
    }
    
    func animateOnScreen(delay: Int) {
        
        // if the user didn't pass in any argurment then use a default value (we calculate with a constant), otherwise use what the user set
        //let d: Int64 = delay == nil ? Int64(Double(ANIM_DELAY) * Double(NSEC_PER_SEC)) : delay!
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(delay) * Double(NSEC_PER_SEC)))
        
        
        dispatch_after(time, dispatch_get_main_queue() ) {
        
            var index = 0
            repeat {
                let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
                moveAnim.toValue = self.originalConstants[index]
                moveAnim.springBounciness = 12
                moveAnim.springSpeed = 12
                
                // this code below slows down brining in the elements for better look
                if (index > 0) {
                    moveAnim.dynamicsFriction += 50 + CGFloat(index)
                    moveAnim.dynamicsMass = 20 // this will add extra effect like going back and forth
                }
            
                let con = self.constraints[index]
                con.pop_addAnimation(moveAnim, forKey: "moveOnScreen")
                
                index = index + 1
                
            } while (index < self.constraints.count)
        }
    }
    
    
    class func animateToPosition(view: UIView, position: CGPoint, completion: ((POPAnimation!, Bool) -> Void)) {
        let moveAnim = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
        moveAnim.toValue = NSValue(CGPoint: position)
        moveAnim.springBounciness = 8
        moveAnim.springSpeed = 8
        
        moveAnim.completionBlock=completion   // this is the block that is going to be called after the animation is done
        
        view.pop_addAnimation(moveAnim, forKey: "moveToPosition")
        
    }
    
    
    class func animateBackground(view: UIView, color: CGColor , completion: ((POPAnimation!, Bool) -> Void))  {
        let spring = POPSpringAnimation(propertyNamed: kPOPViewBackgroundColor)
        //spring.toValue = UIColor(red: 157.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0).CGColor
        spring.toValue = color
        spring.springBounciness = 3
        spring.springSpeed = 5
        
        spring.completionBlock=completion
        
        view.pop_addAnimation(spring, forKey: "backGround")
    }

    
}
