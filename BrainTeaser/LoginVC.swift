//
//  ViewController.swift
//  BrainTeaser
//
//  Created by Laszlo Barabas on 3/19/16.
//  Copyright © 2016 Laszlo Barabas. All rights reserved.
//

//graphics from http://www.freepik.com/

import UIKit
import pop     // this is FaceBook's animation library https://github.com/facebook/pop

class LoginVC: UIViewController {

    @IBOutlet weak var emailConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var passwordConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var loginConstraint: NSLayoutConstraint!
    
    var animEngine: AnimationEngine!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.animEngine = AnimationEngine(constraints: [emailConstraint, passwordConstraint, loginConstraint])
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //this is a standard animation engine, but lets use FB pop
        /*
        UIView.animateWithDuration(6) { () -> Void in
            self.emailConstraint.constant = -100
            self.view.layoutIfNeeded()
        }
        */
        
        self.animEngine.animateOnScreen(2)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

