//
//  Card.swift
//  BrainTeaser
//
//  Created by Laszlo Barabas on 3/19/16.
//  Copyright © 2016 Laszlo Barabas. All rights reserved.
//

import UIKit

class Card: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    let shapes = ["shape1","shape2","shape3"]
    
    var currentShape : String!
    
    @IBOutlet weak var shapeImage: UIImageView!
    
    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            setupView()
        }
    }
    
    override func awakeFromNib() {
        setupView()
        selectShape()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
        
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        self.layer.shadowColor = UIColor(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1.0).CGColor
        self.setNeedsLayout()
    }
    
    func selectShape() {
        //select a random element
        currentShape = shapes[ Int(arc4random_uniform(3)) ]
        shapeImage.image = UIImage(named: currentShape)
        
    }
    
}
